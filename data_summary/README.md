# Dataset summaries

These Markdown files summarise the saved individual datasets in `data/` and
the combined `BEAR.rds`. Track them to review changes in row counts, column
types, missingness and distributions. They describe each complete saved file,
which may contain rows or columns excluded from the combined BEAR dataset.

Source `R/write_summary.R` near the top of each processing script and replace
the final `saveRDS()` call with `save_rds_summary()`:

```r
source("R/write_summary.R")
save_rds_summary(df, "data/Example.rds")
```

This saves the dataset and writes `data_summary/Example.md`. Arguments such
as `compress` and `version` are passed through to `saveRDS()`. For a summary
alone, use `write_summary(df, "data_summary/Example.md")`.

Run `Rscript --vanilla workflow/write_data_summaries.R` from the project root
to refresh all summaries from existing saved files. This does not rewrite the
datasets. Summaries omit timestamps and memory sizes so unchanged data produce
unchanged files. Review and include summary diffs whenever data change.

Tables are grouped by variable type and aligned for reading as plain text.
Numeric variables show mean, sample SD, minimum, maximum and a five-bin
histogram. Statistics and histograms use finite values; infinity counts are
shown when present. Missing values have their own count.

Character and factor variables show missing, unique and empty counts. The
three most common values are included only when there are at most ten unique
values. Fields with names indicating IDs, references, authors, citations,
DOIs, PMIDs, trial registrations, titles, labels, names or URLs omit these
counts. Adjust `top_n` or `max_categories` in `write_summary()` when needed.
