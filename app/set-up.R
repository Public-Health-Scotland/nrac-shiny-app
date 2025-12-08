#' set-up.R
#' Health Finance & Analytics
#' Code written September 2024
#' R version 4.1.2 (2021-11-01)
#'
#' Author:Maiana Sanjuan
#' Runtime:
#' Memory:16GB
#' CPUs:1

# start_time = timestamp()

# load all packages ----

# Public Health Scotland package are not on CRAN, install
if (!requireNamespace("phsmethods", quietly = TRUE)) {
  remotes::install_github("Public-Health-Scotland/phsmethods")
}

if (!requireNamespace("phsstyles", quietly = TRUE)) {
  remotes::install_github("Public-Health-Scotland/phsstyles")
}

library(janitor)
library(here)
library(glue)
library(tidyr)
library(dplyr)
library(magrittr)
library(phsmethods)
library(stringr)
library(jsonlite)
library(RSQLite)

library(shiny)
library(shinyWidgets)
library(shinycssloaders)
library(rsconnect)
library(shinymanager)
library(bslib)

library(highcharter)
library(ggplot2)
library(ggtext)
library(ggiraph)
library(showtext)
library(systemfonts)
library(scales)
library(patchwork)


# fonts
# font_dir <- here("app", "www", "fonts")

# Register the Karla font, use systemfonts for ggiraph package

if (!"Karla" %in% system_fonts()$family) {
  systemfonts::register_font(
    name = "Karla",
    plain = "www/fonts/karla/Karla-Regular.ttf",
    bold = "www/fonts/karla/Karla-Bold.ttf",
    italic = "www/fonts/karla/Karla-Italic.ttf"
  )
}

font_add(
  family = "Karla",
  regular = "www/fonts/karla/Karla-Regular.ttf",
  bold = "www/fonts/karla/Karla-Bold.ttf",
  italic = "www/fonts/karla/Karla-Italic.ttf"
)

font_dir <- "www/fonts/karla/"
cat("Regular font path:", file.exists(file.path(font_dir, "Karla-Regular.ttf")), "\n")


# render fonts
showtext_auto()


# load functions ----

for (file_ in list.files("functions/", full.names = TRUE)) {
  source(file_)
}



# filepaths ----
credentials_path <- "password-protect/credentials.rds"

sqlite_path <- "data/nrac-db.sqlite"

# parameters ----

password_protect <- FALSE

if (isTRUE(password_protect)) {
  source("password-protect/create-credentials.R", local = TRUE)
}

navy <- "#010068"


# import data ----
nracdb <- dbConnect(SQLite(), sqlite_path)

all_index_shares <- dbGetQuery(nracdb, "SELECT * FROM index_shares")

dbDisconnect(nracdb)
# data_filepaths <- as.list(list.files("data", full.names = TRUE))
#
# names(data_filepaths) <- str_remove(list.files("data"), "\\.([^.]*)$")
#
# list2env(lapply(data_filepaths, readRDS), envir = .GlobalEnv)

# user input lists ----
# list of labels used in data and human-readable equivalent
machine2human <- list(
  components = list(pop = "Population", 
                    as = "Age-Sex",
                    mlc = "Multiple Life Circumstances", 
                    xs = "Excess Costs")
)

# intro page
intro_list <- list(side_bar = c("About", "Use", "Contact", "Accessibility"))

# populations
pop_list <- list(hb_names = bind_rows(fromJSON("lookups/hb_cypher_to_name.json")) %>% 
  pull(hb_name))

# shares and indices
# user inputs are mapped to categorical wariables in the data
shares_indices_list <- list(
  stat = list(share = "Shares", index = "Indices"),
  care_programme = list(all = "All", 
                        hchs = "Hospital and Community Health Services",
                        gpp = "General Practice and Prescribing")
)

# end_time = timestamp()
