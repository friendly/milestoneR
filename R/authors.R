#' Retrieve the `author` table from the milestones database
#'
#' @return Returns a tibble of the author table
#' @importFrom lubridate as_date
#' @export
#'
authors <- function(connection = .mstone.env$connnection) {
  auth <- as_tibble(dbReadTable(mstones_con,
                                'author'))

  # change data types of some fields
  # TODO: recode HTML in lname, givennames, birthplace, deathplace to latin1
  auth <- auth %>%
    mutate(fullname = ifelse(givennames != '', paste0(givennames, ' ', lname), lname))
    mutate_at(c(vars(birthlat, birthlong,
                     deathlat, deathlong)), as.numeric) %>%
    mutate_at(c(vars(birthdate, deathdate)), as_date)
    # mutate_at(c(vars(lname, givennames,
    #                  birthplace, deathplace)), html2latin1)

  auth

}
