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

# phsmethods package is not on CRAN, install and load separately
if (! requireNamespace("phsmethods", quietly = TRUE)) {
  remotes::install_github("Public-Health-Scotland/phsmethods")
}

library(janitor)
library(here)
library(tidyr)
library(dplyr)
library(magrittr)
library(shinyWidgets)
library(shinycssloaders)
library(rsconnect)
library(phsmethods)
library(stringr)

# load functions ----
source("functions/core-functions.R")

# parameters ----

password_protect <- FALSE

if(isTRUE(password_protect)){
  source("password-protect/create-credentials.R", local = TRUE)
}

navy <- "#010068"

# filepaths ----
credentials_path <- "password-protect/credentials.rds"

# load app data ----
data_filepaths <- as.list(list.files("data", full.names = TRUE))

names(data_filepaths) <- str_remove(list.files("data"), "\\.([^.]*)$")

list2env(lapply(data_filepaths, readRDS), envir = .GlobalEnv)

# user input lists ----

# intro page sidebar buttons list
home_list <- c("About", "Use", "Contact", "Accessibility")

#end_time = timestamp()

