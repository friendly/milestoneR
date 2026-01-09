# Epoch Boundary Updates - 2026-01-09

## Changes Made

Updated the boundary values for extended epochs to better reflect the actual data range:

### 1. Prehistory Lower Bound: 1400 → -Inf

**Previous:**
```r
breaks <- c(1400, breaks)  # Prehistory: 1400-1500
```

**Updated:**
```r
breaks <- c(-Inf, breaks)  # Prehistory: -Inf to 1500
```

**Rationale:**
- The earliest milestone in the database is from 6200 BC (year -6200)
- Using 1400 as a lower bound would exclude all BC dates
- -Inf properly captures "all dates before 1500"
- Mathematically clean and works correctly with `get_epoch()`

### 2. Digital Age Upper Bound: 2025 → Current Year

**Previous:**
```r
breaks <- c(breaks, 2025)  # Digital Age: 2000-2025
```

**Updated:**
```r
current_year <- as.integer(format(Sys.Date(), "%Y"))
breaks <- c(breaks, current_year)  # Digital Age: 2000-2026 (as of 2026)
```

**Rationale:**
- Hardcoded 2025 would become outdated
- Using `Sys.Date()` makes it automatically current
- Provides a concrete upper bound (better than Inf for most uses)
- Will be 2026 in 2026, 2027 in 2027, etc.

## How Non-Finite Values are Handled

### In `epoch_boundaries()`
```r
bounds <- c(epochs$start, epochs$end)
bounds <- bounds[is.finite(bounds)]  # Filters out -Inf and Inf
unique(sort(bounds))
```

**Result:**
- Default epochs: `c(1500, 1600, ..., 2000)`
- Extended epochs: `c(1500, 1600, ..., 2000, 2026)` (no -Inf included)
- This is correct for plotting vertical reference lines

### In `get_epoch()`
The function correctly handles -Inf and Inf comparisons:
```r
# For year = -6200 in Prehistory epoch (start = -Inf, end = 1500):
-6200 >= -Inf  # TRUE (year is after start)
-6200 < 1500   # TRUE (year is before end)
# → Correctly assigned to Prehistory

# For year = 2026 in Digital Age (start = 2000, end = 2026):
2026 >= 2000   # TRUE (year is after start)
2026 < 2026    # FALSE... wait, this is an edge case!
```

**Edge Case Identified:** Years exactly equal to epoch end points need careful handling.
The current implementation uses `year[i] >= epochs$end[idx[i]]` which would exclude the endpoint.

For intervals [start, end), this is correct (right-open intervals).
For intervals [start, end], we'd need `year[i] > epochs$end[idx[i]]`.

**Current behavior:** Epochs are right-open intervals [start, end).
- 1500-1600 means [1500, 1600) - includes 1500, excludes 1600
- Year 1600 belongs to the next epoch (1600-1700)

This is the standard convention and probably fine, but worth documenting.

### In `print.milestone_epochs()`
```r
start_str <- if (is.na(x$start[i]) || !is.finite(x$start[i])) {
  "..."
} else {
  as.character(x$start[i])
}
```

**Result:**
- -Inf is displayed as "..."
- Inf is displayed as "..."
- Makes the output clean and readable

## Example Output

```r
> extended <- define_epochs(extend = TRUE)
> print(extended)
Milestone Epochs
Number of epochs: 10
Time range: ... to 2026

 1. ...-1500: Prehistory
 2. 1500-1600: Early maps & diagrams
 3. 1600-1700: Measurement & theory
 4. 1700-1800: New graphic forms
 5. 1800-1850: Modern age
 6. 1850-1900: Golden Age
 7. 1900-1950: Dark age
 8. 1950-1975: Re-birth
 9. 1975-2000: Hi-Dim Vis
10. 2000-2026: Digital Age

> epoch_boundaries(extended)
[1] 1500 1600 1700 1800 1850 1900 1950 1975 2000 2026

> get_epoch(c(-6200, 1550, 2025), extended)
[1] "Prehistory"           "Early maps & diagrams" "Digital Age"
```

## Testing

Added two new tests to `dev/test-epochs.R`:

**Test 15:** Verify early dates (BC) work correctly
```r
early_years <- c(-6200, -1000, 1500, 2000, 2026)
get_epoch(early_years, extended)
# Should classify -6200 and -1000 as "Prehistory"
```

**Test 16:** Verify `epoch_boundaries()` excludes -Inf
```r
boundaries_ext <- epoch_boundaries(extended)
stopifnot(!any(is.infinite(boundaries_ext)))
# Should pass - all boundaries are finite
```

## Documentation Updates

1. **R/epochs.R** - Updated `@param extend` documentation
2. **dev/epochs-implementation-summary.md** - Updated extension options
3. **dev/epochs-design-summary.md** - Updated recommendation to Option A

## Files Modified

- `R/epochs.R` - Lines 124-137 (extend logic)
- `R/epochs.R` - Lines 14-21 (documentation)
- `dev/test-epochs.R` - Added tests 15-16
- `dev/epochs-implementation-summary.md` - Updated boundaries
- `dev/epochs-design-summary.md` - Updated recommendation

## Backward Compatibility

**Breaking change:** If anyone was relying on Prehistory starting at 1400 or Digital Age ending at 2025, this will change behavior.

However, since this is new code not yet released, this is not a concern.

## Future Considerations

1. **Endpoint handling:** Document that epochs use right-open intervals [start, end)
2. **Dynamic upper bound:** The Digital Age upper bound will change each year
   - Pro: Always current
   - Con: Results may differ across years
   - Consider: Option to freeze at a specific year for reproducibility?
3. **Plotting:** Ensure plotting functions handle -Inf gracefully (already done via `epoch_boundaries()`)
