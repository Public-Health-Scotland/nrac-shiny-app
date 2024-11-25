#' TODO: turn the plot into a function that takes the NRAC adjustment
#' as an input (age sex, multiple life circumstances, excess costs) with pretty
#' formatting and human readable labels.


name_ <- reactive({
  value_2_name(shares_indices_list, "stat", input$stat_in_shares)
})


shares_indices_data <- reactive({
  
  # create a local value for name that is static to avoid calling the reactive
  # several times
  #local_name <- value_2_name(shares_indices_list, "stat", input$stat_in_shares)
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
    arrange(target_year_start) %>% 
    filter(name == glue("as_{local_name}"))
  # browser()
  
})


# Plot of Shares/Indices for the Age-Sex NRAC formula adjustment
# output$test_plot <- renderHighchart(shares_indices_data() %>%
#                                       hchart(., type = "line", hcaes(
#                                         x = target_year_start, y = value, 
#                                         group = hb_name
#                                       )))


# ggplot version
output$test_plot <- renderGirafe({
  
  # if its a share format as percentage
  is_percentage <- switch(name_(), "share" = TRUE, "index" = FALSE)
  
  # stat_input <- input$stat_in_shares
  
  title_ <- glue("Line chart of the Age-Sex {input$stat_in_shares} by Healthboard")
  
  plot_shares_indices_lines(shares_indices_data(), 
                            percentage = is_percentage, 
                            chart_title = title_)
  
})


