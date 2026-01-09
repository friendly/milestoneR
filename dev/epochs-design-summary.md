# Epoch Data Structure Design for Timeline Plotting

## Purpose
Define a data structure for historical epochs that facilitates:
1. Drawing vertical reference lines at epoch boundaries
2. Shading rectangular regions for epochs
3. Positioning text labels within epochs
4. Extending with custom epochs (e.g., Prehistory < 1500, Digital Age > 2000)

## Proposed Data Structure

### Core Approach: Data Frame
A data frame with one row per epoch, containing:

```r
epoch_id    start  end    label                   midpoint  description
1           1500   1600   Early maps & diagrams   1550      1500-1600: Early...
2           1600   1700   Measurement & theory    1650      1600-1700: Math...
...
```

**Columns:**
- `epoch_id`: Sequential identifier
- `start`: Start year of epoch
- `end`: End year of epoch
- `label`: Short display name (for plot labels)
- `midpoint`: (start + end) / 2 (convenient for label positioning)
- `description`: Optional longer description

**Class:** `c("milestone_epochs", "data.frame")` for S3 methods

### Advantages
1. **ggplot2-friendly**: Easy to use in geom layers
   - `geom_vline(data = epochs, aes(xintercept = start))`
   - `geom_rect(data = epochs, aes(xmin = start, xmax = end, ...))`
   - `geom_text(data = epochs, aes(x = midpoint, label = label))`

2. **Flexible**: Can add columns for visual attributes (color, alpha, line style)

3. **Inspectable**: Easy to view and debug

4. **Extensible**: Easy to bind rows for custom epochs

## Handling Open-Ended Intervals

For epochs like "Prehistory" (< 1500) or "Digital Age" (> 2000):

### Option A: Use -Inf / Inf
```r
breaks <- c(-Inf, 1500, 1600, ..., 2000, Inf)
```
**Pros:** Mathematically clean
**Cons:** Need special handling in plotting (Inf doesn't plot)

### Option B: Use NA with explicit range
```r
create_epochs(breaks, labels, from = NA, to = 2000)
# First epoch: start = NA, end = 1500
```
**Pros:** Explicit about missing bounds
**Cons:** Need to handle NAs carefully

### Option C: Use finite values just outside data range
```r
# If data ranges 1530-1999:
breaks <- c(1400, 1500, 1600, ..., 2000, 2100)
```
**Pros:** Works seamlessly with plotting
**Cons:** Arbitrary choice of bounds

**Recommendation:** Option C for simplicity, with Option B as fallback for truly open intervals.

## Default Epochs

Based on Friendly et al. (2015) and existing code:

```r
Breaks: 1500, 1600, 1700, 1800, 1850, 1900, 1950, 1975, 2000

Epochs:
1. 1500-1600: Early maps & diagrams
2. 1600-1700: Measurement & theory
3. 1700-1800: New graphic forms
4. 1800-1850: Modern age
5. 1850-1900: Golden Age
6. 1900-1950: Dark age
7. 1950-1975: Re-birth
8. 1975-2000: Hi-Dim Vis
```

## Function Design

### `define_epochs()`

**Signature:**
```r
define_epochs(
  breaks = NULL,      # Numeric vector of boundary years
  labels = NULL,      # Character vector of epoch names
  descriptions = NULL,# Optional descriptions
  style = c("default", "custom"),
  extend = NULL       # "before", "after", or "both"
)
```

**Behavior:**
- `style = "default"`: Return predefined epochs (ignoring other args)
- `style = "custom"`: Use provided breaks/labels
- `extend`: Add prehistory/digital age epochs to defaults

**Returns:** Object of class `c("milestone_epochs", "data.frame")`

**Examples:**
```r
# Get defaults
epochs <- define_epochs()

# Custom epochs
my_epochs <- define_epochs(
  breaks = c(1600, 1750, 1900),
  labels = c("Early", "Enlightenment", "Modern"),
  style = "custom"
)

# Extend defaults
extended <- define_epochs(extend = "both")
# Adds: Prehistory (...-1500) and Digital Age (2000-...)
```

### Helper Function: `epoch_boundaries()`

Extract just the boundary years (for vertical lines):

```r
epoch_boundaries <- function(epochs) {
  bounds <- c(epochs$start, epochs$end)
  bounds <- bounds[is.finite(bounds)]
  unique(sort(bounds))
}
```

**Returns:** Numeric vector like `c(1500, 1600, 1700, ...)`

## S3 Methods

### `print.milestone_epochs()`

```r
print(epochs)
# Output:
# Milestone Epochs
# Number of epochs: 8
# Time range: 1500 to 2000
#
# 1. 1500-1600: Early maps & diagrams
# 2. 1600-1700: Measurement & theory
# ...
```

### `summary.milestone_epochs()`

Show statistics about epoch intervals:
- Mean/median duration
- Number of epochs
- Shortest/longest epoch

## Integration with Plotting

### In plot_milestone_timeline():
```r
plot_milestone_timeline <- function(..., epochs = TRUE, epoch_labels = TRUE) {

  # Get epoch definitions
  if (isTRUE(epochs)) {
    epoch_data <- define_epochs()
  } else if (inherits(epochs, "milestone_epochs")) {
    epoch_data <- epochs
  } else {
    epoch_data <- NULL
  }

  # Build plot
  p <- ggplot(...) + ...

  # Add epoch lines
  if (!is.null(epoch_data)) {
    p <- p + geom_vline(data = epoch_data,
                        aes(xintercept = start),
                        linetype = "dashed",
                        color = "brown")
  }

  # Add epoch labels
  if (epoch_labels && !is.null(epoch_data)) {
    p <- p + geom_text(data = epoch_data,
                       aes(x = midpoint, y = ..., label = label),
                       ...)
  }

  return(p)
}
```

### User customization:
```r
# Use custom epochs
my_epochs <- define_epochs(breaks = c(...), labels = c(...))
plot_milestone_timeline(epochs = my_epochs)

# No epochs
plot_milestone_timeline(epochs = FALSE)

# Epochs but no labels
plot_milestone_timeline(epochs = TRUE, epoch_labels = FALSE)
```

## Label Positioning Challenge

**Problem:** Where to position epoch labels vertically?
- Too high: May go off plot
- Too low: May overlap data
- Fixed position: Doesn't adapt to data density

**Solutions:**

1. **Fixed y-position parameter**
   ```r
   epoch_label_y = 0.9  # Fraction of plot height
   ```

2. **Smart positioning** (like in mileyears4.R)
   ```r
   # Pre-compute varied y positions to avoid overlap
   laby <- base_y + offset * c(5, 3, 5, 3, 5, 3, 5, 3)
   ```

3. **Use ggrepel for automatic placement**
   ```r
   geom_text_repel(data = epochs, ...)
   ```

4. **Position above plot area** (using annotation)
   ```r
   # Place in top margin, not affected by y-scale
   ```

**Recommendation:** Start with option 1 (simple), add option 2 (custom positioning array) for advanced users.

## Optional Visual Attributes

Consider adding to epoch data frame:

```r
epoch_id  start  end  label  color      alpha  fill      shade
1         1500   1600 Early  "brown"    0.8    "gray90"  TRUE
2         1600   1700 Meas.  "brown"    0.8    "gray90"  FALSE
...
```

- `color`: Line color for boundaries
- `alpha`: Transparency for shaded regions
- `fill`: Fill color for rectangles
- `shade`: Logical, should this epoch be shaded? (alternating pattern)

This allows:
```r
ggplot(...) +
  geom_rect(data = filter(epochs, shade),
            aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf,
                fill = I(fill), alpha = I(alpha)))
```

## Validation

Should `define_epochs()` validate inputs?

1. **Breaks are sorted:** `all(diff(breaks) > 0)`
2. **No gaps:** Each end == next start
3. **Label count matches:** `length(labels) == length(breaks) - 1`
4. **No NA in breaks** (unless explicitly allowed)

Throw errors for invalid inputs, or warnings?

**Recommendation:** Errors for clearly wrong inputs (wrong length), warnings for suspicious (unsorted breaks).

## Open Questions

1. Should epochs support hierarchical nesting? (e.g., "1800s" contains "1800-1850" and "1850-1900")
   - **Answer:** Not for MVP, but design to allow future extension

2. Should visual attributes be in the data frame or separate styling function?
   - **Answer:** Separate for cleaner data structure, e.g., `style_epochs()`

3. Should there be a `get_epoch(year)` function to look up which epoch a year belongs to?
   - **Answer:** Yes, useful utility. Use `cut()` or `findInterval()`

4. Store as internal data (`sysdata.rda`) or generate on-the-fly?
   - **Answer:** Generate on-the-fly (lightweight), but could cache defaults

## Next Steps

1. Implement `define_epochs()` function
2. Implement print method
3. Add to `R/` directory
4. Write unit tests
5. Document with examples
6. Test integration with plotting functions

## References

- Existing code: `dev/mileyears4.R` lines 38-49, 102-114
- Friendly et al. (2015): "The Milestones Project: A Database for the History of Data Visualization"
