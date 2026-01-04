#' Retrieve the `milestone2aspect` table from the milestones database
#'
#' The `milestone2aspect` table links milestones to their aspect classifications.
#'
#' @return Returns a tibble of the `milestone2aspect` table
#' @details
#'  The fields in the `milestone2aspect` table are:
#'  \describe{
#'   \item{\code{mid}}{milestone id, a numeric vector}
#'   \item{\code{asid}}{aspect id, a numeric vector}
#'   \item{\code{aspect}}{aspect name, a character vector}
#'  }
#'
#'  This table links milestones to aspects. The \code{aspect} field is included
#'  for convenience (joined from the \code{\link{aspect}} table).
#'
#' @importFrom utils data
#' @export
#'
#' @seealso \code{\link{aspect}}, \code{\link{milestone}}
#'
#' @examples
#' \dontrun{
#' # Get milestone-aspect links
#' m2a <- milestone2aspect()
#' }
#'
milestone2aspect <- function() {
  .m2a.env <- new.env()
  data(milestone2aspect, package = 'milestoneR', envir = .m2a.env)
  .m2a.env$milestone2aspect
}

#' @name milestone2aspect-data
#' @rdname milestone2aspect
#' @format A data frame. See \code{\link{milestone2aspect}} for details.
NULL
