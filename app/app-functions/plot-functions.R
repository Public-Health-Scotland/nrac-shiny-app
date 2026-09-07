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
  
  label_fin_year <- function(x){
    glue("{x}/{x+1-2000}")
  }
  
  p <- ggplot(data_, aes(
    x = target_year_start, 
    y = value, 
    color = hb_name,  # Equivalent to group aesthetic
    group = hb_name, 
    data_id = hb_name, 
    shape = hb_name
  )) +
    scale_x_continuous(labels = label_fin_year)
  
  # add an intercept line for 1 if plotting indices
  if(!isTRUE(percentage)){
    p <- p + 
      geom_hline_interactive(yintercept=1, linetype="dashed")
  }
  
  p <- p +
    geom_line_interactive(aes(tooltip = paste0("Healthboard: ", hb_name)), linewidth = 0.3) +
    geom_point_interactive(
      aes(
        tooltip = paste0("Healthboard: ", hb_name, "\nYear: ",
                         glue("{target_year_start}/{target_year_start+1}"),
                         "\nValue: ",
                         format_val(value, percent_fmt = percentage, round_val))
      ),
      size = 1
    ) +
    scale_color_manual_interactive(values = hb_colors)+
    scale_shape_manual_interactive(values = c(1:14))+
    labs(title = chart_title, x = "Year Start", y = "Value") +
    line_chart_theme() +
    guides(color = guide_legend(nrow = 14)) + # Wrap legend
    theme(legend.position = "right", 
          legend.text = element_text(size = 6),
          legend.key.size = unit(0.5, "cm"),
          plot.title = element_text(size = 8), 
          axis.title = element_text(size = 6), 
          axis.text = element_text(size = 6)
          )
  
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
  girafe(ggobj = p, height_svg = 3 , options = list(
    opts_hover(css = select_hover_css),
    opts_tooltip(css = "background-color:lightgray; color:black; border-radius:10px;"), 
    opts_selection(css = select_hover_css, type = "multiple"), 
    opts_selection_inv(css = inv_css), 
    opts_sizing(rescale = TRUE, width = 0.5)
  ))
}
