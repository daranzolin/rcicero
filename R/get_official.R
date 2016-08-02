#' get_official
#'
#'Obtain official information from the Cicero API. Can seach by latitude and longitude coordinates, address, and first and last name.
#'
#' @importFrom magrittr "%>%"
#'
#' @param lat Latitude coordiante
#' @param lon Longitude coordinate
#' @param address Street address
#' @param first_name First name of official
#' @param last_name Last name of official
#' @param district_type Officials from which district type?
#'
#' @return Data frame with--alas--nested columns.
#'
#' @export
#'
#' @examples
#' #' get_official(lat = 40, lon = -75.1)
#' #' get_official(address = "3175 Bowers Ave. Santa Clara, CA", district_type = "STATE_LOWER", "STATE_UPPER")
#' #' get_official(last_name = "Obama")
get_official <- function(lat = NULL, lon = NULL, address = NULL,
                         first_name = NULL, last_name = NULL,
                         district_type = c("STATE_LOWER", "STATE_UPPER",
                                           "NATIONAL_UPPER", "NATIONAL_LOWER")) {
  auth_args <- list(
    key = check_key(),
    token = check_token(),
    user = check_user(),
    format = "json"
  )
  if (missing(address) && missing(last_name)) {
    loc_args <- list(
      lat = lat,
      lon = lon
    )
  } else if (missing(address) && missing(lat)) {
    loc_args <- list(
      last_name = last_name,
      first_name = first_name,
      valid_range = "ALL"
    )
  } else {
    loc_args <- list(
      search_loc = address
    )
  }
  args <- c(
    auth_args,
    loc_args,
    district_type_args_list(district_type)
  )
  url <- paste0(cicero_url(), "/official")
  resp <- httr::GET(url,
                    query = args)
  httr::stop_for_status(resp)
  balance <- resp$headers$`x-cicero-credit-balance`
  print(paste("You have", balance, "credits remaining.", sep = " "))
  json <- httr::content(resp, "text")
  df <- json %>% tidyjson::as.tbl_json %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("candidates") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(match_postal = tidyjson::jstring("match_postal")) %>%
    tidyjson::enter_object("officials") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(last_name = tidyjson::jstring("last_name"),
                            first_name = tidyjson::jstring("first_name"),
                            notes = tidyjson::jstring("notes"),
                            photo_url = tidyjson::jstring("photo_origin_url"),
                            party = tidyjson::jstring("party")
    ) %>%
    tidyjson::enter_object("office") %>%
    tidyjson::spread_values(title = jstring("title")) %>%
    tidyjson::enter_object("district") %>%
    tidyjson::spread_values(district_type = tidyjson::jstring("district_type"),
                            country = tidyjson::jstring("country"),
                            district_id = tidyjson::jstring("district_id"),
                            label = tidyjson::jstring("label"),
                            state = tidyjson::jstring("state")) %>%
    dplyr::select(-document.id, -array.index) %>%
    dplyr::as_data_frame()
  return(df)
}
