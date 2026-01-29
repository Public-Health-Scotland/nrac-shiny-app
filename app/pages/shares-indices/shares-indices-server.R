shares_indices_data <- reactive({
  
  # SQL query parameters
  stat_input <- value_2_name(machine2human, "stat", input$stat_in_shares)
  
  tbl_name <- tolower(input$stat_in_shares)
  
  programme_input <- value_2_name(machine2human, "care_programme", 
                                  input$programme_in_shares)
  
  comp_input <- value_2_name(machine2human, "component", 
                             input$component_in_shares)
  
  query <- sprintf("SELECT hb_name, target_year_start, %s
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

output$si_table <- renderReactable({
  
  min_year <- min(shares_indices_data()$target_year_start)
  max_year <- max(shares_indices_data()$target_year_start)
  
  wide_tbl <- shares_indices_data() |> 
    pivot_wider(names_from = target_year_start, values_from = value) |> 
    select(all_of(c("hb_name", as.character(seq(min_year, max_year)))))
  
  # if its a share format as percentage
  is_percentage <- switch(
    value_2_name(shares_indices_list, "stat", input$stat_in_shares), 
    "share" = TRUE, 
    "index" = FALSE
  )
  
  my_color_pal <- c("#9B4393", "white", "#83BB26")
  
  my_reactbl <- reactable(
    # data 
    wide_tbl, 
    defaultPageSize = 14,
    theme = espn(),
    defaultColDef = colDef(
      style = color_scales(wide_tbl, colors = my_color_pal, span = TRUE), 
      format = colFormat(percent = is_percentage, digits = 3)
    ), 
    columns = list(
      hb_name = colDef(name = "Healthboard")
    )
  ) |> 
    reactablefmtr::add_title(
      glue("{input$component_in_shares} {input$stat_in_shares} by Healthboard")
    )
  
})

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
