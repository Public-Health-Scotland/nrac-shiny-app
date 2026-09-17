# static parameters ----
empty_dataset_user_msg <- "There is no population data for indices since the starting index before any adjustments is 1."

empty_dataset_user_msg_short <- "There is no population data for indices."

# shares & indices data ----
shares_indices_data <- reactive({
  
  # SQL query parameters
  stat_input <- value_2_name(machine2human, "stat", input$stat_in_shares)
  
  # tbl_name <- tolower(input$stat_in_shares)
  tbl_name <- glue("{tolower(input$stat_in_shares)}_with_differences")
  
  programme_input <- value_2_name(machine2human, "care_programme", 
                                  input$programme_in_shares)
  
  comp_input <- value_2_name(machine2human, "component", 
                             input$component_in_shares)
  hb_input <- paste0("('", 
                     paste0(input$hb_in_shares, collapse = "' , '"), 
                     "')")
  
  query <- sprintf("SELECT hb_name, target_year_start, %s, diff
                 FROM %s
                 WHERE care_programme = '%s'
                 AND component LIKE '%%%s%%'
                 AND hb_name IN %s",
                   stat_input, tbl_name, programme_input, comp_input, hb_input)

  # extract data selected by user from the SQLite database
  nracdb <- dbConnect(SQLite(), sqlite_path)
  on.exit(dbDisconnect(nracdb)) # disconnect from db even if query fails
  dbGetQuery(nracdb, query) |>
    rename(value = stat_input) |> 
    arrange(hb_name)
})

# shares & indices plot ----
output$si_plot <- renderGirafe({

  my_stat_label <- str_to_title(
    value_2_name(shares_indices_list, "stat", input$stat_in_shares)
  )  
  # if its a share format as percentage
  is_percentage <- switch(
    my_stat_label, 
    "share" = TRUE, 
    "index" = FALSE
  )
  
  if(nrow(shares_indices_data()) > 0){
    
    title_ <- glue("{input$component_in_shares} {input$stat_in_shares} by Healthboard")
    
    plot_shares_indices_lines(shares_indices_data(),
                              stat_label = my_stat_label,
                              percentage = is_percentage, 
                              chart_title = title_)
    
  } else {
    
    plot_empty_with_text(empty_dataset_user_msg)
    
  }
  

})


# difference plot ----
output$si_plot_diff <- renderGirafe({
  
  diff_data <- shares_indices_data()
  
  if(nrow(diff_data) > 0){
    
    min_year <- min(diff_data$target_year_start)
    
  }
  
  #remove the first year since difference is 0
  diff_data <- diff_data |> 
    filter(target_year_start != min_year) |> 
    select(-value) |> 
    rename(value = diff)
  
  my_stat_label <- str_to_title(
    value_2_name(shares_indices_list, "stat", input$stat_in_shares)
    )
  
  # if its a share format as percentage
  is_percentage <- switch(
    my_stat_label, 
    "share" = TRUE, 
    "index" = FALSE
  )

  if(nrow(diff_data) > 0){
    
    title_ <- glue("Difference in {input$stat_in_shares} since {min_year}/{(min_year +1) %% 100} by Healthboard")
    
    plot_shares_indices_lines(diff_data,
                              stat_label = my_stat_label,
                              is_diff = TRUE,
                              percentage = is_percentage, 
                              chart_title = title_)
    
  } else {
    
    plot_empty_with_text(empty_dataset_user_msg)
    
  }
  
  
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
  
  if(nrow(shares_indices_data()) > 0){
    
    build_pretty_tbl(shares_indices_data(), title_, "value", is_percentage)
    
  } else {
    
    build_empty_tbl(shares_indices_data(), empty_dataset_user_msg_short)
    
  }
  
})

# difference table ----
output$si_table_diff <- renderReactable({
  
  min_year <- min(shares_indices_data()$target_year_start)
  
  title_ <- glue("Difference in {input$stat_in_shares} since {min_year}/{(min_year +1) %% 100} by Healthboard")
  
  # if its a share format as percentage
  is_percentage <- switch(
    value_2_name(shares_indices_list, "stat", input$stat_in_shares), 
    "share" = TRUE, 
    "index" = FALSE
  )
  
  if(nrow(shares_indices_data()) > 0){
    
    build_pretty_tbl(shares_indices_data(), title_, "diff", is_percentage)
    
  } else {
    
    build_empty_tbl(shares_indices_data(), empty_dataset_user_msg_short)
    
  }
  
  
  
})
