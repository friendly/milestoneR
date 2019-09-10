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
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate mutate_at
#' @export
#'
#' @examples
#' # none yet
#'
authors <- function() {
  authors = as.data.table(
    dbReadTable(mstones_con, 'author', encoding = 'UTF-8')
  )
  
  authors[, Full_Name := ifelse(givennames != '', paste0(givennames, ' ', lname), lname)]
  
  
  authors[grepl(', ', birthplace), Birth_Country := tstrsplit(birthplace, ', ')[[length(tstrsplit(birthplace, ', '))]],
          by = 'aid'][, 
                      Birth_Country := gsub('[\\)\\(]', '', Birth_Country)]
  
  authors[grepl(', ', deathplace), Death_Country := tstrsplit(deathplace, ', ')[[length(tstrsplit(deathplace, ', '))]],
          by = 'aid'][, 
                      Death_Country := gsub('[\\)\\(]', '', Death_Country )]
  
  authors[nchar(birthdate) > 3, birthdate_fixed := as.Date(birthdate)]
  authors[, Birth_Year := year(birthdate_fixed)]
  
  authors[nchar(deathdate) > 3, deathdate_fixed := as.Date(deathdate)]
  authors[, Death_Year := year(deathdate_fixed)]
  
  authors[!is.na(birthdate_fixed) & !is.na(deathdate_fixed), 
          Age := as.numeric(deathdate_fixed - birthdate_fixed)/365,
          by = 'aid'][, Age:= as.numeric(Age)]
  
  authors[, c("givennames", 'lname', 'birthplace', 'deathplace', 'Full_Name',
              'Birth_Country', 'Death_Country') := .(
                html2latin1(givennames),
                html2latin1(lname),
                html2latin1(birthplace),
                html2latin1(deathplace),
                html2latin1(Full_Name),
                html2latin1(Birth_Country),
                html2latin1(Death_Country)
              ), keyby = 'aid']

  return(as_tibble(authors))

}
