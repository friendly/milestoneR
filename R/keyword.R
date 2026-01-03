#' Retrieve the `keyword` table from the milestones database
#'
#' The `keyword` table contains keywords or terms attached to milestone items.
#'
#' @return Returns a tibble of the `keyword` table
#' @details
#'  The fields in the `keyword` table are:
#'  \describe{
#'   \item{\code{kid}}{keyword id, a numeric vector}
#'   \item{\code{name}}{keyword name, a character vector}
#'  }
#'
#'  This is a freeform classification listing keywords or terms attached to
#'  milestone items. Use \code{\link{milestone2keyword}} to link milestones
#'  to their keywords.
#'
#' @importFrom utils data
#' @export
#'
#' @examples
#' # Get all keywords
#' kw <- keyword()
#'
#' # Find keywords containing "chart"
#' library(dplyr)
#' kw |> filter(grepl("chart", name, ignore.case = TRUE))
#'
keyword <- function() {
  .keyword.env <- new.env()
  data(keyword, package = 'milestoneR', envir = .keyword.env)
  .keyword.env$keyword
}

#' Keyword data from the Milestones Project
#'
#' A lookup table containing keywords or terms that are attached to
#' milestone items as a freeform classification.
#'
#' @format A data frame with 335 rows and 2 variables:
#' \describe{
#'   \item{kid}{keyword id, a numeric vector}
#'   \item{name}{keyword name, a character vector}
#' }
#' @source \url{https://datavis.ca/milestones/}
#' @seealso \code{\link{milestone2keyword}}
"keyword"
