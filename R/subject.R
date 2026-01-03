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

#' Subject classification data from the Milestones Project
#'
#' A lookup table containing subject classifications that indicate the
#' substantive context of milestone events.
#'
#' @format A data frame with 4 rows and 2 variables:
#' \describe{
#'   \item{sid}{subject id, a numeric vector}
#'   \item{name}{subject name (Physical, Mathematical, Human, Other), a character vector}
#' }
#' @source \url{https://datavis.ca/milestones/}
#' @seealso \code{\link{milestone2subject}}
"subject"
