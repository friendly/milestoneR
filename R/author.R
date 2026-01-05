#' Author data from the Milestones Project
#'
#' Retrieve the `author` table containing information about authors associated
#' with milestone events in the history of data visualization.
#'
#' @return A data frame with 290 rows and 15 variables:
#' \describe{
#'   \item{aid}{author id, a numeric vector}
#'   \item{prefix}{name prefix, a character vector}
#'   \item{givennames}{given names, a character vector}
#'   \item{lname}{last name, a character vector}
#'   \item{suffix}{name suffix, a character vector}
#'   \item{lived}{years lived, a character vector}
#'   \item{birthdate}{birth date, a Date vector}
#'   \item{birthplace}{place of birth, a character vector}
#'   \item{birthlat}{latitude of birthplace, a numeric vector}
#'   \item{birthlong}{longitude of birthplace, a numeric vector}
#'   \item{deathdate}{death date, a Date vector}
#'   \item{deathplace}{place of death, a character vector}
#'   \item{deathlat}{latitude of deathplace, a numeric vector}
#'   \item{deathlong}{longitude of deathplace, a numeric vector}
#'   \item{note}{notes about this author, a character vector}
#' }
#'
#' @source <https://datavis.ca/milestones/>
#' @importFrom utils data
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all authors
#' aut <- authors()
#'
#' # Filter by birth location
#' library(dplyr)
#' aut |> filter(!is.na(birthplace))
#' }
#'
authors <- function() {
  .author.env <- new.env()
  data(author, package = 'milestoneR', envir = .author.env)
  .author.env$author
}

#' @name author
#' @rdname authors
#' @format A data frame. See [authors()] for details.
NULL
