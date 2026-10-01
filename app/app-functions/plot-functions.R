# these plot functions call themes from the `app/function/ggplot-themes.R`

#' plot_empty
#' 
#' use this to display a message to user when they select an empty dataset.
#' 
#' @param my_text (chr) message to display
#'
#' @returns
#' @export
#'
#' @examples
plot_empty <- function(my_text){
  no_data_plot <- ggplot() +
    annotate("text", x = 10,  y = 10,
             size = 4,
             label = str_wrap(my_text)
    )+
    theme_void()
  
  girafe(ggobj = no_data_plot)
}

#' plot_interactive
#' Convert ggplot to an interactive Girafe object
#' @param x ggplot object to convert
#'
#' @returns
#' @export
#'
#' @examples
plot_interactive <- function(x){
  
  girafe(ggobj = x, height_svg = 3 , options = list(
    opts_hover(css = select_hover_css),
    opts_tooltip(css = "background-color:lightgray; color:black; border-radius:10px;"), 
    opts_selection(css = select_hover_css, type = "multiple"), 
    opts_selection_inv(css = inv_css), 
    opts_sizing(rescale = TRUE, width = 0.5), 
    opts_toolbar(hidden = c('lasso_select', 'lasso_deselect'), fixed = TRUE)
  ))
  
}


#' plot_shares_indices_lines
#'
#' @param data_ 
#' @param stat_label 
#' @param is_diff 
#' @param percentage 
#' @param chart_title 
#'
#' @returns
#' @export
#'
#' @examples
plot_shares_indices_lines <- function(data_, stat_label, is_diff = FALSE, percentage, chart_title){
  
  if(isTRUE(percentage)){
    round_val <- 3
  } else {
    round_val <- 3
  }
  
  # plot parameters
  # axis titles
  x_title <- "Year"
  y_title <- stat_label
  
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
  if(isFALSE(percentage) & isFALSE(is_diff)){
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
    labs(title = chart_title, x = x_title, y = y_title) +
    line_chart_theme() +
    guides(color = guide_legend(nrow = 14)) # wrap legend
  
  if(isTRUE(percentage)){
    p <- p + 
      scale_y_continuous(labels = scales::percent)
  }
  
  # convert to girafe interactive plot with some custom settings
  plot_interactive(p)
  
}

plot_marginal_change_lines <- function(df, input_list){
  
  ggplot2::ggplot(df, aes(change_label_human, share, group = ""))+
    geom_line_interactive()+
    facet_grid_interactive(vars(hb_name), 
                           vars(year_label), 
                           scales = "free_y",
                           axis.labels = "all_x")+
    # global custome line chart theme
    line_chart_theme()+
    # angle x legend to fit
    theme(
      axis.text.x = element_text(angle = 90), 
      # Remove facet grid label on Y axis
      strip.text.y = element_blank()
    ) +
    labs(title = input_list[["plot_title"]],
         subtitle = input_list[["plot_subtitle"]]) +
    xlab(input_list[["xlab"]])+
    ylab(input_list[["ylab"]]) +
    # tooltips
    geom_point_interactive(aes(
      tooltip = glue("Share: {round(share, 4)}")
    ), 
    size = 0.5
    )
}
