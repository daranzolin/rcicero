#' get_legislative_district
#'
#' @param address A string with most of any street address. Most of the time, you don't need to include zip code.
#'
#' @return data.frame with some list columns
#' @export
#'
#' @examples
#'#' get_legislative_district("3175 Bowers Ave. Santa Clara, CA")
get_legislative_district <- function(address) {
  key <- check_key()
  token <- check_token()
  user <- check_user()
  args <- list(key = key,
               token = token,
               user = user,
               format = "json",
               search_loc = address)
  url <- paste0(cicero_url(), "/legislative_district")
  resp <- httr::GET(url,
                    query = args)
  httr::stop_for_status(resp)
  parsed <- jsonlite::fromJSON(httr::content(resp, "text"), flatten = TRUE)
  district_df <- parsed$response$results$candidates$districts[[1]]
  if (is.null(district_df)) {
    stop("Sorry, that address could not be located.")
  }
  balance <- resp$headers$`x-cicero-credit-balance`
  print(paste("You have", balance, "credits remaining.", sep = " "))
  return(district_df)
}
