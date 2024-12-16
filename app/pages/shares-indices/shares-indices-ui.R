tagList(
  titlePanel("Shares and Indices"),
  layout_sidebar(
    title = "Population by Healthboard",
    sidebar = sidebar(
      radioButtons(
        "stat_in_shares",
        "Chose a statistic:",
        choices = as.character(shares_indices_list$stat)
      ),
      radioButtons(
        "programme_in_shares",
        "Chose a Care Programme:",
        choices = as.character(shares_indices_list$care_programme)
      )
    ),
    
    accordion(
      open = c("Time Series by Component", "Percentage Change by Component"),
      accordion_panel(
        "Time Series by Component",
        navset_card_underline(nav_panel("Plot", highchartOutput("test_plot")), nav_panel("Table"))
      ),
      accordion_panel(
        "Percentage Change by Component",
        navset_card_underline(nav_panel("Plot"), nav_panel("Table"))
      )
    ) #accordion
  ) #sidebar
) #taglist