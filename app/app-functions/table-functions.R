
build_empty_tbl <- function(my_data, my_msg){
  reactable(my_data, language = reactableLang(noData = my_msg))
}


build_shares_indices_tbl <- function(data, my_title, column_name, is_percentage_val){
  
  min_year <- min(data[,"target_year_start"])
  max_year <- max(data[,"target_year_start"])
  
  wide_tbl <- data |> 
    select(all_of(c("hb_name", "target_year_start", column_name))) |> 
    pivot_wider(names_from = target_year_start, values_from = column_name) |> 
    select(all_of(c("hb_name", as.character(seq(min_year, max_year)))))
  
  # my_color_pal <- c("#9B4393", "white", "#83BB26")
  
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
      hb_name = colDef(name = "Healthboard")
    )
  ) |> 
    reactablefmtr::add_title(my_title)
  
  return(my_reactbl)
}
