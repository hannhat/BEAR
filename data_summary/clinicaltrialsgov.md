# clinicaltrialsgov

- Rows: 151,248
- Columns: 94

## Variable type: character

|Variable                  | Missing| Unique| Empty|Common                                                   |
|:-------------------------|-------:|------:|-----:|:--------------------------------------------------------|
|effect_id                 |       0| 151248|     0|                                                         |
|author_effect_id          |   81321|  69927|     0|                                                         |
|raw_effect_id             |   69927|  81321|     0|                                                         |
|effect_source             |       0|      2|     0|raw_derived: 81321; author_reported: 69927               |
|result_id                 |   33608|  54183|     0|                                                         |
|nct_id                    |       0|  27435|     0|                                                         |
|outcome_id                |       0|  51370|     0|                                                         |
|outcome_analysis_id       |   81321|  69927|     0|                                                         |
|brief_title               |       0|  27306|     0|                                                         |
|official_title            |     755|  26926|     0|                                                         |
|study_type                |       0|      2|     0|INTERVENTIONAL: 144998; OBSERVATIONAL: 6250              |
|phase                     |   41410|      7|     0|PHASE2: 42281; PHASE3: 29239; PHASE1: 19447              |
|overall_status            |       0|      1|     0|completed: 151248                                        |
|enrollment_type           |       2|      1|     0|actual: 151246                                           |
|allocation                |   11178|      2|     0|RANDOMIZED: 134809; NON_RANDOMIZED: 5261                 |
|intervention_model        |    6452|      5|     0|PARALLEL: 126424; CROSSOVER: 9364; SINGLE_GROUP: 6877    |
|primary_purpose           |    7992|      9|     0|TREATMENT: 91824; PREVENTION: 28223; BASIC_SCIENCE: 7728 |
|observational_model       |  145095|      7|     0|COHORT: 3778; CASE_CONTROL: 1081; CASE_ONLY: 992         |
|masking                   |    6689|      5|     0|NONE: 37784; DOUBLE: 36855; QUADRUPLE: 28589             |
|comparator_summary        |       0|     16|     0|                                                         |
|domain_all                |       0|    628|     0|                                                         |
|domain_source             |       0|      3|     0|mesh: 122612; missing: 19334; text_fallback_only: 9302   |
|domain_primary            |       0|     18|     0|                                                         |
|intervention_types_all    |       0|    169|     0|                                                         |
|intervention_type_primary |       0|     12|     0|                                                         |
|lead_sponsor_name         |       0|   4238|     0|                                                         |
|lead_sponsor_class        |       0|      5|     0|industry: 98759; other: 44847; other_gov: 3958           |
|outcome_type              |       0|      1|     0|PRIMARY: 151248                                          |
|outcome_title             |       0|  45409|     0|                                                         |
|outcome_time_frame        |       0|  22719|     0|                                                         |
|measurement_stratum_id    |   69927|  50172|     0|                                                         |
|measurement_title         |   69927|  22098|     0|                                                         |
|measurement_units         |   69927|   4160|     0|                                                         |
|measure_class             |   24211|     14|     0|                                                         |
|measure_detailed          |   24211|     14|     0|                                                         |
|scale                     |       0|      4|     0|raw: 53035; smd: 49955; probit: 31366                    |
|z_operator                |       0|      3|     0|=: 143517; &gt;: 6927; &lt;: 804                         |
|linked_result_group_ids   |  106568|  34942|     0|                                                         |
|linked_group_codes        |  106568|    162|     0|                                                         |
|method                    |  112381|   1764|     0|                                                         |
|param_type                |  105532|   3226|     0|                                                         |
|p_value_modifier          |  135039|      9|     0|&lt;: 14036; =: 1241; &gt;: 904                          |
|raw_group_t_id            |   69927|  33028|     0|                                                         |
|raw_group_c_id            |   69927|  27684|     0|                                                         |
|raw_group_t_title         |   69927|  14897|     0|                                                         |
|raw_group_c_title         |   69927|   9118|     0|                                                         |

## Variable type: logical

|Variable                      | Missing|   TRUE|  FALSE|
|:-----------------------------|-------:|------:|------:|
|include_in_bear               |       0| 132039|  19209|
|is_factorial                  |      18|   1422| 149808|
|is_crossover                  |      18|   9364| 141866|
|has_placebo_comparator        |       0|  60187|  91061|
|is_multi_arm                  |       0|  70817|  80431|
|has_baseline_measurements     |       0| 151228|     20|
|domain_oncology               |       0|  10490| 140758|
|is_drug_trial                 |       0| 102475|  48773|
|is_biological_trial           |       0|  31618| 119630|
|is_device_trial               |       0|  12300| 138948|
|is_procedure_trial            |       0|   3582| 147666|
|is_behavioral_trial           |       0|  16773| 134475|
|is_vaccine_trial              |       0|  17863| 133385|
|is_cell_or_gene_therapy_trial |       0|   1029| 150219|
|is_diagnostic_trial           |       0|   5579| 145669|
|has_industry_sponsor          |       0| 105229|  46019|
|direction_unknown             |   69927|  22174|  59147|
|raw_multi_arm_trial           |   69927|  47183|  34138|

## Variable type: numeric

|Variable                  | Missing|   Mean|      SD|      Min|      Max| -Inf| +Inf|Hist  |
|:-------------------------|-------:|------:|-------:|--------:|--------:|----:|----:|:-----|
|year                      |       0|   2016|   4.941|     1992|     2025|    0|    0|▁▁▅▇▆ |
|enrollment                |       2|   7851|  125800|        1|  4052000|    0|    0|▇▁▁▁▁ |
|number_of_arms            |    6751|  3.408|   2.472|        1|       32|    0|    0|▇▁▁▁▁ |
|number_of_groups          |  145361|  2.806|   6.957|        1|       49|    0|    0|▇▁▁▁▁ |
|results_first_posted_year |       0|   2018|   4.187|     2008|     2025|    0|    0|▂▃▇▇▇ |
|primary_completion_year   |     157|   2015|   4.916|     1991|     2025|    0|    0|▁▁▅▇▆ |
|n_effect_rows_per_study   |       0|  159.4|   403.9|        1|     2474|    0|    0|▇▁▁▁▁ |
|n_outcomes_per_study      |       0|    7.9|   11.88|        1|       96|    0|    0|▇▁▁▁▁ |
|n_design_groups           |       0|  3.365|   2.793|        0|       49|    0|    0|▇▁▁▁▁ |
|domain_n                  |       0|  1.468|  0.9737|        0|       12|    0|    0|▇▁▁▁▁ |
|intervention_type_n       |       0|  1.711|   0.674|        0|        6|    0|    0|▆▇▁▁▁ |
|effect                    |   24629|  12.92|    1710|  -108300|   236000|    0|    0|▁▇▁▁▁ |
|b                         |   24629|  12.92|    1710|  -108300|   236000|    0|    0|▁▇▁▁▁ |
|se                        |   24680|  10.72|   584.8|        0|    79440|    0|    0|▇▁▁▁▁ |
|z                         |       0|  3.842|   403.8|   -221.5|   156800|   11|  120|▇▁▁▁▁ |
|n_linked_groups           |  106568|  1.985|  0.7473|        1|       39|    0|    0|▇▁▁▁▁ |
|estimate                  |  105555|   5279| 1118000|  -108300| 2.39e+08|    0|    0|▇▁▁▁▁ |
|lower                     |  109611|  6.358|    3008|  -235700|   194700|    0|    0|▁▁▇▁▁ |
|upper                     |  109625|  100.4|    3489|    -2716|   305800|    0|    0|▇▁▁▁▁ |
|p_value                   |   97234| 0.2392|  0.3192|   -0.001|     18.5|    0|    0|▇▁▁▁▁ |
|ci_percent                |  105671|  93.88|   6.533|   -42.88|      985|    0|    0|▇▁▁▁▁ |
|ci_n_sides                |  106149|   1.99| 0.09796|        1|        2|    0|    0|▁▁▁▁▇ |
|raw_event_t               |  119882|  90.79|   882.5|   0.0234|   144600|    0|    0|▇▁▁▁▁ |
|raw_event_c               |  119882|  80.22|   904.9|    8e-04|   136500|    0|    0|▇▁▁▁▁ |
|raw_n_t                   |   69927|  146.1|    1198|        1|   183000|    0|    0|▇▁▁▁▁ |
|raw_n_c                   |   69927|  128.2|    1145|        2|   185000|    0|    0|▇▁▁▁▁ |
|raw_mean_t                |  101293|   1660|   90870| -1981000| 12480000|    0|    0|▇▁▁▁▁ |
|raw_mean_c                |  101293|   1859|  110400|   -49190| 18650000|    0|    0|▇▁▁▁▁ |
|raw_sd_t                  |  101293|   1024|   73820|  9.6e-08| 10770000|    0|    0|▇▁▁▁▁ |
|raw_sd_c                  |  101293|   1138|   78890|  1.2e-07| 11670000|    0|    0|▇▁▁▁▁ |

