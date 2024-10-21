#' get-app-data.R
#' Maiana Sanjuan
#' Import and tidy data for the app. Saves the data in the `app/data` folder.

envir_objs <- ls()

# load all packages ----
not_on_cran <- "phsmethods"

library(renv)
renv::restore(exclude = not_on_cran)
lockfile <- renv::lockfile_read()
packages <- names(lockfile$Packages)[names(lockfile$Packages)!=not_on_cran]

invisible(lapply(packages, library, character.only = TRUE))

# phsmethods package is not on CRAN, install and load separately
if (! requireNamespace(not_on_cran, quietly = TRUE)) {
  remotes::install_github("Public-Health-Scotland/phsmethods")
}
library(phsmethods)

# parameters ----
data_years <- jsonlite::fromJSON(here("lookups/data-urls.json")) %>%
  select(target_year_start, target_year_end)

# create dirs ----

if(!("data" %in% list.dirs(here("app"), full.names = FALSE, recursive = FALSE))){
  dir.create(here("app", "data"))
}

if(!("data-pack" %in% list.dirs(here(), full.names = FALSE, recursive = FALSE))){
  dir.create(here("data-pack"))
}

# import and clean data ----

for(i in 1:nrow(data_years)){
  
  data_years_row <- data_years %>% slice(i)
  
  source(here("import-data", "import-app-data.R"), 
         local = list2env(list(start_year = data_years_row$target_year_start,
                               end_year = data_years_row$target_year_end)))
  
}


source(here("import-data", "tidy-app-data.R"), local = TRUE)

# clean environment ----
rm(envir_objs, ls())
