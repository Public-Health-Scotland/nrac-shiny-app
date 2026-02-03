# shares and indices data ----
shares_indices_data <- reactive({
  
  # SQL query parameters
  stat_input <- value_2_name(machine2human, "stat", input$stat_in_shares)
  
  # tbl_name <- tolower(input$stat_in_shares)
  tbl_name <- glue("{tolower(input$stat_in_shares)}_with_differences")
  
  programme_input <- value_2_name(machine2human, "care_programme", 
                                  input$programme_in_shares)
  
  comp_input <- value_2_name(machine2human, "component", 
                             input$component_in_shares)
  
  query <- sprintf("SELECT hb_name, target_year_start, %s, diff
                 FROM %s
                 WHERE care_programme = '%s'
                 AND component LIKE '%%%s%%'",
                   stat_input, tbl_name, programme_input, comp_input)
  
  # extract data selected by user from the SQLite database
  nracdb <- dbConnect(SQLite(), sqlite_path)
  on.exit(dbDisconnect(nracdb)) # disconnect from db even if query fails
  dbGetQuery(nracdb, query) |>
    rename(value = stat_input)

})

# shares & indices plot ----
output$si_plot <- renderGirafe({
  
  # if its a share format as percentage
  is_percentage <- switch(
    value_2_name(shares_indices_list, "stat", input$stat_in_shares), 
    "share" = TRUE, 
    "index" = FALSE
  )
  
  title_ <- glue("{input$component_in_shares} {input$stat_in_shares} by Healthboard")
  
  plot_shares_indices_lines(shares_indices_data(),
                            percentage = is_percentage, 
                            chart_title = title_)
})


# shares and indices difference to base year
output$si_plot_diff <- renderGirafe({
  
  diff_data <- shares_indices_data() |> 
    select(-value) |> 
    rename(value = diff)
  
  min_year <- min(diff_data$target_year_start)
  
  # if its a share format as percentage
  is_percentage <- switch(
    value_2_name(shares_indices_list, "stat", input$stat_in_shares), 
    "share" = TRUE, 
    "index" = FALSE
  )
  
  title_ <- glue("Difference in {input$stat_in_shares} since {min_year} by Healthboard")
  
  plot_shares_indices_lines(diff_data,
                            percentage = is_percentage, 
                            chart_title = title_)
  
})

# shares & indices table ----
output$si_table <- renderReactable({
  
  title_ <- glue("{input$stat_in_shares} by Healthboard")
  
  # if its a share format as percentage
  is_percentage <- switch(
    value_2_name(shares_indices_list, "stat", input$stat_in_shares), 
    "share" = TRUE, 
    "index" = FALSE
  )

  build_shares_indices_tbl(shares_indices_data(), title_, "value", is_percentage)
  
  
})

# difference in shares and indices table ----
output$si_table_diff <- renderReactable({
  
  min_year <- min(shares_indices_data()$target_year_start)
  
  title_ <- glue("Difference in {input$stat_in_shares} since {min_year} by Healthboard")
  
  # if its a share format as percentage
  is_percentage <- switch(
    value_2_name(shares_indices_list, "stat", input$stat_in_shares), 
    "share" = TRUE, 
    "index" = FALSE
  )
  
  build_shares_indices_tbl(shares_indices_data(), title_, "diff", is_percentage)

  
})
