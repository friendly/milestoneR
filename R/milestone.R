#' Retrieve the `milestone` table from the milestones database
#'
#' The `milestone` table gives each item considered a milestone in the history of data visualization. This is
#' the primary table. Others are linked to it via the `mid` key.
#'
#' @return Returns a tibble of the `milestone` table
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate
#' @export
#'
milestone <- function() {
  mstones_con = .mstone.env$connnection
  mstones <- as_tibble(dbReadTable(mstones_con,
                                'milestone'))
  mstones <- mstones %>%
    select(-uid) %>%
    # cleanup description field
    mutate(description = html2latin1(description)) %>%
    mutate(description = gsub("</?p>", "", description))

  # TODO: quoted strings are badly handled in the description field.
  # many instances like: (\"star plot&#039;&#039;) -> (\"star plot'') after html2utf8
  # Need one more gsub() to replace '' when it immediately follows \".*

  # TODO: Do we need to export both the date_from & date_from_numeric fields?

  mstones
}

