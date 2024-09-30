#' tidy-app-data.R
#' Health Finance & Analytics
#' Code written September 2024
#' R version 4.1.2 (2021-11-01)
#'
#' Author:Maiana Sanjuan
#' Runtime:
#' Memory:10GB
#' CPUs:1
#'
# tidy data for the app ----

start_vars <- ls()
# read in the HB data for each financial year

data_files <- list.files(here("data-pack"))
datazone_hscp_files <- data_files[str_detect(str_to_lower(data_files), 
                                  "resource-allocations-datazone-")]

hb_sheet_name <- "Data_HB"
hb_data_row_index <- list(hchs = c(1:15), gpp = c(30:44))

# there are two tables one for gpp one for hchs
# hchs dim A1:A15 x AA1:AA15
# gpp dim A30:A44 x I30:I44
# 

read_excel_data <- function(file_name, sheet_name, row_index, programme){
  
    openxlsx::read.xlsx(here("data-pack", file_name), sheet = sheet_name, 
                        rows = row_index[[programme]]) %>% 
    mutate(target_year_end = 
             as.numeric(str_extract(file_name, "(\\d{2})(?=\\D*$)"))) %>% 
    mutate(target_year_start = target_year_end - 1)

}

hchs_df <- tibble()
gpp_df <- tibble()

for(f in datazone_hscp_files){
  hchs_df %<>% bind_rows(
    read_excel_data(f, hb_sheet_name, hb_data_row_index, "hchs")
  )
  
  gpp_df %<>% bind_rows(
    read_excel_data(f, hb_sheet_name, hb_data_row_index, "gpp")
  )
}

jsonlite::write_json(hchs_df %<>% clean_names(), 
                     here("app", "data", "hb-data-hchs.json"))
jsonlite::write_json(gpp_df %<>% clean_names(), here("app", "data",
                                                     "hb-data-gpp.json"))

# clean environment ----
rm(list = setdiff(ls(), start_vars))
