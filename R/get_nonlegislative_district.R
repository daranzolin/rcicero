#' get_nonlegislative_district
#'
#' @importFrom magrittr "%>%"
#' @importFrom httr stop_for_status GET content
#' @importFrom tidyjson as.tbl_json spread_values jstring enter_object
#' @importFrom dplyr select as_data_frame
#'
#' @param address a string containing a street address
#' @param type a string, nonlegislative district type that is either: CENSUS, COUNTY, JUDICIAL, POLICE, SCHOOL, or WATERSHED
#'
#' @return data.frame
#' @export
#'
#' @examples
#' #' get_nonlegislative_district(address = "3175 Bowers Ave. Santa Clara, CA, type = "SCHOOL")
get_nonlegislative_district <- function(address, type) {
  key <- check_key()
  token <- check_token()
  user <- check_user()
  args <- list(key = key,
               token = token,
               user = user,
               format = "json",
               search_loc = address,
               type = type)
  url <- paste0(cicero_url(), "/nonlegislative_district")
  resp <- httr::GET(url,
                    query = args)
  httr::stop_for_status(resp)
  json <- httr::content(resp, "text")
  print(paste("You have", resp$headers$`x-cicero-credit-balance`, "credits remaining."))
  df <- json %>% tidyjson::as.tbl_json() %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("candidates") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(address = tidyjson::jstring("match_addr"),
                            latitude = tidyjson::jstring("y"),
                            longitude = tidyjson::jstring("x")) %>%
    tidyjson::enter_object("districts") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(district_type = tidyjson::jstring("district_type"),
                            label = tidyjson::jstring("label"),
                            subtype = tidyjson::jstring("subtype"),
                            state = tidyjson::jstring("state")) %>%
    dplyr::select(-document.id, -array.index) %>%
    dplyr::as_data_frame()
  return(df)
}
