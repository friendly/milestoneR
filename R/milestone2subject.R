#' Retrieve the `milestone2subject` table from the milestones database
#'
#' The `milestone2subject` table links milestones to their subject classifications.
#'
#' @return Returns a tibble of the `milestone2subject` table
#' @details
#'  The fields in the `milestone2subject` table are:
#'  \describe{
#'   \item{\code{mid}}{milestone id, a numeric vector}
#'   \item{\code{sid}}{subject id, a numeric vector}
#'   \item{\code{subject}}{subject name, a character vector}
#'  }
#'
#'  This table links milestones to subjects. The \code{subject} field is included
#'  for convenience (joined from the \code{\link{subject}} table).
#'
#' @importFrom utils data
#' @export
#'
#' @seealso \code{\link{subject}}, \code{\link{milestone}}
#'
#' @examples
#' # Get milestone-subject links
#' m2s <- milestone2subject()
#'
milestone2subject <- function() {
  .m2s.env <- new.env()
  data(milestone2subject, package = 'milestoneR', envir = .m2s.env)
  .m2s.env$milestone2subject
}

#' Milestone-to-subject linking data
#'
#' A linking table that associates milestones with their subject classifications.
#' The subject field is included for convenience.
#'
#' @format A data frame with 298 rows and 3 variables:
#' \describe{
#'   \item{mid}{milestone id, a numeric vector}
#'   \item{sid}{subject id, a numeric vector}
#'   \item{subject}{subject name, a character vector}
#' }
#' @source \url{https://datavis.ca/milestones/}
#' @seealso \code{\link{subject}}, \code{\link{milestone}}
"milestone2subject"
