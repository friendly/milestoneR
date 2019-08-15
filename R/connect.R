#' Open a MySQL connection to the milestones database
#'
#' @return
#' @export
#'
#' @examples
#' connect()
#'
connect <- function() {
  mstones_con = dbConnect(RMySQL::MySQL(),
                          host = "setebos.ccs.yorku.ca",
                          dbname = 'milestones',
                          user = 'milestones',
                          password = key_get('milestones',
                                             keyring = 'milestones'))
  mstones_con
}
