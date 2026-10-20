# SCORE_all_claims

- Rows: 3,066
- Columns: 46

## Variable type: character

|Variable               | Missing| Unique| Empty|Common                                                                         |
|:----------------------|-------:|------:|-----:|:------------------------------------------------------------------------------|
|dataset                |       0|      1|     0|SCORE: 3066                                                                    |
|metaid                 |    3066|      0|     0|                                                                               |
|studyid                |       0|    200|     0|                                                                               |
|doi_study              |       0|    200|     0|                                                                               |
|estimate_id            |       0|   3066|     0|                                                                               |
|paper_id               |       0|    200|     0|                                                                               |
|claim_id               |       0|   3066|     0|                                                                               |
|report_id              |    3066|      0|     0|                                                                               |
|citation               |       0|    200|     0|                                                                               |
|journal                |       0|     60|     0|                                                                               |
|discipline             |       0|      6|     0|psychology and health: 734; economics and finance: 553; political science: 511 |
|source                 |       0|      1|     0|claim_text: 3066                                                               |
|subset                 |       0|      6|     0|psychology and health: 734; economics and finance: 553; political science: 511 |
|measure                |    2693|      5|     0|beta: 155; SMD: 104; partial eta-squared: 80                                   |
|z_operator             |    1120|      3|     0|=: 1058; &gt;: 876; &lt;: 12                                                   |
|claim4_id              |       0|   3066|     0|                                                                               |
|p_operator             |    1336|      3|     0|&lt;: 1391; =: 322; &gt;: 17                                                   |
|coded_stat_evidence    |       0|   3040|     0|                                                                               |
|stat_fragment          |       0|   2949|     0|                                                                               |
|nonsig                 |       0|      3|     0|F: 2398; Non-inf: 349; T: 319                                                  |
|significance_rule      |       0|      6|     0|p_upper_bound_significan…: 1338; unavailable: 1120; exact_p: 322               |
|claim_selection_status |       0|      3|     0|aligned_with_score_code: 1840; unparsed: 1173; parsed_mismatch: 53             |
|z_source               |       0|      6|     0|unparsed: 1120; two_sided_p: 1013; coef_over_se: 540                           |
|effect_source          |       0|      3|     0|missing: 1942; labelled_effect: 887; nearby_unlabelled_effect: 237             |
|se_source              |       0|      4|     0|missing: 2116; labelled_se: 755; effect_over_z: 128                            |
|sign_source            |       0|      6|     0|unsigned: 1798; labelled_effect: 705; reported_t: 274                          |
|parse_status           |       0|      3|     0|parsed_z: 1942; unparsed: 859; partial: 265                                    |

## Variable type: logical

|Variable                  | Missing| TRUE| FALSE|
|:-------------------------|-------:|----:|-----:|
|significant               |    1173| 1713|   180|
|selected_significant      |       0| 2747|   319|
|fragment_significant      |    1173| 1713|   180|
|selection_agrees_coded    |       0| 1840|  1226|
|within_claim_disagreement |       0|  124|  2942|

## Variable type: numeric

|Variable                   | Missing|    Mean|      SD|      Min|   Max| -Inf| +Inf|Hist  |
|:--------------------------|-------:|-------:|-------:|--------:|-----:|----:|----:|:-----|
|year                       |       0|    2014|   2.725|     2009|  2018|    0|    0|▅▃▇▇▆ |
|z                          |    1124|   1.159|   7.834|     -141| 67.97|    2|   21|▁▁▁▇▁ |
|abs_z                      |    1124|     3.7|   7.001|        0|   141|    0|   23|▇▁▁▁▁ |
|p                          |    1336| 0.04734|  0.2105|        0|   5.7|    0|    0|▇▁▁▁▁ |
|b                          |    1942| -0.6347|   13.33|   -335.8|  55.1|    0|    0|▁▁▁▁▇ |
|se                         |    2116|   2.056|   23.35|        0| 671.3|    0|    0|▇▁▁▁▁ |
|ss                         |    3066|        |        |         |      |    0|    0|      |
|weights                    |       0| 0.06523| 0.05961| 0.008547|   0.5|    0|    0|▇▁▁▁▁ |
|fragment_id                |       0|   1.082|  0.4068|        1|     7|    0|    0|▇▁▁▁▁ |
|n_fragments                |       0|   1.428|    1.17|        1|    19|    0|    0|▇▁▁▁▁ |
|n_parsed_fragments         |       0|  0.8483|   1.051|        0|     9|    0|    0|▇▁▁▁▁ |
|n_significant_fragments    |       0|  0.7189|  0.9978|        0|     9|    0|    0|▇▁▁▁▁ |
|n_nonsignificant_fragments |       0|  0.1086|   0.345|        0|     4|    0|    0|▇▁▁▁▁ |
|n_ambiguous_fragments      |       0|  0.6001|  0.9612|        0|    19|    0|    0|▇▁▁▁▁ |

