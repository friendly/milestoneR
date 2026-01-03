#' Retrieve the `subject` table from the milestones database
#'
#' The `subject` table contains the classification of milestone events by their
#' substantive context.
#'
#' @return Returns a tibble of the `subject` table
#' @details
#'  The fields in the `subject` table are:
#'  \describe{
#'   \item{\code{sid}}{subject id, a numeric vector}
#'   \item{\code{name}}{subject name, a character vector with values:
#'     "Physical", "Mathematical", "Human", "Other"}
#'  }
#'
#'  The subject classification indicates the substantive context of the milestone event.
#'  Use \code{\link{milestone2subject}} to link milestones to their subjects.
#'
#' @importFrom utils data
#' @export
#'
#' @examples
#' # Get all subjects
#' subj <- subject()
#'
subject <- function() {
  .subject.env <- new.env()
  data(subject, package = 'milestoneR', envir = .subject.env)
  .subject.env$subject
}
