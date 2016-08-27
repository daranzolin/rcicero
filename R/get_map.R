#' get_map
#'
#' Obtain district map data by state, country, district type, and district id.
#'
#' @importFrom httr stop_for_status GET content
#'
#' @param state string indicating state (e.g. "CA", "MA", "MZ", etc.)
#'
#' @param country string indicating country (e.g. "MX", "CN", "UK")
#'
#' @param district_id string indicating district id (obtainable through get_official(), get_legislative_district())
#'
#' @param district_type string indicating district type (e.g. "NATIONAL_LOWER", "NATIONAL_UPPER", "STATE_LOWER", etc.)
#'
#' @return list
#'
#' @export
#'
#' @examples
#'#' map <- get_map(state = "CA", district_type = "NATIONAL_LOWER", district_id = 5)
get_map <- function(state, country = "US", district_id, district_type) {

  args <- list(
    key = check_key(),
    token = check_token(),
    user = check_user(),
    format = "json",
    state = state,
    country = country,
    district_id = district_id,
    district_type = district_type,
    include_image_data = TRUE
  )
  url <- paste0(cicero_url(), "/map")
  resp <- httr::GET(url,
                    query = args)
  httr::stop_for_status(resp)
  print(paste("You have", resp$headers$`x-cicero-credit-balance`, "credits remaining."))
  dat <- httr::content(resp, "parsed")
  img_dat <- dat$response$results$maps[[1]]
  return(img_dat)
}
