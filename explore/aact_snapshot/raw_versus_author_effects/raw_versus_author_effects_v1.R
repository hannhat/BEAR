# Compare author-reported and raw-derived ClinicalTrials.gov effects for the
# same trial, outcome and pair of result groups (shared `result_id`).

library(dplyr)
library(readr)
library(ggplot2)
library(tidyr)

# Paths -----

ctgov_path <- "data/clinicaltrialsgov.rds"
author_candidates_path <- "data_raw/clinicaltrials.gov/derived/author_reported_candidates.rds"
outcome_analyses_path <- file.path(
  "data_raw/clinicaltrials.gov/13102026/briz20jy4pzxe9cbsvkjw6lki2oa",
  "outcome_analyses.txt"
)
out_dir <- "explore/aact_snapshot/raw_versus_author_effects/output"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Read -----

ctgov <- readRDS(ctgov_path)
author_candidates <- readRDS(author_candidates_path)
outcome_analyses <- read_delim(
  outcome_analyses_path, delim = "|",
  col_types = cols(.default = col_character()),
  col_select = c(id, non_inferiority_type),
  progress = FALSE
)

# Explore -----

# Rows with both author and raw effects
# A result_id with both sources is a group-pair comparison that has an
# author-reported effect and at least one raw-derived effect. The link does not
# identify the measurement or timepoint the author used.
overlap <- ctgov %>%
  filter(!is.na(result_id)) %>%
  group_by(result_id) %>%
  filter(any(effect_source == "author_reported"),
         any(effect_source == "raw_derived")) %>%
  mutate(
    new_result_id = cur_group_id(),
    n_raw = sum(effect_source == "raw_derived"),
    n_author = sum(effect_source == "author_reported"),
    n_total = n(),
    n_raw_minus_author = n_raw - n_author,
    author_effect_missing = any(effect_source == "author_reported" & is.na(effect))
  ) %>%
  ungroup() %>%
  relocate(new_result_id, n_raw, n_author, n_total, n_raw_minus_author,
           effect:z_operator, author_effect_missing)

# Results with exactly two effects: one author-reported and one raw-derived
overlap_two_effects <- overlap %>%
  filter(n_total == 2)

# Author and raw effects side by side, one row per result, with differences in
# absolute z (|z author| - |z raw|)
z_wide <- overlap_two_effects %>%
  mutate(source = if_else(effect_source == "author_reported", "author", "raw")) %>%
  select(new_result_id, nct_id, source, measure_class, scale, effect, b, se, z,
         z_operator) %>%
  pivot_wider(
    names_from = source,
    values_from = c(measure_class, scale, effect, b, se, z, z_operator),
    names_glue = "{.value}_{source}"
  ) %>%
  mutate(
    abs_z_raw = abs(z_raw),
    abs_z_diff = abs(z_author) - abs_z_raw,
    abs_abs_z_diff = abs(abs_z_diff)
  ) %>%
  relocate(new_result_id, nct_id, abs_z_diff, abs_abs_z_diff)

# Histogram of differences in absolute z
p_abs_z_diff <- ggplot(z_wide, aes(x = abs_z_diff)) +
  geom_histogram(binwidth = 0.25, boundary = 0, fill = "#2166AC") +
  coord_cartesian(xlim = c(-10, 10)) +
  labs(
    title = "Difference in absolute z, author minus raw",
    x = "|z author| - |z raw|",
    y = "Results"
  ) +
  theme_minimal()

# Overlapping histograms of differences in absolute z by author scale
p_abs_z_diff_by_scale <- ggplot(z_wide, aes(x = abs_z_diff, fill = scale_author)) +
  geom_histogram(binwidth = 0.25, boundary = 0, position = "identity",
                 alpha = 0.5) +
  scale_fill_manual(values = c(raw = "#2166AC", log = "#B2182B")) +
  coord_cartesian(xlim = c(-10, 10)) +
  labs(
    title = "Difference in absolute z by author scale",
    x = "|z author| - |z raw|",
    y = "Results",
    fill = "Author scale"
  ) +
  theme_minimal()

# Regression of the absolute difference in absolute z on the raw standard error
# Infinite author z values are excluded, since lm() cannot fit them.
fit_abs_diff_se <- lm(
  abs_abs_z_diff ~ se_raw,
  data = z_wide %>% filter(is.finite(abs_abs_z_diff))
)
summary(fit_abs_diff_se)

# Raw mean-difference z, for results where both sides are mean differences
# Continuous raw rows only (raw scale smd), where the author reported a mean
# difference. SE of the mean difference is sqrt(sd_t^2 / n_t + sd_c^2 / n_c).
z_md <- z_wide %>%
  filter(scale_raw == "smd", measure_class_author == "Mean Difference") %>%
  left_join(
    overlap_two_effects %>%
      filter(effect_source == "raw_derived") %>%
      select(new_result_id, raw_mean_t, raw_mean_c, raw_sd_t, raw_sd_c,
             raw_n_t, raw_n_c),
    by = "new_result_id"
  ) %>%
  mutate(
    b_md_raw = raw_mean_t - raw_mean_c,
    se_md_raw = sqrt(raw_sd_t^2 / raw_n_t + raw_sd_c^2 / raw_n_c),
    z_md_raw = b_md_raw / se_md_raw,
    abs_z_md_diff = abs(z_author) - abs(z_md_raw)
  ) %>%
  relocate(new_result_id, nct_id, abs_z_md_diff, abs_z_diff)

# Histogram of differences in absolute z, raw mean difference
p_abs_z_md_diff <- ggplot(z_md, aes(x = abs_z_md_diff)) +
  geom_histogram(binwidth = 0.25, boundary = 0, fill = "#2166AC") +
  coord_cartesian(xlim = c(-10, 10)) +
  labs(
    title = "Difference in absolute z, author minus raw mean difference",
    x = "|z author| - |z raw MD|",
    y = "Results"
  ) +
  theme_minimal()

# Overlapping histograms: raw z from the mean difference versus the SMD
p_abs_z_md_vs_smd <- z_md %>%
  select(new_result_id, `Mean difference` = abs_z_md_diff, SMD = abs_z_diff) %>%
  pivot_longer(-new_result_id, names_to = "raw_scale", values_to = "abs_z_diff") %>%
  ggplot(aes(x = abs_z_diff, fill = raw_scale)) +
  geom_histogram(binwidth = 0.25, boundary = 0, position = "identity",
                 alpha = 0.5) +
  scale_fill_manual(values = c(`Mean difference` = "#2166AC", SMD = "#B2182B")) +
  coord_cartesian(xlim = c(-10, 10)) +
  labs(
    title = "Difference in absolute z by raw scale, same results",
    x = "|z author| - |z raw|",
    y = "Results",
    fill = "Raw scale"
  ) +
  theme_minimal()

# SMD recomputed treating the entered SDs as SEs
# The entered value is taken as an SE and converted with SD = SE * sqrt(n);
# Hedges' g, its SE and z then follow the pipeline formulas.
z_md <- z_md %>%
  mutate(
    sd_t_from_se = raw_sd_t * sqrt(raw_n_t),
    sd_c_from_se = raw_sd_c * sqrt(raw_n_c),
    pooled_sd_from_se = sqrt(
      ((raw_n_t - 1) * sd_t_from_se^2 + (raw_n_c - 1) * sd_c_from_se^2) /
        (raw_n_t + raw_n_c - 2)
    ),
    hedges_j = 1 - 3 / (4 * (raw_n_t + raw_n_c) - 9),
    b_smd_se_rule = hedges_j * (raw_mean_t - raw_mean_c) / pooled_sd_from_se,
    se_smd_se_rule = sqrt(
      (raw_n_t + raw_n_c) / (raw_n_t * raw_n_c) +
        b_smd_se_rule^2 / (2 * (raw_n_t + raw_n_c - 2))
    ),
    z_smd_se_rule = b_smd_se_rule / se_smd_se_rule,
    abs_z_smd_se_rule_diff = abs(z_author) - abs(z_smd_se_rule)
  )

# Results where treating the SDs as SEs brings the raw z closer to the author z
se_rule_better <- z_md %>%
  filter(abs(abs_z_smd_se_rule_diff) < abs(abs_z_diff))

# Percent difference in absolute z, relative to the raw z
# Undefined when the raw z is 0 (172 results), and very large when it is near 0.
z_wide <- z_wide %>%
  mutate(pct_z_diff = 100 * abs_z_diff / abs_z_raw)

# Histogram of percent differences in absolute z
# Plotted range only: near-zero raw z values push some percentages into the
# millions, which is too many bins for geom_histogram().
p_pct_z_diff <- z_wide %>%
  filter(between(pct_z_diff, -100, 300)) %>%
  ggplot(aes(x = pct_z_diff)) +
  geom_histogram(binwidth = 5, boundary = 0, fill = "#2166AC") +
  labs(
    title = "Percent difference in absolute z, author relative to raw",
    x = "100 x (|z author| - |z raw|) / |z raw|",
    y = "Results"
  ) +
  theme_minimal()

# Regression of the difference in absolute z on the absolute raw z
fit_abs_diff_raw_z <- lm(
  abs_z_diff ~ abs_z_raw,
  data = z_wide %>% filter(is.finite(abs_z_diff))
)
summary(fit_abs_diff_raw_z)

# Discrepancies for author z just above 1.96 versus other author z below 10
# Exact author z only: bounds such as p < 0.05 are stored as z = 1.96.
z_near_threshold <- z_wide %>%
  filter(z_operator_author == "=", is.finite(abs_z_diff)) %>%
  mutate(
    abs_z_author = abs(z_author),
    author_z_group = case_when(
      between(abs_z_author, 1.96, 2.10) ~ "|z author| 1.96-2.10",
      abs_z_author < 10 ~ "Other |z author| < 10"
    )
  ) %>%
  filter(!is.na(author_z_group))

# Overlapping histograms on the density scale, since the groups differ in size
p_z_diff_near_threshold <- ggplot(z_near_threshold,
                                  aes(x = abs_z_diff, fill = author_z_group)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 0.1, boundary = 0,
                 position = "identity", alpha = 0.5) +
  scale_fill_manual(values = c(`|z author| 1.96-2.10` = "#B2182B",
                               `Other |z author| < 10` = "#2166AC")) +
  coord_cartesian(xlim = c(-4, 4)) +
  labs(
    title = "Difference in absolute z by author z group",
    x = "|z author| - |z raw|",
    y = "Density",
    fill = NULL
  ) +
  theme_minimal()







# Write-up figures -----

# All author rows, with the source of the z-value (CI or p-value) from step 07,
# AACT's non_inferiority_type, and whether the row enters BEAR.rds (the
# filters in workflow/build_bear.R)
author_rows <- ctgov %>%
  filter(effect_source == "author_reported") %>%
  left_join(author_candidates %>% select(author_effect_id, z_source),
            by = "author_effect_id") %>%
  left_join(outcome_analyses %>% rename(outcome_analysis_id = id),
            by = "outcome_analysis_id") %>%
  mutate(
    param_type_lower = tolower(coalesce(param_type, "")),
    in_bear = include_in_bear & study_type %in% "INTERVENTIONAL" &
      allocation %in% "RANDOMIZED" & n_effect_rows_per_study < 20 & !is.na(z)
  )

# A line in the two ratio histograms marks |z| = 10

# Ratios reported as percentages: log-scale rows with a CI-derived z and '%',
# 'percent' or 'x 100' in param_type. Their z tests the ratio against 1, not
# 100. Raw-scale rows with these words are percentage-point differences,
# whose z is unaffected.
pct_ratio_rows <- author_rows %>%
  filter(z_source == "ci", scale == "log",
         grepl("%|percent|x ?100|× ?100", param_type_lower))

pct_ratio_counts <- pct_ratio_rows %>%
  summarise(rows = n(), rows_in_bear = sum(in_bear))

p_z_pct_ratio <- ggplot(pct_ratio_rows, aes(x = abs(z))) +
  geom_histogram(bins = 60, fill = "#2166AC") +
  geom_vline(xintercept = 10, colour = "black") +
  annotate("text", x = 10, y = Inf, label = "|z| = 10", hjust = -0.1,
           vjust = 1.5) +
  scale_x_continuous(trans = scales::pseudo_log_trans(base = 10),
                     breaks = c(0, 1, 2, 5, 10, 30, 100, 300, 1000)) +
  labs(
    title = "Author z for ratios reported as percentages",
    subtitle = "CI-derived z; '%', 'percent' or 'x 100' in param_type",
    x = "|z author| (pseudo-log scale)",
    y = "Rows"
  ) +
  theme_minimal()

# Geometric mean ratios: CI-derived z with 'geometric mean ratio' in
# param_type, excluding the rows above
gmr_rows <- author_rows %>%
  filter(z_source == "ci", grepl("geometric mean ratio", param_type_lower),
         !author_effect_id %in% pct_ratio_rows$author_effect_id)

gmr_counts <- gmr_rows %>%
  summarise(
    rows = n(),
    rows_in_bear = sum(in_bear),
    rows_z_10 = sum(abs(z) >= 10),
    rows_z_10_in_bear = sum(abs(z) >= 10 & in_bear)
  )

p_z_gmr <- ggplot(gmr_rows, aes(x = abs(z))) +
  geom_histogram(bins = 60, fill = "#2166AC") +
  geom_vline(xintercept = 10, colour = "black") +
  annotate("text", x = 10, y = Inf, label = "|z| = 10", hjust = -0.1,
           vjust = 1.5) +
  scale_x_continuous(trans = scales::pseudo_log_trans(base = 10),
                     breaks = c(0, 1, 2, 5, 10, 30, 100, 300, 1000)) +
  labs(
    title = "Author z for geometric mean ratios",
    subtitle = "CI-derived z; 'geometric mean ratio' in param_type, without '%', 'percent' or 'x 100'",
    x = "|z author| (pseudo-log scale)",
    y = "Rows"
  ) +
  theme_minimal()

# Non-inferiority and equivalence analyses whose z comes from the p-value,
# with no CI bound reported. The p-value tests a margin, not no difference.
ni_types <- c("NON_INFERIORITY", "EQUIVALENCE", "NON_INFERIORITY_OR_EQUIVALENCE",
              "NON_INFERIORITY_OR_EQUIVALENCE_LEGACY")

ni_p_rows <- author_rows %>%
  filter(non_inferiority_type %in% ni_types, z_source == "p",
         is.na(lower), is.na(upper))

ni_p_counts <- ni_p_rows %>%
  summarise(rows = n(), rows_in_bear = sum(in_bear),
            rows_z_infinite = sum(is.infinite(z)))

# Infinite z values (p = 0) cannot be binned and are left out of the plot
p_z_ni_p <- ggplot(ni_p_rows %>% filter(is.finite(z)), aes(x = abs(z))) +
  geom_histogram(binwidth = 0.1, boundary = 0, fill = "#2166AC") +
  labs(
    title = "Author z from non-inferiority and equivalence p-values",
    subtitle = "z from the p-value; no CI reported",
    x = "|z author|",
    y = "Rows"
  ) +
  theme_minimal()

# Disagreement with the raw effect for p-derived author z, non-inferiority and
# equivalence versus other analyses. Author and raw rows are linked as in step
# 09 (shared result_id); each author row keeps its closest raw match, since a
# result can hold raw rows for other measurements or timepoints.
ni_linked <- author_rows %>%
  filter(!is.na(result_id), z_source == "p", is.finite(z)) %>%
  select(author_effect_id, result_id, z_author = z, non_inferiority_type) %>%
  inner_join(
    ctgov %>%
      filter(effect_source == "raw_derived", is.finite(z)) %>%
      select(result_id, z_raw = z),
    by = "result_id",
    relationship = "many-to-many"
  ) %>%
  mutate(abs_z_diff = abs(z_author) - abs(z_raw)) %>%
  group_by(author_effect_id) %>%
  slice_min(abs(abs_z_diff), n = 1, with_ties = FALSE) %>%
  ungroup() %>%
  mutate(analysis_type = if_else(non_inferiority_type %in% ni_types,
                                 "Non-inferiority / equivalence", "Other"))

ni_linked_summary <- ni_linked %>%
  group_by(analysis_type) %>%
  summarise(
    rows = n(),
    median_abs_diff = median(abs(abs_z_diff)),
    share_author_larger = mean(abs_z_diff > 0),
    share_sig_author_only = mean(abs(z_author) >= 1.96 & abs(z_raw) < 1.96),
    .groups = "drop"
  )

# Density scale, since the groups differ in size
p_ni_linked <- ggplot(ni_linked, aes(x = abs_z_diff, fill = analysis_type)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 0.1, boundary = 0,
                 position = "identity", alpha = 0.5) +
  scale_fill_manual(values = c(`Non-inferiority / equivalence` = "#B2182B",
                               Other = "#2166AC")) +
  coord_cartesian(xlim = c(-4, 4)) +
  labs(
    title = "Difference in absolute z for p-derived author z, by analysis type",
    subtitle = "Closest raw match per author row",
    x = "|z author| - |z raw|",
    y = "Density",
    fill = NULL
  ) +
  theme_minimal()

# Save write-up figures
ggsave(file.path(out_dir, "z_pct_ratio.png"), p_z_pct_ratio, width = 7, height = 4)
ggsave(file.path(out_dir, "z_gmr.png"), p_z_gmr, width = 7, height = 4)
ggsave(file.path(out_dir, "z_ni_p.png"), p_z_ni_p, width = 7, height = 4)
ggsave(file.path(out_dir, "z_diff_ni_linked.png"), p_ni_linked, width = 7, height = 4)
