#' Open a MySQL connection to the milestones database
#'
#' This version requires that you setup a keyring password for the service `milestones` with
#' username `milestones`. Due to York IT security, this only works with a Yorku IP address
#' or via VPN.
#'
#'
#' @return The string representing the database connection. For convenience, this is also
#'         stored in an environment variable, `.mstone.env$connnection`.
#' @importFrom RMySQL MySQL
#' @importFrom DBI dbConnect
#' @importFrom keyring key_get
#' @export
#'
#' @examples
#' \dontrun{
#' connect()
#' }
#'
connect <- function() {
  mstones_con = dbConnect(RMySQL::MySQL(),
                          host = "setebos.ccs.yorku.ca",
                          dbname = 'milestones',
                          user = 'milestones',
                          password = key_get(service = 'milestones',
                                             username = 'milestones'))
  .mstone.env <- new.env()
  .mstone.env$connnection <- mstones_con
  mstones_con
}


