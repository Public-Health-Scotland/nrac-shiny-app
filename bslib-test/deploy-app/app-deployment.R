########################################
############ Deploying app #############
########################################

# Source this file to deploy the app
library(dplyr)

app_loc <- here::here("bslib-test")

app_name <- "phs-nrac"

# Get deployment functions
source("app/deploy-app/deployment-functions.R")

# Get secrets for deployment
# NB: you must set this file up using information from colleagues
source("app/deploy-app/deployment-secrets.R")

# Set deployment date
set_deployment_date(dir_ = app_loc)

# This deploys the app
# deploy(app_loc, pra = pra)
rsconnect::deployApp(appDir = app_loc,
                     # appFiles = public_files,
                     appName = app_name,
                     account = "scotland",
                     logLevel = "verbose"
)


# Check logs of deployed app
# check_logs(app_loc, pra = pra)
rsconnect::showLogs(appPath = app_loc,
                    appName = app_name,
                    account = "scotland")

###########################################################
##END
