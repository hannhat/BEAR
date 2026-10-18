# Changelog

## 2026-10-18

- Added `ctgov_snapshot_comparison_v1.R`, comparing author-reported rows in
  the August 2025 public file with the 13 October 2026 rebuild.
- First run: 20,317 trials in both files, 1,751 added (6,375 rows; 1,630
  first posted results in 2025-2026) and 25 dropped (51 rows). Within shared
  trials, 69,480 of 69,941 old rows match exactly and 20,082 trials are
  identical.
- Added the `old_rows_not_in_new_v1` output: 512 old rows from 256 trials
  (51 from dropped trials, 461 unmatched rows in 231 shared trials).
