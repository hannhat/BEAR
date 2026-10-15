# Process Sladekova et al. source meta-analytic datasets into BEAR inputs.
# Preserve prepared effects/variances; metadata records supported source fields.
# Study IDs are approximate within-meta-analysis groupings.

library(tidyverse)
source("R/write_summary.R")
source("R/doi_lookup.R")
source("R/z_derivation_helpers.R")

raw_files <- list.files("data_raw/Sladekova/data", full.names = TRUE)
dfs <- lapply(raw_files, read.csv)
names(dfs) <- basename(raw_files)

metadata <- read_csv("process/Sladekova/metadata.csv", show_col_types = FALSE)
stopifnot(!anyDuplicated(metadata$metaid),
          setequal(names(dfs), metadata$metaid))
metadata <- metadata %>% mutate(key = str_extract(metaid, "^[AB][0-9]+"),
                                doi_meta = NA_character_, topic = NA_character_)
if(file.exists("doi/Sladekova/final/meta_doi_mapping.rds")) {
  metadata <- join_identifiers(metadata,
    readRDS("doi/Sladekova/final/meta_doi_mapping.rds"), "key",
    c("doi_meta", "topic"))
}

# Read only supported count fields; both arms must be available to sum them.
source_count <- function(df, column) {
  if(is.na(column)) return(rep(NA_real_, nrow(df)))
  x <- as.numeric(df[[column]])
  ifelse(is.finite(x) & x > 0, x, NA_real_)
}

best_col <- function(df, candidates) {
  candidates <- intersect(candidates, names(df))
  if(length(candidates) == 0) return(NA_character_)
  nonmissing <- sapply(candidates, function(col) {
    sum(!is.na(df[[col]]) & df[[col]] != "")
  })
  if(max(nonmissing) == 0) return(NA_character_)
  candidates[which.max(nonmissing)]
}

clean_text <- function(x) {
  x <- stringr::str_squish(as.character(x))
  dplyr::na_if(x, "")
}

normalize_study_text <- function(x) {
  x <- stringr::str_to_lower(clean_text(x))
  x <- stringr::str_replace_all(x, "\\[[0-9]+\\]", "")
  x <- stringr::str_replace_all(x, "[^a-z0-9]+", " ")
  x <- stringr::str_squish(x)
  dplyr::na_if(x, "")
}

extract_year <- function(x) {
  year <- stringr::str_extract(as.character(x), "(18|19|20)[0-9]{2}")
  suppressWarnings(as.numeric(year))
}

study_label_cols <- c("author", "Author", "authors", "Authors", "Study.name",
                      "Stady.name", "Study.Author", "Source", "sample",
                      "Sample_Description")
year_cols <- c("year", "Year", "Study.Year", "pub_year", "pub_year_full",
               "Publication_year", "std_year", "std_pub_year", "year_full")

onedf <- imap(dfs, function(df, metaid) {
  info <- metadata[match(metaid, metadata$metaid), ]
  df$source_row <- seq_len(nrow(df))
  df$ss <- coalesce(source_count(df, info$n_total),
                    source_count(df, info$n_arm1) +
                      source_count(df, info$n_arm2))

  # yi and vi already reflect the authors' effect-size preparation.
  # Keep their supplied scales, including unresolved source pairs.
  ret <- df %>%
    filter(!is.na(yi), !is.na(vi)) %>%
    mutate(b = yi, se = sqrt(vi),
           z = if (info$effect_scale == "fisher_z")
             derive_correlation_z(b, se = se, effect_scale = "fisher_z")$z
           else b/se,
           measure = info$measure, effect_scale = info$effect_scale,
           doi_meta = info$doi_meta, topic = info$topic)
  if(nrow(ret) == 0) return(tibble())

  # Reconstruct study IDs within each imported meta-analysis. The source
  # `study_id` is just the file suffix. Only DOI-like or descriptive fields
  # group rows; otherwise identifiers refer to original source-row positions.
  doi_col <- best_col(ret, grep("doi", names(df), ignore.case = TRUE,
                                value = TRUE))
  label_col <- best_col(ret, study_label_cols)
  year_col <- best_col(ret, year_cols)
  
  doi <- if(is.na(doi_col)) NA_character_ else extract_doi(ret[[doi_col]])
  doi <- normalize_study_text(doi)
  
  ret$study_label <- if(is.na(label_col)) {
    NA_character_
  } else {
    clean_text(ret[[label_col]])
  }
  ret$study_label_norm <- normalize_study_text(ret$study_label)
  ret$study_label_norm[stringr::str_detect(ret$study_label_norm, "^[0-9]+$")] <-
    NA_character_
  
  ret$study_year <- if(is.na(year_col)) NA_real_ else extract_year(ret[[year_col]])
  descriptive_id <- ifelse(
    !is.na(ret$study_label_norm) & !is.na(ret$study_year),
    paste(ret$study_label_norm, ret$study_year, sep = "_"),
    ret$study_label_norm
  )
  row_unique_id <- paste0("row_", stringr::str_pad(ret$source_row, 5, pad = "0"))
  
  ret$studyid <- dplyr::case_when(
    !is.na(doi) ~ paste0("doi_", doi),
    !is.na(descriptive_id) ~ descriptive_id,
    TRUE ~ row_unique_id
  )
  if(is.null(ret$year)) {
    ret$year <- as.numeric(NA)
  } else {
    ret$year <- extract_year(ret$year)
  }
  ret$year <- coalesce(ret$year, ret$study_year)
  ret %>%
    dplyr::select(
      studyid, study_label, doi_meta, topic, measure, effect_scale,
      b, se, z, ss, year
    )
}) %>% 
  dplyr::bind_rows(.id = "metaid") %>%
  relocate(studyid, study_label)

save_rds_summary(onedf, "data/Sladekova.rds")
rm(onedf)
rm(dfs)
