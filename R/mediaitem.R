#' Retrieve the `mediaitem` table from the milestones database
#'
#' The `mediaitem` table gives each link or image used in displaying the milestones items
#'
#' @return Returns a tibble of the `mediaitem` table
#' @details
#'
#'  The fields in the `mediaitem` table are:
#' \describe{
#'    \item{\code{miid}}{mediaitem id, a numeric vector}
#'    \item{\code{type}}{type, a character vector, with values \code{link}, \code{image}}
#'    \item{\code{url}}{URL to reference this item in the milestones application}
#'    \item{\code{title}}{a character vector}
#'    \item{\code{caption}}{a character vector}
#'    \item{\code{source}}{a character vector}
#'    \item{\code{mid}}{milestones id to which this is attached, a numeric vector}
#' }
#'
#' For `type=="link"`, these give a standard HTML reference in the `url` field.
#' For `type=="image"`, the `url` field references the image in the milestones website.
#'
#' @importFrom utils data
#' @export
#'
mediaitem <- function() {
  .mediaitem.env <- new.env()
  data(mediaitem, package = 'milestoneR', envir = .mediaitem.env)
  .mediaitem.env$mediaitem
}

