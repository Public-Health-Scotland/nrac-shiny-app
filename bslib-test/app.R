#' app.R
#' Health Finance & Analytics
#' Code written September 2024
#' R version 4.1.2 (2021-11-01)
#'
#' Author:Maiana Sanjuan
#' Runtime:
#' Memory:10GB
#' CPUs:1
#'

# set-up ------------------------------------------------------------------

# load packages
source("set-up.R")

# ui ----------------------------------------------------------------------

ui <- page_navbar(
  title = "NRAC Dashboard", 
  nav_panel("Shares and Indices",
            source(
              file.path("pages/shares-indices/shares-indices-ui.R"),
              local = TRUE
            )$value
            )
)

# server ------------------------------------------------------------------

server <- function(input, output, session){
  source(file.path("pages/shares-indices/shares-indices-server.R"),
         local = TRUE)$value
}

# run the app -------------------------------------------------------------
shinyApp(ui = ui, server = server)
