#' Get authors associated with milestone(s)
#'
#' Retrieves author information for one or more milestones by joining the
#' milestone2author linking table with the author table.
#'
#' @param mid A numeric vector of milestone IDs
#'
#' @return A data frame with columns from both milestone2author and author tables,
#'   including mid, aid, and all author fields (prefix, givennames, lname, etc.)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get authors for a single milestone
#' get_milestone_authors(53)
#'
#' # Get authors for multiple milestones
#' get_milestone_authors(c(53, 54, 55))
#' }
#'
get_milestone_authors <- function(mid) {
  # Load linking table
  .m2a.env <- new.env()
  utils::data(milestone2author, package = 'milestoneR', envir = .m2a.env)
  m2a <- .m2a.env$milestone2author

  # Filter by requested milestone IDs
  m2a_subset <- m2a[m2a$mid %in% mid, ]

  # If no matches, return empty data frame
  if (nrow(m2a_subset) == 0) {
    return(data.frame())
  }

  # Load author table
  .aut.env <- new.env()
  utils::data(author, package = 'milestoneR', envir = .aut.env)
  authors <- .aut.env$author

  # Join with author table
  result <- merge(m2a_subset, authors, by = "aid", all.x = TRUE)

  # Order by mid, then aid
  result <- result[order(result$mid, result$aid), ]

  result
}


#' Get references associated with milestone(s)
#'
#' Retrieves reference information for one or more milestones by joining the
#' milestone2reference linking table with the reference table.
#'
#' @param mid A numeric vector of milestone IDs
#'
#' @return A data frame with columns from both milestone2reference and reference tables,
#'   including mid, rid, and all reference fields (author, title, year, etc.)
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get references for a single milestone
#' get_milestone_references(53)
#'
#' # Get references for multiple milestones
#' get_milestone_references(c(53, 54, 55))
#' }
#'
get_milestone_references <- function(mid) {
  # Load linking table
  .m2r.env <- new.env()
  utils::data(milestone2reference, package = 'milestoneR', envir = .m2r.env)
  m2r <- .m2r.env$milestone2reference

  # Filter by requested milestone IDs
  m2r_subset <- m2r[m2r$mid %in% mid, ]

  # If no matches, return empty data frame
  if (nrow(m2r_subset) == 0) {
    return(data.frame())
  }

  # Load reference table
  .ref.env <- new.env()
  utils::data(reference, package = 'milestoneR', envir = .ref.env)
  refs <- .ref.env$reference

  # Join with reference table
  result <- merge(m2r_subset, refs, by = "rid", all.x = TRUE)

  # Order by mid, then rid
  result <- result[order(result$mid, result$rid), ]

  result
}


#' Get media items associated with milestone(s)
#'
#' Retrieves media item information for one or more milestones from the mediaitem table,
#' which contains the mid field directly (no linking table needed).
#'
#' @param mid A numeric vector of milestone IDs
#'
#' @return A data frame with columns from the mediaitem table, including mid, miid,
#'   type, url, title, caption, source, and type2
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get media items for a single milestone
#' get_milestone_media(53)
#'
#' # Get media items for multiple milestones
#' get_milestone_media(c(53, 54, 55))
#' }
#'
get_milestone_media <- function(mid) {
  # Load mediaitem table (contains mid field directly - no linking table needed)
  .media.env <- new.env()
  utils::data(mediaitem, package = 'milestoneR', envir = .media.env)
  media <- .media.env$mediaitem

  # Filter by requested milestone IDs
  result <- media[media$mid %in% mid, ]

  # If no matches, return empty data frame
  if (nrow(result) == 0) {
    return(data.frame())
  }

  # Order by mid, then miid (media item id)
  result <- result[order(result$mid, result$miid), ]

  result
}


#' Get keywords associated with milestone(s)
#'
#' Retrieves keyword information for one or more milestones from the
#' milestone2keyword table, which already includes keyword names.
#'
#' @param mid A numeric vector of milestone IDs
#'
#' @return A data frame with columns mid, kid, and keyword
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get keywords for a single milestone
#' get_milestone_keywords(53)
#'
#' # Get keywords for multiple milestones
#' get_milestone_keywords(c(53, 54, 55))
#' }
#'
get_milestone_keywords <- function(mid) {
  # Load milestone2keyword table (already has keyword field)
  .m2k.env <- new.env()
  utils::data(milestone2keyword, package = 'milestoneR', envir = .m2k.env)
  m2k <- .m2k.env$milestone2keyword

  # Filter by requested milestone IDs
  result <- m2k[m2k$mid %in% mid, ]

  # Order by mid, then keyword
  result <- result[order(result$mid, result$keyword), ]

  result
}


#' Get subjects associated with milestone(s)
#'
#' Retrieves subject information for one or more milestones from the
#' milestone2subject table, which already includes subject names.
#'
#' @param mid A numeric vector of milestone IDs
#'
#' @return A data frame with columns mid, sid, and subject
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get subjects for a single milestone
#' get_milestone_subjects(53)
#'
#' # Get subjects for multiple milestones
#' get_milestone_subjects(c(53, 54, 55))
#' }
#'
get_milestone_subjects <- function(mid) {
  # Load milestone2subject table (already has subject field)
  .m2s.env <- new.env()
  utils::data(milestone2subject, package = 'milestoneR', envir = .m2s.env)
  m2s <- .m2s.env$milestone2subject

  # Filter by requested milestone IDs
  result <- m2s[m2s$mid %in% mid, ]

  # Order by mid, then subject
  result <- result[order(result$mid, result$subject), ]

  result
}


#' Get aspects associated with milestone(s)
#'
#' Retrieves aspect information for one or more milestones from the
#' milestone2aspect table, which already includes aspect names.
#'
#' @param mid A numeric vector of milestone IDs
#'
#' @return A data frame with columns mid, asid, and aspect
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get aspects for a single milestone
#' get_milestone_aspects(53)
#'
#' # Get aspects for multiple milestones
#' get_milestone_aspects(c(53, 54, 55))
#' }
#'
get_milestone_aspects <- function(mid) {
  # Load milestone2aspect table (already has aspect field)
  .m2a.env <- new.env()
  utils::data(milestone2aspect, package = 'milestoneR', envir = .m2a.env)
  m2a <- .m2a.env$milestone2aspect

  # Filter by requested milestone IDs
  result <- m2a[m2a$mid %in% mid, ]

  # Order by mid, then aspect
  result <- result[order(result$mid, result$aspect), ]

  result
}
