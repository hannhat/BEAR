# ClinicalTrials.gov Snapshot Comparison

This is a BEAR-internal, maintainer-facing exploration. It was developed with
LLM assistance and should be treated as scratch analysis code, not as polished
paper documentation.

It compares ClinicalTrials.gov effects built from different AACT snapshots, to
check that a snapshot refresh changes the data only in expected ways.

`ctgov_snapshot_comparison_v1.R` compares author-reported rows in the August
2025 public file (`BEAR_data` commit `b0f8860`, which is author-only) with the
13 October 2026 rebuild. It reports which trials were added or dropped, the
registry status of dropped trials, when added trials first posted results, and
how many rows match exactly within trials present in both files. The old file
has no outcome-analysis ID, so rows are matched as a multiset on rounded
`measure_class`, `b`, `se`, `z` and `z_operator` within each trial.

Inputs:

- `data_raw/clinicaltrials.gov/_archive/clinicaltrialsgov_BEAR_data_b0f8860.rds`
- `data/clinicaltrialsgov.rds` (13 October 2026 rebuild)
- `studies.txt` from the 13 October 2026 AACT snapshot

Run from the project root with:

```r
Rscript --vanilla explore/aact_snapshot/ctgov_snapshot_comparison/ctgov_snapshot_comparison_v1.R
```

Outputs, written to the ignored `output/` folder:

- `trial_presence_v1.csv`: one row per trial, with row counts in each file
  and current registry status
- `trial_summary_v1.csv`: trials and rows by presence (both, old only, new only)
- `old_only_status_v1.csv`: registry status and last-update year of dropped trials
- `new_only_posting_year_v1.csv`: results-posting year of added trials
- `row_match_summary_v1.csv`: row matching within shared trials
- `old_rows_not_in_new_v1.rds` and `.csv`: every old row with no match in the
  new file, with all old columns plus `old_only_reason`
  (`trial_absent_from_new` or `row_not_matched_in_new`), the trial's status
  and last update in the new snapshot, and its row counts in each file

Raw-derived rows cannot be compared yet, because no August 2025 raw-derived
output is available locally.
