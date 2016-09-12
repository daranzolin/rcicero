#' get_legislative_district
#'
#' @importFrom magrittr "%>%"
#' @importFrom httr stop_for_status GET content
#' @importFrom tidyjson as.tbl_json spread_values jstring enter_object
#' @importFrom dplyr select as_data_frame
#'
#' @param search_loc A string with most of any street address. Most of the time, you don't need to include zip code.
#'
#' @return data_frame
#'
#' @export
#'
#' @examples
#'#' get_legislative_district("3175 Bowers Ave. Santa Clara, CA")
get_legislative_district <- function(search_loc = NULL, lat = NULL, lon = NULL) {
  args <- sc(list(
    key = check_key(),
    token = check_token(),
    user = check_user(),
    format = "json",
    search_loc = search_loc,
    lat = lat,
    lon = lon
    )
  )
  url <- paste0(cicero_url(), "/legislative_district")
  resp <- httr::GET(url,
                    query = args)
  httr::stop_for_status(resp)
  json <- httr::content(resp, "text")
  message(paste("You have", resp$headers$`x-cicero-credit-balance`, "credits remaining."))

  if (!is.null(search_loc)) {
    df <- json %>% tidyjson::as.tbl_json() %>%
      tidyjson::enter_object("response") %>%
      tidyjson::enter_object("results") %>%
      tidyjson::enter_object("candidates") %>% tidyjson::gather_array() %>%
      tidyjson::spread_values(match_postal = tidyjson::jstring("match_postal"),
                              match_addr = tidyjson::jstring("match_addr"),
                              match_subregion = tidyjson::jstring("match_subregion"),
                              match_region = tidyjson::jstring("match_region")
                              ) %>%
      tidyjson::enter_object("districts") %>% tidyjson::gather_array() %>%
      tidyjson::spread_values(district_type = tidyjson::jstring("district_type"),
                              state = tidyjson::jstring("state"),
                              district_id = tidyjson::jstring("district_id"),
                              label = tidyjson::jstring("label"),
                              num_officials = tidyjson::jnumber("num_officials"),
                              id = tidyjson::jstring("id"),
                              last_updated = tidyjson::jstring("last_update_date")
      )

  } else {
    df <- json %>% tidyjson::as.tbl_json() %>%
      tidyjson::enter_object("response") %>%
      tidyjson::enter_object("results") %>%
      tidyjson::enter_object("districts") %>% tidyjson::gather_array() %>%
      tidyjson::spread_values(district_type = tidyjson::jstring("district_type"),
                              state = tidyjson::jstring("state"),
                              district_id = tidyjson::jstring("district_id"),
                              label = tidyjson::jstring("label"),
                              num_officials = tidyjson::jnumber("num_officials"),
                              id = tidyjson::jstring("id"),
                              last_updated = tidyjson::jstring("last_update_date")
      )
  }
  df <- df %>%
    dplyr::select(-document.id, -array.index) %>%
    dplyr::as_data_frame()
  return(df)
}
