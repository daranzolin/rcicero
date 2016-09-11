###This function returns a list with your user and token
#' set_token_and_user
#'
#'Obtain your Cicero API token and user with a POST request
#'
#' @param username string - your Cicero account username
#' @param password string - your Cicero account password
#'
#' @return list
#' @export
#'
#' @examples
#' #' set_token_and_user("darazolin@gmail.com", "password")
set_token_and_user <- function(username, password) {
  req <- httr::POST("http://cicero.azavea.com/v3.1/token/new.json",
                    body = list(username = username,
                                password = password))
  user_and_token <- httr::content(req, as = "parsed")
  if (!user_and_token$success) {
    stop("Your connection was not authorized. Please check to see if you have a valid Cicero account.",
         .call = FALSE)
  }
  options(cicero_user = user_and_token$user)
  options(cicero_token = user_and_token$token)
  message("Your Cicero API user and token options have been set.")
}

check_token <- function() {
  token <- getOption('cicero_token')
  if (is.null(token)) {
    stop("No token detected. Please run set_user_and_token() without error",
         call. = FALSE)
  }
  token
}

check_key <- function(x) {
  key <- Sys.getenv('CICERO_API_KEY')
  if (identical(key, "")) {
    stop("Please set env var CICERO_API_KEY to your personal api key",
         call. = FALSE)
  }
  key
}

check_user <- function() {
  user <- getOption('cicero_user')
  if (is.null(user)) {
    stop("No token detected. Please run set_user_and_token() without error",
         call. = FALSE)
  }
  user
}

cicero_url <- function() 'https://cicero.azavea.com/v3.1'

district_type_args_list <- function(x) {
  dtl <- list()
  for (i in seq_along(x)) {
    dtl[[i]] <- x[i]
    names(dtl)[[i]] <- "district_type"
  }
  dtl
}
