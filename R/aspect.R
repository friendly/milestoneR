#' Aspect classification data from the Milestones Project
#'
#' Retrieve the `aspect` table containing aspect classifications that indicate
#' the role milestone events played in the history of data visualization.
#'
#' @return A data frame with 4 rows and 2 variables:
#' \describe{
#'   \item{asid}{aspect id, a numeric vector}
#'   \item{name}{aspect name (Cartography, Statistics & Graphics, Technology, Other), a character vector}
#' }
#'
#' @details
#'  The aspect classification indicates the role an event played in the history
#'  of data visualization. Use \code{\link{milestone2aspect}} to link milestones
#'  to their aspects.
#'
#' @source \url{https://datavis.ca/milestones/}
#' @seealso \code{\link{milestone2aspect}}
#' @importFrom utils data
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all aspects
#' aspect()
#' }
#'
aspect <- function() {
  .aspect.env <- new.env()
  data(aspect, package = 'milestoneR', envir = .aspect.env)
  .aspect.env$aspect
}

#' @name aspect-data
#' @rdname aspect
#' @format A data frame. See \code{\link{aspect}} for details.
NULL
