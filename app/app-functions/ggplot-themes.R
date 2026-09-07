# custom ggplot themes called across the app

line_chart_theme <- function(base_text_size = 10) {
  theme_minimal(base_size = base_text_size) +
    theme(text = element_text(family = "Karla"),
          axis.title = element_blank(),
          plot.title = element_text(family = "Karla", 
                                    face = "bold",
                                    colour = "#10090E",
                                    size = rel(1.3)),
          plot.subtitle = ggtext::element_textbox_simple(
            size = ggplot2::rel(1.2),
            lineheight = 1.3,
            margin = ggplot2::margin(10, 0, 20, 0,
                                     unit = "points")),
          panel.grid = element_line(colour = "#F1F1F2"),
          panel.grid.major.x = element_blank(),
          plot.background = element_rect(colour = "#FFFFFF",
                                         fill = "#FFFFFF"),
          # plot.margin = ggplot2::margin(10, 15, 10, 15,
          #                               unit = "points"),
          #legend.position = "bottom", 
          #legend.box = "horizontal",
          # legend.text = element_text(size = rel(0.8)),
          # legend.key.size = unit(0.3, "cm"),
          legend.title = element_blank() # remove legend title
    )
}