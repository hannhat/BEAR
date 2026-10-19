# Collect every author/raw z discrepancy at or above the 95th percentile for
# full manual review, with diagnostic alternative raw z values and a
# first-pass mechanism label. Same population as manual_review_sample_v1.R:
# exact author z values with |z raw| < 10.

library(dplyr)
library(readr)

# Builds review_pool, band_cuts and add_review_fields()
source("explore/aact_snapshot/raw_versus_author_effects/manual_review_sample_v1.R")

out_dir <- "explore/aact_snapshot/raw_versus_author_effects/output"

# Tail -----

review_tail <- review_pool %>%
  filter(abs_abs_z_diff > band_cuts[[4]]) %>%
  add_review_fields()

# Diagnostics -----

# Alternative raw z values from the same inputs. A close match to the author z
# points to a scale or test choice; a match under the SE rule points to
# standard errors entered as standard deviations.
review_tail <- review_tail %>%
  mutate(
    df = raw_n_t + raw_n_c - 2,
    pooled_sd = sqrt(((raw_n_t - 1) * raw_sd_t^2 + (raw_n_c - 1) * raw_sd_c^2) / df),
    z_t_pooled = abs(qnorm(pt(-abs(raw_md / (pooled_sd * sqrt(1 / raw_n_t + 1 / raw_n_c))), df))),
    z_md_unpooled = abs(raw_md / sqrt(raw_sd_t^2 / raw_n_t + raw_sd_c^2 / raw_n_c)),
    z_md_se_rule = abs(raw_md / sqrt(raw_sd_t^2 + raw_sd_c^2)),
    z_logor = abs(log(raw_or) / sqrt(1 / raw_event_t + 1 / (raw_n_t - raw_event_t) +
                                       1 / raw_event_c + 1 / (raw_n_c - raw_event_c))),
    z_rd = abs(raw_rd / sqrt(p_t * (1 - p_t) / raw_n_t + p_c * (1 - p_c) / raw_n_c)),
    abs_z_author = abs(z_author),
    alt_gap = if_else(
      scale_raw == "probit",
      pmin(abs(abs_z_author - z_logor), abs(abs_z_author - z_rd), na.rm = TRUE),
      pmin(abs(abs_z_author - z_t_pooled), abs(abs_z_author - z_md_unpooled), na.rm = TRUE)
    ),
    se_rule_gap = abs(abs_z_author - z_md_se_rule),
    abs_g = abs(b_raw),
    cv = (raw_sd_t + raw_sd_c) / (abs(raw_mean_t) + abs(raw_mean_c)),
    first_pass = case_when(
      scale_raw == "smd" & se_rule_gap <= pmax(0.25, 0.15 * abs_z_author) ~ "se_as_sd",
      alt_gap <= pmax(0.25, 0.10 * abs_z_author) & scale_raw == "probit" ~ "probit_scale",
      alt_gap <= pmax(0.25, 0.10 * abs_z_author) ~ "test_choice",
      TRUE ~ "unexplained"
    )
  ) %>%
  arrange(desc(abs_abs_z_diff))

# Save -----

saveRDS(review_tail, file.path(out_dir, "manual_review_tail_v1.rds"))
write_csv(review_tail, file.path(out_dir, "manual_review_tail_v1.csv"))

message(nrow(review_tail), " results above the 95th percentile (",
        round(band_cuts[[4]], 3), ")")
print(count(review_tail, scale_raw, first_pass))
