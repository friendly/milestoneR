#' Subject classification data from the Milestones Project
#'
#' Retrieve the `subject` table containing subject classifications that indicate
#' the substantive context of milestone events.
#'
#' @return A data frame with 4 rows and 2 variables:
#' \describe{
#'   \item{sid}{subject id, a numeric vector}
#'   \item{name}{subject name (Physical, Mathematical, Human, Other), a character vector}
#' }
#'
#' @details
#'  The subject classification indicates the substantive context of the milestone event.
#'  Use \code{\link{milestone2subject}} to link milestones to their subjects.
#'
#' @source \url{https://datavis.ca/milestones/}
#' @seealso \code{\link{milestone2subject}}
#' @importFrom utils data
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all subjects
#' subj <- subject()
#' }
#'
subject <- function() {
  .subject.env <- new.env()
  data(subject, package = 'milestoneR', envir = .subject.env)
  .subject.env$subject
}

#' @name subject-data
#' @rdname subject
#' @format A data frame. See \code{\link{subject}} for details.
NULL
