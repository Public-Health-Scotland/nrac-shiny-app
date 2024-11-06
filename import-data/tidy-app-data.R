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

hb_lookup_path <- here("app", "lookups", "hb_cypher_to_name.json")
sqlite_path <- here("app", "data", "nrac-db.sqlite")

# read in the HB data for each financial year

data_files <- list.files(here("data-pack"))
datazone_hscp_files <- data_files[str_detect(str_to_lower(data_files), 
                                  "resource-allocations-datazone-")]

hb_sheet_name <- "Data_HB"
notes_heet_name <- "Notes Page"
hb_data_row_index <- list(hchs = c(1:15), gpp = c(30:44), weights = c(92:93))

# there are two tables one for gpp one for hchs
# hchs dim A1:A15 x AA1:AA15
# gpp dim A30:A44 x I30:I44
# 

read_excel_data <- function(file_name, sheet_name, row_index, programme, ...){
  
    openxlsx::read.xlsx(here("data-pack", file_name), sheet = sheet_name, 
                        rows = row_index[[programme]], ...) %>% 
    mutate(target_year_end = 
             2000 + as.numeric(str_extract(file_name, "(\\d{2})(?=\\D*$)"))) %>% 
    mutate(target_year_start = target_year_end - 1) %>% 
    clean_names()

}


hchs_df <- tibble()
gpp_df <- tibble()
programme_weights <- tibble()

for(f in datazone_hscp_files){
  hchs_df %<>% bind_rows(
    read_excel_data(f, hb_sheet_name, hb_data_row_index, "hchs") %>% 
      select(hb, population, as_index, "as_pop" = overall_as_pop,
             mlc_index, "mlc_pop" = overall_mlc_pop, 
             xs_index, "xs_pop" = overall_xs_pop, 
             "programme_index" = overall_hchs_index, 
             target_year_end, target_year_start)
    )
  
  gpp_df %<>% bind_rows(
    read_excel_data(f, hb_sheet_name, hb_data_row_index, "gpp")%>% 
      rename("programme_index" = "overall_presc_index")
  ) 
  
  programme_weights %<>% bind_rows(
    read_excel_data(f, notes_heet_name, hb_data_row_index, "weights", 
                    cols = c(7:14))
  )
  
}

# Get the Scotland total population per year so that we can calculate the population shares for HCHS and GPP
scotland_population <- hchs_df %>% 
  group_by(target_year_end, target_year_start) %>% 
  summarise(scotland_pop = sum(population))

join_cols <- c("target_year_end", "target_year_start")

index_shares_programme <- bind_rows(list(hchs = hchs_df, gpp = gpp_df),
                          .id = "care_programme") %>% 
  left_join(scotland_population, by = join_cols) %>% 
  mutate(pop_share = population/scotland_pop,
         as_share = as_pop/scotland_pop,
         mlc_share = mlc_pop/scotland_pop,
         xs_share = xs_pop/scotland_pop) %>% 
  select(-c("population", "as_pop", "mlc_pop", "xs_pop", "scotland_pop"))

# Use the programme weights to compute the indices and population shares for all care programmes
programme_weights %<>% 
  select(hchs_weight = overall_hchs, gpp_weight = gp_prescribing, 
         target_year_start, target_year_end) %>% 
  pivot_longer(cols = (ends_with("weight")), 
               values_to = "care_programme_weight", 
               names_to = "care_programme") %>% 
  mutate(care_programme = str_remove(care_programme, "_weight"))

index_shares_all <- index_shares_programme %>% 
  left_join(programme_weights, by = c("target_year_start", "target_year_end",
                                      "care_programme")) %>% 
  group_by(hb, target_year_start, target_year_end) %>% 
  summarise(pop_share = sum(pop_share * care_programme_weight),
           as_share = sum(as_share * care_programme_weight), 
           mlc_share = sum(mlc_share * care_programme_weight),
           xs_share = sum(xs_share * care_programme_weight),
           as_index = as_share/pop_share,
           mlc_index = mlc_share/as_share,
           xs_index = xs_share/mlc_share,
           .groups = "drop") %>% 
  mutate(care_programme = "all")

# bind all the index and shares data and tidy it
index_shares <- bind_rows(index_shares_all, index_shares_programme) %>% 
  left_join(bind_rows(fromJSON(file = hb_lookup_path)), 
            by = c("hb" = "hb_cypher"))

# store the the indices and shares data in a sqlite file
nracdb <- dbConnect(RSQLite::SQLite(), sqlite_path)
dbWriteTable(nracdb, "index_shares", index_shares, overwrite = TRUE)

# test query
#dbGetQuery(nracdb, 'SELECT * FROM index_shares LIMIT 5')

dbDisconnect(nracdb)

# clean environment ----
rm(list = setdiff(ls(), start_vars))
