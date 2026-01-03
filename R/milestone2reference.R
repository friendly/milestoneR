#' Retrieve the `milestone2reference` table from the milestones database
#'
#' The `milestone2reference` table links milestones to their references.
#'
#' @return Returns a tibble of the `milestone2reference` table
#' @details
#'  The fields in the `milestone2reference` table are:
#'  \describe{
#'   \item{\code{mid}}{milestone id, a numeric vector}
#'   \item{\code{rid}}{reference id, a numeric vector}
#'  }
#'
#'  This table links milestones to references. Use with \code{\link{reference}}
#'  to get reference information.
#'
#' @importFrom utils data
#' @export
#'
#' @seealso \code{\link{reference}}, \code{\link{milestone}}
#'
#' @examples
#' # Get milestone-reference links
#' m2r <- milestone2reference()
#'
milestone2reference <- function() {
  .m2r.env <- new.env()
  data(milestone2reference, package = 'milestoneR', envir = .m2r.env)
  .m2r.env$milestone2reference
}
