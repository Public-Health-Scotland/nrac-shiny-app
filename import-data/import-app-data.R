#' import-app-data.R
#' Health Finance & Analytics
#' Code written September 2024
#' R version 4.1.2 (2021-11-01)
#'
#' Author:Maiana Sanjuan
#' Runtime:
#' Memory:10GB
#' CPUs:1
#' 
#' imports several years of data from the NRAC PHS publications and saves all 
#' the outputs in `data-pack/`
#'
# import data from Public Health Scotland ----

start_vars <- ls()

# higher timeout needed to download large data 
options(timeout = max(600, getOption("timeout")))

# temp parameters
# start_year <- 22
# end_year <- 23

fin_year_suffix <- glue("-20{start_year}-{end_year}")

dest_folder <- "data-pack"

# import data from the NRAC publication for selected financial year
data_url <- jsonlite::fromJSON(here("app/lookups/data-urls.json")) %>% 
  filter(target_year_start == start_year, target_year_end == end_year) %>% 
  pull(data_url)

file_ext <- str_extract(data_url,"\\.([^\\.]*)$")

if(file_ext == ".zip"){
  filepath <- here(dest_folder, glue(
    "resource-allocations-data-pack{fin_year_suffix}{file_ext}"))
  
  download.file(data_url, filepath)
  
  unzip(filepath, exdir = here::here(dest_folder))
} else {
  filepath <- here(dest_folder, glue(
    "resource-allocations-datazone-hscp{fin_year_suffix}{file_ext}"))
  
  download.file(data_url, filepath)
}              


# clean environment ----
rm(list = setdiff(ls(), start_vars))
