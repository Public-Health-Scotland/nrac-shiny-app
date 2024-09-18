#' set-up.R
#' Health Finance & Analytics
#' Code written September 2024
#' R version 4.1.2 (2021-11-01)
#'
#' Author:Maiana Sanjuan
#' Runtime:
#' Memory:16GB
#' CPUs:1

# load packages ----
library(here)
library(glue)
library(shiny)


# load functions ----
source(here("app/functions/core-functions.R"))

# parameters ----
import_data <- ifelse(length(list.files(here("data-pack"))) == 0, TRUE, FALSE)

clean_data <- ifelse(length((list.files(here("app/data/")))) == 0, TRUE, FALSE)

# import and clean data ----

if(isTRUE(import_data)){
  source(here("import-app-data.R"), local = TRUE)
}