#' Print reference entries in various formats
#'
#' Format and print reference entries from the milestones database as text,
#' HTML, or BibTeX.
#'
#' @param ref A data frame from the [reference()] table (one or more rows),
#'   or a numeric vector of reference IDs (rid) to look up
#' @param result Output format: "text" for plain text citation (default),
#'   "html" for HTML formatted citation, "md" or "markdown" for markdown format,
#'   or "bibtex" for BibTeX entry
#' @param bibtex Logical; if TRUE, output as BibTeX entry (overrides `result`).
#'   Default is FALSE.
#'
#' @return A character vector with the formatted references (invisibly). The
#'   formatted references are also printed to the console.
#'
#' @details
#' The function formats references according to the reference type (article, book,
#' incollection, inproceedings). When `bibtex = TRUE`, it generates a proper
#' BibTeX entry using the `bibtexkey` field.
#'
#' If multiple references are provided (either as multiple rows or multiple IDs),
#' each reference is printed on a separate line with a blank line between them.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get references and print the first one
#' refs <- reference()
#' print_reference(refs[1, ])
#'
#' # Print multiple references
#' print_reference(refs[1:3, ])
#'
#' # Print as HTML
#' print_reference(refs[1, ], result = "html")
#'
#' # Print as markdown
#' print_reference(refs[1, ], result = "md")
#'
#' # Print as BibTeX
#' print_reference(refs[1, ], bibtex = TRUE)
#'
#' # Look up by reference ID
#' print_reference(261)
#'
#' # Look up multiple IDs
#' print_reference(c(261, 262, 263))
#' }
#'
print_reference <- function(ref, result = c("text", "html", "md", "markdown", "bibtex"), bibtex = FALSE) {

  result <- match.arg(result)

  # Normalize markdown option
  if (result == "markdown") {
    result <- "md"
  }

  # If bibtex = TRUE, override result
  if (bibtex) {
    result <- "bibtex"
  }

  # If ref is numeric, look up the ID(s)
  if (is.numeric(ref)) {
    ref_ids <- ref  # Save the original IDs for error messages
    .ref.env <- new.env()
    utils::data(reference, package = 'milestoneR', envir = .ref.env)
    all_refs <- .ref.env$reference
    ref <- all_refs[all_refs$rid %in% ref_ids, ]

    # Check if any IDs were not found
    if (nrow(ref) == 0) {
      stop("Reference ID(s) not found: ", paste(ref_ids, collapse = ", "))
    }
    missing_ids <- setdiff(ref_ids, ref$rid)
    if (length(missing_ids) > 0) {
      warning("Reference ID(s) not found: ", paste(missing_ids, collapse = ", "))
    }
  }

  # Ensure we have at least one row
  if (!is.data.frame(ref) || nrow(ref) == 0) {
    stop("ref must be a data frame with at least one row, or a numeric vector of reference IDs")
  }

  # Process each reference
  outputs <- character(nrow(ref))
  for (i in 1:nrow(ref)) {
    outputs[i] <- switch(result,
      text = .format_text_reference(ref[i, ]),
      html = .format_html_reference(ref[i, ]),
      md = .format_markdown_reference(ref[i, ]),
      bibtex = .format_bibtex_reference(ref[i, ])
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


#' Format reference as plain text
#' @noRd
.format_text_reference <- function(ref) {
  parts <- character()

  # Author
  if (!is.na(ref$author) && ref$author != "NULL") {
    parts <- c(parts, ref$author)
  }

  # Year
  if (!is.na(ref$year)) {
    parts <- c(parts, paste0("(", ref$year, ")"))
  }

  # Title
  if (!is.na(ref$title)) {
    parts <- c(parts, paste0('"', ref$title, '"'))
  }

  # Type-specific formatting
  if (ref$type == "article") {
    if (!is.na(ref$journal)) {
      parts <- c(parts, paste0("_", ref$journal, "_"))
    }
    vol_info <- character()
    if (!is.na(ref$volume)) vol_info <- c(vol_info, ref$volume)
    if (!is.na(ref$number)) vol_info <- c(vol_info, paste0("(", ref$number, ")"))
    if (length(vol_info) > 0) parts <- c(parts, paste(vol_info, collapse = ""))
    if (!is.na(ref$pages)) parts <- c(parts, paste0("pp. ", ref$pages))
  } else if (ref$type == "book") {
    if (!is.na(ref$publisher)) {
      pub <- ref$publisher
      if (!is.na(ref$address)) {
        pub <- paste0(ref$address, ": ", pub)
      }
      parts <- c(parts, pub)
    }
  } else if (ref$type == "incollection" || ref$type == "inproceedings") {
    if (!is.na(ref$booktitle)) {
      parts <- c(parts, paste0("In: _", ref$booktitle, "_"))
    }
    if (!is.na(ref$editor) && ref$editor != "NULL") {
      parts <- c(parts, paste0("(Ed. ", ref$editor, ")"))
    }
    if (!is.na(ref$publisher)) {
      pub <- ref$publisher
      if (!is.na(ref$address)) {
        pub <- paste0(ref$address, ": ", pub)
      }
      parts <- c(parts, pub)
    }
    if (!is.na(ref$pages)) parts <- c(parts, paste0("pp. ", ref$pages))
  }

  # Note
  if (!is.na(ref$note)) {
    parts <- c(parts, paste0("[", ref$note, "]"))
  }

  paste(parts, collapse = ". ")
}


#' Format reference as HTML (simple semantic HTML without CSS classes)
#' @noRd
.format_html_reference <- function(ref) {
  parts <- character()

  # Author
  if (!is.na(ref$author) && ref$author != "NULL") {
    parts <- c(parts, paste0('<strong>', ref$author, '</strong>'))
  }

  # Year
  if (!is.na(ref$year)) {
    parts <- c(parts, paste0('(', ref$year, ')'))
  }

  # Title
  if (!is.na(ref$title)) {
    parts <- c(parts, paste0('"', ref$title, '"'))
  }

  # Type-specific formatting
  if (ref$type == "article") {
    if (!is.na(ref$journal)) {
      parts <- c(parts, paste0('<em>', ref$journal, '</em>'))
    }
    vol_info <- character()
    if (!is.na(ref$volume)) vol_info <- c(vol_info, ref$volume)
    if (!is.na(ref$number)) vol_info <- c(vol_info, paste0("(", ref$number, ")"))
    if (length(vol_info) > 0) {
      parts <- c(parts, paste(vol_info, collapse = ""))
    }
    if (!is.na(ref$pages)) {
      parts <- c(parts, paste0("pp. ", ref$pages))
    }
  } else if (ref$type == "book") {
    if (!is.na(ref$publisher)) {
      pub <- ref$publisher
      if (!is.na(ref$address)) {
        pub <- paste0(ref$address, ": ", pub)
      }
      parts <- c(parts, pub)
    }
  } else if (ref$type == "incollection" || ref$type == "inproceedings") {
    if (!is.na(ref$booktitle)) {
      parts <- c(parts, paste0('In: <em>', ref$booktitle, '</em>'))
    }
    if (!is.na(ref$editor) && ref$editor != "NULL") {
      parts <- c(parts, paste0('(Ed. ', ref$editor, ')'))
    }
    if (!is.na(ref$publisher)) {
      pub <- ref$publisher
      if (!is.na(ref$address)) {
        pub <- paste0(ref$address, ": ", pub)
      }
      parts <- c(parts, pub)
    }
    if (!is.na(ref$pages)) {
      parts <- c(parts, paste0("pp. ", ref$pages))
    }
  }

  # Note
  if (!is.na(ref$note)) {
    parts <- c(parts, paste0('[', ref$note, ']'))
  }

  paste(parts, collapse = ". ")
}


#' Format reference as Markdown
#' @noRd
.format_markdown_reference <- function(ref) {
  parts <- character()

  # Author
  if (!is.na(ref$author) && ref$author != "NULL") {
    parts <- c(parts, paste0('**', ref$author, '**'))
  }

  # Year
  if (!is.na(ref$year)) {
    parts <- c(parts, paste0('(', ref$year, ')'))
  }

  # Title
  if (!is.na(ref$title)) {
    parts <- c(parts, paste0('"', ref$title, '"'))
  }

  # Type-specific formatting
  if (ref$type == "article") {
    if (!is.na(ref$journal)) {
      parts <- c(parts, paste0('*', ref$journal, '*'))
    }
    vol_info <- character()
    if (!is.na(ref$volume)) vol_info <- c(vol_info, ref$volume)
    if (!is.na(ref$number)) vol_info <- c(vol_info, paste0("(", ref$number, ")"))
    if (length(vol_info) > 0) {
      parts <- c(parts, paste(vol_info, collapse = ""))
    }
    if (!is.na(ref$pages)) {
      parts <- c(parts, paste0("pp. ", ref$pages))
    }
  } else if (ref$type == "book") {
    if (!is.na(ref$publisher)) {
      pub <- ref$publisher
      if (!is.na(ref$address)) {
        pub <- paste0(ref$address, ": ", pub)
      }
      parts <- c(parts, pub)
    }
  } else if (ref$type == "incollection" || ref$type == "inproceedings") {
    if (!is.na(ref$booktitle)) {
      parts <- c(parts, paste0('In: *', ref$booktitle, '*'))
    }
    if (!is.na(ref$editor) && ref$editor != "NULL") {
      parts <- c(parts, paste0('(Ed. ', ref$editor, ')'))
    }
    if (!is.na(ref$publisher)) {
      pub <- ref$publisher
      if (!is.na(ref$address)) {
        pub <- paste0(ref$address, ": ", pub)
      }
      parts <- c(parts, pub)
    }
    if (!is.na(ref$pages)) {
      parts <- c(parts, paste0("pp. ", ref$pages))
    }
  }

  # Note
  if (!is.na(ref$note)) {
    parts <- c(parts, paste0('[', ref$note, ']'))
  }

  paste(parts, collapse = ". ")
}


#' Format reference as BibTeX
#' @noRd
.format_bibtex_reference <- function(ref) {
  # Start with entry type and key
  entry_type <- as.character(ref$type)
  key <- if (!is.na(ref$bibtexkey)) ref$bibtexkey else paste0("ref", ref$rid)

  lines <- paste0("@", entry_type, "{", key, ",")

  # Helper to add field
  add_field <- function(field_name, field_value, comma = TRUE) {
    if (!is.na(field_value) && field_value != "NULL" && nchar(field_value) > 0) {
      value <- gsub('"', '\\\\"', field_value)  # Escape quotes
      ending <- if (comma) "," else ""
      paste0("  ", field_name, " = {", value, "}", ending)
    } else {
      NULL
    }
  }

  # Add fields based on type
  fields <- list(
    add_field("author", ref$author),
    add_field("title", ref$title),
    add_field("journal", ref$journal),
    add_field("booktitle", ref$booktitle),
    add_field("year", ref$year),
    add_field("volume", ref$volume),
    add_field("number", ref$number),
    add_field("pages", ref$pages),
    add_field("month", ref$month),
    add_field("publisher", ref$publisher),
    add_field("address", ref$address),
    add_field("editor", ref$editor),
    add_field("note", ref$note),
    add_field("abstract", ref$abstract, comma = FALSE)  # Last field, no comma
  )

  # Remove NULL entries and add to lines
  fields <- Filter(Negate(is.null), fields)
  if (length(fields) > 0) {
    # Remove comma from last field
    fields[[length(fields)]] <- sub(",$", "", fields[[length(fields)]])
    lines <- c(lines, unlist(fields))
  }

  lines <- c(lines, "}")

  paste(lines, collapse = "\n")
}
