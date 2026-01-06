#' Print milestone entries in various formats
#'
#' Format and print milestone entries from the milestones database as text,
#' HTML, markdown, or enhanced CLI output, including all associated information
#' (authors, references, keywords, subjects, aspects, media).
#'
#' @param ms A data frame from the [milestone()] table (one or more rows),
#'   or a numeric vector of milestone IDs (mid) to look up
#' @param result Output format: "text" for plain text (default),
#'   "html" for HTML formatted output, "md"/"markdown" for markdown format,
#'   or "cli" for enhanced console output with clickable links
#' @param include Character vector specifying which sections to include.
#'   Options: "authors", "keywords", "subjects", "aspects", "media", "references".
#'   Default is all sections.
#' @param show_images Logical; if TRUE, show image information in output.
#'   Default is TRUE. For text format, shows filenames only.
#'
#' @return For "text", "html", and "md" formats: a character vector with the
#'   formatted milestone entries (invisibly). For "cli" format: NULL (invisibly).
#'   The formatted entries are printed to the console in all cases.
#'
#' @details
#' The function formats milestones following the structure of the datavis.ca/milestones
#' website, including header information (date, authors, tag), description, and
#' optional sections for keywords, subjects, aspects, media items, and references.
#'
#' If multiple milestones are provided (either as multiple rows or multiple IDs),
#' each milestone is printed separately with a blank line (or visual separator for CLI).
#'
#' The "cli" format uses the `cli` package to provide enhanced console output with
#' clickable hyperlinks, better visual structure, and improved formatting.
#'
#' @importFrom cli cli_h1 cli_h2 cli_text cli_ul cli_li cli_rule cli_end
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
#' # Print with enhanced CLI formatting (clickable links)
#' print_milestone(53, result = "cli")
#'
#' # Print with only selected sections
#' print_milestone(53, include = c("authors", "references"))
#' }
#'
print_milestone <- function(ms,
                           result = c("text", "html", "md", "markdown", "cli"),
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

  # Handle CLI format separately (doesn't return text output)
  if (result == "cli") {
    for (i in 1:nrow(ms)) {
      .format_cli_milestone(ms[i, ], include, show_images)

      # Visual separator between milestones
      if (i < nrow(ms)) {
        cli::cli_rule()
      }
    }
    return(invisible(NULL))
  }

  # Process each milestone for text-based formats
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


#' Format milestone using cli functions
#' @noRd
.format_cli_milestone <- function(ms, include, show_images) {

  # Header: [DATE] Tag
  date_str <- if (!is.na(ms$date_from)) ms$date_from else ""
  tag_str <- if (!is.na(ms$tag)) .cli_escape(ms$tag) else ""
  header <- paste0("[", date_str, "] ", tag_str)
  cli::cli_h1(header)

  # Authors
  if ("authors" %in% include) {
    authors <- get_milestone_authors(ms$mid)
    if (nrow(authors) > 0) {
      author_names <- paste(authors$givennames, authors$lname)
      author_names_safe <- .cli_escape(paste(author_names, collapse = ', '))
      cli::cli_text("{.strong Authors:} {author_names_safe}")
    }
  }

  cli::cli_text("")  # Blank line

  # Description
  if (!is.na(ms$description) && nchar(ms$description) > 0) {
    desc_safe <- .cli_escape(ms$description)
    cli::cli_text(desc_safe)
    cli::cli_text("")
  }

  # Location
  if (!is.na(ms$location) && nchar(ms$location) > 0) {
    location_safe <- .cli_escape(ms$location)
    cli::cli_text("{.strong Location:} {location_safe}")
  }

  # Keywords
  if ("keywords" %in% include) {
    keywords <- get_milestone_keywords(ms$mid)
    if (nrow(keywords) > 0) {
      keywords_safe <- .cli_escape(paste(keywords$keyword, collapse = ', '))
      cli::cli_text("{.strong Keywords:} {keywords_safe}")
    }
  }

  # Subjects
  if ("subjects" %in% include) {
    subjects <- get_milestone_subjects(ms$mid)
    if (nrow(subjects) > 0) {
      subjects_safe <- .cli_escape(paste(subjects$subject, collapse = ', '))
      cli::cli_text("{.strong Subjects:} {subjects_safe}")
    }
  }

  # Aspects
  if ("aspects" %in% include) {
    aspects <- get_milestone_aspects(ms$mid)
    if (nrow(aspects) > 0) {
      aspects_safe <- .cli_escape(paste(aspects$aspect, collapse = ', '))
      cli::cli_text("{.strong Aspects:} {aspects_safe}")
    }
  }

  # Media
  if ("media" %in% include && show_images) {
    media <- get_milestone_media(ms$mid)
    if (nrow(media) > 0) {
      cli::cli_text("")
      cli::cli_h2("Media")

      # Start unordered list
      cli::cli_ul()
      for (i in 1:nrow(media)) {
        # Create clickable link if URL is available
        if (!is.na(media$url[i]) && nchar(media$url[i]) > 0) {
          link_text <- .cli_escape(media$title[i])
          url <- media$url[i]
          type_safe <- .cli_escape(media$type[i])

          # Add caption if available
          if (!is.na(media$caption[i]) && nchar(media$caption[i]) > 0) {
            caption_safe <- .cli_escape(media$caption[i])
            cli::cli_li("{.href [{link_text}]({url})} [{type_safe}] - {caption_safe}")
          } else {
            cli::cli_li("{.href [{link_text}]({url})} [{type_safe}]")
          }
        } else {
          # No URL available
          title_safe <- .cli_escape(media$title[i])
          type_safe <- .cli_escape(media$type[i])
          if (!is.na(media$caption[i]) && nchar(media$caption[i]) > 0) {
            caption_safe <- .cli_escape(media$caption[i])
            cli::cli_li("{title_safe} [{type_safe}] - {caption_safe}")
          } else {
            cli::cli_li("{title_safe} [{type_safe}]")
          }
        }
      }
      cli::cli_end()  # End list
    }
  }

  # Notes
  if (!is.na(ms$note) && nchar(ms$note) > 0) {
    cli::cli_text("")
    note_safe <- .cli_escape(ms$note)
    cli::cli_text("{.strong Note:} {note_safe}")
  }

  # References
  if ("references" %in% include) {
    refs <- get_milestone_references(ms$mid)
    if (nrow(refs) > 0) {
      cli::cli_text("")
      cli::cli_h2("References")

      cli::cli_ul()
      for (i in 1:nrow(refs)) {
        # Format reference as plain text first
        ref_text <- .format_cli_reference(refs[i, ])
        cli::cli_li(ref_text)
      }
      cli::cli_end()  # End list
    }
  }
}


#' Escape curly braces for cli
#' @noRd
.cli_escape <- function(text) {
  if (is.na(text) || nchar(text) == 0) return(text)
  text <- gsub("\\{", "{{", text, fixed = FALSE)
  text <- gsub("\\}", "}}", text, fixed = FALSE)
  text
}


#' Format a reference for CLI output
#' @noRd
.format_cli_reference <- function(ref) {
  parts <- character()

  # Author (bold)
  if (!is.na(ref$author) && nchar(ref$author) > 0) {
    author_safe <- .cli_escape(ref$author)
    parts <- c(parts, paste0("{.strong ", author_safe, "}"))
  }

  # Year
  if (!is.na(ref$year) && nchar(ref$year) > 0) {
    parts <- c(parts, paste0("(", ref$year, ")"))
  }

  # Title and container (journal/booktitle)
  # For articles/chapters: "Title" in container
  # For books: Title (italics)
  is_part <- !is.na(ref$type) && ref$type %in% c("article", "inproceedings", "incollection")

  if (!is.na(ref$title) && nchar(ref$title) > 0) {
    title_safe <- .cli_escape(ref$title)
    if (is_part) {
      # Article/chapter title in quotes
      parts <- c(parts, paste0('"', title_safe, '"'))
    } else {
      # Book title in italics
      parts <- c(parts, paste0("{.emph ", title_safe, "}"))
    }
  }

  # Journal/Booktitle (only for articles/chapters, or if different from title)
  if (!is.na(ref$journal) && nchar(ref$journal) > 0) {
    journal_safe <- .cli_escape(ref$journal)
    parts <- c(parts, paste0("{.emph ", journal_safe, "}"))
  } else if (!is.na(ref$booktitle) && nchar(ref$booktitle) > 0) {
    # Only add booktitle if it's different from title (avoid duplication)
    if (is.na(ref$title) || ref$booktitle != ref$title) {
      booktitle_safe <- .cli_escape(ref$booktitle)
      parts <- c(parts, paste0("{.emph ", booktitle_safe, "}"))
    }
  }

  # Volume
  if (!is.na(ref$volume) && nchar(ref$volume) > 0) {
    parts <- c(parts, ref$volume)
  }

  # Number
  if (!is.na(ref$number) && nchar(ref$number) > 0) {
    parts <- c(parts, paste0("(", ref$number, ")"))
  }

  # Pages
  if (!is.na(ref$pages) && nchar(ref$pages) > 0) {
    parts <- c(parts, paste0("pp. ", ref$pages))
  }

  # Publisher
  if (!is.na(ref$publisher) && nchar(ref$publisher) > 0) {
    pub_str <- ref$publisher
    # Add address if available
    if (!is.na(ref$address) && nchar(ref$address) > 0) {
      pub_str <- paste0(ref$address, ": ", pub_str)
    }
    parts <- c(parts, pub_str)
  }

  # Note (in brackets)
  # Escape curly braces to prevent cli from trying to parse them
  if (!is.na(ref$note) && nchar(ref$note) > 0) {
    note_escaped <- gsub("\\{", "{{", ref$note, fixed = FALSE)
    note_escaped <- gsub("\\}", "}}", note_escaped, fixed = FALSE)
    parts <- c(parts, paste0("[", note_escaped, "]"))
  }

  # Combine all parts
  paste(parts, collapse = ". ")
}
