# Refresh tracked summaries from saved datasets without rerunning processing.
source("R/write_summary.R")

for (file in list.files("data", pattern = "\\.rds$", full.names = TRUE)) {
  message("Summarising ", basename(file))
  write_summary(readRDS(file), file.path("data_summary", paste0(
    tools::file_path_sans_ext(basename(file)), ".md")))
}
write_summary(readRDS("BEAR.rds"), "data_summary/BEAR.md")
