layout_sidebar(
  
  sidebar = sidebar(
    radioButtons(
      "programme_in_mc",
      "Chose a Care Programme:",
      choices = as.character(machine2human$care_programme)
    ), 
    selectizeInput(
      "hb_in_mc", 
      "Choose Healthboards:", 
      choices = pop_list$hb_names, 
      multiple = FALSE, 
      selected = "NHS Ayrshire & Arran"
    )
  ), # sidebar
  
  navset_tab(
    
    nav_panel("Crude Figures",
              br(),
              navset_underline(
                nav_panel("Plot", girafeOutput("mc_plot", width = "90%")),
                nav_panel("Table", reactableOutput("mc_table")) 
              )
    ), # nav_panel
    
    nav_panel("Absolute Difference",
              br(), 
              navset_underline(
                
              )
    ) # nav_panel
    
  ) # navset_tab
  
) # layout_sidebar
