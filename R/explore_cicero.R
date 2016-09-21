#' Shiny app for exploring Cicero data on elected officials
#' @importFrom shiny fluidPage fluidRow sidebarPanel textInput selectInput actionButton column
#' @importFrom shiny tabsetPanel tabPanel tableOutput textOutput htmlOutput icon
#' @importFrom shiny eventReactive renderTable renderText renderUI shinyApp
#' @importFrom leaflet leaflet addTiles addMarkers renderLeaflet leafletOutput
#' @export
#' @examples
#'
#' explore_cicero()
#'

explore_cicero <- function() {

ui <- fluidPage(
  fluidRow(
    sidebarPanel(
      textInput("search_loc", "Address"),
      selectInput("district_type", "District Type", choices = list("National Upper",
                                                                   "National Lower",
                                                                   "State Upper",
                                                                   "State Lower")
                  ),
      actionButton("button", "Search", icon("cog"))
    ),
    column(
      4,
      leafletOutput("map", height = 600)
    ),
    column(
      4,
      tabsetPanel(
        tabPanel("General Info", tableOutput("gen_info")),
        tabPanel("Identifiers", tableOutput("ids")),
        tabPanel("Address Info", tableOutput("address_info")),
        tabPanel("District Info", tableOutput("district_info")),
        tabPanel("Bio", textOutput("notes")),
        tabPanel("Image", htmlOutput("image"))
        )
      )
  )
)

server <- function(input, output, session, ...) {

  cicero_data <- eventReactive(input$button, {

    district_type <- switch(input$district_type,
                   "National Upper" = "NATIONAL_UPPER",
                   "Nationl Lower" = "NATIONAL_LOWER",
                   "State Upper" = "STATE_UPPER",
                   "State Lower" = "STATE_LOWER")
    rcicero::get_official(search_loc = input$search_loc, district_type = district_type)
  })

  output$map <- renderLeaflet({

    leaflet(cicero_data()$gen_info) %>% addTiles() %>%
      addMarkers(~lon, ~lat, popup = ~sprintf("%s %s, %s", first_name, last_name, party))
  })

  output$gen_info <- renderTable({
    cicero_data()$gen_info %>%
      dplyr::select(-notes)
  })

  output$ids <- renderTable({
    cicero_data()$identifiers
  })

  output$address_info <- renderTable({
    cicero_data()$address_info
  })

  output$district_info <- renderTable({
    cicero_data()$district_info
  })

  output$notes <- renderText({
    cicero_data()$gen_info$notes
  })

  output$image = renderUI({
    src = cicero_data()$gen_info$photo_url
    tags$img(src=src)
  })

}
shinyApp(ui, server)
}




