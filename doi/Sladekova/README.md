# Sladekova meta-analysis DOIs

Run `Rscript --vanilla doi/Sladekova/lookup_meta.R` before the ordinary
[processor](../../process/Sladekova/Sladekova.R). It obtains the 2008/2018 paper
sampling inventories from the linked
phase-one project (https://osf.io/txbnz/) and checks supplied identifiers against
the publication-bias project's coded metadata (https://osf.io/yzu9c/).

The original paper key, such as A35, joins the publication to all of its
imported analyses, such as A35_1.csv. `doi_meta` identifies that meta-analytic
paper, rather than Sladekova et al. (2023) or its included primary studies.
The 88 retained paper keys have 87 source DOIs. Valid coded identifiers agree
with the sampling inventories; conflicting assignments are withheld.

A191 (Acker, 2008) remains missing by maintainer decision on 13 October 2026.
The publisher's later archive provides 10.1017/S1930297500000863, but lists a
2023 online date; this identifier has not been attached. Primary-study DOI
matching is deferred. No new DOI is used to change a study grouping.

Source downloads, audit tables and the accepted mapping are ignored local
files. Without the optional mapping, the processor leaves `doi_meta` missing.

The same mapping retains the authors' `psych_subfield` as `topic`. Categories
are attached only when the populated coder assignments agree. B281 has Social
and Clinical codes and remains unassigned by maintainer decision; 87/88 papers
(11,558 estimate rows) have a topic. These describe the source meta-analytic
paper rather than a new classification of each primary estimate.
