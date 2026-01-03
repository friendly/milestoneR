#' Retrieve the `milestone2keyword` table from the milestones database
#'
#' The `milestone2keyword` table links milestones to their keywords.
#'
#' @return Returns a tibble of the `milestone2keyword` table
#' @details
#'  The fields in the `milestone2keyword` table are:
#'  \describe{
#'   \item{\code{mid}}{milestone id, a numeric vector}
#'   \item{\code{kid}}{keyword id, a numeric vector}
#'   \item{\code{keyword}}{keyword name, a character vector}
#'  }
#'
#'  This table links milestones to keywords. The \code{keyword} field is included
#'  for convenience (joined from the \code{\link{keyword}} table).
#'
#' @importFrom utils data
#' @export
#'
#' @seealso \code{\link{keyword}}, \code{\link{milestone}}
#'
#' @examples
#' # Get milestone-keyword links
#' m2k <- milestone2keyword()
#'
milestone2keyword <- function() {
  .m2k.env <- new.env()
  data(milestone2keyword, package = 'milestoneR', envir = .m2k.env)
  .m2k.env$milestone2keyword
}

#' Milestone-to-keyword linking data
#'
#' A linking table that associates milestones with their keywords.
#' The keyword field is included for convenience.
#'
#' @format A data frame with 454 rows and 3 variables:
#' \describe{
#'   \item{mid}{milestone id, a numeric vector}
#'   \item{kid}{keyword id, a numeric vector}
#'   \item{keyword}{keyword name, a character vector}
#' }
#' @source \url{https://datavis.ca/milestones/}
#' @seealso \code{\link{keyword}}, \code{\link{milestone}}
"milestone2keyword"
