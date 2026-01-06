#' Print milestone entries with enhanced CLI formatting
#'
#' Format and print milestone entries from the milestones database using the
#' `cli` package for enhanced console output with clickable links, better
#' formatting, and visual structure.
#'
#' This is a convenience wrapper around [print_milestone()] with `result = "cli"`.
#' You can also call `print_milestone(ms, result = "cli")` directly.
#'
#' @param ms A data frame from the [milestone()] table (one or more rows),
#'   or a numeric vector of milestone IDs (mid) to look up
#' @param include Character vector specifying which sections to include.
#'   Options: "authors", "keywords", "subjects", "aspects", "media", "references".
#'   Default is all sections.
#' @param show_images Logical; if TRUE, show image information in output.
#'   Default is TRUE.
#'
#' @return NULL (invisibly). The formatted milestone is printed to the console
#'   using cli functions.
#'
#' @details
#' This function uses the `cli` package to create enhanced console output with:
#' \itemize{
#'   \item Clickable hyperlinks for media items and references
#'   \item Better visual structure with headers and lists
#'   \item Color and formatting for improved readability
#' }
#'
#' If multiple milestones are provided (either as multiple rows or multiple IDs),
#' each milestone is printed separately with visual separation.
#'
#' @export
#'
#' @seealso [print_milestone()] for the main print function with multiple output formats
#'
#' @examples
#' \dontrun{
#' # Print a single milestone
#' print_milestone_cli(53)
#'
#' # Print multiple milestones
#' print_milestone_cli(c(53, 54, 55))
#'
#' # Print with only selected sections
#' print_milestone_cli(53, include = c("authors", "references"))
#'
#' # Equivalent using print_milestone directly
#' print_milestone(53, result = "cli")
#' }
#'
print_milestone_cli <- function(ms,
                                include = c("authors", "keywords", "subjects", "aspects", "media", "references"),
                                show_images = TRUE) {
  print_milestone(ms, result = "cli", include = include, show_images = show_images)
}
