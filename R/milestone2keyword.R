#' Retrieve the `milestone2keyword` table from the milestones database
#'
#' The `milestone2keyword` table links milestones to their keywords.
#'
#' @return Returns a tibble of the `milestone2keyword` table
#' @details
#'  The fields in the `milestone2keyword` table are:
#'  \describe{
#'   \item{`mid`}{milestone id, a numeric vector}
#'   \item{`kid`}{keyword id, a numeric vector}
#'   \item{`keyword`}{keyword name, a character vector}
#'  }
#'
#'  This table links milestones to keywords. The `keyword` field is included
#'  for convenience (joined from the [keyword()] table).
#'
#' @importFrom utils data
#' @export
#'
#' @seealso [keyword()], [milestone()]
#'
#' @examples
#' \dontrun{
#' # Get milestone-keyword links
#' m2k <- milestone2keyword()
#' }
#'
milestone2keyword <- function() {
  .m2k.env <- new.env()
  data(milestone2keyword, package = 'milestoneR', envir = .m2k.env)
  .m2k.env$milestone2keyword
}

#' @name milestone2keyword-data
#' @rdname milestone2keyword
#' @format A data frame. See [milestone2keyword()] for details.
NULL
