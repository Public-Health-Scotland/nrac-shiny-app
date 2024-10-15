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
# set-up ----

# load packages
source("set-up.R")

# ui ----

ui <- fluidPage(
  
  tagList(
    
    navbarPage(
      id = "intabset", # id used for jumping between tabs
      position = "fixed-top",
      collapsible = "true",
      title = div(
        tags$a(img(src = "white-logo.png", height = 40,
                   alt ="Go to Public Health Scotland (external site)"),
               href = "https://www.publichealthscotland.scot/",
               target = "_blank"), # PHS logo links to PHS website
        style = "position: relative; top: -10px;"),
      windowTitle = "NRAC Dashboard", # Title for browser tab
      header = source(file.path("header.R"), local=TRUE)$value,
      
      ## intro-page ----
      
      tabPanel(
        title = "Introduction",
        icon = icon_no_warning_fn("circle-info"),
        value = "intro",
        source(file.path("pages/introduction/introduction-ui.R"), local = TRUE)$value
      ),
      
      ## populations ----
      
      tabPanel(
        title = "Populations",
        icon = icon_no_warning_fn("users"),
        value = "populations",
        source(file.path("pages/populations/populations-ui.R"), local = TRUE)$value
      ),
      
      
      ## trends ----
      tabPanel(
        title = "Trends",
        icon = icon_no_warning_fn("chart-line"),
        value = "trends",
        source(file.path("pages/trends/trends-ui.R"), local = TRUE)$value
      )
      
      
    ) # navbar
    
  ) # tag list
  
) # fluid page

# server ----
server <- function(input, output, session){
  
  if(password_protect){
    source(file.path("password-protect/password-protect-server.R"), local = TRUE)$value
  }
  
  # modules ----
  
  # functions ----
  
  # pages ----
  source(file.path("pages/introduction/introduction-server.R"), local = TRUE)$value
}

# run the application ----
# conditionally add password protect app UI
if (password_protect){ ui <- secure_app(ui) }
shinyApp(ui=ui, server=server)
