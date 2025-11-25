# Filter Jellyfish tables by patient

Given a list of tables, filter them by patient.

## Usage

``` r
select_patients(tables, patient)
```

## Arguments

- tables:

  A list of tables (samples, phylogeny, compositions, ranks)

- patient:

  The patient or patients to filter by

## Value

A list of tables filtered by patient

## Examples

``` r
jellyfisher_example_tables |>
  select_patients("EOC809")
#> $samples
#>                    sample displayName rank               parent patient
#> 363  EOC809_p2Bow1_c_DNA2    p2Bow1_c    3                       EOC809
#> 364  EOC809_p2Ome1_c_DNA1    p2Ome1_c    3                       EOC809
#> 365 EOC809_p2OvaL1_c_DNA6   p2OvaL1_c    3                       EOC809
#> 366 EOC809_p2Per1_cO_DNA2   p2Per1_cO    3                       EOC809
#> 367    EOC809_r1Bow1_DNA1      r1Bow1   10 EOC809_p2Bow1_c_DNA2  EOC809
#> 
#> $phylogeny
#>     subclone parent   color branchLength patient
#> 602        1     -1 #cccccc         5787  EOC809
#> 603        2     12 #a6cee3         1646  EOC809
#> 604        4     10 #cab2d6         1020  EOC809
#> 605       10     15 #41ae76          567  EOC809
#> 606       11     10 #ff7f00         1102  EOC809
#> 607       12      1 #3de4c5         1544  EOC809
#> 608       14     12 #9933ff         2834  EOC809
#> 609       15      1 #3690c0         4452  EOC809
#> 
#> $compositions
#>                     sample subclone clonalPrevalence patient
#> 1206  EOC809_p2Bow1_c_DNA2        4           0.6305  EOC809
#> 1207  EOC809_p2Bow1_c_DNA2       15           0.3700  EOC809
#> 1208  EOC809_p2Ome1_c_DNA1        1           0.0205  EOC809
#> 1209  EOC809_p2Ome1_c_DNA1        4           0.0545  EOC809
#> 1210  EOC809_p2Ome1_c_DNA1       10           0.3365  EOC809
#> 1211  EOC809_p2Ome1_c_DNA1       12           0.0305  EOC809
#> 1212  EOC809_p2Ome1_c_DNA1       15           0.5580  EOC809
#> 1213 EOC809_p2OvaL1_c_DNA6       11           0.6700  EOC809
#> 1214 EOC809_p2OvaL1_c_DNA6       15           0.3220  EOC809
#> 1215 EOC809_p2Per1_cO_DNA2        1           0.0345  EOC809
#> 1216 EOC809_p2Per1_cO_DNA2        2           0.5800  EOC809
#> 1217 EOC809_p2Per1_cO_DNA2       12           0.3855  EOC809
#> 1218    EOC809_r1Bow1_DNA1       12           0.0980  EOC809
#> 1219    EOC809_r1Bow1_DNA1       14           0.9000  EOC809
#> 
#> $ranks
#>    rank       title
#> 1     1   Diagnosis
#> 2     2   Diagnosis
#> 3     3 Diagnosis 2
#> 4     4 Diagnosis 3
#> 5     5    Interval
#> 6     6    Interval
#> 7     7  Interval 2
#> 8     8  Interval 3
#> 9     9     Relapse
#> 10   10     Relapse
#> 11   11   Relapse 2
#> 12   12   Relapse 3
#> 13   13   Relapse 4
#> 
```
