#' Retrieve the `author` table from the milestones database
#'
#' @return Returns a tibble of the `author` table
#' @details
#' The `author` data set contains the following fields:
#'
#'   \describe{
#'      \item{\code{aid}}{author id, a numeric vector}
#'      \item{\code{prefix}}{name prefix, a character vector}
#'      \item{\code{givennames}}{givennames, a character vector}
#'      \item{\code{lname}}{last name, a character vector}
#'      \item{\code{suffix}}{name suffix, a character vector}
#'      \item{\code{lived}}{years lived, a character vector}
#'      \item{\code{birthdate}}{a Date vector}
#'      \item{\code{birthplace}}{place of birth, a character vector}
#'      \item{\code{birthlat}}{latitude of birthplace, a numeric vector}
#'      \item{\code{birthlong}}{longitude of birthplace, a numeric vector}
#'      \item{\code{deathdate}}{a Date vector}
#'      \item{\code{deathplace}}{a character vector}
#'      \item{\code{deathlat}}{latitude of deathplace, a numeric vector}
#'      \item{\code{deathlong}}{longitude of deathplace, a numeric vector}
#'      \item{\code{note}}{notes about this author, a character vector}
#'    }
#'
#' @importFrom tibble as_tibble
#' @importFrom utils data
#' @export
#'
#' @examples
#' # none yet
#'
authors <- function() {
  .author.env <- new.env()
  data(author, package = 'milestoneR', envir = .author.env)
  .author.env$author
}
