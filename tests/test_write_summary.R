# Check compact summaries, category filtering and the paired RDS save.
source("R/write_summary.R")

directory <- tempfile("bear-summary-")
dir.create(directory)
data <- data.frame(number = c(1:7, Inf, -Inf, NA, NaN),
                   category = c("", NA, "missing", "a|b", "<tag>",
                                "[link](url)", "a", "b", "c", "d", "e"),
                   flag = rep(c(TRUE, FALSE, NA), length.out = 11),
                   absent = NA_real_, studyid = rep(c("x", "y"), length.out = 11),
                   reference = "A paper", author1 = "An author",
                   rct_id_2 = "trial-1",
                   text = paste0("value", 1:11), tiny = 1e-12)
data$date <- as.Date("2020-01-01") + seq_len(nrow(data))
data$labelled <- haven::labelled(rep(c(0, 1), length.out = 11),
                                c(no = 0, yes = 1))
data$factor <- factor(rep("one", 11), levels = c("one", "unused"))
data$list <- lapply(seq_len(nrow(data)), seq_len)
write_summary(data, file.path(directory, "example.md"), top_n = 10)
lines <- readLines(file.path(directory, "example.md"))
stopifnot(any(grepl("Rows: 11", lines, fixed = TRUE)),
          all(paste0("## Variable type: ", c("character", "factor", "logical",
                     "numeric", "date", "other")) %in% lines),
          !any(grepl("Percentages|denominator|median|Distribution", lines)),
          any(grepl("a&#124;b", lines, fixed = TRUE)),
          any(grepl("&lt;tag&gt;", lines, fixed = TRUE)))
number <- trimws(strsplit(lines[grepl("^\\|number +\\|", lines)], "|",
                          fixed = TRUE)[[1]])
stopifnot(identical(number[3:9], c("2", "4", "2.16", "1", "7", "1", "1")),
          nchar(number[10]) == 5)
for (name in c("studyid", "reference", "author1", "rct_id_2", "text")) {
  row <- lines[grepl(paste0("^\\|", name, " +\\|"), lines)]
  stopifnot(!grepl(": [0-9]", row))
}
stopifnot(any(grepl("1e-12", lines, fixed = TRUE)))
write_summary(data, file.path(directory, "example.md"), top_n = 10)
stopifnot(identical(lines, readLines(file.path(directory, "example.md"))))
write_summary(data[0, ], file.path(directory, "empty.md"))
stopifnot(any(grepl("Rows: 0", readLines(file.path(directory, "empty.md")),
                    fixed = TRUE)))
original_directory <- getwd()
setwd(directory)
data |> save_rds_summary("example.rds", compress = FALSE, version = 2)
stopifnot(identical(data, readRDS("example.rds")),
          file.exists("data_summary/example.md"))
setwd(original_directory)
unlink(directory, recursive = TRUE)
message("Compact summary and paired RDS save checks passed.")
