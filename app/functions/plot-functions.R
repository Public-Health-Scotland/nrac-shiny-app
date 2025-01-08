# these plot functions call themes from the `app/function/ggplot-themes.R`

plot_shares_indices_lines <- function(data_, component, percentage, chart_title){
  
  data_ <- data_ %>% 
    filter(str_detect(name, glue("^{component}")))
  
  p <- ggplot(data_, aes(
    x = target_year_start, 
    y = value, 
    color = hb_name,  # Equivalent to group aesthetic
    group = hb_name
  )) +
    #scale_y_continuous(labels = scales::percent) +
    geom_line_interactive(size = 0.3) +
    geom_point_interactive(
      aes(
        tooltip = paste0("Healthboard: ", hb_name, "\nYear: ", 
                         target_year_start, "\nValue: ", 
                         format_val(value, percent_fmt = percentage, 2)), # Tooltip for points
        data_id = paste0(hb_name, "-", target_year_start)
      ),
      size = 1
    ) +
    labs(title = chart_title, x = "Year Start", y = "Value") +
    line_chart_theme() +
    guides(color = guide_legend(nrow = 3)) + # Wrap legend
    theme(legend.position = "bottom")
  
  if(isTRUE(percentage)){
    p <- p + 
      scale_y_continuous(labels = scales::percent)
    }
  
  # Convert ggplot to interactive Girafe object
  girafe(ggobj = p, options = list(
    opts_hover(css = "stroke-width:2px;"),
    opts_tooltip(css = "background-color:lightgray; color:black; border-radius:5px;")
  ))
}
