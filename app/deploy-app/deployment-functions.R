# Deployment functions

set_deployment_date <- function(dir_){

  Deployment_Date <- lubridate::today() %>% format("%d %B %Y")
  saveRDS(Deployment_Date, paste0(dir_, "/data/Deployment_Date.rds"))

}

deploy <- function(app_loc, pra = TRUE){

  #protected <- is_password_protected(app_loc)

  if(pra) {
    app_name = "phs-nrac-pra"
    password_protect(TRUE)

  } else {
    app_name = "phs-nrac"
    password_protect(FALSE)

  }

  rsconnect::deployApp(appDir = app_loc,
                       # appFiles = public_files,
                       appName = app_name,
                       account = "scotland",
                       logLevel = "verbose"
  )

}

check_logs <- function(app_loc, pra = TRUE){

  if(pra) {
    app_name = "phs-nrac-pra"

  } else {
    app_name = "phs-nrac"

  }

  rsconnect::showLogs(appPath = app_loc,
                      appName = app_name,
                      account = "scotland")
}

