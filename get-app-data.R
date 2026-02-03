#' get-app-data.R
#' Maiana Sanjuan
#' Import and tidy data for the app. Saves the data in the `app/data` folder.

# load all packages ----
library(here)
library(tidyverse)
library(glue)
library(magrittr)
library(janitor)
library(jsonlite)
library(DBI)
library(RSQLite)

# parameters ----
data_years <- jsonlite::fromJSON(txt = here("app/lookups/data-urls.json")) %>%
  select(target_year_start, target_year_end)

# create dirs ----

if (!("data" %in% list.dirs(here("app"), full.names = FALSE, recursive = FALSE))) {
  dir.create(here("app", "data"))
}

if (!("data-pack" %in% list.dirs(here(), full.names = FALSE, recursive = FALSE))) {
  dir.create(here("data-pack"))
}

# import data ----
for (i in 1:nrow(data_years)) {
  data_years_row <- data_years %>% slice(i)
  
  source(here("import-data", "import-app-data.R"), local = list2env(
    list(
      start_year = data_years_row$target_year_start,
      end_year = data_years_row$target_year_end
    )
  ))
  
}

# tidy data and save it in a sqlite database ----
source(here("import-data", "tidy-app-data.R"), local = TRUE)

# clean environment ----
rm(list = ls())
