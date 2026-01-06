# Milestone Visualization Functions: Design Plan

## Overview

This document outlines a plan for implementing visualization functions for the milestoneR package, based on four exemplary timeline plots that demonstrate key use cases for exploring the history of data visualization.

## Existing Example Plots

### 1. Author Lifespan Distribution (`lifespan.png`)
**Purpose:** Analyze the distribution of author lifespans

**Visual Elements:**
- Kernel density curve showing distribution of lifespans
- Rug plot at bottom showing individual author lifespans
- Labeled annotations for extremes (shortest: Moseley, Henry; longest: Hermanus Elmar, Willibald Beyall, Battista Agnese)
- Clean typography and layout

**Data Requirements:**
- Author birth and death dates
- Calculated lifespan (death_year - birth_year)

### 2. Thematic Timeline by Categories (`milecatline.png`)
**Purpose:** Show temporal distribution of milestones across multiple categorical dimensions

**Visual Elements:**
- Categorical timeline with multiple horizontal tracks
- Rows organized by Subject (Human, Physical, Mathematical) and Aspect (Maps, Diagrams, Technology)
- Different symbols and colors for categories
- Vertical dashed lines marking historical epochs
- Epoch labels: "Early maps", "Measurement & Theory", "New graphic forms", etc.
- Colored sidebars distinguishing Subject vs Aspect groupings
- Marginal counts showing total milestones per category

**Data Requirements:**
- Milestone dates
- Subject classifications
- Aspect classifications
- Epoch definitions with time boundaries

### 3. Geographic Density Comparison (`mileyears4.png`)
**Purpose:** Compare temporal distribution of milestones across geographic regions

**Visual Elements:**
- Two overlaid density curves (Europe: blue, North America: red)
- Rug plots at bottom (color-coded by region)
- Vertical reference lines for epoch boundaries
- Epoch labels positioned above curves
- Sample size annotations (n=83, n=162)
- Smooth density curves with appropriate bandwidth

**Data Requirements:**
- Milestone dates
- Geographic location (derived from location field or author nationality)
- Epoch definitions

**Implementation Details:** (from `dev/mileyears4.R`)
- Uses `density()` with Sheather-Jones bandwidth selection (`bw="sj"`)
- Separate `adjust` parameters to equalize visual weight (adjust=2.5 for smaller group, 0.75 for larger)
- Epoch reference lines: 1600, 1700, 1800, 1850, 1900, 1950, 1975
- Epoch labels positioned strategically to avoid overlap

### 4. Author Biography Chart (`timespan.png`)
**Purpose:** Visualize lifespans of milestone authors grouped by country

**Visual Elements:**
- Horizontal line segments from birth year to death year
- Grouped into facets (England/Scotland vs France)
- Author names labeled at endpoints (birth or death)
- Points marking birth (filled) and death (open or filled)
- Sorted within groups for readability
- Elegant use of space and typography

**Data Requirements:**
- Author birth/death years
- Author names
- Author nationality/location
- Geographic groupings (e.g., England/Scotland, France)

---

## Proposed Visualization Functions

### Priority 1: Core Timeline Functions

#### `plot_milestone_timeline()`
**Purpose:** Create a basic timeline of milestones with optional grouping

**Parameters:**
```r
plot_milestone_timeline(
  ms = NULL,                    # milestone data frame or IDs
  date_col = "date_from_numeric",
  group_by = NULL,              # NULL, "subject", "aspect", "keyword"
  symbols = TRUE,               # use different symbols for groups
  colors = NULL,                # color palette
  epochs = TRUE,                # show epoch reference lines
  epoch_labels = TRUE,          # show epoch labels
  rug = TRUE,                   # show rug plot
  counts = TRUE,                # show marginal counts
  title = NULL,
  xlab = "Year",
  xlim = NULL,
  ...
)
```

**Features:**
- Flexible grouping by subject, aspect, or keyword
- Optional epoch markers and labels
- Customizable symbols and colors
- Marginal count summaries
- Returns ggplot2 object for customization

**Examples:**
```r
# Basic timeline
plot_milestone_timeline()

# Grouped by subject
plot_milestone_timeline(group_by = "subject")

# Grouped by aspect with custom colors
plot_milestone_timeline(group_by = "aspect",
                        colors = c("Maps" = "red", "Diagrams" = "blue"))

# Subset of milestones
playfair_ids <- search_authors("Playfair")
plot_milestone_timeline(playfair_ids, title = "Playfair's Milestones")
```

#### `plot_milestone_density()`
**Purpose:** Create density plots of milestone temporal distribution

**Parameters:**
```r
plot_milestone_density(
  ms = NULL,                    # milestone data frame or IDs
  date_col = "date_from_numeric",
  group_by = NULL,              # grouping variable for comparison
  adjust = 1,                   # bandwidth adjustment
  bw = "SJ",                    # bandwidth selection method
  from = NULL,                  # start of density estimation
  to = NULL,                    # end of density estimation
  overlay = TRUE,               # overlay groups or facet
  epochs = TRUE,                # show epoch reference lines
  epoch_labels = TRUE,          # show epoch labels
  rug = TRUE,                   # show rug plot
  labels = TRUE,                # show sample size labels
  title = NULL,
  xlab = "Year",
  ylab = "Frequency",
  colors = NULL,
  ...
)
```

**Features:**
- Kernel density estimation with multiple bandwidth options
- Overlay or facet multiple groups
- Automatic or manual epoch definitions
- Rug plots color-coded by group
- Sample size annotations

**Examples:**
```r
# Overall density
plot_milestone_density()

# Compare subjects
plot_milestone_density(group_by = "subject")

# Geographic comparison (requires location field enhancement)
europe_ids <- search_milestones("France|England|Germany", fields = "location")
namer_ids <- search_milestones("United States|Canada", fields = "location")
plot_milestone_density(ms = list(Europe = europe_ids,
                                 "North America" = namer_ids))

# Custom bandwidth and range
plot_milestone_density(bw = "sj", adjust = 1.5, from = 1500, to = 2000)
```

#### `plot_author_lifespans()`
**Purpose:** Create a biography-style chart of author lifespans

**Parameters:**
```r
plot_author_lifespans(
  authors = NULL,               # author IDs or data frame
  group_by = NULL,              # grouping variable (e.g., nationality)
  sort_by = c("birth", "death", "alphabetical"),
  facet = FALSE,                # facet by groups
  labels = c("all", "endpoints", "extremes", "none"),
  label_position = c("auto", "left", "right", "both"),
  colors = NULL,
  title = NULL,
  xlab = "Year",
  xlim = NULL,
  ...
)
```

**Features:**
- Horizontal line segments from birth to death
- Flexible grouping and sorting
- Smart label placement to avoid overlap
- Faceting options for large datasets
- Highlight extremes (shortest/longest lifespans)

**Examples:**
```r
# All authors
plot_author_lifespans()

# Authors grouped by nationality
plot_author_lifespans(group_by = "nationality", facet = TRUE)

# Just the extremes
plot_author_lifespans(labels = "extremes")

# Authors from a specific milestone
halley_authors <- get_milestone_authors(53)
plot_author_lifespans(halley_authors)
```

#### `plot_lifespan_distribution()`
**Purpose:** Show distribution of author lifespans

**Parameters:**
```r
plot_lifespan_distribution(
  authors = NULL,
  type = c("density", "histogram", "both"),
  rug = TRUE,
  annotate_extremes = TRUE,
  n_extremes = 3,               # number of extremes to label
  bw = "SJ",
  title = NULL,
  xlab = "Lifespan (years)",
  ylab = "Density",
  ...
)
```

**Features:**
- Density curve of lifespan distribution
- Rug plot showing individual lifespans
- Automatic annotation of extreme values
- Option for histogram or combined plot

**Examples:**
```r
# Basic lifespan distribution
plot_lifespan_distribution()

# With histogram overlay
plot_lifespan_distribution(type = "both")

# More extreme labels
plot_lifespan_distribution(annotate_extremes = TRUE, n_extremes = 5)
```

---

### Priority 2: Enhanced Analysis Functions

#### `plot_milestone_cumulative()`
**Purpose:** Show cumulative count of milestones over time

**Parameters:**
```r
plot_milestone_cumulative(
  ms = NULL,
  date_col = "date_from_numeric",
  group_by = NULL,
  step = TRUE,                  # step function vs smooth
  epochs = TRUE,
  acceleration_bands = FALSE,   # highlight periods of rapid growth
  title = NULL,
  xlab = "Year",
  ylab = "Cumulative Count",
  ...
)
```

**Features:**
- Step function or smoothed cumulative curve
- Compare groups
- Highlight periods of acceleration
- Derivative annotations showing rate of change

**Examples:**
```r
# Overall cumulative
plot_milestone_cumulative()

# By subject
plot_milestone_cumulative(group_by = "subject")

# Show acceleration
plot_milestone_cumulative(acceleration_bands = TRUE)
```

#### `plot_milestone_gaps()`
**Purpose:** Identify and visualize temporal gaps in milestone history

**Parameters:**
```r
plot_milestone_gaps(
  ms = NULL,
  date_col = "date_from_numeric",
  gap_threshold = NULL,         # auto-detect or specify
  highlight = TRUE,
  annotate = TRUE,
  ...
)
```

**Features:**
- Detect unusual gaps between milestones
- Annotate "dark ages" or quiet periods
- Statistical identification of significant gaps

#### `plot_milestone_heatmap()`
**Purpose:** Create a 2D heatmap showing milestone density by category and time

**Parameters:**
```r
plot_milestone_heatmap(
  ms = NULL,
  x_var = "year_bin",
  y_var = "subject",
  bin_width = 10,               # years per bin
  scale = c("count", "density", "proportion"),
  colors = NULL,
  ...
)
```

**Features:**
- Bin milestones by time periods
- Cross-tabulate with categorical variables
- Color intensity showing concentration

---

### Priority 3: Supporting Functions

#### `define_epochs()`
**Purpose:** Create and manage epoch definitions

**Parameters:**
```r
define_epochs(
  breaks = NULL,
  labels = NULL,
  style = c("default", "custom"),
  add = FALSE                   # add to existing defaults
)
```

**Default Epochs:**
Based on `mileyears4.R`:
- 1500-1600: Early maps & diagrams
- 1600-1700: Measurement & theory
- 1700-1800: New graphic forms
- 1800-1850: Modern age
- 1850-1900: Golden Age
- 1900-1950: Dark age
- 1950-1975: Re-birth
- 1975-2000: Hi-Dim Vis

**Examples:**
```r
# Get default epochs
epochs <- define_epochs()

# Custom epochs
my_epochs <- define_epochs(
  breaks = c(1600, 1750, 1850, 1950),
  labels = c("Early", "Enlightenment", "Industrial", "Modern")
)

# Add to defaults
define_epochs(breaks = c(2000), labels = "Digital Age", add = TRUE)
```

#### `prepare_milestone_data()`
**Purpose:** Helper to prepare milestone data for plotting

**Parameters:**
```r
prepare_milestone_data(
  ms = NULL,
  date_col = "date_from_numeric",
  group_col = NULL,
  filter_incomplete = TRUE,     # remove NA dates
  add_epochs = TRUE,
  add_location_category = TRUE  # categorize locations
)
```

**Features:**
- Standardize data input (IDs, data frames, or NULL for all)
- Add computed columns (epoch, decade, century)
- Merge with related tables as needed
- Validate and clean data

#### `add_epoch_lines()`
**Purpose:** Add epoch reference lines and labels to existing plot

**Parameters:**
```r
add_epoch_lines(
  plot = NULL,                  # existing ggplot object
  epochs = NULL,                # epoch definitions
  lines = TRUE,
  labels = TRUE,
  label_position = c("top", "bottom", "auto"),
  line_type = "dashed",
  line_color = "gray50",
  ...
)
```

**Features:**
- Works with any ggplot timeline
- Flexible positioning
- Customizable styling

---

## Implementation Strategy

### Phase 1: Foundation (Weeks 1-2)
1. Implement `define_epochs()` with default epoch definitions
2. Create `prepare_milestone_data()` helper function
3. Develop base plotting theme consistent with example plots
4. Create utility functions for:
   - Label placement/anti-collision
   - Color palette generation
   - Legend formatting

### Phase 2: Core Functions (Weeks 3-5)
1. `plot_milestone_timeline()` - Start with basic version
2. `plot_milestone_density()` - Adapt from `mileyears4.R` code
3. `plot_author_lifespans()` - Biography chart
4. `plot_lifespan_distribution()` - Author lifespan analysis

### Phase 3: Enhancement (Weeks 6-7)
1. Add grouping/faceting to core functions
2. Implement `plot_milestone_cumulative()`
3. Add interactive features (optional plotly conversion)
4. Polish aesthetics and themes

### Phase 4: Documentation & Testing (Week 8)
1. Complete function documentation with examples
2. Create vignette: "Visualizing Milestones"
3. Comprehensive testing with edge cases
4. Performance optimization for large datasets

---

## Technical Decisions

### Plotting Framework: ggplot2
**Rationale:**
- Consistent with tidyverse ecosystem
- Excellent theming and customization
- Easy to extend with additional layers
- Returns objects users can further customize
- Good documentation and community support

**Alternative Considered:**
- Base R graphics (used in current examples)
  - Pros: No dependencies, full control
  - Cons: Harder to extend, less consistent API

### Key Dependencies
- **Required:** ggplot2, scales
- **Suggested:** ggrepel (for label placement), patchwork (for combining plots)
- **Optional:** plotly (for interactive versions), gganimate (for animated timelines)

### Design Principles
1. **Sensible defaults:** Work out-of-box with minimal arguments
2. **Customizable:** Return ggplot objects for user modification
3. **Data-flexible:** Accept IDs, data frames, or NULL (all data)
4. **Consistent API:** Similar parameters across functions
5. **Documented examples:** Each function with 3-5 examples
6. **Performant:** Efficient for 300+ milestones, 250+ authors

---

## Data Enhancements Needed

### Geographic Categories
Currently, the `location` field is free-text. For geographic comparisons:
1. Add helper function to categorize locations:
   - Europe (by country)
   - North America (US, Canada)
   - Other regions
2. Options:
   - Parse existing location strings
   - Add `region` field to milestone data
   - Create `milestone2location` linking table

### Epoch Classifications
1. Create `epoch` data table with:
   - `epoch_id`, `epoch_name`, `start_year`, `end_year`, `description`
2. Add epoch assignment to milestones
3. Make epochs customizable per analysis

### Author Nationalities
Enhance `author` table to better support geographic grouping:
1. Standardize birth/death location format
2. Add `nationality` or `country` field
3. Support multiple nationalities for international authors

---

## Example Vignette Outline

### "Visualizing Milestones in Data Visualization History"

**1. Introduction**
- Brief history of the Milestones Project
- Overview of visualization capabilities

**2. Timeline Visualizations**
```r
# Basic timeline
plot_milestone_timeline()

# Grouped by subject and aspect
plot_milestone_timeline(group_by = "subject") +
  labs(title = "Milestones by Subject Area")
```

**3. Temporal Density Analysis**
```r
# Overall distribution
plot_milestone_density()

# Geographic comparison
plot_milestone_density(group_by = "region")

# Custom epochs
my_epochs <- define_epochs(...)
plot_milestone_density(epochs = my_epochs)
```

**4. Author Biography Charts**
```r
# All authors
plot_author_lifespans()

# Grouped by nationality
plot_author_lifespans(group_by = "nationality", facet = TRUE)

# Lifespan distribution
plot_lifespan_distribution(annotate_extremes = TRUE)
```

**5. Cumulative Growth Analysis**
```r
# Overall growth
plot_milestone_cumulative()

# By subject
plot_milestone_cumulative(group_by = "subject")
```

**6. Advanced Customization**
```r
# Start with basic plot
p <- plot_milestone_timeline(group_by = "aspect")

# Add custom annotations
p + annotate("rect", xmin = 1850, xmax = 1900,
             ymin = -Inf, ymax = Inf, alpha = 0.2) +
  labs(subtitle = "The Golden Age highlighted")

# Custom theme
p + theme_minimal() +
  theme(legend.position = "bottom")
```

**7. Combining Plots**
```r
library(patchwork)

p1 <- plot_milestone_density()
p2 <- plot_milestone_cumulative()

p1 / p2
```

**8. Export for Publications**
```r
ggsave("milestones-timeline.pdf",
       width = 10, height = 6, dpi = 300)
```

---

## Testing Strategy

### Unit Tests
- Each function with various input types
- Edge cases: empty data, single point, all same date
- Parameter validation
- Return value structure

### Integration Tests
- Functions work with real milestone data
- Plots render without errors
- Grouped operations work correctly

### Visual Regression Tests
- Compare output plots to reference images
- Detect unintended visual changes
- Use vdiffr package for automated comparison

### Performance Tests
- Benchmark with full dataset (297 milestones)
- Ensure reasonable render times (<2 seconds)
- Memory usage monitoring

---

## Future Enhancements (Beyond Initial Release)

### Interactive Visualizations
- Convert static plots to plotly for tooltips and zooming
- Create Shiny app with interactive filtering and plot updates
- Linked brushing across multiple views

### Network Visualizations
- Author collaboration networks
- Citation networks between milestones
- Influence graphs

### Geographic Maps
- Leaflet maps showing milestone locations
- Animated maps showing spread over time
- Choropleth maps by country/region

### Animated Timelines
- gganimate for temporal evolution
- Show accumulation of milestones over time
- Highlight different aspects/subjects sequentially

### Advanced Analytics
- Changepoint detection in milestone frequency
- Trend analysis and forecasting
- Clustering of similar time periods

---

## Open Questions for Discussion

1. **Geographic data:** Should we add location categorization now or later?
2. **Epoch definitions:** Hardcode defaults or make fully user-configurable?
3. **Dependencies:** How many ggplot2 extensions are acceptable?
4. **Interactivity:** Should initial release include plotly versions?
5. **Color palettes:** Create custom milestoneR palette or use existing (ColorBrewer, viridis)?
6. **Function naming:** Prefix all with `plot_milestone_*` or shorter names?

---

## References

- Friendly, M., Sigal, M. & Harnanansingh, D. (2015). "The Milestones Project: A Database for the History of Data Visualization."
- Existing visualization code: `dev/mileyears4.R`
- Example plots: `man/figures/{lifespan,milecatline,mileyears4,timespan}.png`
- ggplot2 documentation: https://ggplot2.tidyverse.org/
- Best practices: Wickham, H. (2016). "ggplot2: Elegant Graphics for Data Analysis"
