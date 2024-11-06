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

if(!requireNamespace("phsstyles", quietly = TRUE)){
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

# parameters ----

password_protect <- TRUE

if(isTRUE(password_protect)){
  source("password-protect/create-credentials.R", local = TRUE)
}

navy <- "#010068"


# load app data ----
data_filepaths <- as.list(list.files("data", full.names = TRUE))

names(data_filepaths) <- str_remove(list.files("data"), "\\.([^.]*)$")

list2env(lapply(data_filepaths, readRDS), envir = .GlobalEnv)

# user input lists ----

# intro page sidebar buttons list
home_list <- c("About", "Use", "Contact", "Accessibility")
hb_list <- fromJSON("lookups/hb_cypher_to_name.json") %>% 
  pull(hb_name)
stat_list <- c("Shares", "Indices")
programme_list <- c("All", "Hospital and Community Health Services", 
                    "General Practice and Prescribing")

#end_time = timestamp()

