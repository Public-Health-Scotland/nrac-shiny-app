# marginal changes data ----
#' Here, marginal change refers to the change in shares caused by each adjustment in the formula.
#' We start with a share 0 in year 1, then adjust the share based on the population, then based on the age-sex demographics, 
#' until we arrive to a final share, which becomes the starting share for year 2.
marginal_change <- reactive({
  
  # SQL query parameters
  tbl_name <- "marginal_changes"
  
  programme_input <- value_2_name(machine2human, "care_programme", 
                                  input$programme_in_mc)
  
  hb_input <- paste0("('", 
                     paste0(input$hb_in_mc, collapse = "' , '"), 
                     "')")
  
  query <- sprintf("SELECT *
                 FROM %s
                 WHERE care_programme = '%s'
                 AND hb_name IN %s",
                 tbl_name, programme_input, hb_input)
  
  # extract data selected by user from the SQLite database
  nracdb <- dbConnect(SQLite(), sqlite_path)
  on.exit(dbDisconnect(nracdb)) # disconnect from db even if query fails
  
  dbGetQuery(nracdb, query) |>
    arrange(hb_name) |> 
    select(-care_programme)

})


# marginal change table ----

# Table of year-on-year marginal change. Here, marginal change refers to the change
# in shares caused by each adjustment in the formula.
output$mc_table <- renderReactable({
  
  reactable(marginal_change(), 
             striped = TRUE,
             defaultPageSize = 14,
             theme = espn(font_size = 16, header_font_size = 18),
             # style = list(fontSize = "1.875rem"),
             highlight = TRUE, # highlight row on hover
             defaultColDef = colDef(
               # style = color_scales(wide_tbl, colors = my_color_pal, span = TRUE, highlight = TRUE), 
               format = colFormat(percent = TRUE, digits = 3)
             ), 
             columns = list(
               hb_name = colDef(name = "Healthboard")
             )
  )
    
    
})

# marginal change_plot ----
output$mc_plot <- renderGirafe({
  
  plot_df <- marginal_change() |> 
    pivot_longer(c(change_0, change_1, change_2, change_3, change_4), 
                 names_to = "change_label", values_to = "share") |> 
    mutate("change_label_human" = case_when(
      change_label == "change_0" ~ "Previous Year Share",
      change_label == "change_1" ~ "Population Change",
      change_label == "change_2" ~ "Age-Sex Change",
      change_label == "change_3" ~ "MLC change",
      change_label == "change_4" ~ "Excess Costs Change",
      TRUE ~ NA
    )) |> 
    mutate(change_label_human = 
             factor(change_label_human, levels = 
                      c("Previous Year Share", 
                        "Population Change", 
                        "Age-Sex Change", 
                        "MLC change", 
                        "Excess Costs Change"), 
                    ordered = TRUE
             )
    )
  
  p <- ggplot2::ggplot(plot_df, aes(change_label_human, share, group = ""))+
    geom_line_interactive()+
    facet_grid(vars(hb_name), vars(year_label), scales = "free_y")+
    theme(axis.text.x = element_text(angle = 90)) +
    xlab("marginal change")
  
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
  girafe(ggobj = p , height_svg = 3, options = list(
    opts_hover(css = select_hover_css),
    opts_tooltip(css = "background-color:lightgray; color:black; border-radius:10px;"), 
    opts_selection(css = select_hover_css, type = "multiple"), 
    opts_selection_inv(css = inv_css), 
    opts_sizing(rescale = TRUE, width = 0.5)
  ))
})

