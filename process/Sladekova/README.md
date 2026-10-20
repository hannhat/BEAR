(This documentation was generated post-hoc by an LLM based on explorations
we conducted to prepare this code.)

# Sladekova: evidence for the effect-scale classifications

The supplied datasets contain several cases where an effect estimate and its
variance describe different scales. We identified these by following the
authors' public preparation code and checking the exported numbers. The paper
does not explicitly describe these mismatches. Some cases are directly visible
in the code; others require further source checks before a correction can be
chosen.

BEAR includes only the **2,758 clearly Fisher-transformed estimates**. The
individual `data/Sladekova.rds` retains all 11,634 estimates and the supplied
effects and variances, with the classifications documented here. This note
records the local review of 13–14 October 2026; its counts refer to the 406
imported CSVs, rather than all 433 datasets reported in the paper.

## Files and processing

Run the processor from the BEAR project root:

```sh
Rscript --vanilla process/Sladekova/Sladekova.R
```

`Sladekova.R` reads the source CSVs under `data_raw/Sladekova/data/` and the
accompanying [metadata.csv](metadata.csv). Each metadata row names the exported
effect and variance columns, the supported sample-size fields, the authors'
preparation-script URL, and the evidence for the classification. The processor
does not download or execute the authors' scripts.

The individual file sets `b` to the supplied `yi`, `se` to the square root of
the supplied `vi`, and `z` to their ratio. Variance is the square of a standard
error and must describe uncertainty on the same scale as the effect. For
already-Fisher-transformed effects, processing uses the shared helper in
[R/z_derivation_helpers.R](../../R/z_derivation_helpers.R), preserving the
supplied effect and standard error without transforming them again. The
combined-data workflow includes only rows with `effect_scale = "fisher_z"`.
Keeping the other ratios in the individual file does not establish that they
reproduce valid significance tests.

| `effect_scale` | Estimates | Source CSVs | Basis |
|---|---:|---:|---|
| `fisher_z` | 2,758 | 70 | The effect is Fisher-transformed and the variance is on that scale. |
| `raw` | 5,013 | 188 | The effect and variance are on the raw-correlation scale. |
| `raw correlation and Fisher variance` | 3,380 | 139 | The exported effect is a raw correlation, but the variance is calculated for a Fisher-transformed correlation. |
| `possible mismatch` | 230 | 8 | B680 combines correlations and variances on different scales; A23 transforms effects without corresponding variance changes. |
| `unclear` | 253 | 1 | B364 does not establish the scale of its imported effect. |

Counts are estimate rows, not independent studies. A paper can contribute
several datasets, and those datasets can reuse the same studies.

## What has to match

A raw correlation $r$ and its Fisher transformation
$f=\operatorname{atanh}(r)$ express the same association differently. The
transformation increasingly stretches the scale as the correlation approaches
−1 or 1. Its variance must therefore describe uncertainty on the transformed
scale, rather than uncertainty around the original correlation.

For an ordinary correlation with sample size $n$, common approximations are

\[
\operatorname{Var}(r)\approx\frac{(1-r^2)^2}{n-1},\qquad
\operatorname{Var}(f)\approx\frac{1}{n-3}.
\]

The authors' `vr_raw()` and `vz()` helpers use these respective formulas.
`vz()` returns 1 for sample sizes below four; that guard does not establish a
valid Fisher variance for such samples. Converted, corrected and combined
correlations may require different uncertainty calculations.

For example, with $r=0.5$ and $n=100$, the raw standard error is about 0.0754,
whereas the Fisher standard error is about 0.1015. The Fisher effect is about
0.5493, giving an effect/SE ratio of 5.41. Pairing the raw effect 0.5 with that
Fisher SE instead gives 4.92. The distinction is small near zero and grows at
larger correlations. These are approximate ratios; even a correctly paired
raw-correlation ratio need not reproduce the usual Pearson correlation test.

## Raw correlations paired with Fisher variances: 3,380 estimates

This classification is based on the preparation code, rather than just column
names or the range of the observed effects. The metadata identifies the raw
effect column and traces the variance calculation to the authors' Fisher
variance helper. The source checks also compare the exported `yi` and `vi`
with those named columns.

The code establishes that the Fisher variance formula accompanies a raw
effect. It does not establish whether this was accidental or an intended
approximation around a zero correlation. We have not asked the authors to
clarify that choice.

### A104: a Fisher variance stored under a raw-looking name

The [A104 preparation script](https://osf.io/download/mqvcg/) builds raw
correlations from its source data, including averages within study groups. It
then assigns `r = es_r1` or `r = es_r2` and `vr = vz(n)`. Despite the name
`vr`, the latter is a Fisher variance. The script fits models with `yi = r`
and `vi = vr`, then exports the same pair.

We checked the authors' [saved A104_1 model](https://osf.io/download/cr6np/).
Its full input vectors match the supplied CSV, allowing for missing rows; its
113 included effects are raw correlations and its variances equal
$1/(n-3)$. This shows that the pair was actually used in a fitted model, rather
than appearing only in an unused export instruction. The local A104 files
contain **796 retained estimates across 24 datasets**.

### A234: the transformed effect exists but is not selected

The [A234 preparation script](https://osf.io/download/5fc5065eab651803dbb115b1/)
calculates `z = r_to_z(es_r)` and `vz = vz(n)`. It therefore creates a
Fisher-transformed effect and a matching variance. However, its model calls and
exports select `es_r`, the raw correlation, together with `vz`.

We checked the authors' [saved A234_1 model](https://osf.io/download/5fc50839c62319042cd807bc/):
all 15 input effects and variances match that exported pair. Across its three
local datasets, A234 contributes **90 estimates**. Simply detecting the
presence of a column named `z` would have missed the problem: the relevant
question is which effect was paired with the variance in the fitted model and
export.

### Coverage of this classification

The following source-paper keys account for all 3,380 estimates in this
category. The metadata gives the particular exported columns and public script
URL for every constituent CSV.

| Paper key | Estimates | CSVs |
|---|---:|---:|
| A104 | 796 | 24 |
| A11 | 56 | 2 |
| A114 | 569 | 22 |
| A16 | 93 | 4 |
| A234 | 90 | 3 |
| A249 | 54 | 2 |
| A259 | 43 | 2 |
| A264 | 36 | 1 |
| A46 | 28 | 3 |
| A52 | 105 | 14 |
| A68 | 126 | 5 |
| B230 | 196 | 1 |
| B281 | 76 | 1 |
| B319 | 276 | 14 |
| B338 | 134 | 19 |
| B460 | 136 | 4 |
| B506 | 55 | 1 |
| B544 | 80 | 4 |
| B660 | 20 | 3 |
| B663 | 60 | 1 |
| B67 | 59 | 1 |
| B693 | 146 | 1 |
| B7 | 81 | 1 |
| B747 | 65 | 6 |

## Possible mismatch: 230 estimates

### B680: average raw correlations with combined Fisher variances

B680 contributes **166 estimates across six datasets**. Its
[preparation script](https://osf.io/download/5fc506abc62319042bd7fe16/) forms
`average.es` by averaging raw correlations. It separately starts the
uncertainty calculation with `tot.var = 1/(total.n - 3)`, combines these
variances using information about related outcomes, and exports
`yi = es.agg` with `vi = composite.var.agg`. Thus, the point estimate remains
an average of raw correlations while the variance calculation starts on the
Fisher scale.

We label this a possible mismatch because the appropriate correction requires
reviewing the averaging and dependence calculations together. Applying
Fisher's transformation to an average is generally different from averaging
the individually transformed correlations. Replacing the variance with
$1/(n-3)$ would also discard the source's attempt to account for related
outcomes. Neither shortcut establishes a defensible correction.

The exported `total.n.agg` is an average of source sample sizes. BEAR leaves
the analytical sample size missing for these rows because that average does
not establish the number of participants contributing to the combined effect.

### A23: standardised log rates with original-scale variances

A23 contributes **64 rows across two datasets** about non-paternity rates.
The [preparation script](https://osf.io/download/5fc5063ec62319042bd7fc9f/)
sets `NP = es`, takes its logarithm, and then centres and standardises the
logged values to form `std_logNP`. However, it constructs `v` from the
original effect and upper confidence bound using `var_from_ci(es, ci_upper)`.
That helper calculates $[(\mathrm{upper}-\mathrm{effect})/1.96]^2$.

The models and exported files pair `std_logNP` with `v`. No corresponding
adjustment of the variance for the logarithm or subsequent standardisation is
visible in this code. The exported effects are also transformed rates, rather
than correlations, so an ordinary correlation-to-Fisher conversion would not
resolve the issue. The two analyses use different year predictors and should
not be interpreted as 64 independent studies.

The authors' downstream adjustment loops explicitly skip A23. Its baseline
results are included separately in their combined results table, while the
adjusted entries are missing. We therefore do not claim that these 64 rows
contributed to every reported comparison of publication-bias adjustments.

## Unclear scale: B364's 253 estimates

The [B364 preparation script](https://osf.io/download/5fc5068ac62319042bd7fdad/)
assigns `z = es` and `vz = vz(n)`, fits a model using these fields, and exports
`yi = es` with `vi = vz`. It does not explicitly transform `es` or establish
whether the imported values were already Fisher-transformed.

We therefore use `unclear`, rather than asserting a mismatch. If `es` already
contains Fisher-transformed correlations, the pairing could be appropriate.
If it contains raw correlations, it has the same scale problem described for
A234. The values themselves cannot settle this: Fisher-transformed effects
can also lie between −1 and 1. Resolving the classification requires checking
the original extraction and the meaning of the imported `es` field.

## Which pairs entered the authors' analyses?

There is direct evidence for use in both baseline and adjusted analyses.
The saved A104_1 and A234_1 models verify baseline use, and both datasets have
adjusted entries in the authors' [final results table](https://osf.io/download/fz4rd/).
The [conditional adjustment script](https://osf.io/download/krw36/) reads the
exported CSVs and passes their `yi` and `vi` directly to methods such as PET
and PEESE. Consequently, the preparation-stage pairings carry through to these
methods unless a particular dataset is skipped or excluded.

The [main analysis script](https://osf.io/download/82dsg/) excludes A104_3,
A104_8, A52_2 and B338_4, among other datasets. Those source files remain in
the individual Sladekova file. A23 has the separate treatment described in its
section. These qualifications matter: finding a questionable pair in the
source package does not establish its contribution to every published model.

The evidence concerns Sladekova and colleagues' preparation and reanalysis.
We have not established that the authors of the earlier meta-analytic papers
used the same variance calculations, nor reproduced the entire published
analysis or assessed how corrections would change its conclusions. The
[paper](https://doi.org/10.1037/met0000470), in its Reanalysis Procedure,
describes reproduction of the source analyses and conversion to correlations;
our more specific classifications come from the code and exported data.

## Why BEAR restricts inclusion

Keeping correctly paired raw effects still leaves a separate question about
the interpretation of their effect/SE ratios. In the current individual file,
raw-scale rows have mean absolute z of 10.12 and median 2.81, compared with
3.67 and 2.12 for Fisher-scale rows. Much of the raw group's heavy tail comes
from A181's 1,627 estimates: removing that paper reduces the raw group's mean
to 3.66 and median to 2.23. This is evidence that the choice of entries matters,
but the groups also differ in their source papers and sample sizes.

Near boundary correlations, the usual estimated raw SE approaches zero and
the raw effect/SE ratio can become extremely large. For example, the supplied
A181 effect 0.999 with a sample size of 30 produces a ratio of about 2,689.
This is a concern about the interpretation of the ratio, even though its
effect and variance have matching scale labels. Fisher-scale ratios also use
a large-sample approximation and need not reproduce the exact Pearson test.

BEAR therefore uses the clearly Fisher-transformed rows and preserves the
other source values in the individual file for further investigation. No
automatic repair is applied to the mismatches. A future correction should
establish the original effect, the matching variance, and the intended test
before changing these rows.

## Local evidence and checks

Local source material is kept under `data_raw/Sladekova/` and is not tracked:

- `source_scripts/` contains the downloaded preparation scripts and helpers;
  `source_index.json` records their public URLs. The downstream scripts cited
  here are also retained locally.
- `validation/author_analysis/` contains the two checked saved models, the
  final results CSV and their download URLs in `sources.json`.
- `validation/scale_pairing_audit.R` and its CSV outputs record the scale
  counts and descriptive comparisons. They are supporting audit material,
  not inputs to ordinary processing.

Run `Rscript --vanilla tests/test_sladekova.R` to check the exported source
columns, preserved numerical values, classifications and Fisher-only BEAR
inclusion. Run `Rscript --vanilla tests/test_correlation_derivation.R` to check
the shared helper's transformation, supplied Fisher SEs and boundary handling.
These checks substantiate the implementation; unresolved source meanings
still require review.
