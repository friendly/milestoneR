#' Milestone data from the Milestones Project
#'
#' Retrieve the `milestone` table containing milestone events in the history of
#' data visualization. This is the primary table in the database. Other tables
#' are linked to it via the `mid` key.
#'
#' @return A data frame with 297 rows and 14 variables:
#' \describe{
#'   \item{mid}{milestone id, a numeric vector}
#'   \item{slug}{title slug, a character vector}
#'   \item{date_from_numeric}{numeric start date, a numeric vector}
#'   \item{date_from}{start date text, a character vector}
#'   \item{date_to_numeric}{numeric end date, a numeric vector}
#'   \item{date_to}{end date text, a character vector}
#'   \item{tag}{tag line, a character vector}
#'   \item{description}{description of the milestone, a character vector}
#'   \item{location}{location, a character vector}
#'   \item{add_date}{date added to database, a character vector}
#'   \item{modified_date}{date last modified, a character vector}
#'   \item{status}{publication status, a character vector}
#'   \item{note}{notes, a character vector}
#'   \item{extra}{extra information, a character vector}
#' }
#'
#' @source \url{https://datavis.ca/milestones/}
#' @importFrom utils data
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all milestones
#' m <- milestone()
#'
#' # Filter by date
#' library(dplyr)
#' m |> filter(date_from_numeric < 0)  # BC milestones
#' }
#'
milestone <- function() {
  # TODO: quoted strings are badly handled in the description field.
  # many instances like: (\"star plot&#039;&#039;) -> (\"star plot'') after html2utf8
  # Need one more gsub() to replace '' when it immediately follows \".*

  # TODO: Do we need to export both the date_from & date_from_numeric fields?

  mstones <- .get.mstone()
  mstones
}


#' @importFrom utils data
.get.mstone <- function(){
  .mstone.env <- new.env()
  data(milestone, package = 'milestoneR', envir = .mstone.env)
  .mstone.env$milestone
}

#' @name milestone-data
#' @rdname milestone
#' @format A data frame. See \code{\link{milestone}} for details.
NULL
