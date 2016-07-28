#' Insert \%>\% View()
#'
#' Call this function as an addin to insert \code{ \%>\% View() } at the cursor position.
#'
#' @export
insertInAddin <- function() {
  rstudioapi::insertText(" %>% View() ")
}
