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

# Public Health Scotland package are not on CRAN, install
if (!requireNamespace("phsmethods", quietly = TRUE)) {
  remotes::install_github("Public-Health-Scotland/phsmethods")
}

if (!requireNamespace("phsstyles", quietly = TRUE)) {
  remotes::install_github("Public-Health-Scotland/phsstyles")
  
}



library(janitor)
library(here)
library(tidyr)
library(dplyr)
library(magrittr)
library(phsmethods)
library(stringr)
library(jsonlite)
library(RSQLite)

library(shinyWidgets)
library(shinycssloaders)
library(rsconnect)
library(shinymanager)
library(bslib)
library(highcharter)


# load functions ----
source("functions/core-functions.R")

# filepaths ----
credentials_path <- "password-protect/credentials.rds"

sqlite_path <- here("app", "data", "nrac-db.sqlite")

# parameters ----

password_protect <- TRUE

if (isTRUE(password_protect)) {
  source("password-protect/create-credentials.R", local = TRUE)
}

navy <- "#010068"


# import data ----
nracdb <- dbConnect(SQLite(), sqlite_path)

all_index_shares <- dbGetQuery(nracdb, 'SELECT * FROM index_shares')

dbDisconnect(nracdb)
# data_filepaths <- as.list(list.files("data", full.names = TRUE))
#
# names(data_filepaths) <- str_remove(list.files("data"), "\\.([^.]*)$")
#
# list2env(lapply(data_filepaths, readRDS), envir = .GlobalEnv)

# user input lists ----

# one list per page

# intro page
intro_list <- list(side_bar = c("About", "Use", "Contact", "Accessibility"))

# populations
pop_list <- list(hb_names = bind_rows(fromJSON(file = "lookups/hb_cypher_to_name.json")) %>%
                   pull(hb_name))

# shares and indices
# user inputs are mapped to categorical wariables in the data
shares_indices_list <- list(
  stat = list(share = "Shares", index = "Indices"),
  care_programme = list(all = "All", hchs = "Hospital and Community Health Services", gpp = "General Practice and Prescribing")
)

#end_time = timestamp()
