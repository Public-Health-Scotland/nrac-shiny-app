
build_empty_tbl <- function(my_data, my_msg){
  reactable(my_data, language = reactableLang(noData = my_msg))
}


build_pretty_tbl <- function(my_data, my_title, column_name, is_percentage_val){
  
  min_year <- min(my_data[,"target_year_start"])
  # max_year <- max(my_data[,"target_year_start"])
  
  # if creating a percentage difference table remove the first year since difference is 0
  if(column_name == "diff"){
    my_data <- my_data[my_data$target_year_start != min_year,]
  }
  
  
  wide_tbl <- my_data |> 
    select(all_of(c("hb_name", "target_year_start", column_name))) |> 
    mutate(fin_year_lbl = glue("{target_year_start}/{(target_year_start + 1) %% 100}")) |> 
    arrange(target_year_start) |> 
    select(-target_year_start) |> 
    pivot_wider(names_from = fin_year_lbl, values_from = column_name)

  digits2round <- ifelse(is_percentage_val, 2, 3)
  
  my_reactbl <- reactable(
    # data 
    wide_tbl,
    striped = TRUE,
    defaultPageSize = 14,
    theme = espn(font_size = 16, header_font_size = 18),
    # style = list(fontSize = "1.875rem"),
    highlight = TRUE, # highlight row on hover
    defaultColDef = colDef(
      # style = color_scales(wide_tbl, colors = my_color_pal, span = TRUE, highlight = TRUE), 
      format = colFormat(percent = is_percentage_val, digits = digits2round)
    ), 
    columns = list(
      hb_name = colDef(name = "Health Board")
    )
  ) |> 
    reactablefmtr::add_title(my_title)
  
  return(my_reactbl)
}
