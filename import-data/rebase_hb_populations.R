#' rebase_hb_populations.R
#' 
#' R version 4.5.1 
#' Code written
#' Health Finance & Analytics team
#' 
#' Posit Workbench - 
#' Run time: ~
#'

# 0. set up ----
library(here)
library(tidyverse)
start_vars <- ls()

source(here::here("functions.R"), local = TRUE)

hb_est <- readRDS(here("data-pack", "HB2019_pop_est_1981_2024.rds"))
hb_proj <- readRDS(here("data-pack", "HB2019_pop_est_1981_2024.rds"))
