#' core-functions.R
#' Health Finance & Analytics
#' Code written September 2024
#' R version 4.1.2 (2021-11-01)
#'
#'
#' Core functions for the shiny app. Sourced in the `set-up.R` script.


# Add n linebreaks ----
linebreaks <- function(n) {
  HTML(strrep(br(), n))
}

# Get name from list value ----
#' value_2_name
#'
#' @param list a list of lists
#' @param nest_name character, name of nested list
#' @param value character, a user input
#'
#' @return
#' @export
#'
#' @examples value_2_name(shares_indices_list, "stat", "Shares")
value_2_name <- function(list, nest_name, value) {
  names(which(list[[nest_name]] == value))
}

# Remove warnings from icons ----
icon_no_warning_fn = function(icon_name) {
  icon(icon_name, verify_fa = FALSE)
}

withNavySpinner <- function(out, color_) {
  withSpinner(out, color = color_)
}

# Get health board name ----
# get_hb_name <- function(code){
# # e.g. converts HB code to "NHS Ayrshire and Arran"
#   ifelse(is.na(code),
#          NA_character_,
#          phsmethods::match_area(code) %>% paste("NHS", .)
#          )
# }

## Function to format a given entry in a table ----
format_entry <- function(x, dp = 0, perc = F) {
  # x (numeric, char): entry
  # dp (int): number of decimal places
  # perc (bool): whether to add % afterwards
  
  # First strip any existing commas and whitespace out
  x <- gsub(",", "", x)
  x <- gsub(" ", "", x)
  
  # Try to convert entry to numeric, if failed return NULL
  numx <- tryCatch(
    as.numeric(x),
    warning = function(w)
      NULL
  )
  
  # Format entry if numeric
  if (!is.null(numx)) {
    numx <- formatC(numx,
                    format = "f",
                    big.mark = ",",
                    digits = dp)
    if (perc) {
      numx <- paste0(numx, "%")
    }
    return (numx)
  } else {
    # If entry cannot be converted to numeric, return original entry i.e. "*"
    return(x)
  }
}


# Load data function ----
# load_rds_file <- function(rds){
#   # Given a .rds file name in shiny_app/data
#   # this function loads it as a variable with the same name as the
#   # file apart from the extension
#   assign(gsub(".rds", "", rds), readRDS(paste0("data/", rds)), envir = .GlobalEnv)
# }

# Date conversion functions ----
# convert_date_to_month <- function(date){
#   date <- format(date, "%b %Y")
#   return(date)
# }
#
# as_dashboard_date <- function(date){
#   date <- format(as.Date(date), "%d %b %y")
#   return(date)
# }
