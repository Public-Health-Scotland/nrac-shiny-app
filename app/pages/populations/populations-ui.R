tagList(titlePanel("Populations"),
  layout_sidebar(
  title = "Population by Healthboard", 
  sidebar = selectInput("hb_in_pop", "Chose a Healthboard:", choices = hb_list),
  navset_tab(
  nav_panel("Rebased Projected Populations", 
            navset_card_underline(
              nav_panel("Plot"),
              nav_panel("Table")
            )
          ),
  nav_panel("Population History", 
            navset_card_underline(
              nav_panel("Plot"),
              nav_panel("Table")
            )
          ), 
  nav_panel("Healthboard Comparison", 
            navset_card_underline(
              nav_panel("Plot"),
              nav_panel("Table")
          )
        )
      )
          
    )
  ) #taglist