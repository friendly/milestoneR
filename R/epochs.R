#' Define Historical Epochs for Timeline Visualization
#'
#' Creates a data structure defining historical epochs (time periods) for use in
#' timeline visualizations. Returns a data frame with epoch boundaries, labels,
#' and calculated midpoints.
#'
#' @param breaks Numeric vector of boundary years (for custom epochs). Must be
#'   sorted in ascending order.
#' @param labels Character vector of epoch names. Length must be one less than
#'   length of `breaks`.
#' @param descriptions Optional character vector of longer descriptions for each epoch.
#' @param style Character. Either "default" to use predefined epochs, or "custom"
#'   to use provided `breaks` and `labels`.
#' @param extend Character or logical. How to extend the default epochs:
#'   \itemize{
#'     \item \code{NULL} or \code{FALSE}: Use defaults as-is (1500-2000)
#'     \item \code{"before"}: Add Prehistory epoch (-Inf to 1500)
#'     \item \code{"after"}: Add Digital Age epoch (2000 to current year)
#'     \item \code{"both"} or \code{TRUE}: Add both Prehistory and Digital Age
#'   }
#'   Only used when \code{style = "default"}.
#'
#' @details
#' The default epochs are based on the periodization described in Friendly et al. (2015):
#' \itemize{
#'   \item 1500-1600: Early maps & diagrams
#'   \item 1600-1700: Measurement & theory
#'   \item 1700-1800: New graphic forms
#'   \item 1800-1850: Modern age
#'   \item 1850-1900: Golden Age
#'   \item 1900-1950: Dark age
#'   \item 1950-1975: Re-birth
#'   \item 1975-2000: Hi-Dim Vis
#' }
#'
#' The returned data frame has class \code{c("milestone_epochs", "data.frame")}
#' and contains columns:
#' \itemize{
#'   \item \code{epoch_id}: Sequential identifier (1, 2, 3, ...)
#'   \item \code{start}: Start year of epoch
#'   \item \code{end}: End year of epoch
#'   \item \code{label}: Short display name
#'   \item \code{midpoint}: (start + end) / 2, useful for label positioning
#'   \item \code{description}: Optional longer description
#' }
#'
#' @return A data frame of class \code{c("milestone_epochs", "data.frame")} with
#'   one row per epoch.
#'
#' @references
#' Friendly, M., Sigal, M. & Harnanansingh, D. (2015).
#' "The Milestones Project: A Database for the History of Data Visualization."
#' In Kimball, M. & Kostelnick, C. (Eds.)
#' \emph{Visible Numbers: The Historyof Data Visualization}, Chapter 10.
#'
#' @rdname epochs
#' @examples
#' # Get default epochs
#' epochs <- define_epochs()
#' print(epochs)
#'
#' # Extend with Prehistory and Digital Age
#' extended <- define_epochs(extend = TRUE)
#' print(extended)
#'
#' # Extend only before
#' with_prehistory <- define_epochs(extend = "before")
#'
#' # Define custom epochs (4 breaks creates 3 intervals)
#' my_epochs <- define_epochs(
#'   breaks = c(1600, 1750, 1900, 2000),
#'   labels = c("Early Modern", "Enlightenment", "Industrial"),
#'   style = "custom"
#' )
#'
#' # Get epoch boundaries for plotting vertical lines
#' boundaries <- epoch_boundaries(epochs)
#'
#' @export
define_epochs <- function(breaks = NULL,
                         labels = NULL,
                         descriptions = NULL,
                         style = c("default", "custom"),
                         extend = NULL) {

  style <- match.arg(style)

  # Handle extend = TRUE as "both"
  if (isTRUE(extend)) {
    extend <- "both"
  } else if (isFALSE(extend)) {
    extend <- NULL
  }

  # Validate extend argument
  if (!is.null(extend)) {
    extend <- match.arg(extend, choices = c("before", "after", "both"))
  }

  if (style == "default") {
    # Use predefined epochs
    breaks <- c(1500, 1600, 1700, 1800, 1850, 1900, 1950, 1975, 2000)
    labels <- c(
      "Early maps & diagrams",
      "Measurement & theory",
      "New graphic forms",
      "Modern age",
      "Golden Age",
      "Dark age",
      "Re-birth",
      "Hi-Dim Vis"
    )
    descriptions <- c(
      "Early cartography and diagrams",
      "Mathematical measurement and theory development",
      "Innovation in graphical forms",
      "Emergence of modern statistical graphics",
      "Golden age of data graphics and thematic cartography",
      "Decline in statistical graphics innovation",
      "Revival of statistical graphics and visualization",
      "High-dimensional visualization and computer graphics"
    )

    # Apply extend option
    if (!is.null(extend)) {
      if (extend %in% c("before", "both")) {
        breaks <- c(-Inf, breaks)
        labels <- c("Prehistory", labels)
        descriptions <- c("Pre-1500: Early development period", descriptions)
      }
      if (extend %in% c("after", "both")) {
        # Use current year as upper bound for Digital Age
        current_year <- as.integer(format(Sys.Date(), "%Y"))
        breaks <- c(breaks, current_year)
        labels <- c(labels, "Digital Age")
        descriptions <- c(descriptions, "Modern digital and web-based visualization")
      }
    }

  } else {
    # Custom epochs
    if (is.null(breaks) || is.null(labels)) {
      stop("For custom epochs, both 'breaks' and 'labels' must be provided")
    }

    # Validate inputs
    if (length(labels) != length(breaks) - 1) {
      stop(sprintf(
        "Length of labels (%d) must be one less than length of breaks (%d)",
        length(labels), length(breaks)
      ))
    }

    if (is.unsorted(breaks)) {
      stop("Breaks must be in ascending order")
    }

    if (any(diff(breaks) <= 0)) {
      stop("Breaks must be strictly increasing (no duplicates)")
    }
  }

  # Build the epochs data frame
  epochs <- data.frame(
    epoch_id = seq_along(labels),
    start = breaks[-length(breaks)],
    end = breaks[-1],
    label = labels,
    midpoint = (breaks[-length(breaks)] + breaks[-1]) / 2,
    stringsAsFactors = FALSE
  )

  # Add descriptions if provided
  if (!is.null(descriptions)) {
    if (length(descriptions) != nrow(epochs)) {
      warning(sprintf(
        "Length of descriptions (%d) does not match number of epochs (%d). Descriptions ignored.",
        length(descriptions), nrow(epochs)
      ))
    } else {
      epochs$description <- descriptions
    }
  }

  # Set class
  class(epochs) <- c("milestone_epochs", "data.frame")

  return(epochs)
}


#' Extract Epoch Boundaries
#'
#' Extracts the unique boundary years from an epoch definition. Useful for
#' adding vertical reference lines at epoch transitions.
#'
#' @param epochs An object of class \code{"milestone_epochs"} created by
#'   \code{\link{define_epochs}}.
#'
#' @return A numeric vector of unique, sorted boundary years.
#'
#' @examples
#' epochs <- define_epochs()
#' boundaries <- epoch_boundaries(epochs)
#' print(boundaries)
#'
#' @rdname epochs
#' @export
epoch_boundaries <- function(epochs) {
  if (!inherits(epochs, "milestone_epochs")) {
    stop("Input must be an object of class 'milestone_epochs'")
  }

  bounds <- c(epochs$start, epochs$end)
  bounds <- bounds[is.finite(bounds)]
  unique(sort(bounds))
}


#' Get Epoch for Given Year(s)
#'
#' Determines which epoch(s) one or more years belong to.
#'
#' @param year Numeric vector of years to classify.
#' @param epochs An object of class \code{"milestone_epochs"} created by
#'   \code{\link{define_epochs}}.
#' @param label Logical. If \code{TRUE}, return epoch labels; if \code{FALSE},
#'   return epoch IDs.
#'
#' @return A character vector (if \code{label = TRUE}) or integer vector
#'   (if \code{label = FALSE}) indicating which epoch each year belongs to.
#'   Years outside the epoch range return \code{NA}.
#'
#' @examples
#' epochs <- define_epochs()
#'
#' # Which epoch is 1850?
#' get_epoch(1850, epochs)
#'
#' # Multiple years
#' get_epoch(c(1650, 1850, 1975), epochs)
#'
#' # Get IDs instead of labels
#' get_epoch(c(1650, 1850), epochs, label = FALSE)
#'
#' @rdname epochs
#' @export
get_epoch <- function(year, epochs, label = TRUE) {
  if (!inherits(epochs, "milestone_epochs")) {
    stop("epochs must be an object of class 'milestone_epochs'")
  }

  # Use findInterval to locate which epoch each year falls into
  # findInterval returns 0 if before first interval, n+1 if after last
  idx <- findInterval(year, epochs$start, rightmost.closed = TRUE)

  # Adjust: findInterval returns the index of the start point that is <= year
  # We need to check that year is also < end
  epoch_id <- idx

  # Check if year is within valid range
  for (i in seq_along(year)) {
    if (idx[i] == 0 || idx[i] > nrow(epochs)) {
      epoch_id[i] <- NA_integer_
    } else {
      # Check if year is before the end of the epoch
      if (year[i] >= epochs$end[idx[i]]) {
        epoch_id[i] <- NA_integer_
      } else {
        epoch_id[i] <- idx[i]
      }
    }
  }

  if (label) {
    result <- epochs$label[epoch_id]
  } else {
    result <- epoch_id
  }

  return(result)
}


#' Print Method for Milestone Epochs
#'
#' @param x An object of class \code{"milestone_epochs"}.
#' @param ... Additional arguments (currently ignored).
#'
#' @return Invisibly returns the input object.
#'
#' @rdname epochs
#' @export
print.milestone_epochs <- function(x, ...) {
  cat("Milestone Epochs\n")
  cat(sprintf("Number of epochs: %d\n", nrow(x)))

  # Determine time range
  start_range <- if (is.na(x$start[1]) || !is.finite(x$start[1])) {
    "..."
  } else {
    as.character(x$start[1])
  }

  end_range <- if (is.na(x$end[nrow(x)]) || !is.finite(x$end[nrow(x)])) {
    "..."
  } else {
    as.character(x$end[nrow(x)])
  }

  cat(sprintf("Time range: %s to %s\n\n", start_range, end_range))

  # Print each epoch
  for (i in 1:nrow(x)) {
    start_str <- if (is.na(x$start[i]) || !is.finite(x$start[i])) {
      "..."
    } else {
      as.character(x$start[i])
    }

    end_str <- if (is.na(x$end[i]) || !is.finite(x$end[i])) {
      "..."
    } else {
      as.character(x$end[i])
    }

    cat(sprintf("%2d. %s-%s: %s\n", i, start_str, end_str, x$label[i]))
  }

  invisible(x)
}
