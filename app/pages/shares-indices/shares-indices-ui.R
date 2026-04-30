tagList(
  titlePanel("Shares and Indices"),
  
  layout_sidebar(
    # title = "Population by Healthboard",
    sidebar = sidebar(
      radioButtons(
        "stat_in_shares",
        "Chose a statistic:",
        choices = as.character(machine2human$stat)
      ),
      radioButtons(
        "programme_in_shares",
        "Chose a Care Programme:",
        choices = as.character(machine2human$care_programme)
      ), 
      radioButtons(
        "component_in_shares", 
        "Choose a Component:", 
        choices = as.character(machine2human$component)
      )
    ),
    
    # accordion(
      nav_panel(
        "", 
        
        navset_tab(
          
          nav_panel("Crude Figures",
                    br(),
                    navset_underline(
                      nav_panel("Plot", girafeOutput("si_plot")), 
                      nav_panel("Table", reactableOutput("si_table"))
                    )
          ), 
          
          nav_panel("Absolute Difference",
                    br(), 
                    navset_underline(
                      nav_panel("Plot", girafeOutput("si_plot_diff")),
                      nav_panel("Table", reactableOutput("si_table_diff"))  
                    )
          )
          
        ) # navset_card
        
      )
    # ) # accordion
    
  ) # layout_sidebar
) # taglist 
