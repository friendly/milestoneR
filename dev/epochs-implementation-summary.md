# Epoch Functions Implementation Summary

**Date:** 2026-01-09
**Status:** Implemented, ready for testing

## Files Created

### 1. `R/epochs.R` - Main implementation
Contains four exported functions:

#### `define_epochs()`
Creates epoch definitions for timeline visualization.

**Parameters:**
- `breaks` - Numeric vector of boundary years
- `labels` - Character vector of epoch names
- `descriptions` - Optional longer descriptions
- `style` - "default" or "custom"
- `extend` - NULL, FALSE, TRUE, "before", "after", or "both"

**Returns:** Data frame with class `c("milestone_epochs", "data.frame")`

**Columns:**
- `epoch_id` - Sequential ID (1, 2, 3, ...)
- `start` - Start year
- `end` - End year
- `label` - Display name
- `midpoint` - (start + end) / 2
- `description` - Optional description

**Default Epochs:**
1. 1500-1600: Early maps & diagrams
2. 1600-1700: Measurement & theory
3. 1700-1800: New graphic forms
4. 1800-1850: Modern age
5. 1850-1900: Golden Age
6. 1900-1950: Dark age
7. 1950-1975: Re-birth
8. 1975-2000: Hi-Dim Vis

**Extension Options:**
- `extend = "before"` adds: -Inf to 1500 Prehistory
- `extend = "after"` adds: 2000 to current year (2026) Digital Age
- `extend = TRUE` or `"both"` adds both

**Note:** The Prehistory epoch uses -Inf as the lower bound to accommodate very early milestones (e.g., 6200 BC). The Digital Age uses the current year as determined by `Sys.Date()` at runtime.

#### `epoch_boundaries()`
Extracts unique boundary years from epochs.

**Usage:**
```r
epochs <- define_epochs()
boundaries <- epoch_boundaries(epochs)
# Returns: c(1500, 1600, 1700, 1800, 1850, 1900, 1950, 1975, 2000)

extended <- define_epochs(extend = TRUE)
boundaries <- epoch_boundaries(extended)
# Returns: c(1500, 1600, 1700, 1800, 1850, 1900, 1950, 1975, 2000, 2026)
# Note: -Inf is filtered out automatically
```

Useful for adding vertical reference lines in plots. The function automatically filters out non-finite values (-Inf, Inf) since they can't be plotted as vertical lines.

#### `get_epoch()`
Determines which epoch(s) given year(s) belong to.

**Parameters:**
- `year` - Numeric vector of years
- `epochs` - milestone_epochs object
- `label` - TRUE for labels, FALSE for IDs

**Usage:**
```r
epochs <- define_epochs()
get_epoch(1850, epochs)
# Returns: "Golden Age"

get_epoch(c(1550, 1850, 1975), epochs, label = FALSE)
# Returns: c(1, 5, 7)
```

#### `print.milestone_epochs()`
S3 print method for nicely formatted output.

**Example output:**
```
Milestone Epochs
Number of epochs: 8
Time range: 1500 to 2000

 1. 1500-1600: Early maps & diagrams
 2. 1600-1700: Measurement & theory
 ...
```

### 2. `dev/test-epochs.R` - Test suite
Comprehensive tests covering:
- Default epochs
- All extension options (before, after, both, TRUE)
- Custom epochs
- Helper functions (boundaries, get_epoch)
- Error handling (wrong inputs, unsorted breaks)
- Edge cases (years outside range)
- Data structure validation

**To run tests:**
```r
devtools::load_all()
source("dev/test-epochs.R")
```

### 3. `dev/epochs-usage-demo.R` - Usage examples
Demonstrates intended usage patterns:
- Classifying milestones by epoch
- Counting milestones per epoch
- Finding milestones near epoch boundaries
- Pseudocode for plot integration

**To run demo:**
```r
devtools::load_all()
source("dev/epochs-usage-demo.R")
```

### 4. Documentation files (in `dev/`)
- `epochs-design.R` - Original design exploration
- `epochs-design-summary.md` - Design decisions document

## Next Steps

### Immediate (to activate the code):
1. Run `devtools::document()` to generate man pages from roxygen comments
2. Run tests: `source("dev/test-epochs.R")`
3. Update NAMESPACE (automatic when you run document())
4. Consider: Add to package dependencies if needed (currently uses only base R)

### Future (when implementing plotting):
1. Create `plot_milestone_timeline()` that uses `define_epochs()`
2. Create `plot_milestone_density()` that uses epoch boundaries
3. Add visual styling options (colors, line types for epochs)
4. Consider `add_epoch_lines()` helper to add epochs to existing ggplot

## Design Decisions Made

1. **Data structure:** Data frame (not list) for ggplot2 compatibility
2. **Open-ended intervals:** Use -Inf for Prehistory lower bound, current year for Digital Age upper bound
3. **Extension:** `extend = TRUE` same as `extend = "both"` (user-requested)
4. **Validation:** Errors for clearly wrong inputs, warnings for minor issues
5. **No summary method:** Removed as redundant with print method (user feedback)

## Usage Examples

### Basic usage:
```r
# Get defaults
epochs <- define_epochs()

# With extensions
epochs <- define_epochs(extend = TRUE)

# Custom
my_epochs <- define_epochs(
  breaks = c(1600, 1750, 1900),
  labels = c("Early", "Middle", "Late"),
  style = "custom"
)
```

### Integration with milestones:
```r
ms <- milestone()
ms$epoch <- get_epoch(ms$date_from_numeric, epochs)
table(ms$epoch)
```

### For plotting (future):
```r
plot_timeline <- function(ms, epochs = TRUE) {
  if (isTRUE(epochs)) {
    epoch_data <- define_epochs(extend = "before")
  }

  boundaries <- epoch_boundaries(epoch_data)

  # Use boundaries for geom_vline()
  # Use epoch_data$midpoint and $label for geom_text()
  # Use epoch_data$start/end for geom_rect()
}
```

## Dependencies

**Current:** None (uses only base R)

**Future plotting will need:**
- ggplot2
- possibly scales, ggrepel

## Files Modified

None yet - this is all new code.

## Files to be Generated (after `devtools::document()`)

- `man/define_epochs.Rd`
- `man/epoch_boundaries.Rd`
- `man/get_epoch.Rd`
- `man/print.milestone_epochs.Rd`
- Updated `NAMESPACE`

## Known Limitations / Future Enhancements

1. **Label positioning:** Currently only provides midpoint; plotting functions will need to handle y-position
2. **Visual attributes:** No built-in color/styling; add if needed for plotting
3. **Validation:** Could add check for gaps between epochs
4. **Hierarchical epochs:** Not supported (e.g., nesting decades within centuries)
5. **International labels:** Currently English only

## Testing Status

- [x] Function implementations complete
- [x] Roxygen documentation complete
- [ ] Unit tests run successfully (need R environment)
- [ ] Examples run successfully (need R environment)
- [ ] Integration with plotting (future)

## Questions Resolved

1. ✓ Should `extend = TRUE` work? **Yes, same as "both"**
2. ✓ Need summary method? **No, print is sufficient**
3. ✓ How to handle open intervals? **Use finite bounds**
4. ✓ Data structure? **Data frame for ggplot compatibility**

## Ready For

- Review of implementation
- Testing in R environment
- Integration into plotting functions (when ready)
- Addition of vignette examples
