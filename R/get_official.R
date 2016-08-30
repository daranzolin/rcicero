#' get_official
#'
#'Obtain official information from the Cicero API. Can seach by latitude and longitude coordinates and first and last name.
#'
#' @importFrom magrittr "%>%"
#' @importFrom httr stop_for_status GET content
#' @importFrom tidyjson as.tbl_json spread_values jstring enter_object
#' @importFrom dplyr select as_data_frame contains
#'
#' @param lat Latitude coordiante
#'
#' @param lon Longitude coordinate
#'
#' @param address Street address
#'
#' @param first_name First name of official
#'
#' @param last_name Last name of official
#'
#' @param district_type Officials from which district type?
#'
#' @return list
#'
#' @export
#'
#' @examples
#' #' get_official(lat = 40, lon = -75.1)
#' #' get_official(address = "3175 Bowers Ave. Santa Clara, CA", district_type = "STATE_LOWER", "STATE_UPPER")
#' #' get_official(last_name = "Obama")
get_official <- function(lat = NULL, lon = NULL, first_name = NULL, last_name = NULL,
                         district_type = c("STATE_LOWER", "STATE_UPPER",
                                           "NATIONAL_UPPER", "NATIONAL_LOWER")) {
  auth_args <- list(
    key = check_key(),
    token = check_token(),
    user = check_user(),
    format = "json"
  )
  if (missing(last_name) || missing(first_name)) {
    loc_args <- list(
      lat = lat,
      lon = lon
    )
  } else if (missing(lon) || missing(lat)) {
    loc_args <- list(
      last_name = last_name,
      first_name = first_name,
      valid_range = "ALL"
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
  print(paste("You have", resp$headers$`x-cicero-credit-balance`, "credits remaining."))
  json <- httr::content(resp, "text")
  gen_info <- json %>% tidyjson::as.tbl_json() %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("officials") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(last_name = tidyjson::jstring("last_name"),
                            first_name = tidyjson::jstring("first_name"),
                            notes = tidyjson::jstring("notes"),
                            photo_url = tidyjson::jstring("photo_origin_url"),
                            party = tidyjson::jstring("party"),
                            initial_start_date = tidyjson::jstring("initial_term_start_date"),
                            current_term_start_date = tidyjson::jstring("current_term_start_date"),
                            webform_url = tidyjson::jstring("web_form_url")
    ) %>%
    dplyr::as_data_frame() %>%
    dplyr::select(-dplyr::contains("document"), -dplyr::contains("array")) %>%
    dplyr::distinct(.keep_all = TRUE)

  identifiers <- json %>% tidyjson::as.tbl_json() %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("officials") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(last_name = tidyjson::jstring("last_name"),
                            first_name = tidyjson::jstring("first_name")
    ) %>%
    tidyjson::enter_object("identifiers") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(identifier = tidyjson::jstring("identifier_value"),
                            identifier_type = tidyjson::jstring("identifier_type")
    ) %>%
    dplyr::as_data_frame() %>%
    dplyr::select(-dplyr::contains("document"), -dplyr::contains("array")) %>%
    dplyr::distinct(.keep_all = TRUE)

  district_info <- json %>% tidyjson::as.tbl_json() %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("officials") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(last_name = tidyjson::jstring("last_name"),
                            first_name = tidyjson::jstring("first_name")) %>%
    tidyjson::enter_object("office") %>%
    tidyjson::enter_object("district") %>%
    tidyjson::spread_values(district_type = tidyjson::jstring("district_type"),
                            country = tidyjson::jstring("country"),
                            district_id = tidyjson::jstring("district_id"),
                            label = tidyjson::jstring("label"),
                            state = tidyjson::jstring("state"),
                            subtype = tidyjson::jstring("subtype")
                            ) %>%
    dplyr::as_data_frame() %>%
    dplyr::select(-dplyr::contains("document"), -dplyr::contains("array")) %>%
    dplyr::distinct(.keep_all = TRUE)

  committee_info <- json %>% tidyjson::as.tbl_json() %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("officials") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(last_name = tidyjson::jstring("last_name"),
                            first_name = tidyjson::jstring("first_name")) %>%
    tidyjson::enter_object("committees") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(description = tidyjson::jstring("description"),
                            comm_id = tidyjson::jstring("id")) %>%
    dplyr::as_data_frame() %>%
    dplyr::select(-dplyr::contains("document"), -dplyr::contains("array")) %>%
    dplyr::distinct(.keep_all = TRUE)

  address_info <- json %>% tidyjson::as.tbl_json() %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("officials") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(last_name = tidyjson::jstring("last_name"),
                            first_name = tidyjson::jstring("first_name")) %>%
    tidyjson::enter_object("addresses") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(postal_code = tidyjson::jstring("postal_code"),
                            phone = tidyjson::jstring("phone_1"),
                            fax = tidyjson::jstring("fax_1"),
                            city = tidyjson::jstring("city"),
                            state = tidyjson::jstring("state"),
                            address_1 = tidyjson::jstring("address_1"),
                            address_2 = tidyjson::jstring("address_2"),
                            address_3 = tidyjson::jstring("address_3"))%>%
    dplyr::select(-dplyr::contains("document"), -dplyr::contains("array")) %>%
    dplyr::distinct(.keep_all = TRUE)

  off_data <- list(
    gen_info = gen_info,
    identifiers = identifiers,
    committee_info = committee_info,
    address_info = address_info,
    district_info = district_info
  )
  return(off_data)
}
