###This function returns a list with your user and token
#' set_token_and_user
#'
#'Obtain your Cicero API token and user with a POST request
#'
#' @importFrom dplyr select as_data_frame contains
#' @importFrom magrittr "%>%"
#' @importFrom httr stop_for_status GET content user_agent
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

cicero_query <- function(path, args, content_type) {
  url <- paste0('https://cicero.azavea.com/v3.1', path)
  resp <- httr::GET(url,
                    httr::user_agent("rcicero - https://github.com/daranzolin/rcicero"),
                    query = args)
  message(paste("You have", resp$headers$`x-cicero-credit-balance`, "credits remaining."))
  httr::stop_for_status(resp)
  if (as.numeric(resp$headers$`content-length`) < 150) {
    stop("No results found")
  }
  json <- httr::content(resp, content_type)
  return(json)
}

iter_args_list <- function(x, label) {
  ln <- list()
  for (i in seq_along(x)) {
    ln[[i]] <- x[i]
    names(ln)[[i]] <- label
  }
  ln
}

sc <- function(x) {
  Filter(Negate(is.null), x)
}

format_df <- function(x) {
  x <- x %>%
    dplyr::as_data_frame() %>%
    dplyr::select(-dplyr::contains("document"), -dplyr::contains("array")) %>%
    dplyr::distinct(.keep_all = TRUE)
}
