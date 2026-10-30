# Link the TrialScout trial sample to BEAR's ClinicalTrials.gov data.

library(dplyr)

# Paths -----

ctgov_path <- "data/clinicaltrialsgov.rds"
trialscout_path <- "data_raw/clinicaltrials.gov/trialscout_sample/finalSample.rda"

# Read -----

ctgov <- readRDS(ctgov_path)

# finalSample.rda holds a single data.table, `df`
trialscout_env <- new.env()
load(trialscout_path, envir = trialscout_env)
trialscout <- trialscout_env$df
rm(trialscout_env)
