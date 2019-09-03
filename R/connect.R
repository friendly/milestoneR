#' Open a MySQL connection to the milestones database
#'
#' This version requires that you setup a keyring password for the service `milestones` with
#' username `milestones`. Due to York IT security, this only works with a Yorku IP address
#' or via VPN.
#'
#' The connect function assumes that the user has stored the database password
#' in their OS's keyring.  This has been made flexible to account for users
#' who use either Linux, Windows, or MacOS.
#'
#' @return The string representing the database connection. For convenience, this is also
#'         stored in an environment variable, `.mstone.env$connnection`.
#' @importFrom RMySQL MySQL
#' @importFrom DBI dbConnect
#' @importFrom keyring key_get
#' @importFrom keyringr decrypt_gk_pw
#' @importFrom keyringr decrypt_kc_pw
#' @export
#'
#' @examples
#' \dontrun{
#' connect()
#' }
#'

source('Utils.R')



connect <- function() {

  os = get_os()

  if (os == 'linux') {
    pw = decrypt_gk_pw('db mstones user milestones')
  } else if (os == 'windows') {
    pw = key_get(keyring = 'mstones', username = 'milestones')
  } else if (os == 'osx') {
    pw = decrypt_kc_pw("mstones")
  }

  mstones_con = dbConnect(RMySQL::MySQL(),
                          host = "setebos.ccs.yorku.ca",
                          dbname = 'milestones',
                          user = 'milestones',
                          password = pw)
  .mstone.env <- new.env()
  .mstone.env$connnection <- mstones_con
  mstones_con
}


