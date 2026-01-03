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
#' @source \url{https://datavis.ca/milestones/}
"reference"
