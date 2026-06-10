# these plot functions call themes from the `app/function/ggplot-themes.R`

# use when user selects an empty dataset
plot_empty_with_text <- function(my_text){
  no_data_plot <- ggplot() +
    annotate("text", x = 10,  y = 10,
             size = 4,
             label = str_wrap(my_text)
    )+
    theme_void()
  
  girafe(ggobj = no_data_plot)
}


plot_shares_indices_lines <- function(data_, percentage, chart_title){
  
  if(isTRUE(percentage)){
    round_val <- 3
  } else {
    round_val <- 3
  }
  
  p <- ggplot(data_, aes(
    x = target_year_start, 
    y = value, 
    color = hb_name,  # Equivalent to group aesthetic
    group = hb_name, 
    data_id = hb_name, 
    shape = hb_name
  )) +
    #scale_y_continuous(labels = scales::percent) +
    geom_line_interactive(aes(tooltip = paste0("Healthboard: ", hb_name)), linewidth = 0.3) +
    geom_point_interactive(
      aes(
        tooltip = paste0("Healthboard: ", hb_name, "\nYear: ",
                         target_year_start, "\nValue: ",
                         format_val(value, percent_fmt = percentage, round_val))
      ),
      size = 1
    ) +
    scale_color_manual_interactive(values = hb_colors)+
    scale_shape_manual_interactive(values = c(1:14))+
    labs(title = chart_title, x = "Year Start", y = "Value") +
    line_chart_theme() +
    guides(color = guide_legend(nrow = 14)) + # Wrap legend
    theme(legend.position = "right")
  
  if(isTRUE(percentage)){
    p <- p + 
      scale_y_continuous(labels = scales::percent)
  }
  
  # css options for hovering over/selecting a line or point
  select_hover_css <- "
  filter: brightness(75%);
  cursor: pointer;
  transition: all 0.5s ease-out;
  filter: brightness(1.15);
  stroke-width: 1.3px 
"
  # css for stuff that isnt selected, stuff that isnt selected is greyed out
  inv_css <- "opacity:0.3; transition: all 0.2s ease-out;"
  
  # Convert ggplot to interactive Girafe object
  girafe(ggobj = p, options = list(
    opts_hover(css = select_hover_css),
    opts_tooltip(css = "background-color:lightgray; color:black; border-radius:10px;"), 
    opts_selection(css = select_hover_css, type = "multiple"), 
    opts_selection_inv(css = inv_css)
  ))
}
