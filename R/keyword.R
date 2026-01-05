#' Keyword data from the Milestones Project
#'
#' Retrieve the `keyword` table containing keywords or terms attached to
#' milestone items as a freeform classification.
#'
#' @return A data frame with 335 rows and 2 variables:
#' \describe{
#'   \item{kid}{keyword id, a numeric vector}
#'   \item{name}{keyword name, a character vector}
#' }
#'
#' @details
#'  This is a freeform classification listing keywords or terms attached to
#'  milestone items. Use [milestone2keyword()] to link milestones
#'  to their keywords.
#'
#' @source <https://datavis.ca/milestones/>
#' @seealso [milestone2keyword()]
#' @importFrom utils data
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all keywords
#' kw <- keyword()
#'
#' # Find keywords containing "chart"
#' library(dplyr)
#' kw |> filter(grepl("chart", name, ignore.case = TRUE))
#' }
#'
keyword <- function() {
  .keyword.env <- new.env()
  data(keyword, package = 'milestoneR', envir = .keyword.env)
  .keyword.env$keyword
}

#' @name keyword-data
#' @rdname keyword
#' @format A data frame. See [keyword()] for details.
NULL
