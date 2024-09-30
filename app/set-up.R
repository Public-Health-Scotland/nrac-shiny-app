#' set-up.R
#' Health Finance & Analytics
#' Code written September 2024
#' R version 4.1.2 (2021-11-01)
#'
#' Author:Maiana Sanjuan
#' Runtime:
#' Memory:16GB
#' CPUs:1

#start_time = timestamp()
# load packages ----
library(here)
library(glue)
library(openxlsx)
library(magrittr)
library(janitor)
library(shiny)


# load functions ----
source(here("app/functions/core-functions.R"))

# parameters ----

import_data <- ifelse(length(list.files(here("data-pack"))) == 0, TRUE, FALSE)

tidy_data <- ifelse(length((list.files(here("app/data/")))) == 0, TRUE, FALSE)

data_years <- jsonlite::fromJSON("lookups/data-urls.json") %>%
  select(target_year_start, target_year_end)

# create dirs ----
if(!("data" %in% list.dirs(here("app"), full.names = FALSE))){
  dir.create(here("app", "data"))
}

# import and clean data ----

# data takes approx 20 min to download
if(isTRUE(import_data)){
   
  for(i in 1:nrow(data_years)){
    
    data_years_row <- data_years %>% slice(i)
    
    source(here("import-app-data.R"), 
           local = list2env(list(start_year = data_years_row$target_year_start,
                            end_year = data_years_row$target_year_end)))
    
  }
}

if(isTRUE(tidy_data)){
  source(here("tidy-app-data.R"), local = TRUE)
}
#end_time = timestamp()
