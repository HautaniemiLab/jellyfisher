# Set parents for samples

Given a list of jellyfish input tables and a named list of parents for
each sample, set the parent for each sample.

## Usage

``` r
set_parents(tables, parents, unset_missing = FALSE)
```

## Arguments

- tables:

  A list of tables (samples, phylogeny, compositions, ranks)

- parents:

  A named list of parents for each sample. Keys are the samples and
  values are their new parents

- unset_missing:

  If TRUE, unset the parent for samples that are not in the parent list

## Value

A list of tables with parents set for each sample

## Details

By default, all samples that have no explicit parent are children of the
*inferred root* sample. You can customize the parent-child relationships
by modifying the `parent` column in the `samples` data frame before
plotting.

You can also modify the relationships using the `set_parents` function.

For example, if you have three samples, A, B, and C, they will have the
following relationships by default:

        Root
       / | \
      A  B  C

With the explicit parents, you can customize the relationships:

    tables |>
      set_parents(list(
        # The parent of C is B
        C = "B"
      ) |>
      jellyfisher()

        Root
       /  \
      A    B
            \
             C

## Examples

``` r
jellyfisher_example_tables |>
  select_patients("EOC809") |>
  set_parents(list("EOC809_r1Bow1_DNA1" = "EOC809_p2Per1_cO_DNA2")) |>
  jellyfisher()

{"x":{"tables":{"samples":{"sample":["EOC809_p2Bow1_c_DNA2","EOC809_p2Ome1_c_DNA1","EOC809_p2OvaL1_c_DNA6","EOC809_p2Per1_cO_DNA2","EOC809_r1Bow1_DNA1"],"displayName":["p2Bow1_c","p2Ome1_c","p2OvaL1_c","p2Per1_cO","r1Bow1"],"rank":[3,3,3,3,10],"parent":["","","","","EOC809_p2Per1_cO_DNA2"],"patient":["EOC809","EOC809","EOC809","EOC809","EOC809"]},"phylogeny":{"subclone":[1,2,4,10,11,12,14,15],"parent":[-1,12,10,15,10,1,12,1],"color":["#cccccc","#a6cee3","#cab2d6","#41ae76","#ff7f00","#3de4c5","#9933ff","#3690c0"],"branchLength":[5787,1646,1020,567,1102,1544,2834,4452],"patient":["EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809"]},"compositions":{"sample":["EOC809_p2Bow1_c_DNA2","EOC809_p2Bow1_c_DNA2","EOC809_p2Ome1_c_DNA1","EOC809_p2Ome1_c_DNA1","EOC809_p2Ome1_c_DNA1","EOC809_p2Ome1_c_DNA1","EOC809_p2Ome1_c_DNA1","EOC809_p2OvaL1_c_DNA6","EOC809_p2OvaL1_c_DNA6","EOC809_p2Per1_cO_DNA2","EOC809_p2Per1_cO_DNA2","EOC809_p2Per1_cO_DNA2","EOC809_r1Bow1_DNA1","EOC809_r1Bow1_DNA1"],"subclone":[4,15,1,4,10,12,15,11,15,1,2,12,12,14],"clonalPrevalence":[0.6304999999999999,0.37,0.0205,0.0545,0.3365,0.0305,0.5580000000000001,0.67,0.322,0.0345,0.58,0.3855,0.098,0.9],"patient":["EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809","EOC809"]},"ranks":{"rank":[1,2,3,4,5,6,7,8,9,10,11,12,13],"title":["Diagnosis","Diagnosis","Diagnosis 2","Diagnosis 3","Interval","Interval","Interval 2","Interval 3","Relapse","Relapse","Relapse 2","Relapse 3","Relapse 4"]}},"options":{"crossingWeight":10,"pathLengthWeight":2,"orderMismatchWeight":2,"bundleMismatchWeight":3,"divergenceWeight":4,"bellTipShape":0.1,"bellTipSpread":0.5,"bellStrokeWidth":1,"bellStrokeDarkening":0.6,"bellPlateauPos":0.7,"sampleHeight":110,"sampleWidth":90,"inferredSampleHeight":120,"gapHeight":60,"sampleSpacing":60,"columnSpacing":90,"tentacleWidth":2,"tentacleSpacing":5,"inOutCPDistance":0.3,"bundleCPDistance":0.6,"sampleFontSize":12,"showLegend":true,"phylogenyColorScheme":true,"phylogenyHueOffset":0,"phylogenyLightnessStart":0.9399999999999999,"phylogenyLightnessEnd":0.68,"phylogenyChromaStart":0.025,"phylogenyChromaEnd":0.21,"sampleTakenGuide":"text","showRankTitles":true,"normalsAtPhylogenyRoot":false},"controls":"closed"},"evals":[],"jsHooks":[]}
```
