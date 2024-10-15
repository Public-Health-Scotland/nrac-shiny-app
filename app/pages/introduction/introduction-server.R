# jump to buttons observe event ----
observeEvent(input$jump_to_populations, 
             {updateTabsetPanel(session, "intabset", selected = "populations")})
observeEvent(input$jump_to_trends, 
             {updateTabsetPanel(session, "intabset", selected = "trends")})


# sidebar tab outputs ----
output$introduction_about <- renderUI({
  
  tagList(
    h3(tags$b(
      "An experimental dashboard for the National Resource Allocation publication.")),
    br(),
    fluidRow(
      column(4,tags$div(class = "special_button",
                        actionButton("jump_to_populations", "Populations"))),
      column(8, p("This section provides the population projections used by the 
                  resource allocation formula."))),
    fluidRow(
      column(4,tags$div(class = "special_button",
                        actionButton("jump_to_trends", "Trends"))),
      column(8, p("This section provides the latest trends in shares and indices
                  produced by the formula.")))
    ) #taglist

})
    
output$introduction_use <- renderUI({
  
  tagList(
    h3(tags$b("How to use this dashboard")),
    br(),
    p(tags$li("Click on tabs in the blue navigation bar at the top to view each section"),
      tags$img(src = "intro_images/nav_bar.png", height = 50,
               alt ="Image of a part of the navigation bar for reference"))
  ) #taglist
  
})

output$introduction_contact <- renderUI({
  tagList(h3(tags$b("Contact us")),
          p("Please contact the ", 
            tags$a(href="mailto:phs.costsinfo@phs.scot", 
                   "Health and Finance Analytics"),
            "if you have any questions about the data in this dashboard.")
  ) #taglist
})

output$introduction_accessibility <- renderUI({
  
})

