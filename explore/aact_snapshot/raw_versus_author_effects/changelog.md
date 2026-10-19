# Changelog

## 2026-10-18

- Added `raw_versus_author_effects_v1.R`, which selects comparisons with both
  an author-reported and a raw-derived row (shared `result_id`).
- First run: 13,194 comparisons from 6,278 trials; 16,601 author-reported rows
  and 20,968 raw-derived rows (13,353 SMD, 7,615 probit). The raw count equals
  the raw rows marked `include_in_bear = FALSE`. 5,797 of the author rows have
  no `measure_class`.
- Added `manual_review_sample_v1.R`: seeded 10% sample (262 per band) from
  the 5-35, 35-65 and 65-95 percentile bands of | |z author| - |z raw| |
  (exact author z, |z raw| < 10), with review fields, AACT free text and
  rule-based flags. Field and rule code is in `add_review_fields()`.
- Added `manual_review_tail_v1.R`: every comparison above the 95th percentile
  (438), with alternative raw z values and a first-pass mechanism label.
- Main finding from the tail: author ratios reported x100 (null 100) are
  treated as ratios with null 1, giving spuriously large author z; about 2.9%
  of all author rows match. Other tail causes: probit and SMD-ceiling
  artefacts, SE-as-SD entries, non-inferiority/equivalence p-values, and
  legitimate analysis differences.
