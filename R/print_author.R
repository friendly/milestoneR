#' Print author entries in various formats
#'
#' Format and print author entries from the milestones database as text,
#' HTML, or markdown.
#'
#' @param aut A data frame from the \code{\link{authors}} table (one or more rows),
#'   or a numeric vector of author IDs (aid) to look up
#' @param result Output format: "text" for plain text (default),
#'   "html" for HTML formatted output, or "md"/"markdown" for markdown format
#'
#' @return A character vector with the formatted author entries (invisibly). The
#'   formatted entries are also printed to the console.
#'
#' @details
#' The function formats author information including name, birth/death places and dates,
#' and notes. Missing values are handled gracefully.
#'
#' If multiple authors are provided (either as multiple rows or multiple IDs),
#' each author is printed on a separate line with a blank line between them.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get authors and print the first one
#' aut <- authors()
#' print_author(aut[1, ])
#'
#' # Print multiple authors
#' print_author(aut[1:3, ])
#'
#' # Print as HTML
#' print_author(aut[1, ], result = "html")
#'
#' # Print as markdown
#' print_author(aut[1, ], result = "md")
#'
#' # Look up by author ID
#' print_author(2)
#'
#' # Look up multiple IDs
#' print_author(c(2, 3, 4))
#' }
#'
print_author <- function(aut, result = c("text", "html", "md", "markdown")) {

  result <- match.arg(result)

  # Normalize markdown option
  if (result == "markdown") {
    result <- "md"
  }

  # If aut is numeric, look up the ID(s)
  if (is.numeric(aut)) {
    aut_ids <- aut  # Save the original IDs for error messages
    .aut.env <- new.env()
    utils::data(author, package = 'milestoneR', envir = .aut.env)
    all_authors <- .aut.env$author
    aut <- all_authors[all_authors$aid %in% aut_ids, ]

    # Check if any IDs were not found
    if (nrow(aut) == 0) {
      stop("Author ID(s) not found: ", paste(aut_ids, collapse = ", "))
    }
    missing_ids <- setdiff(aut_ids, aut$aid)
    if (length(missing_ids) > 0) {
      warning("Author ID(s) not found: ", paste(missing_ids, collapse = ", "))
    }
  }

  # Ensure we have at least one row
  if (!is.data.frame(aut) || nrow(aut) == 0) {
    stop("aut must be a data frame with at least one row, or a numeric vector of author IDs")
  }

  # Process each author
  outputs <- character(nrow(aut))
  for (i in 1:nrow(aut)) {
    outputs[i] <- switch(result,
      text = .format_text_author(aut[i, ]),
      html = .format_html_author(aut[i, ]),
      md = .format_markdown_author(aut[i, ])
    )
  }

  # Print with blank lines between entries
  for (i in seq_along(outputs)) {
    cat(outputs[i], "\n")
    if (i < length(outputs)) {
      cat("\n")  # Blank line between entries
    }
  }

  invisible(outputs)
}


#' Format author as plain text
#' @noRd
.format_text_author <- function(aut) {
  parts <- character()

  # Construct full name
  name_parts <- character()
  if (!is.na(aut$prefix)) name_parts <- c(name_parts, aut$prefix)
  if (!is.na(aut$givennames)) name_parts <- c(name_parts, aut$givennames)
  if (!is.na(aut$lname)) name_parts <- c(name_parts, aut$lname)
  if (!is.na(aut$suffix)) name_parts <- c(name_parts, aut$suffix)

  if (length(name_parts) > 0) {
    parts <- c(parts, paste(name_parts, collapse = " "))
  }

  # Birth information
  birth_info <- character()
  if (!is.na(aut$birthplace)) {
    birth_info <- aut$birthplace
  }
  if (!is.na(aut$birthdate)) {
    date_str <- format(aut$birthdate, "%Y-%m-%d")
    if (length(birth_info) > 0) {
      birth_info <- paste0(birth_info, " (", date_str, ")")
    } else {
      birth_info <- date_str
    }
  }
  if (length(birth_info) > 0) {
    parts <- c(parts, paste0("born: ", birth_info))
  }

  # Death information
  death_info <- character()
  if (!is.na(aut$deathplace)) {
    death_info <- aut$deathplace
  }
  if (!is.na(aut$deathdate)) {
    date_str <- format(aut$deathdate, "%Y-%m-%d")
    if (length(death_info) > 0) {
      death_info <- paste0(death_info, " (", date_str, ")")
    } else {
      death_info <- date_str
    }
  }
  if (length(death_info) > 0) {
    parts <- c(parts, paste0("died: ", death_info))
  }

  # Note
  if (!is.na(aut$note)) {
    parts <- c(parts, paste0("[", aut$note, "]"))
  }

  paste(parts, collapse = "; ")
}


#' Format author as HTML
#' @noRd
.format_html_author <- function(aut) {
  parts <- character()

  # Construct full name
  name_parts <- character()
  if (!is.na(aut$prefix)) name_parts <- c(name_parts, aut$prefix)
  if (!is.na(aut$givennames)) name_parts <- c(name_parts, aut$givennames)
  if (!is.na(aut$lname)) name_parts <- c(name_parts, aut$lname)
  if (!is.na(aut$suffix)) name_parts <- c(name_parts, aut$suffix)

  if (length(name_parts) > 0) {
    parts <- c(parts, paste0("<strong>", paste(name_parts, collapse = " "), "</strong>"))
  }

  # Birth information
  birth_info <- character()
  if (!is.na(aut$birthplace)) {
    birth_info <- aut$birthplace
  }
  if (!is.na(aut$birthdate)) {
    date_str <- format(aut$birthdate, "%Y-%m-%d")
    if (length(birth_info) > 0) {
      birth_info <- paste0(birth_info, " (", date_str, ")")
    } else {
      birth_info <- date_str
    }
  }
  if (length(birth_info) > 0) {
    parts <- c(parts, paste0("<strong>born</strong>: ", birth_info))
  }

  # Death information
  death_info <- character()
  if (!is.na(aut$deathplace)) {
    death_info <- aut$deathplace
  }
  if (!is.na(aut$deathdate)) {
    date_str <- format(aut$deathdate, "%Y-%m-%d")
    if (length(death_info) > 0) {
      death_info <- paste0(death_info, " (", date_str, ")")
    } else {
      death_info <- date_str
    }
  }
  if (length(death_info) > 0) {
    parts <- c(parts, paste0("<strong>died</strong>: ", death_info))
  }

  # Note
  if (!is.na(aut$note)) {
    parts <- c(parts, paste0("[", aut$note, "]"))
  }

  paste(parts, collapse = "; ")
}


#' Format author as Markdown
#' @noRd
.format_markdown_author <- function(aut) {
  parts <- character()

  # Construct full name
  name_parts <- character()
  if (!is.na(aut$prefix)) name_parts <- c(name_parts, aut$prefix)
  if (!is.na(aut$givennames)) name_parts <- c(name_parts, aut$givennames)
  if (!is.na(aut$lname)) name_parts <- c(name_parts, aut$lname)
  if (!is.na(aut$suffix)) name_parts <- c(name_parts, aut$suffix)

  if (length(name_parts) > 0) {
    parts <- c(parts, paste0("**", paste(name_parts, collapse = " "), "**"))
  }

  # Birth information
  birth_info <- character()
  if (!is.na(aut$birthplace)) {
    birth_info <- aut$birthplace
  }
  if (!is.na(aut$birthdate)) {
    date_str <- format(aut$birthdate, "%Y-%m-%d")
    if (length(birth_info) > 0) {
      birth_info <- paste0(birth_info, " (", date_str, ")")
    } else {
      birth_info <- date_str
    }
  }
  if (length(birth_info) > 0) {
    parts <- c(parts, paste0("**born**: ", birth_info))
  }

  # Death information
  death_info <- character()
  if (!is.na(aut$deathplace)) {
    death_info <- aut$deathplace
  }
  if (!is.na(aut$deathdate)) {
    date_str <- format(aut$deathdate, "%Y-%m-%d")
    if (length(death_info) > 0) {
      death_info <- paste0(death_info, " (", date_str, ")")
    } else {
      death_info <- date_str
    }
  }
  if (length(death_info) > 0) {
    parts <- c(parts, paste0("**died**: ", death_info))
  }

  # Note
  if (!is.na(aut$note)) {
    parts <- c(parts, paste0("[", aut$note, "]"))
  }

  paste(parts, collapse = "; ")
}
