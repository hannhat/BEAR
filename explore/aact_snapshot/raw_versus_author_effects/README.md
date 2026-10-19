# Raw-Derived Versus Author-Reported Effects

This is a BEAR-internal, maintainer-facing exploration. It was developed with
LLM assistance and should be treated as scratch analysis code, not as polished
paper documentation.

It compares author-reported ClinicalTrials.gov effects with effects BEAR
derives from raw arm-level data (group means, SDs and counts), to check
whether they disagree and, if so, whether the disagreement is real or a
processing problem.

`raw_versus_author_effects_v1.R` selects the comparisons that have both an
author-reported row and at least one raw-derived row, linked by `result_id`
(same trial, outcome and unordered pair of result groups). The link does not
identify the measurement or timepoint the author used, and the two sources
are usually on different scales (raw: SMD or probit difference; author: mostly
mean differences and ratios), so matched rows are not directly comparable
without further work.

Input:

- `data/clinicaltrialsgov.rds` (13 October 2026 rebuild)

Run from the project root with:

```r
Rscript --vanilla explore/aact_snapshot/raw_versus_author_effects/raw_versus_author_effects_v1.R
```

Outputs, written to the ignored `output/` folder:

- `overlap_rows_v1.rds`: all rows in comparisons with both sources
- `overlap_summary_v1.csv`: rows by source and `measure_class`
