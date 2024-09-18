#' clean-app-data.R
#' Health Finance & Analytics
#' Code written September 2024
#' R version 4.1.2 (2021-11-01)
#'
#' Author:Maiana Sanjuan
#' Runtime:
#' Memory:10GB
#' CPUs:1
#'
# import data from Public Health Scotland ----

start_vars <- ls()

fin_year_suffix <- "-2025-26"

dest_folder <- "data-pack"

# import data from the NRAC publication for 25/26
data_pack_url <- "https://www.publichealthscotland.scot/media/28612/resource-allocations-2025-26.zip"

zip_filepath <- here(dest_folder, 
                     glue("resource-allocations{fin_year_suffix}.zip"))

download.file(data_pack_url, zip_filepath)
              
unzip(zip_filepath, exdir = here::here(dest_folder))


# clean environment ----
rm(list = setdiff(ls(), start_vars))
