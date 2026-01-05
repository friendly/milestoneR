#' Retrieve the `milestone2author` table from the milestones database
#'
#' The `milestone2author` table links milestones to their authors.
#'
#' @return Returns a tibble of the `milestone2author` table
#' @details
#'  The fields in the `milestone2author` table are:
#'  \describe{
#'   \item{`mid`}{milestone id, a numeric vector}
#'   \item{`aid`}{author id, a numeric vector}
#'  }
#'
#'  This table links milestones to authors. Use with [authors()]
#'  to get author information.
#'
#' @importFrom utils data
#' @export
#'
#' @seealso [authors()], [milestone()]
#'
#' @examples
#' \dontrun{
#' # Get milestone-author links
#' m2a <- milestone2author()
#' }
#'
milestone2author <- function() {
  .m2a.env <- new.env()
  data(milestone2author, package = 'milestoneR', envir = .m2a.env)
  .m2a.env$milestone2author
}

#' @name milestone2author-data
#' @rdname milestone2author
#' @format A data frame. See [milestone2author()] for details.
NULL
