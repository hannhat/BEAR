source("R/write_summary.R")
load("data/BarnettWren/Georgescu.Wren.RData")
save_rds_summary(complete, file = "data/BarnettWren.rds")
rm(complete)
