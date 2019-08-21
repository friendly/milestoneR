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
#'      \item{\code{birthdate}}{a character vector}
#'      \item{\code{birthplace}}{place of birth, a character vector}
#'      \item{\code{birthlat}}{latitude of birthplace, a numeric vector}
#'      \item{\code{birthlong}}{longitude of birthplace, a numeric vector}
#'      \item{\code{deathdate}}{a character vector}
#'      \item{\code{deathplace}}{a character vector}
#'      \item{\code{deathlat}}{latitude of deathplace, a numeric vector}
#'      \item{\code{deathlong}}{longitude of deathplace, a numeric vector}
#'      \item{\code{note}}{notes about this author, a character vector}
#'    }
#'
#' TODO: The various names field contain some HTML characters.  These should be
#' translated to latin1.
#'
#' @importFrom lubridate as_date
#' @export
#'
#' @examples
#' # none yet
#'
authors <- function() {
  mstones_con = .mstone.env$connnection
  auth <- as_tibble(dbReadTable(mstones_con,
                                'author'))

  # change data types of some fields
  # TODO: recode HTML in lname, givennames, birthplace, deathplace to latin1
  auth <- auth %>%
    # fullname should include prefix & suffix
    mutate(fullname = ifelse(givennames != '', paste0(givennames, ' ', lname), lname))
    mutate_at(c(vars(birthlat, birthlong,
                     deathlat, deathlong)), as.numeric) %>%
    mutate_at(c(vars(birthdate, deathdate)), as_date)
    # mutate_at(c(vars(lname, givennames,
    #                  birthplace, deathplace)), html2latin1)

  auth

}
