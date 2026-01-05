#' Retrieve the `reference` table from the milestones database
#'
#' The `reference` table gives the references associated with milestones items
#'
#' @return Returns a tibble of the `reference` table
#' @details
#'  The fields in the `reference` table are:
#'  \describe{
#'   \item{`rid`}{reference id, a numeric vector}
#'   \item{`type`}{reference type, a factor with levels \code{} `article` `book` `incollection`}
#'   \item{`author`}{author, a character vector}
#'   \item{`title`}{title of publication, a character vector}
#'   \item{`journal`}{journal name, for an `article`, character vector}
#'   \item{`month`}{month name, a character vector}
#'   \item{`year`}{a numeric vector}
#'   \item{`volume`}{a character vector}
#'   \item{`number`}{a character vector}
#'   \item{`pages`}{a character vector}
#'   \item{`publisher`}{a character vector}
#'   \item{`address`}{a character vector}
#'   \item{`editor`}{a character vector}
#'   \item{`booktitle`}{a character vector}
#'   \item{`bibtexkey`}{BibTeX key used in the source .bib files, a character vector}
#'   \item{`abstract`}{a character vector}
#'   \item{`note`}{a character vector}
#'  }
#'
#'  In the `note` field, `Loc{}` refers to a library catalog identifier, e.g, `Loc{BL: IA 3Q024}`
#'
#'  TODO: need a function to turn these back to BibTeX
#'
#' @importFrom utils data
#' @export
#'
reference <- function() {
  .reference.env <- new.env()
  data(reference, package = 'milestoneR', envir = .reference.env)
  .reference.env$reference
}

#' Reference data from the Milestones Project
#'
#' A dataset containing bibliographic references associated with milestone events.
#'
#' @format A data frame with 352 rows and 17 variables:
#' \describe{
#'   \item{rid}{reference id, a numeric vector}
#'   \item{type}{reference type (article, book, incollection), a factor}
#'   \item{author}{author names, a character vector}
#'   \item{title}{title of publication, a character vector}
#'   \item{journal}{journal name (for articles), a character vector}
#'   \item{month}{month of publication, a character vector}
#'   \item{year}{year of publication, a character vector}
#'   \item{volume}{volume number, a character vector}
#'   \item{number}{issue number, a character vector}
#'   \item{pages}{page numbers, a character vector}
#'   \item{publisher}{publisher name, a character vector}
#'   \item{address}{publisher address, a character vector}
#'   \item{editor}{editor names, a character vector}
#'   \item{booktitle}{book title (for incollection), a character vector}
#'   \item{bibtexkey}{BibTeX key, a character vector}
#'   \item{abstract}{abstract, a character vector}
#'   \item{note}{notes, a character vector}
#' }
#' @source <https://datavis.ca/milestones/>
"reference"
