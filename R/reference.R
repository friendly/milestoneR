#' Retrieve the `reference` table from the milestones database
#'
#' The `reference` table gives the references associated with milestones items
#'
#' @return Returns a tibble of the `reference` table
#' @details
#'  The fields in the `reference` table are:
#'  \describe{
#'   \item{\code{rid}}{reference id, a numeric vector}
#'   \item{\code{type}}{reference type, a factor with levels \code{} \code{article} \code{book} \code{incollection}}
#'   \item{\code{author}}{author, a character vector}
#'   \item{\code{title}}{title of publication, a character vector}
#'   \item{\code{journal}}{journal name, for an \code{article}, character vector}
#'   \item{\code{month}}{month name, a character vector}
#'   \item{\code{year}}{a numeric vector}
#'   \item{\code{volume}}{a character vector}
#'   \item{\code{number}}{a character vector}
#'   \item{\code{pages}}{a character vector}
#'   \item{\code{publisher}}{a character vector}
#'   \item{\code{address}}{a character vector}
#'   \item{\code{editor}}{a character vector}
#'   \item{\code{booktitle}}{a character vector}
#'   \item{\code{bibtexkey}}{BibTeX key used in the source .bib files, a character vector}
#'   \item{\code{abstract}}{a character vector}
#'   \item{\code{note}}{a character vector}
#'  }
#'
#'  TODO: need a function to turn these back to BibTeX
#'
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate
#' @export
#'
reference <- function() {
  mstones_con = .mstone.env$connnection
  mstones <- as_tibble(dbReadTable(mstones_con,
                                   'reference'))
  refs <- reference %>%
    mutate(type = as.factor(type),
           year = as.numeric(year),
           author = html2latin1(author),
           title = html2latin1(title),
           journal = html2latin1(journal) )

  # fix books that have a booktitle rather than title; booktitle should only be used for incollection.
  # This is very messy, but it works.
  # Should we also make booktitle NA for books?
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
