#' Retrieve the `reference` table from the milestones database
#'
#' The `reference` table gives the references associated with milestones items
#'
#' @return Returns a tibble of the `reference` table
#' @details
#'
#'  \describe{
#'   \item{\code{rid}}{reference id, a numeric vector}
#'   \item{\code{type}}{reference type, a factor with levels \code{} \code{article} \code{book} \code{incollection}}
#'   \item{\code{author}}{author, a character vector}
#'   \item{\code{title}}{title, a character vector}
#'   \item{\code{journal}}{journal name, for an \code{article}, character vector}
#'   \item{\code{month}}{a character vector}
#'   \item{\code{year}}{a numeric vector}
#'   \item{\code{volume}}{a character vector}
#'   \item{\code{number}}{a character vector}
#'   \item{\code{pages}}{a character vector}
#'   \item{\code{publisher}}{a character vector}
#'   \item{\code{address}}{a character vector}
#'   \item{\code{editor}}{a character vector}
#'   \item{\code{booktitle}}{a character vector}
#'   \item{\code{bibtexkey}}{a character vector}
#'   \item{\code{abstract}}{a character vector}
#'   \item{\code{note}}{a character vector}
#'  }
#'
#'  TODO: fix HTML encoding of author, title journal, ...

#' @export
#'
reference <- function() {
  mstones_con = .mstone.env$connnection
  mstones <- as_tibble(dbReadTable(mstones_con,
                                   'reference'))
  refs <- reference %>%
    mutate(type = as.factor(type),
           year = as.numeric(year))

  # fix books that have a booktitle rather than title; booktitle should only be used for incollection
  # very messy, but it works
  fixtitle <- function(type, title, booktitle) {
    if(type != "book") return (title)
    if(title == "" & booktitle != "") return (booktitle)
    title
  }
  for (i in 1:nrow(refs)) {
    refs$title[i] = fixtitle(refs$type[i], refs$title[i], refs$booktitle[i])
  }


  refs
}
