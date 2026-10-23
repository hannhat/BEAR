# clinicaltrialsgov

- Rows: 164,453
- Columns: 96

## Variable type: character

|Variable                    | Missing| Unique| Empty|Common                                                        |
|:---------------------------|-------:|------:|-----:|:-------------------------------------------------------------|
|effect_id                   |       0| 164453|     0|                                                              |
|author_effect_id            |   88100|  76353|     0|                                                              |
|raw_effect_id               |   76353|  88100|     0|                                                              |
|effect_source               |       0|      2|     0|raw_derived: 88100; author_reported: 76353                    |
|result_id                   |   36734|  59383|     0|                                                              |
|nct_id                      |       0|  29852|     0|                                                              |
|outcome_id                  |       0|  56676|     0|                                                              |
|outcome_analysis_id         |   88100|  76353|     0|                                                              |
|brief_title                 |       0|  29724|     0|                                                              |
|official_title              |     757|  29327|     0|                                                              |
|study_type                  |       0|      2|     0|INTERVENTIONAL: 157755; OBSERVATIONAL: 6698                   |
|phase                       |   48426|      7|     0|PHASE2: 44300; PHASE3: 30822; PHASE1: 20241                   |
|overall_status              |       0|      1|     0|completed: 164453                                             |
|enrollment_type             |       2|      1|     0|actual: 164451                                                |
|allocation                  |   12425|      2|     0|RANDOMIZED: 146260; NON_RANDOMIZED: 5768                      |
|intervention_model          |    6906|      5|     0|PARALLEL: 137079; CROSSOVER: 10058; SINGLE_GROUP: 7725        |
|primary_purpose             |    8420|      9|     0|TREATMENT: 98313; PREVENTION: 31101; BASIC_SCIENCE: 8541      |
|observational_model         |  157852|      7|     0|COHORT: 3989; CASE_CONTROL: 1098; CASE_ONLY: 1092             |
|masking                     |    7139|      5|     0|NONE: 42051; DOUBLE: 38798; QUADRUPLE: 30771                  |
|comparator_summary          |       0|     16|     0|                                                              |
|domain_all                  |       0|    801|     0|                                                              |
|domain_source               |       0|      3|     0|mesh: 130887; missing: 22657; text_fallback_only: 10909       |
|domain_primary              |       0|     18|     0|                                                              |
|intervention_types_all      |       0|    185|     0|                                                              |
|intervention_type_primary   |       0|     12|     0|                                                              |
|lead_sponsor_name           |       0|   4578|     0|                                                              |
|lead_sponsor_class          |       0|      5|     0|industry: 104078; other: 51757; other_gov: 4600               |
|outcome_type                |       0|      1|     0|PRIMARY: 164453                                               |
|outcome_title               |       0|  49996|     0|                                                              |
|outcome_time_frame          |       0|  24891|     0|                                                              |
|measurement_stratum_id      |   76353|  55019|     0|                                                              |
|measurement_title           |   76353|  24352|     0|                                                              |
|measurement_units           |   76353|   4625|     0|                                                              |
|measure_class               |   26476|     14|     0|                                                              |
|measure_detailed            |   26476|     14|     0|                                                              |
|scale                       |       0|      4|     0|raw: 57936; smd: 54891; probit: 33209                         |
|z_operator                  |       0|      3|     0|=: 156071; &gt;: 7485; &lt;: 897                              |
|linked_result_group_ids     |  114996|  38498|     0|                                                              |
|linked_group_codes          |  114996|    167|     0|                                                              |
|method                      |  121329|   1946|     0|                                                              |
|param_type                  |  114576|   3456|     0|                                                              |
|p_value_modifier            |  146884|      9|     0|&lt;: 15121; =: 1413; &gt;: 1007                              |
|non_inferiority_type        |   88100|      8|     0|SUPERIORITY: 25855; SUPERIORITY_OR_OTHER: 21354; OTHER: 15154 |
|non_inferiority_description |  146420|   8167|     0|                                                              |
|raw_group_t_id              |   76353|  36211|     0|                                                              |
|raw_group_c_id              |   76353|  30590|     0|                                                              |
|raw_group_t_title           |   76353|  16124|     0|                                                              |
|raw_group_c_title           |   76353|   9948|     0|                                                              |

## Variable type: logical

|Variable                      | Missing|   TRUE|  FALSE|
|:-----------------------------|-------:|------:|------:|
|include_in_bear               |       0| 143485|  20968|
|is_factorial                  |      18|   1682| 162753|
|is_crossover                  |      18|  10058| 154377|
|has_placebo_comparator        |       0|  63946| 100507|
|is_multi_arm                  |       0|  76263|  88190|
|has_baseline_measurements     |       0| 164431|     22|
|domain_oncology               |       0|  11684| 152769|
|is_drug_trial                 |       0| 107390|  57063|
|is_biological_trial           |       0|  31803| 132650|
|is_device_trial               |       0|  14001| 150452|
|is_procedure_trial            |       0|   3769| 160684|
|is_behavioral_trial           |       0|  20705| 143748|
|is_vaccine_trial              |       0|  19426| 145027|
|is_cell_or_gene_therapy_trial |       0|   1132| 163321|
|is_diagnostic_trial           |       0|   6499| 157954|
|has_industry_sponsor          |       0| 110896|  53557|
|direction_unknown             |   76353|  24416|  63684|
|raw_multi_arm_trial           |   76353|  50177|  37923|

## Variable type: numeric

|Variable                  | Missing|   Mean|      SD|      Min|      Max| -Inf| +Inf|Hist  |
|:-------------------------|-------:|------:|-------:|--------:|--------:|----:|----:|:-----|
|year                      |       0|   2016|   5.265|     1992|     2026|    0|    0|▁▁▅▇▆ |
|enrollment                |       2|   7500|  120700|        1|  4052000|    0|    0|▇▁▁▁▁ |
|number_of_arms            |    7200|  3.451|   2.679|        1|       32|    0|    0|▇▁▁▁▁ |
|number_of_groups          |  158229|  2.757|   6.772|        1|       49|    0|    0|▇▁▁▁▁ |
|results_first_posted_year |       0|   2019|   4.482|     2008|     2026|    0|    0|▂▅▆▇▇ |
|primary_completion_year   |     149|   2016|   5.245|     1991|     2026|    0|    0|▁▁▅▇▅ |
|n_effect_rows_per_study   |       0|  150.9|     390|        1|     2474|    0|    0|▇▁▁▁▁ |
|n_outcomes_per_study      |       0|  7.796|   11.63|        1|       96|    0|    0|▇▁▁▁▁ |
|n_design_groups           |       0|  3.404|   2.947|        0|       49|    0|    0|▇▁▁▁▁ |
|domain_n                  |       0|  1.535|   1.095|        0|       13|    0|    0|▇▂▁▁▁ |
|intervention_type_n       |       0|  1.812|  0.6808|        0|        7|    0|    0|▅▇▂▁▁ |
|effect                    |   26943|  12.02|    1648|  -108300|   236000|    0|    0|▁▇▁▁▁ |
|b                         |   26943|  12.02|    1648|  -108300|   236000|    0|    0|▁▇▁▁▁ |
|se                        |   26999|  10.04|   562.3|        0|    79440|    0|    0|▇▁▁▁▁ |
|z                         |       0|  2.703|   387.2|   -221.5|   156800|   12|  136|▇▁▁▁▁ |
|n_linked_groups           |  114996|  1.976|   0.751|        1|       39|    0|    0|▇▁▁▁▁ |
|estimate                  |  114599|   4840| 1071000|  -108300| 2.39e+08|    0|    0|▇▁▁▁▁ |
|lower                     |  119279|  6.844|    2892|  -235700|   194700|    0|    0|▁▁▇▁▁ |
|upper                     |  119301|  96.22|    3372|    -2716|   305800|    0|    0|▇▁▁▁▁ |
|p_value                   |  105194| 0.2423|  0.3201|   -5.516|     18.5|    0|    0|▁▇▁▁▁ |
|ci_percent                |  115299|  93.88|    6.42|   -42.88|      985|    0|    0|▇▁▁▁▁ |
|ci_n_sides                |  115382|   1.99| 0.09771|        1|        2|    0|    0|▁▁▁▁▇ |
|raw_event_t               |  131244|  94.12|   861.8|   0.0234|   144600|    0|    0|▇▁▁▁▁ |
|raw_event_c               |  131244|  84.14|   883.5|    8e-04|   136500|    0|    0|▇▁▁▁▁ |
|raw_n_t                   |   76353|  159.1|    1334|        1|   183000|    0|    0|▇▁▁▁▁ |
|raw_n_c                   |   76353|  140.7|    1329|        2|   205800|    0|    0|▇▁▁▁▁ |
|raw_mean_t                |  109562|   2849|  281000| -1981000| 62100000|    0|    0|▇▁▁▁▁ |
|raw_mean_c                |  109562|   2490|  200900|   -49190|    4e+07|    0|    0|▇▁▁▁▁ |
|raw_sd_t                  |  109562|   2695|  354900|  9.6e-08| 79990000|    0|    0|▇▁▁▁▁ |
|raw_sd_c                  |  109562|   2523|  349700|  1.2e-07|    8e+07|    0|    0|▇▁▁▁▁ |

