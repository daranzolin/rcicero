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
  json <- httr::content(resp, "text")
  balance <- resp$headers$`x-cicero-credit-balance`
  print(paste("You have", balance, "credits remaining.", sep = " "))
  df <- json %>% tidyjson::as.tbl_json() %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("candidates") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(address = jstring("match_addr"),
                            latitude = jstring("y"),
                            longitude = jstring("x")) %>%
    tidyjson::enter_object("districts") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(district_type = jstring("district_type"),
                            state = jstring("state"),
                            district_id = jstring("district_id"),
                            label = jstring("label")) %>%
    dplyr::select(-document.id, -array.index) %>%
    dplyr::as_data_frame()
  return(df)
}
