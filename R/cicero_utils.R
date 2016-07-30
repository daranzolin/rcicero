###This function returns a list with your user and token
#' get_token_and_user
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
#' #' get_token_and_user("darazolin@gmail.com", "password")
get_token_and_user <- function(username, password) {
  req <- httr::POST("http://cicero.azavea.com/v3.1/token/new.json",
                    body = list(username = username,
                                password = password))
  user_and_token <- httr::content(req, as = "parsed")
  if (!user_and_token$success) {
    stop("Your connection was not authorized. Please check to see if you have a valid Cicero account.",
         .call = FALSE)
  }
  return(user_and_token)
}


#' check_token
#'
#' Checks for and returns the token in your .Renviron
#'
#' @return string
#' @export
#'
#' @examples
#' #' check_token()
check_token <- function() {
  token <- Sys.getenv('CICERO_API_TOKEN')
  if (identical(token, "")) {
    stop("Please set env var CICERO_API_TOKEN to your personal access token",
         call. = FALSE)
  }
  token
}

#' check_key
#'
#' Checks for and returns the key in your .Renviron
#'
#' @return string
#' @export
#'
#' @examples
#' #' check_key()
check_key <- function(x) {
  key <- Sys.getenv('CICERO_API_KEY')
  if (identical(key, "")) {
    stop("Please set env var CICERO_API_KEY to your personal api key",
         call. = FALSE)
  }
  key
}

#' check_user
#'
#' Checks for and returns user in your .Renviron
#'
#' @return string
#' @export
#'
#' @examples
#' #' check_user()
check_user <- function() {
  user <- Sys.getenv('CICERO_API_USER')
  if (identical(user, "")) {
    stop("Please set env var CICERO_API_USER to your personal user",
         call. = FALSE)
  }
  user
}

cicero_url <- function() 'https://cicero.azavea.com/v3.1'

### This function turns the district_type parameter into a list
#' district_type_args_list
#'
#'format the arguments into acceptable query
#'
#' @param x list from parameters
#'
#' @return list
#' @export
#'
#' @examples
#' #' district_type_args_list(district_type)
district_type_args_list <- function(x) {
  dtl <- list()
  for (i in seq_along(x)) {
    dtl[[i]] <- x[i]
    names(dtl)[[i]] <- "district_type"
  }
  dtl
}
