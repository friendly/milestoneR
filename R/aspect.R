#' Retrieve the `aspect` table from the milestones database
#'
#' The `aspect` table contains the classification of milestone events by their
#' role in the history of data visualization.
#'
#' @return Returns a tibble of the `aspect` table
#' @details
#'  The fields in the `aspect` table are:
#'  \describe{
#'   \item{\code{asid}}{aspect id, a numeric vector}
#'   \item{\code{name}}{aspect name, a character vector with values:
#'     "Cartography", "Statistics & Graphics", "Technology", "Other"}
#'  }
#'
#'  The aspect classification indicates the role an event played in the history
#'  of data visualization. Use \code{\link{milestone2aspect}} to link milestones
#'  to their aspects.
#'
#' @importFrom utils data
#' @export
#'
#' @examples
#' # Get all aspects
#' asp <- aspect()
#'
aspect <- function() {
  .aspect.env <- new.env()
  data(aspect, package = 'milestoneR', envir = .aspect.env)
  .aspect.env$aspect
}

#' Aspect classification data from the Milestones Project
#'
#' A lookup table containing aspect classifications that indicate the role
#' milestone events played in the history of data visualization.
#'
#' @format A data frame with 4 rows and 2 variables:
#' \describe{
#'   \item{asid}{aspect id, a numeric vector}
#'   \item{name}{aspect name (Cartography, Statistics & Graphics, Technology, Other), a character vector}
#' }
#' @source \url{https://datavis.ca/milestones/}
#' @seealso \code{\link{milestone2aspect}}
"aspect"
