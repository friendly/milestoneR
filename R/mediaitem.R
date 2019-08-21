#' Retrieve the `mediaitem` table from the milestones database
#'
#' The `mediaitem` table gives each link or image used in displaying the milestones items
#'
#' @return Returns a tibble of the `mediaitem` table
#' @details
#'
#' \describe{
#'    \item{\code{miid}}{mediaitem id, a numeric vector}
#'    \item{\code{type}}{type, a factor, with values \code{link}, \code{image}}
#'    \item{\code{url}}{URL to reference this item in the milestones application}
#'    \item{\code{title}}{a character vector}
#'    \item{\code{caption}}{a character vector}
#'    \item{\code{source}}{a character vector}
#'    \item{\code{mid}}{milestones id to which this is attached, a numeric vector}
#' }

#' @export
#'
mediaitem <- function() {
  mstones_con = .mstone.env$connnection
  mitems <- as_tibble(dbReadTable(mitems_con,
                                   'mediaitem'))
  mitems <- mitems %>%
    mutate(type = as.factor(type)) %>%
    # should use a general html2latin1
    mutate(title = str_replace(title, "&#039;", "'")) %>%
    mutate(title = str_replace(title, "&quot;", '"'))

  mitems
}

