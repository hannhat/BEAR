# Compare author-reported ClinicalTrials.gov effects between the August 2025
# public file (BEAR_data b0f8860) and the 13 October 2026 AACT rebuild.
# The old public file is author-only, so this compares author-reported rows.

library(dplyr)
library(readr)
library(tidyr)

# Paths -----

old_path <- "data_raw/clinicaltrials.gov/_archive/clinicaltrialsgov_BEAR_data_b0f8860.rds"
new_path <- "data/clinicaltrialsgov.rds"
new_studies_path <- "data_raw/clinicaltrials.gov/13102026/briz20jy4pzxe9cbsvkjw6lki2oa/studies.txt"
out_dir <- "explore/ctgov_snapshot_comparison/output"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Read -----

old <- readRDS(old_path)
new <- readRDS(new_path) %>% filter(effect_source == "author_reported")

stopifnot(nrow(old) == 69992, n_distinct(old$nct_id) == 20342)

# Current registry status of every trial in either file, from the new snapshot.
new_studies <- read_delim(
  new_studies_path, delim = "|",
  col_select = c(nct_id, overall_status, results_first_posted_date,
                 last_update_posted_date),
  col_types = cols(.default = col_character()),
  show_col_types = FALSE, progress = FALSE
)

# Trial level -----

trial_counts <- full_join(
  count(old, nct_id, name = "n_old"),
  count(new, nct_id, name = "n_new"),
  by = "nct_id"
) %>%
  mutate(
    across(c(n_old, n_new), ~ coalesce(.x, 0L)),
    presence = case_when(
      n_old > 0 & n_new > 0 ~ "both",
      n_old > 0 ~ "old_only",
      TRUE ~ "new_only"
    )
  ) %>%
  left_join(new_studies, by = "nct_id") %>%
  mutate(
    results_first_posted_year = as.integer(substr(results_first_posted_date, 1, 4)),
    last_update_year = as.integer(substr(last_update_posted_date, 1, 4))
  )

trial_summary <- trial_counts %>%
  group_by(presence) %>%
  summarise(
    trials = n(),
    rows_old = sum(n_old),
    rows_new = sum(n_new),
    same_row_count = sum(n_old == n_new),
    .groups = "drop"
  )

# Why trials leave: registry status and update timing in the new snapshot.
old_only_status <- trial_counts %>%
  filter(presence == "old_only") %>%
  count(overall_status, last_update_year, name = "trials") %>%
  arrange(desc(trials))

# When added trials first posted results.
new_only_posting <- trial_counts %>%
  filter(presence == "new_only") %>%
  count(results_first_posted_year, name = "trials")

# Row level, within trials in both files -----

# The old file has no outcome-analysis ID, so rows are matched as a multiset on
# rounded statistics within each trial.
add_row_key <- function(df) {
  df %>%
    mutate(key = paste(measure_class, round(b, 6), round(se, 6), round(z, 4),
                       z_operator, sep = "|"))
}

row_key <- function(df) {
  add_row_key(df) %>% count(nct_id, key, name = "n")
}

shared <- trial_counts$nct_id[trial_counts$presence == "both"]
row_match <- full_join(
  row_key(filter(old, nct_id %in% shared)) %>% rename(n_old = n),
  row_key(filter(new, nct_id %in% shared)) %>% rename(n_new = n),
  by = c("nct_id", "key")
) %>%
  mutate(across(c(n_old, n_new), ~ coalesce(.x, 0L)))

row_summary <- tibble(
  shared_trials = length(shared),
  old_rows = sum(row_match$n_old),
  new_rows = sum(row_match$n_new),
  matched_rows = sum(pmin(row_match$n_old, row_match$n_new)),
  old_rows_unmatched = sum(pmax(row_match$n_old - row_match$n_new, 0L)),
  new_rows_unmatched = sum(pmax(row_match$n_new - row_match$n_old, 0L)),
  trials_identical = row_match %>%
    group_by(nct_id) %>%
    summarise(same = all(n_old == n_new), .groups = "drop") %>%
    pull(same) %>%
    sum()
)

# Old rows with no match in the new file -----

# Within each trial and key, the first n_new old rows count as matched; any
# beyond that are old-only. Rows sharing a key are identical on the matched
# fields, so which duplicate is kept does not matter.
new_key_counts <- row_key(new) %>% rename(n_new_key = n)

old_rows_not_in_new <- old %>%
  add_row_key() %>%
  group_by(nct_id, key) %>%
  mutate(key_copy = row_number()) %>%
  ungroup() %>%
  left_join(new_key_counts, by = c("nct_id", "key")) %>%
  mutate(n_new_key = coalesce(n_new_key, 0L)) %>%
  filter(key_copy > n_new_key) %>%
  left_join(
    trial_counts %>%
      select(nct_id, presence, n_old_trial = n_old, n_new_trial = n_new,
             overall_status_new = overall_status, last_update_posted_date),
    by = "nct_id"
  ) %>%
  mutate(
    old_only_reason = if_else(
      presence == "old_only", "trial_absent_from_new", "row_not_matched_in_new"
    )
  ) %>%
  select(nct_id, old_only_reason, overall_status_new, last_update_posted_date,
         n_old_trial, n_new_trial, all_of(names(old)), -nct_id, nct_id) %>%
  relocate(nct_id) %>%
  arrange(old_only_reason, nct_id)

stopifnot(
  nrow(old_rows_not_in_new) ==
    sum(trial_counts$n_old[trial_counts$presence == "old_only"]) +
      row_summary$old_rows_unmatched
)

# Save and print -----

saveRDS(old_rows_not_in_new, file.path(out_dir, "old_rows_not_in_new_v1.rds"))
write_csv(old_rows_not_in_new, file.path(out_dir, "old_rows_not_in_new_v1.csv"))

write_csv(trial_counts, file.path(out_dir, "trial_presence_v1.csv"))
write_csv(trial_summary, file.path(out_dir, "trial_summary_v1.csv"))
write_csv(old_only_status, file.path(out_dir, "old_only_status_v1.csv"))
write_csv(new_only_posting, file.path(out_dir, "new_only_posting_year_v1.csv"))
write_csv(row_summary, file.path(out_dir, "row_match_summary_v1.csv"))

print(trial_summary)
print(head(old_only_status, 10))
print(new_only_posting, n = Inf)
print(row_summary, width = Inf)
print(count(old_rows_not_in_new, old_only_reason))
