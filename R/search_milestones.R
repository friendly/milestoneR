#' Search milestones by text pattern
#'
#' Search for milestones matching a text pattern (regular expression) across
#' specified fields in the milestone table.
#'
#' @param pattern Character string or regular expression to search for
#' @param fields Character vector of field names to search. Default is
#'   c("description", "tag", "note"). Other searchable fields include:
#'   "slug", "date_from", "date_to", "location", "extra".
#' @param output Output format: "mid" returns a numeric vector of milestone IDs,
#'   "print" prints formatted milestones and returns them invisibly,
#'   "data" returns the matching milestone data frame rows.
#'   Default is "mid".
#' @param ignore.case Logical; if TRUE (default), case is ignored during matching
#' @param ... Additional arguments passed to \code{\link{print_milestone}} when
#'   output = "print"
#'
#' @return Depends on \code{output}:
#'   \itemize{
#'     \item "mid": Numeric vector of matching milestone IDs
#'     \item "print": Character vector of formatted milestones (invisibly),
#'           with formatted output printed to console
#'     \item "data": Data frame of matching milestone rows
#'   }
#'
#' @details
#' The function searches for the pattern across all specified fields using
#' regular expression matching. A milestone is included in the results if the
#' pattern matches in ANY of the specified fields (OR logic).
#'
#' The \code{pattern} argument accepts regular expressions, allowing for
#' flexible searching:
#' \itemize{
#'   \item Simple text: "contour" finds "contour map", "contours", etc.
#'   \item Multiple terms: "chart|graph" finds either term
#'   \item Word boundaries: "\\\\bmap\\\\b" finds "map" but not "bitmap"
#'   \item Case patterns: "[Cc]artograph" finds "cartograph" or "Cartograph"
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Find milestones mentioning "statistical"
#' search_milestones("statistical")
#'
#' # Search in specific fields
#' search_milestones("Halley", fields = c("description", "note"))
#'
#' # Use regex to find chart OR graph
#' search_milestones("chart|graph", fields = "description")
#'
#' # Get and print formatted results
#' search_milestones("contour", output = "print")
#'
#' # Get full data frame of matches
#' results <- search_milestones("visualization", output = "data")
#'
#' # Search tags for specific terms
#' search_milestones("^1st", fields = "tag")
#'
#' # Case-sensitive search
#' search_milestones("Map", ignore.case = FALSE)
#' }
#'
search_milestones <- function(pattern,
                             fields = c("description", "tag", "note"),
                             output = c("mid", "print", "data"),
                             ignore.case = TRUE,
                             ...) {

  output <- match.arg(output)

  # Load milestone data
  .ms.env <- new.env()
  utils::data(milestone, package = 'milestoneR', envir = .ms.env)
  ms <- .ms.env$milestone

  # Validate fields
  valid_fields <- c("slug", "date_from", "date_to", "tag", "description",
                   "location", "note", "extra")
  invalid_fields <- setdiff(fields, valid_fields)
  if (length(invalid_fields) > 0) {
    stop("Invalid field(s): ", paste(invalid_fields, collapse = ", "),
         "\nValid fields are: ", paste(valid_fields, collapse = ", "))
  }

  # Search across specified fields
  matches <- rep(FALSE, nrow(ms))

  for (field in fields) {
    # Get the field values
    field_values <- ms[[field]]

    # Skip if field doesn't exist or is all NA
    if (is.null(field_values)) next

    # Convert to character and handle NAs
    field_values <- as.character(field_values)
    field_values[is.na(field_values)] <- ""

    # Search for pattern in this field
    field_matches <- grepl(pattern, field_values, ignore.case = ignore.case)

    # Combine with previous matches (OR logic)
    matches <- matches | field_matches
  }

  # Get matching milestone IDs
  matching_mids <- ms$mid[matches]

  if (length(matching_mids) == 0) {
    message("No milestones found matching pattern: ", pattern)
    if (output == "mid") {
      return(numeric(0))
    } else if (output == "data") {
      return(ms[0, ])
    } else {
      return(invisible(character(0)))
    }
  }

  # Return based on output format
  if (output == "mid") {
    return(matching_mids)
  } else if (output == "data") {
    return(ms[matches, ])
  } else {  # output == "print"
    result <- print_milestone(matching_mids, ...)
    return(invisible(result))
  }
}


#' Search milestones by keyword
#'
#' Search for milestones that have been tagged with specific keywords.
#'
#' @param pattern Character string or regular expression to match against keywords
#' @param ignore.case Logical; if TRUE (default), case is ignored during matching
#' @param output Output format: "mid" returns milestone IDs (default),
#'   "print" prints formatted milestones, "data" returns milestone data frame
#' @param ... Additional arguments passed to \code{\link{print_milestone}} when
#'   output = "print"
#'
#' @return Depends on \code{output} parameter (see \code{\link{search_milestones}})
#'
#' @details
#' This is a convenience function that searches the keyword field in the
#' milestone2keyword table and returns matching milestones.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Find milestones tagged with "contour"
#' search_keywords("contour")
#'
#' # Find milestones with statistical keywords
#' search_keywords("statistic")
#'
#' # Print formatted results
#' search_keywords("visualization", output = "print")
#' }
#'
search_keywords <- function(pattern,
                           ignore.case = TRUE,
                           output = c("mid", "print", "data"),
                           ...) {

  output <- match.arg(output)

  # Load keyword linking table
  .m2k.env <- new.env()
  utils::data(milestone2keyword, package = 'milestoneR', envir = .m2k.env)
  m2k <- .m2k.env$milestone2keyword

  # Search keywords
  matches <- grepl(pattern, m2k$keyword, ignore.case = ignore.case)
  matching_mids <- unique(m2k$mid[matches])

  if (length(matching_mids) == 0) {
    message("No milestones found with keyword matching: ", pattern)
    if (output == "mid") {
      return(numeric(0))
    } else if (output == "data") {
      .ms.env <- new.env()
      utils::data(milestone, package = 'milestoneR', envir = .ms.env)
      return(.ms.env$milestone[0, ])
    } else {
      return(invisible(character(0)))
    }
  }

  # Return based on output format
  if (output == "mid") {
    return(matching_mids)
  } else if (output == "data") {
    .ms.env <- new.env()
    utils::data(milestone, package = 'milestoneR', envir = .ms.env)
    ms <- .ms.env$milestone
    return(ms[ms$mid %in% matching_mids, ])
  } else {  # output == "print"
    result <- print_milestone(matching_mids, ...)
    return(invisible(result))
  }
}


#' Search milestones by author
#'
#' Search for milestones associated with authors whose names match a pattern.
#'
#' @param pattern Character string or regular expression to match against author names
#' @param name_fields Character vector specifying which name fields to search.
#'   Options: "givennames", "lname" (last name), "prefix", "suffix".
#'   Default is c("givennames", "lname").
#' @param ignore.case Logical; if TRUE (default), case is ignored during matching
#' @param output Output format: "mid" returns milestone IDs (default),
#'   "print" prints formatted milestones, "data" returns milestone data frame
#' @param ... Additional arguments passed to \code{\link{print_milestone}} when
#'   output = "print"
#'
#' @return Depends on \code{output} parameter (see \code{\link{search_milestones}})
#'
#' @details
#' This function searches author names and returns milestones associated with
#' matching authors. The search is performed across specified name fields, and
#' a milestone is returned if ANY associated author matches.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Find milestones by Halley
#' search_authors("Halley")
#'
#' # Find milestones by authors with "John" in their name
#' search_authors("John")
#'
#' # Search only last names
#' search_authors("Playfair", name_fields = "lname")
#'
#' # Print formatted results
#' search_authors("Nightingale", output = "print")
#' }
#'
search_authors <- function(pattern,
                          name_fields = c("givennames", "lname"),
                          ignore.case = TRUE,
                          output = c("mid", "print", "data"),
                          ...) {

  output <- match.arg(output)

  # Load author data
  .aut.env <- new.env()
  utils::data(author, package = 'milestoneR', envir = .aut.env)
  authors <- .aut.env$author

  # Validate name fields
  valid_name_fields <- c("prefix", "givennames", "lname", "suffix")
  invalid_fields <- setdiff(name_fields, valid_name_fields)
  if (length(invalid_fields) > 0) {
    stop("Invalid name_fields: ", paste(invalid_fields, collapse = ", "),
         "\nValid fields are: ", paste(valid_name_fields, collapse = ", "))
  }

  # Search across specified name fields
  matches <- rep(FALSE, nrow(authors))

  for (field in name_fields) {
    field_values <- authors[[field]]
    if (is.null(field_values)) next

    field_values <- as.character(field_values)
    field_values[is.na(field_values)] <- ""

    field_matches <- grepl(pattern, field_values, ignore.case = ignore.case)
    matches <- matches | field_matches
  }

  # Get matching author IDs
  matching_aids <- authors$aid[matches]

  if (length(matching_aids) == 0) {
    message("No authors found matching: ", pattern)
    if (output == "mid") {
      return(numeric(0))
    } else if (output == "data") {
      .ms.env <- new.env()
      utils::data(milestone, package = 'milestoneR', envir = .ms.env)
      return(.ms.env$milestone[0, ])
    } else {
      return(invisible(character(0)))
    }
  }

  # Get milestones for these authors
  .m2a.env <- new.env()
  utils::data(milestone2author, package = 'milestoneR', envir = .m2a.env)
  m2a <- .m2a.env$milestone2author

  matching_mids <- unique(m2a$mid[m2a$aid %in% matching_aids])

  if (length(matching_mids) == 0) {
    message("No milestones found for authors matching: ", pattern)
    if (output == "mid") {
      return(numeric(0))
    } else if (output == "data") {
      .ms.env <- new.env()
      utils::data(milestone, package = 'milestoneR', envir = .ms.env)
      return(.ms.env$milestone[0, ])
    } else {
      return(invisible(character(0)))
    }
  }

  # Return based on output format
  if (output == "mid") {
    return(matching_mids)
  } else if (output == "data") {
    .ms.env <- new.env()
    utils::data(milestone, package = 'milestoneR', envir = .ms.env)
    ms <- .ms.env$milestone
    return(ms[ms$mid %in% matching_mids, ])
  } else {  # output == "print"
    result <- print_milestone(matching_mids, ...)
    return(invisible(result))
  }
}
