# TrialScout Linkage

This is a BEAR-internal, maintainer-facing exploration. It was developed with
LLM assistance and should be treated as scratch analysis code, not as polished
paper documentation.

It explores how to link the TrialScout trial sample to BEAR's
ClinicalTrials.gov data.

TrialScout (Love Ahnström, Karolinska Institutet) finds publications linked
to trial registrations and uses large language models to judge whether each
publication reports the trial's results. Its analysis sample, built by
`analysis/code/1-processing_ctgov.R` in the TrialScout repository, is a simple
random sample (`set.seed(42)`) of 9,600 ClinicalTrials.gov studies from a
12 February 2026 export, keeping interventional studies that are completed or
terminated, with a primary completion date (or completion date) up to
September 2022. `year_bin` and `enrollment_bin` are descriptive only and were
not used in the draw. The sample is not restricted to randomized trials or to
trials with posted results, unlike BEAR's ClinicalTrials.gov rows.

References:

- TrialScout article: https://www.sciencedirect.com/science/article/pii/S0895435626003604
- TrialScout code and data: https://github.com/lahnstrom/trialscout

Inputs:

- `data/clinicaltrialsgov.rds`: BEAR's ClinicalTrials.gov dataset.
- `data_raw/clinicaltrials.gov/trialscout_sample/finalSample.rda`: the
  TrialScout sample, a single data.table `df` with one row per trial (9,600
  trials, keyed by `NCT Number`) in ClinicalTrials.gov's study-export format.
  Not tracked; download `analysis/data/finalSample.rda` from the TrialScout
  repository.

Run from the BEAR root:

```r
source("explore/trialscout/trialscout_linkage_v1.R")
```
