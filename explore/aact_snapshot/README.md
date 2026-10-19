# AACT Snapshot Explorations

This is a BEAR-internal, maintainer-facing folder for explorations of the
ClinicalTrials.gov data built from AACT snapshots. It was developed with LLM
assistance and should be treated as scratch analysis code, not as polished
paper documentation.

Subfolders:

- `ctgov_snapshot_comparison/`: compares effects built from different AACT
  snapshots, to check that a snapshot refresh changes the data only in
  expected ways.
- `raw_versus_author_effects/`: compares author-reported effects with effects
  derived from raw arm-level data for the same comparison.

Each subfolder has its own README, changelog, versioned scripts and an ignored
`output/` folder. Run scripts from the project root.
