#' Retrieve the `milestone2aspect` table from the milestones database
#'
#' The `milestone2aspect` table links milestones to their aspect classifications.
#'
#' @return Returns a tibble of the `milestone2aspect` table
#' @details
#'  The fields in the `milestone2aspect` table are:
#'  \describe{
#'   \item{`mid`}{milestone id, a numeric vector}
#'   \item{`asid`}{aspect id, a numeric vector}
#'   \item{`aspect`}{aspect name, a character vector}
#'  }
#'
#'  This table links milestones to aspects. The `aspect` field is included
#'  for convenience (joined from the [aspect()] table).
#'
#' @importFrom utils data
#' @export
#'
#' @seealso [aspect()], [milestone()]
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
#' @format A data frame. See [milestone2aspect()] for details.
NULL
