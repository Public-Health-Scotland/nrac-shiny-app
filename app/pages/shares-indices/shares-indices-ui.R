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
      #open = c("Time Series by Component", "Percentage Change by Component"),
      accordion_panel(
        "NRAC Adjustment",
        navset_card_underline(
          nav_panel(machine2human$components[["as"]],
                    girafeOutput("si_as_plot")),
          nav_panel(machine2human$components[["mlc"]],
                    girafeOutput("si_mlc_plot")),
          nav_panel(machine2human$components[["xs"]], 
                    girafeOutput("si_xs_plot"))
        )
      ),
    ),
    accordion_panel(
      "Percentage Change by Component",
      navset_card_underline(nav_panel("Plot"), nav_panel("Table"))
    )
  ) # accordion
) # sidebar
# ) #taglist
