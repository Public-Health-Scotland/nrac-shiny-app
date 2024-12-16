#' TODO: turn the plot into a function that takes the NRAC adjustment
#' as an input (age sex, multiple life circumstances, excess costs) with pretty
#' formatting and human readable labels.


name_ <- reactive({
  value_2_name(shares_indices_list, "stat", input$stat_in_shares)
})

shares_indices_data <- reactive({
  all_index_shares %>%
    select(hb_name,
           care_programme,
           target_year_start,
           ends_with(name_())) %>%
    filter(
      care_programme == value_2_name(
        shares_indices_list,
        "care_programme",
        input$programme_in_shares
      )
    ) %>%
    pivot_longer(cols = ends_with(name_())) %>%
    arrange(target_year_start)
  
})


# Plot of Shares/Indices for the Age-Sex NRAC formula adjustment
output$test_plot <- renderHighchart(shares_indices_data() %>%
                                      filter(name == glue("as_{name_()}")) %>%
                                      hchart(., type = "line", hcaes(
                                        x = target_year_start, y = value, group = hb_name
                                      )))
