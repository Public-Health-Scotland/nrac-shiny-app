# custom ggplot themes called across the app

line_chart_theme <- function(base_text_size = 10) {
  theme_minimal(base_size = base_text_size) +
  theme(
    # text attributes
    text = element_text(family = "Karla"),
    
    # panel and background colors
    panel.grid = element_line(colour = "#F1F1F2"),
    panel.grid.major.x = element_blank(),
    plot.background = element_rect(colour = "#FFFFFF",
                                 fill = "#FFFFFF"),
    
    # legend attributes and title
    legend.position = "right", 
    legend.text = element_text(size = 6),
    legend.key.size = unit(0.5, "cm"),
    legend.title = element_blank(), # remove legend title
    
    # plot and axis titles
    plot.title = element_text(size = 8),
    plot.subtitle = element_text(size = 7),
    axis.title = element_text(size = 6), 
    axis.text = element_text(size = 6),
    # facet_grid title
    strip.text.x = element_text(size = 6)
)
}