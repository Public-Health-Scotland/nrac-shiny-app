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

# load all packages ----
library(renv)
lockfile <- renv::lockfile_read()
packages <- names(lockfile$Packages)

invisible(lapply(packages, library, character.only = TRUE))


# load functions ----
source(here("app/functions/core-functions.R"))

# parameters ----

import_data <- ifelse(length(list.files(here("data-pack"))) == 0, TRUE, FALSE)

tidy_data <- ifelse(length((list.files(here("app/data/")))) == 0, TRUE, FALSE)

data_years <- jsonlite::fromJSON(here("lookups/data-urls.json")) %>%
  select(target_year_start, target_year_end)

password_protect <- TRUE

if(isTRUE(password_protect)){
  source(here("app", "password-protect", "create-credentials.R"), local = TRUE)
}

navy <- "#010068"

# filepaths ----
credentials_path <- here::here("app", "password-protect", "credentials.rds")

# create dirs ----

if(!("data" %in% list.dirs(here("app"), full.names = FALSE, recursive = FALSE))){
  dir.create(here("app", "data"))
}

if(!("data-pack" %in% list.dirs(here(), full.names = FALSE, recursive = FALSE))){
  dir.create(here("data-pack"))
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


# load app data ----
data_filepaths <- as.list(list.files(here("app", "data"), full.names = TRUE))

names(data_filepaths) <- str_remove(list.files(here("app", "data")),
                                    "\\.([^.]*)$")

list2env(lapply(data_filepaths, readRDS), envir = .GlobalEnv)

# user input lists ----

# intro page sidebar buttons list
home_list <- c("About", "Use", "Contact", "Accessibility")

#end_time = timestamp()

