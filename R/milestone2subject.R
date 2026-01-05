#' Retrieve the `milestone2subject` table from the milestones database
#'
#' The `milestone2subject` table links milestones to their subject classifications.
#'
#' @return Returns a tibble of the `milestone2subject` table
#' @details
#'  The fields in the `milestone2subject` table are:
#'  \describe{
#'   \item{`mid`}{milestone id, a numeric vector}
#'   \item{`sid`}{subject id, a numeric vector}
#'   \item{`subject`}{subject name, a character vector}
#'  }
#'
#'  This table links milestones to subjects. The `subject` field is included
#'  for convenience (joined from the [subject()] table).
#'
#' @importFrom utils data
#' @export
#'
#' @seealso [subject()], [milestone()]
#'
#' @examples
#' \dontrun{
#' # Get milestone-subject links
#' m2s <- milestone2subject()
#' }
#'
milestone2subject <- function() {
  .m2s.env <- new.env()
  data(milestone2subject, package = 'milestoneR', envir = .m2s.env)
  .m2s.env$milestone2subject
}

#' @name milestone2subject-data
#' @rdname milestone2subject
#' @format A data frame. See [milestone2subject()] for details.
NULL
