#' Retrieve the `milestone` table from the milestones database
#'
#' The `milestone` table gives each item considered a milestone in the history of data visualization.
#'
#' @return Returns a tibble of the `milestone` table
#' @export
#'
milestones <- function(connection = .mstone.env$connnection) {
  mstones <- as_tibble(dbReadTable(mstones_con,
                                'milestone'))
  mstones <- mstones %>%
    select(-uid)
  mstones
}

