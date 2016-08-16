#' get_legislative_district
#'
#' @importFrom magrittr "%>%"
#' @importFrom httr stop_for_status GET content
#' @importFrom tidyjson as.tbl_json spread_values jstring enter_object
#' @importFrom dplyr select as_data_frame
#'
#' @param address A string with most of any street address. Most of the time, you don't need to include zip code.
#'
#' @return data.frame with some list columns
#'
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
  sprintf("You have %d credits remaining.", resp$headers$`x-cicero-credit-balance`)
  df <- json %>% tidyjson::as.tbl_json() %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("candidates") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(address = tidyjson::jstring("match_addr"),
                            latitude = tidyjson::jstring("y"),
                            longitude = tidyjson::jstring("x")) %>%
    tidyjson::enter_object("districts") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(district_type = tidyjson::jstring("district_type"),
                            state = tidyjson::jstring("state"),
                            district_id = tidyjson::jstring("district_id"),
                            label = tidyjson::jstring("label")) %>%
    dplyr::select(-document.id, -array.index) %>%
    dplyr::as_data_frame()
  return(df)
}
