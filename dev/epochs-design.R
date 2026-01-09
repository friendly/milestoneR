# Exploring epoch data structures for timeline plots
# Michael Friendly, 2026-01-09

library(dplyr)
library(ggplot2)

# Option 1: Define epochs by intervals (data frame approach)
# This is most explicit and flexible for plotting

create_epochs_df <- function(breaks, labels, descriptions = NULL) {
  # breaks: numeric vector of boundary years
  # labels: character vector of epoch names (length = length(breaks) - 1)

  if (length(labels) != length(breaks) - 1) {
    stop("Length of labels must be one less than length of breaks")
  }

  epochs <- data.frame(
    epoch_id = seq_along(labels),
    start = breaks[-length(breaks)],
    end = breaks[-1],
    label = labels,
    midpoint = (breaks[-length(breaks)] + breaks[-1]) / 2,
    stringsAsFactors = FALSE
  )

  if (!is.null(descriptions)) {
    epochs$description <- descriptions
  }

  class(epochs) <- c("milestone_epochs", "data.frame")
  return(epochs)
}

# Default epochs based on the plan
default_breaks <- c(1500, 1600, 1700, 1800, 1850, 1900, 1950, 1975, 2000)

default_labels <- c(
  "Early maps & diagrams",
  "Measurement & theory",
  "New graphic forms",
  "Modern age",
  "Golden Age",
  "Dark age",
  "Re-birth",
  "Hi-Dim Vis"
)

default_descriptions <- c(
  "1500-1600: Early cartography and diagrams",
  "1600-1700: Mathematical measurement and theory development",
  "1700-1800: Innovation in graphical forms",
  "1800-1850: Emergence of modern statistical graphics",
  "1850-1900: Golden age of data graphics and thematic cartography",
  "1900-1950: Decline in statistical graphics innovation",
  "1950-1975: Revival of statistical graphics and visualization",
  "1975-2000: High-dimensional visualization and computer graphics"
)

# Create default epochs
default_epochs <- create_epochs_df(default_breaks, default_labels, default_descriptions)
print(default_epochs)

# Example: Add custom epoch for prehistory
# How to handle open-ended intervals?

# Option A: Use -Inf/Inf for open ends
prehistory_breaks <- c(-Inf, 1500, 1600, 1700, 1800, 1850, 1900, 1950, 1975, 2000, Inf)
prehistory_labels <- c(
  "Prehistory",
  default_labels,
  "Digital Age"
)

custom_epochs <- create_epochs_df(prehistory_breaks, prehistory_labels)
print(custom_epochs)

# Option B: Use NA for open ends (might be cleaner for plotting)
create_epochs_df2 <- function(breaks, labels, descriptions = NULL,
                               from = NA, to = NA) {
  # from, to: optional overall range to handle open-ended intervals

  n_labels <- length(labels)

  epochs <- data.frame(
    epoch_id = seq_along(labels),
    start = c(from, breaks)[1:n_labels],
    end = c(breaks, to)[1:n_labels],
    label = labels,
    stringsAsFactors = FALSE
  )

  # Calculate midpoint (handling NAs)
  epochs$midpoint <- ifelse(
    is.na(epochs$start) | is.na(epochs$end),
    NA,
    (epochs$start + epochs$end) / 2
  )

  if (!is.null(descriptions)) {
    epochs$description <- descriptions
  }

  class(epochs) <- c("milestone_epochs", "data.frame")
  return(epochs)
}

# Test option B
custom_epochs2 <- create_epochs_df2(
  breaks = default_breaks[-1],  # remove first 1500
  labels = c("Prehistory", default_labels),
  from = NA,
  to = 2000
)
print(custom_epochs2)


# ========================================================================
# Visualization examples showing how to use the epoch structure
# ========================================================================

# Load milestone data
library(milestoneR)
ms <- milestone()

# Simple plot with epoch boundaries
ggplot(ms, aes(x = date_from_numeric)) +
  geom_histogram(binwidth = 10, fill = "steelblue", alpha = 0.7) +
  # Add vertical lines at epoch boundaries
  geom_vline(data = default_epochs,
             aes(xintercept = start),
             linetype = "dashed", color = "brown", linewidth = 0.5) +
  # Add epoch labels at midpoints
  geom_text(data = default_epochs,
            aes(x = midpoint, y = 20, label = label),
            angle = 0, vjust = 0, size = 3, color = "gray30") +
  theme_minimal() +
  labs(title = "Milestones with epoch markers",
       x = "Year", y = "Count")

# With shaded rectangles (alternating)
default_epochs$shade <- rep(c(TRUE, FALSE), length.out = nrow(default_epochs))

ggplot(ms, aes(x = date_from_numeric)) +
  # Add shaded rectangles for alternating epochs
  geom_rect(data = default_epochs[default_epochs$shade, ],
            aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf),
            fill = "gray90", alpha = 0.5, inherit.aes = FALSE) +
  geom_histogram(binwidth = 10, fill = "steelblue", alpha = 0.7) +
  # Add vertical lines at epoch boundaries
  geom_vline(data = default_epochs,
             aes(xintercept = start),
             linetype = "dashed", color = "brown", linewidth = 0.5) +
  # Add epoch labels
  geom_text(data = default_epochs,
            aes(x = midpoint, y = 20, label = label),
            angle = 0, vjust = 0, size = 3, color = "gray30") +
  theme_minimal() +
  labs(title = "Milestones with shaded epoch regions",
       x = "Year", y = "Count")


# ========================================================================
# Print method for epochs
# ========================================================================

print.milestone_epochs <- function(x, ...) {
  cat("Milestone Epochs\n")
  cat(sprintf("Number of epochs: %d\n", nrow(x)))
  cat(sprintf("Time range: %s to %s\n",
              ifelse(is.na(x$start[1]), "open", x$start[1]),
              ifelse(is.na(x$end[nrow(x)]), "open", x$end[nrow(x)])))
  cat("\n")

  # Print each epoch
  for (i in 1:nrow(x)) {
    cat(sprintf("%d. %s-%s: %s\n",
                i,
                ifelse(is.na(x$start[i]), "...", x$start[i]),
                ifelse(is.na(x$end[i]), "...", x$end[i]),
                x$label[i]))
  }

  invisible(x)
}

# Test print method
print(default_epochs)
print(custom_epochs2)


# ========================================================================
# Helper function to extract epoch boundaries only (for vertical lines)
# ========================================================================

epoch_boundaries <- function(epochs) {
  # Returns unique sorted boundaries (excluding NAs and Infs)
  bounds <- c(epochs$start, epochs$end)
  bounds <- bounds[is.finite(bounds)]
  unique(sort(bounds))
}

epoch_boundaries(default_epochs)


# ========================================================================
# Next steps to consider:
# ========================================================================

# 1. Should define_epochs() return a data frame (as above) or an S3 object?
# 2. How to handle label positioning when plotting?
#    - Auto at midpoint (simple but may overlap data)
#    - User-specified y-position
#    - Smart positioning algorithm
# 3. Should epochs include visual attributes (color, alpha, line type)?
# 4. Validation: check for gaps, overlaps in epoch intervals?
# 5. Function to merge/extend epochs (add prehistory to defaults)
