# Demo: Using epoch functions for milestone visualization
# This shows the intended usage patterns without implementing full plots yet
# 2026-01-09

library(milestoneR)
devtools::load_all()

cat("==== Epoch Usage Demonstration ====\n\n")

# Load milestone data
ms <- milestone()

cat("Total milestones:", nrow(ms), "\n")
cat("Date range:", min(ms$date_from_numeric, na.rm = TRUE), "-",
    max(ms$date_from_numeric, na.rm = TRUE), "\n\n")

# ---- Example 1: Basic epoch definition ----
cat("Example 1: Get default epochs\n")
epochs <- define_epochs()
print(epochs)
cat("\n")

# ---- Example 2: Extended epochs for full data range ----
cat("Example 2: Extend epochs to cover all data\n")
extended <- define_epochs(extend = "before")
print(extended)
cat("\n")

# ---- Example 3: Add epoch information to milestones ----
cat("Example 3: Classify milestones by epoch\n")
ms$epoch <- get_epoch(ms$date_from_numeric, extended)
ms$epoch_id <- get_epoch(ms$date_from_numeric, extended, label = FALSE)

# Show sample
cat("\nSample milestones with epochs:\n")
sample_idx <- c(1, 50, 100, 150, 200, 250, 297)
print(ms[sample_idx, c("mid", "date_from_numeric", "tag", "epoch")])
cat("\n")

# Count milestones per epoch
cat("Milestones per epoch:\n")
epoch_counts <- table(ms$epoch, useNA = "ifany")
print(epoch_counts)
cat("\n")

# ---- Example 4: Detailed epoch statistics ----
cat("Example 4: Epoch statistics\n")
epoch_stats <- aggregate(
  date_from_numeric ~ epoch,
  data = ms[!is.na(ms$epoch), ],
  FUN = function(x) c(count = length(x), min = min(x), max = max(x), median = median(x))
)
# Expand the matrix column
epoch_summary <- data.frame(
  epoch = epoch_stats$epoch,
  count = epoch_stats$date_from_numeric[, "count"],
  min_year = epoch_stats$date_from_numeric[, "min"],
  max_year = epoch_stats$date_from_numeric[, "max"],
  median_year = epoch_stats$date_from_numeric[, "median"]
)
print(epoch_summary)
cat("\n")

# ---- Example 5: Get boundaries for plotting ----
cat("Example 5: Extract epoch boundaries for vertical lines\n")
boundaries <- epoch_boundaries(extended)
cat("Boundaries:", boundaries, "\n")
cat("These would be used as: geom_vline(xintercept = boundaries, ...)\n\n")

# ---- Example 6: Custom epochs for specific analysis ----
cat("Example 6: Define custom epochs for 'centuries' analysis\n")
century_epochs <- define_epochs(
  breaks = seq(1500, 2100, by = 100),
  labels = paste0(seq(1500, 2000, by = 100), "s"),
  style = "custom"
)
print(century_epochs)
cat("\n")

# Classify by century
ms$century <- get_epoch(ms$date_from_numeric, century_epochs)
cat("Milestones by century:\n")
print(table(ms$century, useNA = "ifany"))
cat("\n")

# ---- Example 7: Find milestones at epoch boundaries ----
cat("Example 7: Milestones near epoch transitions\n")
# Find milestones within 5 years of a boundary
boundaries <- epoch_boundaries(extended)
ms$near_boundary <- FALSE
for (b in boundaries) {
  ms$near_boundary <- ms$near_boundary |
    (abs(ms$date_from_numeric - b) <= 5)
}

boundary_milestones <- ms[ms$near_boundary & !is.na(ms$near_boundary),
                          c("mid", "date_from_numeric", "tag", "epoch")]
cat("Found", nrow(boundary_milestones), "milestones within 5 years of epoch boundaries\n")
cat("\nFirst 10:\n")
print(head(boundary_milestones, 10))
cat("\n")

# ---- Example 8: How epochs would be used in plotting (pseudocode) ----
cat("Example 8: Pseudocode for plot integration\n")
cat('
# In a future plot_milestone_timeline() function:

plot_milestone_timeline <- function(ms, epochs = TRUE, epoch_labels = TRUE, ...) {

  # Get epoch definitions
  if (isTRUE(epochs)) {
    epoch_data <- define_epochs(extend = "before")
  } else if (inherits(epochs, "milestone_epochs")) {
    epoch_data <- epochs
  } else {
    epoch_data <- NULL
  }

  # Build base plot
  p <- ggplot(ms, aes(x = date_from_numeric)) + ...

  # Add epoch boundaries as vertical lines
  if (!is.null(epoch_data)) {
    boundaries <- epoch_boundaries(epoch_data)
    p <- p + geom_vline(xintercept = boundaries,
                        linetype = "dashed",
                        color = "brown")
  }

  # Add epoch labels
  if (epoch_labels && !is.null(epoch_data)) {
    p <- p + geom_text(data = epoch_data,
                       aes(x = midpoint, y = ..., label = label),
                       size = 3, vjust = -0.5)
  }

  return(p)
}

# Usage examples:
# plot_milestone_timeline(ms)  # Use defaults
# plot_milestone_timeline(ms, epochs = define_epochs(extend = TRUE))
# plot_milestone_timeline(ms, epochs = FALSE)  # No epochs
')

cat("\n==== Demo completed ====\n")
