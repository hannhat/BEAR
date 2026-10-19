# Draw a seeded manual-review sample of author/raw z discrepancies and attach
# the fields needed to judge them, with rule-based first-pass classifications.
# Band: 30-percentile bands (5-35, 35-65, 65-95) of | |z author| - |z raw| |,
# among exact author z values with |z raw| < 10; 10% sampled per band.

library(dplyr)
library(readr)
library(stringr)

# Builds z_wide and overlap_two_effects
source("explore/aact_snapshot/raw_versus_author_effects/raw_versus_author_effects_v1.R")

# Paths -----

aact_dir <- "data_raw/clinicaltrials.gov/13102026/briz20jy4pzxe9cbsvkjw6lki2oa"
om_long_path <- "data_raw/clinicaltrials.gov/derived/intermediate/outcome_measurements_long.rds"
out_dir <- "explore/aact_snapshot/raw_versus_author_effects/output"
sample_seed <- 20261018

# Band and sample -----

review_pool <- z_wide %>%
  filter(is.finite(abs_z_diff), z_operator_author == "=", abs_z_raw < 10)

band_cuts <- quantile(review_pool$abs_abs_z_diff, c(0.05, 0.35, 0.65, 0.95))

review_base <- review_pool %>%
  mutate(band = cut(abs_abs_z_diff, band_cuts, include.lowest = TRUE,
                    labels = c("p05-35", "p35-65", "p65-95"))) %>%
  filter(!is.na(band))

set.seed(sample_seed)
review_sample <- review_base %>%
  group_by(band) %>%
  slice_sample(prop = 0.10) %>%
  ungroup()

# Review fields -----

author_fields <- overlap_two_effects %>%
  filter(effect_source == "author_reported") %>%
  select(new_result_id, outcome_analysis_id, outcome_title, outcome_time_frame,
         method, param_type, estimate, lower, upper, ci_percent, ci_n_sides,
         p_value, p_value_modifier)

raw_fields <- overlap_two_effects %>%
  filter(effect_source == "raw_derived") %>%
  select(new_result_id, measurement_stratum_id, measurement_units,
         raw_mean_t, raw_mean_c, raw_sd_t, raw_sd_c, raw_n_t, raw_n_c,
         raw_event_t, raw_event_c, raw_group_t_title, raw_group_c_title,
         direction_unknown)

analysis_text <- read_delim(
  file.path(aact_dir, "outcome_analyses.txt"), delim = "|",
  col_types = cols(.default = col_character()),
  col_select = c(id, non_inferiority_description, p_value_description,
                 method_description, estimate_description, groups_description,
                 other_analysis_description),
  progress = FALSE
) %>%
  rename(outcome_analysis_id = id) %>%
  filter(outcome_analysis_id %in% author_fields$outcome_analysis_id)

measurement_text <- readRDS(om_long_path) %>%
  distinct(measurement_stratum_id, .keep_all = TRUE) %>%
  select(measurement_stratum_id, raw_param_type = param_type, classification,
         category, measurement_description)

decimals <- function(x) {
  s <- sub("0+$", "", sprintf("%.10f", abs(x)))
  nchar(sub("^[0-9]*\\.?", "", s))
}

# Rule-based first pass -----

adjusted_pattern <- paste(
  "ancova|covariance|regression|mixed|mmrm|repeated measures|gee|generali[sz]ed",
  "cochran|cmh|mantel|stratif|adjust|covariate|least square|ls mean|lsmean",
  "baseline as|controlling for|\\bcox\\b|proportional hazard",
  sep = "|"
)
unadjusted_pattern <- "t-test|t test|anova|wilcoxon|mann|kruskal|chi|fisher|z-test|exact"

near <- function(a, b, tol = 0.02) {
  !is.na(a) & !is.na(b) & is.finite(b) & abs(abs(a) - abs(b)) <= pmax(tol * abs(b), 0.01)
}

# Attach review fields and rule-based flags to rows of z_wide
add_review_fields <- function(df) {
  df %>%
  left_join(author_fields, by = "new_result_id") %>%
  left_join(raw_fields, by = "new_result_id") %>%
  left_join(analysis_text, by = "outcome_analysis_id") %>%
  left_join(measurement_text, by = "measurement_stratum_id") %>%
  mutate(
    author_text = str_to_lower(paste(method, param_type, method_description,
                                     estimate_description, groups_description,
                                     non_inferiority_description,
                                     other_analysis_description)),
    adjusted_rule = case_when(
      str_detect(author_text, adjusted_pattern) ~ "adjusted",
      str_detect(str_to_lower(coalesce(method, "")), unadjusted_pattern) ~ "unadjusted",
      TRUE ~ "unclear"
    ),
    author_z_from = if_else(!is.na(lower) & !is.na(upper), "ci", "p"),

    # Raw quantities on the author's scales, for a same-quantity check
    raw_md = raw_mean_t - raw_mean_c,
    p_t = raw_event_t / raw_n_t,
    p_c = raw_event_c / raw_n_c,
    raw_rd = p_t - p_c,
    raw_or = (p_t / (1 - p_t)) / (p_c / (1 - p_c)),
    raw_rr = p_t / p_c
  ) %>%
  mutate(
    same_quantity = case_when(
      measure_class_author == "Mean Difference" ~ near(estimate, raw_md),
      measure_class_author %in% c("Risk Difference", "Difference in Percentages") ~
        near(estimate, raw_rd) | near(estimate, 100 * raw_rd),
      measure_class_author == "Odds Ratio" ~ near(estimate, raw_or) | near(estimate, 1 / raw_or),
      measure_class_author == "Risk Ratio" ~ near(estimate, raw_rr) | near(estimate, 1 / raw_rr),
      TRUE ~ NA
    ),

    # Range of author |z| consistent with rounding of the reported p-value or CI
    # Ratio measures (author scale "log") are evaluated on the log scale.
    p_half_unit = 0.5 * 10^(-decimals(p_value)),
    ci_half_unit = 0.5 * 10^(-pmax(decimals(lower), decimals(upper))),
    z_crit = qnorm(1 - (1 - coalesce(ci_percent, 95) / 100) / 2),
    on_log = scale_author == "log",
    est_s = if_else(on_log, log(estimate), estimate),
    width_wide = if_else(on_log,
                         log(upper + ci_half_unit) - log(pmax(lower - ci_half_unit, 1e-12)),
                         upper - lower + 2 * ci_half_unit),
    width_narrow = if_else(on_log,
                           log(pmax(upper - ci_half_unit, 1e-12)) - log(lower + ci_half_unit),
                           upper - lower - 2 * ci_half_unit),
    p_z_low = qnorm(1 - pmin(p_value + p_half_unit, 1) / 2),
    p_z_high = qnorm(1 - pmax(p_value - p_half_unit, 1e-300) / 2),
    ci_z_low = abs(est_s) / (width_wide / (2 * z_crit)),
    ci_z_high = abs(est_s) / (pmax(width_narrow, 1e-12) / (2 * z_crit)),
    # The pipeline falls back to the p-value when a CI looks non-Wald or
    # asymmetric, so take the source whose range contains the stored author z.
    author_z_from = case_when(
      !is.na(ci_z_low) & abs(z_author) >= ci_z_low - 1e-6 &
        abs(z_author) <= ci_z_high + 1e-6 ~ "ci",
      !is.na(p_z_low) ~ "p",
      TRUE ~ author_z_from
    ),
    author_abs_z_low = if_else(author_z_from == "p", p_z_low, ci_z_low),
    author_abs_z_high = if_else(author_z_from == "p", p_z_high, ci_z_high),
    raw_within_rounding = abs_z_raw >= author_abs_z_low & abs_z_raw <= author_abs_z_high
  ) %>%
  relocate(any_of("band"), new_result_id, nct_id, abs_abs_z_diff, abs_z_diff,
           z_author, z_raw, adjusted_rule, same_quantity, author_z_from,
           raw_within_rounding)
}

review_sample <- add_review_fields(review_sample)

# Save -----

saveRDS(review_sample, file.path(out_dir, "manual_review_sample_v1.rds"))
write_csv(review_sample, file.path(out_dir, "manual_review_sample_v1.csv"))

print(review_sample %>% count(band))
print(band_cuts)
