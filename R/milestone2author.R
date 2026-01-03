#' Retrieve the `milestone2author` table from the milestones database
#'
#' The `milestone2author` table links milestones to their authors.
#'
#' @return Returns a tibble of the `milestone2author` table
#' @details
#'  The fields in the `milestone2author` table are:
#'  \describe{
#'   \item{\code{mid}}{milestone id, a numeric vector}
#'   \item{\code{aid}}{author id, a numeric vector}
#'  }
#'
#'  This table links milestones to authors. Use with \code{\link{authors}}
#'  to get author information.
#'
#' @importFrom utils data
#' @export
#'
#' @seealso \code{\link{authors}}, \code{\link{milestone}}
#'
#' @examples
#' # Get milestone-author links
#' m2a <- milestone2author()
#'
milestone2author <- function() {
  .m2a.env <- new.env()
  data(milestone2author, package = 'milestoneR', envir = .m2a.env)
  .m2a.env$milestone2author
}

#' Milestone-to-author linking data
#'
#' A linking table that associates milestones with their authors.
#'
#' @format A data frame with 348 rows and 2 variables:
#' \describe{
#'   \item{mid}{milestone id, a numeric vector}
#'   \item{aid}{author id, a numeric vector}
#' }
#' @source \url{https://datavis.ca/milestones/}
#' @seealso \code{\link{authors}}, \code{\link{milestone}}
"milestone2author"
