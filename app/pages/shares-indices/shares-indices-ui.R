layout_sidebar(
  
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
    ), 
    selectizeInput(
      "hb_in_shares", 
      "Choose Healthboards:", 
      choices = pop_list$hb_names, 
      multiple = TRUE, 
      selected = pop_list$hb_names
    )
  ), # sidebar
  
  navset_tab(
    
    nav_panel("Crude Figures",
              br(),
              navset_underline(
                nav_panel("Plot", girafeOutput("si_plot", width = "90%")), 
                nav_panel("Table", reactableOutput("si_table"))
              )
    ), # nav_panel
    
    nav_panel("Absolute Difference",
              br(), 
              navset_underline(
                nav_panel("Plot", girafeOutput("si_plot_diff", width = "90%")),
                nav_panel("Table", reactableOutput("si_table_diff"))  
              )
    ) # nav_panel
    
  ) # navset_tab
  
) # layout_sidebar
  
  