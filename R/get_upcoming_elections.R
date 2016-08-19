#' get_upcoming_elections
#'
#' @importFrom magrittr "%>%"
#' @importFrom httr stop_for_status GET content
#' @importFrom tidyjson as.tbl_json spread_values jstring enter_object
#' @importFrom dplyr select as_data_frame
#'
#' @param election_expire_date_on_or_after a character vector indicating date. Defaults to "today"
#'
#' @param is_local Boolean indicating that the ElectionEvent represents a local election
#'
#' @param is_state Boolean indicating that the ElectionEvent represents a state election
#'
#' @param is_national Boolean indicating that the ElectionEvent represents a national election
#'
#' @param is_transnational Boolean indicating that the ElectionEvent represents a transnational election
#'
#' @param elections an integer, indicating max number of elections to return
#'
#' @return data_frame
#'
#' @export
#'
#' @examples
#' #' get_upcoming_elections(is_state = TRUE, elections = 2)
#' #' get_upcoming_elections(is_national = TRUE, elections = 5)
get_upcoming_elections <- function(election_expire_date_on_or_after = "today", is_local = NULL, is_state = NULL,
                                   is_national = NULL, is_transnational = NULL, elections = 5) {
  key <- check_key()
  token <- check_token()
  user <- check_user()
  args <- list(
    key = key,
    token = token,
    user = user,
    format = "json",
    election_expire_date_on_or_after = election_expire_date_on_or_after,
    is_state = is_state,
    is_national = is_national,
    is_transnational = is_transnational,
    max = elections
    )
  args <- Filter(Negate(is.null), args)
  url <- paste0(cicero_url(), "/election_event")
  resp <- httr::GET(url,
                    query = args)
  print(paste("You have", resp$headers$`x-cicero-credit-balance`, "credits remaining."))
  httr::stop_for_status(resp)
  json <- httr::content(resp, "text")
  df <- json %>% tidyjson::as.tbl_json() %>%
    tidyjson::enter_object("response") %>%
    tidyjson::enter_object("results") %>%
    tidyjson::enter_object("election_events") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(election_label = tidyjson::jstring("label"),
                  election_date = tidyjson::jstring("election_date_text")) %>%
    tidyjson::enter_object("chambers") %>% tidyjson::gather_array() %>%
    tidyjson::spread_values(id = tidyjson::jstring("id"),
                  term_length = tidyjson::jstring("term_length"),
                  chamber_type = tidyjson::jstring("type"),
                  name_formal = tidyjson::jstring("name_formal"),
                  election_frequency = tidyjson::jstring("election_frequency"),
                  contact_email = tidyjson::jstring("contact_email"),
                  contact_phone = tidyjson::jstring("contact_phone"),
                  election_rules = tidyjson::jstring("election_rules")
    ) %>%
    tidyjson::enter_object("government") %>%
    tidyjson::spread_values(state = tidyjson::jstring("state"),
                  full_name = tidyjson::jstring("name")) %>%
    tidyjson::enter_object("country") %>%
    tidyjson::spread_values(name_short = tidyjson::jstring("name_short"),
                  name_long = tidyjson::jstring("name_long")) %>%
    dplyr::select(-document.id, -array.index) %>%
    dplyr::as_data_frame()
  return(df)
}
