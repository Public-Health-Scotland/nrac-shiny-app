#' TODO: turn the plot into a function that takes the NRAC adjustment
#' as an input (age sex, multiple life circumstances, excess costs) with pretty
#' formatting and human readable labels.


name_ <- reactive({
  value_2_name(shares_indices_list, "stat", input$stat_in_shares)
})

# observe({
#   cat("input$stat_in_shares:", input$stat_in_shares, "\n")
# })

shares_indices_data <- reactive({
  # create a local value for name that is static to avoid calling the reactive
  # several times
  local_name <- name_()
  all_index_shares %>%
    select(hb_name,
           care_programme,
           target_year_start,
           ends_with(local_name)) %>%
    filter(
      care_programme == value_2_name(
        shares_indices_list,
        "care_programme",
        input$programme_in_shares
      )
    ) %>%
    pivot_longer(cols = ends_with(local_name)) %>%
    arrange(target_year_start) 

})


# charts by component
output$si_as_plot <- renderGirafe({
  #nrac formula component
  component_ <- "as"
  
  title_component <- machine2human$components[[component_]]
  
  # if its a share format as percentage
  is_percentage <- switch(name_(), "share" = TRUE, "index" = FALSE)

  title_ <- glue("Line chart of the {title_component} {input$stat_in_shares} by Healthboard")
  
  plot_shares_indices_lines(shares_indices_data(),
                            component = component_,
                            percentage = is_percentage, 
                            chart_title = title_)
  

  
})

output$si_mlc_plot <- renderGirafe({
  
  #nrac formula component
  component_ <- "mlc"
  
  title_component <- machine2human$components[[component_]]
  
  # if its a share format as percentage
  is_percentage <- switch(name_(), "share" = TRUE, "index" = FALSE)

  title_ <- glue("Line chart of the {title_component} {input$stat_in_shares} by Healthboard")
  
  plot_shares_indices_lines(shares_indices_data(),
                            component = component_,
                            percentage = is_percentage, 
                            chart_title = title_)
  
})

output$si_xs_plot <- renderGirafe({
  
  #nrac formula component
  component_ <- "xs"
  
  title_component <- machine2human$components[[component_]]
  
  # if its a share format as percentage
  is_percentage <- switch(name_(), "share" = TRUE, "index" = FALSE)

  title_ <- glue("Line chart of the {title_component} {input$stat_in_shares} by Healthboard")
  
  plot_shares_indices_lines(shares_indices_data(),
                            component = component_,
                            percentage = is_percentage, 
                            chart_title = title_)
  
})

