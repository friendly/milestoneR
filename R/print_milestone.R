#' Print milestone entries in various formats
#'
#' Format and print milestone entries from the milestones database as text,
#' HTML, or markdown, including all associated information (authors, references,
#' keywords, subjects, aspects, media).
#'
#' @param ms A data frame from the \code{\link{milestone}} table (one or more rows),
#'   or a numeric vector of milestone IDs (mid) to look up
#' @param result Output format: "text" for plain text (default),
#'   "html" for HTML formatted output, or "md"/"markdown" for markdown format
#' @param include Character vector specifying which sections to include.
#'   Options: "authors", "keywords", "subjects", "aspects", "media", "references".
#'   Default is all sections.
#' @param show_images Logical; if TRUE, show image information in output.
#'   Default is TRUE. For text format, shows filenames only.
#'
#' @return A character vector with the formatted milestone entries (invisibly). The
#'   formatted entries are also printed to the console.
#'
#' @details
#' The function formats milestones following the structure of the datavis.ca/milestones
#' website, including header information (date, authors, tag), description, and
#' optional sections for keywords, subjects, aspects, media items, and references.
#'
#' If multiple milestones are provided (either as multiple rows or multiple IDs),
#' each milestone is printed separately with a blank line between them.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get milestones and print one
#' ms <- milestone()
#' print_milestone(ms[1, ])
#'
#' # Print by milestone ID
#' print_milestone(53)
#'
#' # Print multiple milestones
#' print_milestone(c(53, 54, 55))
#'
#' # Print as HTML
#' print_milestone(53, result = "html")
#'
#' # Print as markdown
#' print_milestone(53, result = "md")
#'
#' # Print with only selected sections
#' print_milestone(53, include = c("authors", "references"))
#' }
#'
print_milestone <- function(ms,
                           result = c("text", "html", "md", "markdown"),
                           include = c("authors", "keywords", "subjects", "aspects", "media", "references"),
                           show_images = TRUE) {

  result <- match.arg(result)

  # Normalize markdown option
  if (result == "markdown") {
    result <- "md"
  }

  # If ms is numeric, look up the ID(s)
  if (is.numeric(ms)) {
    ms_ids <- ms  # Save the original IDs for error messages
    .ms.env <- new.env()
    utils::data(milestone, package = 'milestoneR', envir = .ms.env)
    all_milestones <- .ms.env$milestone
    ms <- all_milestones[all_milestones$mid %in% ms_ids, ]

    # Check if any IDs were not found
    if (nrow(ms) == 0) {
      stop("Milestone ID(s) not found: ", paste(ms_ids, collapse = ", "))
    }
    missing_ids <- setdiff(ms_ids, ms$mid)
    if (length(missing_ids) > 0) {
      warning("Milestone ID(s) not found: ", paste(missing_ids, collapse = ", "))
    }
  }

  # Ensure we have at least one row
  if (!is.data.frame(ms) || nrow(ms) == 0) {
    stop("ms must be a data frame with at least one row, or a numeric vector of milestone IDs")
  }

  # Process each milestone
  outputs <- character(nrow(ms))
  for (i in 1:nrow(ms)) {
    outputs[i] <- switch(result,
      text = .format_text_milestone(ms[i, ], include, show_images),
      html = .format_html_milestone(ms[i, ], include, show_images),
      md = .format_markdown_milestone(ms[i, ], include, show_images)
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


#' Format milestone as plain text
#' @noRd
.format_text_milestone <- function(ms, include, show_images) {
  lines <- character()

  # Header: [DATE] Tag
  date_str <- if (!is.na(ms$date_from)) ms$date_from else ""
  tag_str <- if (!is.na(ms$tag)) ms$tag else ""
  header <- paste0("[", date_str, "] ", tag_str)
  lines <- c(lines, header)

  # Authors
  if ("authors" %in% include) {
    authors <- get_milestone_authors(ms$mid)
    if (nrow(authors) > 0) {
      author_names <- paste(authors$givennames, authors$lname)
      lines <- c(lines, paste("Authors:", paste(author_names, collapse = ", ")))
    }
  }

  lines <- c(lines, "")  # Blank line

  # Description
  if (!is.na(ms$description) && nchar(ms$description) > 0) {
    lines <- c(lines, ms$description)
    lines <- c(lines, "")
  }

  # Location
  if (!is.na(ms$location) && nchar(ms$location) > 0) {
    lines <- c(lines, paste("Location:", ms$location))
  }

  # Keywords
  if ("keywords" %in% include) {
    keywords <- get_milestone_keywords(ms$mid)
    if (nrow(keywords) > 0) {
      lines <- c(lines, paste("Keywords:", paste(keywords$keyword, collapse = ", ")))
    }
  }

  # Subjects
  if ("subjects" %in% include) {
    subjects <- get_milestone_subjects(ms$mid)
    if (nrow(subjects) > 0) {
      lines <- c(lines, paste("Subjects:", paste(subjects$subject, collapse = ", ")))
    }
  }

  # Aspects
  if ("aspects" %in% include) {
    aspects <- get_milestone_aspects(ms$mid)
    if (nrow(aspects) > 0) {
      lines <- c(lines, paste("Aspects:", paste(aspects$aspect, collapse = ", ")))
    }
  }

  # Media
  if ("media" %in% include && show_images) {
    media <- get_milestone_media(ms$mid)
    if (nrow(media) > 0) {
      lines <- c(lines, "", "Media:")
      for (i in 1:nrow(media)) {
        media_line <- paste0("  - [", media$type[i], "] ", media$title[i])
        if (!is.na(media$caption[i]) && nchar(media$caption[i]) > 0) {
          media_line <- paste0(media_line, " - ", media$caption[i])
        }
        lines <- c(lines, media_line)
      }
    }
  }

  # Notes
  if (!is.na(ms$note) && nchar(ms$note) > 0) {
    lines <- c(lines, "", paste("Note:", ms$note))
  }

  # References
  if ("references" %in% include) {
    refs <- get_milestone_references(ms$mid)
    if (nrow(refs) > 0) {
      lines <- c(lines, "", "References:")
      for (i in 1:nrow(refs)) {
        # Use the print_reference helper to format each reference
        ref_text <- .format_text_reference(refs[i, ])
        lines <- c(lines, paste0("  - ", ref_text))
      }
    }
  }

  paste(lines, collapse = "\n")
}


#' Format milestone as HTML
#' @noRd
.format_html_milestone <- function(ms, include, show_images) {
  lines <- character()

  # Container div
  lines <- c(lines, paste0('<div id="milestone-', ms$mid, '">'))

  # Header
  lines <- c(lines, '  <div class="milestone-header">')

  # Date, Authors, Tag on one line
  header_parts <- character()

  date_str <- if (!is.na(ms$date_from)) ms$date_from else ""
  header_parts <- c(header_parts, paste0('<span class="date">', date_str, '</span>'))

  # Authors
  if ("authors" %in% include) {
    authors <- get_milestone_authors(ms$mid)
    if (nrow(authors) > 0) {
      author_names <- paste(authors$givennames, authors$lname)
      authors_html <- paste0('<span class="authors">', paste(author_names, collapse = ", "), '</span>')
      header_parts <- c(header_parts, authors_html)
    }
  }

  tag_str <- if (!is.na(ms$tag)) ms$tag else ""
  header_parts <- c(header_parts, paste0('<span class="tag">', tag_str, '</span>'))

  lines <- c(lines, paste0('    ', paste(header_parts, collapse = " ")))
  lines <- c(lines, '  </div>')

  # Detail section
  lines <- c(lines, '  <div class="milestone-detail">')

  # Description
  if (!is.na(ms$description) && nchar(ms$description) > 0) {
    lines <- c(lines, paste0('    <p>', ms$description, '</p>'))
  }

  # Location
  if (!is.na(ms$location) && nchar(ms$location) > 0) {
    lines <- c(lines, paste0('    <p><strong>Location:</strong> ', ms$location, '</p>'))
  }

  # Keywords
  if ("keywords" %in% include) {
    keywords <- get_milestone_keywords(ms$mid)
    if (nrow(keywords) > 0) {
      lines <- c(lines, paste0('    <p><strong>Keywords:</strong> ', paste(keywords$keyword, collapse = ", "), '</p>'))
    }
  }

  # Subjects
  if ("subjects" %in% include) {
    subjects <- get_milestone_subjects(ms$mid)
    if (nrow(subjects) > 0) {
      lines <- c(lines, paste0('    <p><strong>Subjects:</strong> ', paste(subjects$subject, collapse = ", "), '</p>'))
    }
  }

  # Aspects
  if ("aspects" %in% include) {
    aspects <- get_milestone_aspects(ms$mid)
    if (nrow(aspects) > 0) {
      lines <- c(lines, paste0('    <p><strong>Aspects:</strong> ', paste(aspects$aspect, collapse = ", "), '</p>'))
    }
  }

  # Media
  if ("media" %in% include && show_images) {
    media <- get_milestone_media(ms$mid)
    if (nrow(media) > 0) {
      lines <- c(lines, '    <div class="media">')
      lines <- c(lines, '      <h3>Media</h3>')
      for (i in 1:nrow(media)) {
        if (!is.na(media$url[i])) {
          lines <- c(lines, paste0('      <p><a href="', media$url[i], '">', media$title[i], '</a>'))
          if (!is.na(media$caption[i])) {
            lines <- c(lines, paste0(' - ', media$caption[i]))
          }
          lines <- c(lines, '</p>')
        }
      }
      lines <- c(lines, '    </div>')
    }
  }

  # Notes
  if (!is.na(ms$note) && nchar(ms$note) > 0) {
    lines <- c(lines, paste0('    <p><strong>Note:</strong> ', ms$note, '</p>'))
  }

  # References
  if ("references" %in% include) {
    refs <- get_milestone_references(ms$mid)
    if (nrow(refs) > 0) {
      lines <- c(lines, '    <div class="references">')
      lines <- c(lines, '      <p><strong>References:</strong></p>')
      lines <- c(lines, '      <ul>')
      for (i in 1:nrow(refs)) {
        ref_html <- .format_html_reference(refs[i, ])
        lines <- c(lines, paste0('        <li>', ref_html, '</li>'))
      }
      lines <- c(lines, '      </ul>')
      lines <- c(lines, '    </div>')
    }
  }

  lines <- c(lines, '  </div>')  # End detail
  lines <- c(lines, '</div>')    # End container

  paste(lines, collapse = "\n")
}


#' Format milestone as Markdown
#' @noRd
.format_markdown_milestone <- function(ms, include, show_images) {
  lines <- character()

  # Header: ## [DATE] Tag
  date_str <- if (!is.na(ms$date_from)) ms$date_from else ""
  tag_str <- if (!is.na(ms$tag)) ms$tag else ""
  lines <- c(lines, paste0("## [", date_str, "] ", tag_str))

  # Authors
  if ("authors" %in% include) {
    authors <- get_milestone_authors(ms$mid)
    if (nrow(authors) > 0) {
      author_names <- paste(authors$givennames, authors$lname)
      lines <- c(lines, paste0("**Authors:** ", paste(author_names, collapse = ", ")))
    }
  }

  lines <- c(lines, "")  # Blank line

  # Description
  if (!is.na(ms$description) && nchar(ms$description) > 0) {
    lines <- c(lines, ms$description)
    lines <- c(lines, "")
  }

  # Location
  if (!is.na(ms$location) && nchar(ms$location) > 0) {
    lines <- c(lines, paste0("**Location:** ", ms$location))
  }

  # Keywords
  if ("keywords" %in% include) {
    keywords <- get_milestone_keywords(ms$mid)
    if (nrow(keywords) > 0) {
      lines <- c(lines, paste0("**Keywords:** ", paste(keywords$keyword, collapse = ", ")))
    }
  }

  # Subjects
  if ("subjects" %in% include) {
    subjects <- get_milestone_subjects(ms$mid)
    if (nrow(subjects) > 0) {
      lines <- c(lines, paste0("**Subjects:** ", paste(subjects$subject, collapse = ", ")))
    }
  }

  # Aspects
  if ("aspects" %in% include) {
    aspects <- get_milestone_aspects(ms$mid)
    if (nrow(aspects) > 0) {
      lines <- c(lines, paste0("**Aspects:** ", paste(aspects$aspect, collapse = ", ")))
    }
  }

  # Media
  if ("media" %in% include && show_images) {
    media <- get_milestone_media(ms$mid)
    if (nrow(media) > 0) {
      lines <- c(lines, "", "### Media")
      for (i in 1:nrow(media)) {
        media_line <- paste0("- **", media$title[i], "**")
        if (!is.na(media$caption[i]) && nchar(media$caption[i]) > 0) {
          media_line <- paste0(media_line, " - ", media$caption[i])
        }
        lines <- c(lines, media_line)
      }
    }
  }

  # Notes
  if (!is.na(ms$note) && nchar(ms$note) > 0) {
    lines <- c(lines, "", paste0("**Note:** ", ms$note))
  }

  # References
  if ("references" %in% include) {
    refs <- get_milestone_references(ms$mid)
    if (nrow(refs) > 0) {
      lines <- c(lines, "", "### References")
      for (i in 1:nrow(refs)) {
        ref_md <- .format_markdown_reference(refs[i, ])
        lines <- c(lines, paste0("- ", ref_md))
      }
    }
  }

  paste(lines, collapse = "\n")
}
