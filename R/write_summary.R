# Write compact Markdown tables for reviewing saved BEAR datasets.
# Numeric histograms and statistics use finite values; infinities are counted.

write_summary <- function(df, path, top_n = 3L, max_categories = 10L,
                          digits = 4L) {
  stopifnot(is.data.frame(df), !anyDuplicated(names(df)),
            top_n >= 1, top_n == as.integer(top_n),
            max_categories >= 1, digits >= 1)
  identifier <- paste0("ids?$|(^|[._])(ids?|ref)([._]|$)|",
                       "reference|author|citation|doi|pmid|nct|title|label|name|url")
  rows <- lapply(names(df), function(name) {
    x <- df[[name]]
    if (inherits(x, "haven_labelled")) x <- haven::zap_labels(x)
    type <- if (inherits(x, "Date")) "date" else
      if (inherits(x, "POSIXt")) "datetime" else
      if (is.factor(x)) "factor" else
      if (is.numeric(x)) "numeric" else
      if (is.logical(x)) "logical" else
      if (is.character(x)) "character" else "other"
    row <- data.frame(type, Variable = name, Missing = sum(is.na(x)))
    observed <- x[!is.na(x)]
    if (type == "numeric") {
      finite <- x[is.finite(x)]
      row$Mean <- if (length(finite)) mean(finite) else NA_real_
      row$SD <- sd(finite)
      row$Min <- if (length(finite)) min(finite) else NA_real_
      row$Max <- if (length(finite)) max(finite) else NA_real_
      row$`-Inf` <- sum(x == -Inf, na.rm = TRUE)
      row$`+Inf` <- sum(x == Inf, na.rm = TRUE)
      row$Hist <- trimws(skimr::inline_hist(finite, n_bins = 5))
    } else if (type %in% c("character", "factor")) {
      row$Unique <- dplyr::n_distinct(observed)
      row$Empty <- sum(observed == "")
      row$Common <- ""
      if (row$Unique > 0 && row$Unique <= max_categories &&
          !grepl(identifier, name, ignore.case = TRUE)) {
        counts <- tibble::tibble(value = as.character(observed)) |>
          dplyr::count(value, name = "n", sort = TRUE)
        top <- head(counts, top_n)
        labels <- top$value
        labels[labels == ""] <- "(empty)"
        labels <- ifelse(nchar(labels) > 24,
                         paste0(substr(labels, 1, 24), "…"), labels)
        labels <- gsub("[\r\n]+", " ", labels)
        labels <- gsub("&", "&amp;", labels, fixed = TRUE)
        labels <- gsub("<", "&lt;", labels, fixed = TRUE)
        labels <- gsub(">", "&gt;", labels, fixed = TRUE)
        labels <- gsub("|", "&#124;", labels, fixed = TRUE)
        row$Common <- paste(paste0(labels, ": ", top$n), collapse = "; ")
      }
    } else if (type == "logical") {
      row$`TRUE` <- sum(x %in% TRUE)
      row$`FALSE` <- sum(x %in% FALSE)
    } else if (type %in% c("date", "datetime")) {
      row$Min <- if (length(observed)) as.character(min(observed)) else ""
      row$Max <- if (length(observed)) as.character(max(observed)) else ""
    } else {
      row$Class <- paste(class(x), collapse = "/")
    }
    row
  })
  lines <- c(paste0("# ", tools::file_path_sans_ext(basename(path))), "",
             paste0("- Rows: ", format(nrow(df), big.mark = ",", trim = TRUE)),
             paste0("- Columns: ", ncol(df)), "")
  for (type in c("character", "factor", "logical", "numeric",
                 "date", "datetime", "other")) {
    group <- rows[vapply(rows, function(row) row$type == type, logical(1))]
    if (!length(group)) next
    table <- dplyr::bind_rows(group) |> dplyr::select(-type)
    if (type == "numeric") {
      for (column in c("-Inf", "+Inf"))
        if (all(table[[column]] == 0)) table[[column]] <- NULL
      for (column in c("Mean", "SD", "Min", "Max"))
        table[[column]] <- vapply(table[[column]], function(value) {
          if (is.na(value)) "" else
            format(signif(value, digits), trim = TRUE, scientific = NA)
        }, character(1))
    }
    align <- ifelse(names(table) %in% c("Variable", "Common", "Hist",
                                        "Class"), "l", "r")
    lines <- c(lines, paste0("## Variable type: ", type), "",
               knitr::kable(table, format = "pipe", row.names = FALSE,
                            align = align, digits = 8), "")
  }
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  writeLines(lines, path, useBytes = TRUE)
  invisible(path)
}

# Save an individual dataset together with its tracked summary.
save_rds_summary <- function(object, file, ...) {
  write_summary(object, file.path("data_summary", paste0(
    tools::file_path_sans_ext(basename(file)), ".md")))
  saveRDS(object, file, ...)
  invisible(object)
}
