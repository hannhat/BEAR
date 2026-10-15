# SCORE_replications

- Rows: 548
- Columns: 42

## Variable type: character

|Variable              | Missing| Unique| Empty|Common                                                                       |
|:---------------------|-------:|------:|-----:|:----------------------------------------------------------------------------|
|dataset               |       0|      1|     0|SCORE: 548                                                                   |
|metaid                |     548|      0|     0|                                                                             |
|studyid               |       0|    164|     0|                                                                             |
|doi_study             |       0|    164|     0|                                                                             |
|doi_replication       |     274|      1|     0|                                                                             |
|estimate_id           |       0|    548|     0|                                                                             |
|paper_id              |       0|    164|     0|                                                                             |
|claim_id              |       0|    274|     0|                                                                             |
|report_id             |     274|    274|     0|                                                                             |
|citation              |       0|    164|     0|                                                                             |
|journal               |       0|     54|     0|                                                                             |
|discipline            |       0|      6|     0|psychology and health: 188; political science: 90; economics and finance: 76 |
|source                |       0|      2|     0|original: 274; replication: 274                                              |
|subset                |       0|      6|     0|psychology and health: 188; political science: 90; economics and finance: 76 |
|measure               |       0|      1|     0|r: 548                                                                       |
|z_operator            |      10|      2|     0|=: 531; &gt;: 7                                                              |
|replication_type      |     274|      2|     0|secondary data: 146; new data: 128                                           |
|type_internal         |     274|      3|     0|p1: 134; bushel: 115; p2: 25                                                 |
|z_source              |      10|      4|     0|coef_over_se: 334; reported_stat: 106; two_sided_p: 50                       |
|original_stat_type    |     289|      6|     0|t: 146; z: 65; F: 35                                                         |
|original_p_value_type |     280|      4|     0|exact: 206; less-than: 59; threshold: 2                                      |
|repli_stat_type       |     286|      5|     0|t: 125; z: 90; F: 30                                                         |

## Variable type: logical

|Variable                   | Missing| TRUE| FALSE|
|:--------------------------|-------:|----:|-----:|
|significant                |       1|  436|   111|
|repli_effect_direction     |     284|  216|    48|
|repli_pattern_criteria_met |     274|  208|    66|
|repli_score_criteria_met   |     274|  151|   123|

## Variable type: numeric

|Variable                         | Missing|    Mean|      SD|       Min|      Max| -Inf| +Inf|Hist  |
|:--------------------------------|-------:|-------:|-------:|---------:|--------:|----:|----:|:-----|
|year                             |       0|    2013|   2.975|      2009|     2018|    0|    0|▇▆▅▃▆ |
|z                                |      10|    3.74|   58.06|      -173|     1315|    4|    3|▇▁▁▁▁ |
|abs_z                            |      10|   7.842|   57.65|   0.02244|     1315|    0|    7|▇▁▁▁▁ |
|p                                |       5| 0.08667|  0.2063|         0|    0.991|    0|    0|▇▁▁▁▁ |
|b                                |      35| 0.06207|  0.2979|   -0.9892|   0.9375|    0|    0|▁▂▇▅▁ |
|se                               |      35| 0.05626| 0.04577| 0.0001426|   0.2545|    0|    0|▇▃▂▁▁ |
|ss                               |      17|  120400| 2162000|         3| 49200000|    0|    0|▇▁▁▁▁ |
|weights                          |       0|  0.2993|  0.2076|   0.02778|      0.5|    0|    0|▆▁▁▁▇ |
|z_from_coef                      |     214|   4.326|   73.06|      -173|     1315|    0|    0|▇▁▁▁▁ |
|z_from_stat                      |      74|   4.115|   65.36|    -31.24|     1408|    1|    4|▇▁▁▁▁ |
|z_from_p                         |      14|  0.8437|   5.094|    -27.39|    37.51|   17|   45|▁▃▇▁▁ |
|original_effect_size_value_repro |     364|   2.539|   42.07|    -42.46|    566.5|    0|    0|▇▁▁▁▁ |
|original_effect_size_value_repli |     300|   3.131|   41.59|    -22.73|    566.5|    0|    0|▇▁▁▁▁ |
|repli_effect_size_value          |     338|   2.063|   40.86|    -92.44|    575.9|    0|    0|▇▁▁▁▁ |
|repli_effect_size_value_raw      |     298|   2.652|   36.49|    -10.06|    575.9|    0|    0|▇▁▁▁▁ |
|k                                |       0|   8.131|   8.866|         2|       36|    0|    0|▇▃▁▁▁ |

