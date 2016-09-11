#' get_nonlegislative_district
#'
#' @importFrom magrittr "%>%"
#' @importFrom httr stop_for_status GET content
#' @importFrom tidyjson as.tbl_json spread_values jstring enter_object
#' @importFrom dplyr select as_data_frame
#'
#' @param search_loc a string containing a street address
#' @param type a string, nonlegislative district type that is either: CENSUS, COUNTY, JUDICIAL, POLICE, SCHOOL, or WATERSHED
#'
#' @return data_frame
#' @export
#'
#' @examples
#' #' get_nonlegislative_district(search_loc = "3175 Bowers Ave. Santa Clara, CA, type = "SCHOOL")
get_nonlegislative_district <- function(search_loc = NULL, lat = NULL, lon = NULL,
                                        type = "SCHOOL") {
  if (!type %in% c("CENSUS", "COUNTY", "JUDICIAL", "POLICE", "SCHOOL", "WATERSHED") || length(type) != 1) {
    stop("type argument must be one of CENSUS, COUNTY, JUDICIAL, POLICE, SCHOOL, or WATERSHED")
  }
  auth_args <- list(
    key = check_key(),
    token = check_token(),
    user = check_user(),
    format = "json"
  )
  args <- as.list(match.call())
  args <- c(args, auth_args)
  args <- args[sapply(args, function(x) !is.call(x) && !is.name(x))]

  url <- paste0(cicero_url(), "/nonlegislative_district")
  resp <- httr::GET(url,
                    query = args)
  httr::stop_for_status(resp)
  json <- httr::content(resp, "text")
  message(paste("You have", resp$headers$`x-cicero-credit-balance`, "credits remaining."))
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
