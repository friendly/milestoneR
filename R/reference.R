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
