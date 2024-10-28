tagList(titlePanel("Populations"),
        layout_sidebar("Population by Healthboard", 
                       selectInput("hb_in_pop", "Chose a Healthboard:", choices = hb_list)),
        layout_sidebar("Healthboard Comparison", "plot2"),
        layout_sidebar("Population History", "plot3")
        ) #taglist