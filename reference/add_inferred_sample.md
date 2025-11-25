# Insert an a hypothetical inferred sample into the sample tree and set it as the parent of specified samples.

Insert an a hypothetical inferred sample into the sample tree and set it
as the parent of specified samples.

## Usage

``` r
add_inferred_sample(
  tables,
  name,
  rank = NULL,
  samples = character(),
  parent_sample = NULL,
  display_name = "Inferred"
)
```

## Arguments

- tables:

  A list of tables (samples, phylogeny, compositions, ranks)

- name:

  The name of the inferred sample to add

- rank:

  The rank of the inferred sample

- samples:

  A character vector of samples to set the inferred sample as their
  parent

- parent_sample:

  The parent sample of the inferred sample. If NULL, the inferred root
  is used.

- display_name:

  The display name of the inferred sample (default: "Inferred")

## Value

A list of tables with a newly added inferred sample and updated parent
relationships

## Examples

``` r
jellyfisher_example_tables |>
  select_patients("EOC153") |>
  add_inferred_sample("EOC153_Inf",
                      2,
                      c("EOC153_iPer1_DNA4",
                        "EOC153_iOme1_DNA4",
                        "EOC153_iOvaR1_DNA1")) |>
  jellyfisher()

{"x":{"tables":{"samples":{"sample":["EOC153_iOme1_DNA4","EOC153_iOvaR1_DNA1","EOC153_iPer1_DNA4","EOC153_pAsc1_DNA1","EOC153_pOme1_DNA3","EOC153_pPer1_DNA3","EOC153_Inf"],"displayName":["iOme1","iOvaR1","iPer1","pAsc1","pOme1","pPer1","Inferred"],"rank":[5,5,5,1,1,1,2],"parent":["EOC153_Inf","EOC153_Inf","EOC153_Inf","","","",null],"patient":["EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153"]},"phylogeny":{"subclone":[1,2,3,4,5,6,8,9,11,12],"parent":[-1,4,11,1,9,9,4,4,1,3],"color":["#cccccc","#a6cee3","#b2df8a","#cab2d6","#ff99ff","#fdbf6f","#bbbb77","#cf8d30","#ff7f00","#3de4c5"],"branchLength":[1678,631,1869,7783,812,191,263,2034,676,2748],"patient":["EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153"]},"compositions":{"sample":["EOC153_iOme1_DNA4","EOC153_iOme1_DNA4","EOC153_iOme1_DNA4","EOC153_iOme1_DNA4","EOC153_iOme1_DNA4","EOC153_iOme1_DNA4","EOC153_iOvaR1_DNA1","EOC153_iOvaR1_DNA1","EOC153_iOvaR1_DNA1","EOC153_iPer1_DNA4","EOC153_iPer1_DNA4","EOC153_iPer1_DNA4","EOC153_pAsc1_DNA1","EOC153_pAsc1_DNA1","EOC153_pAsc1_DNA1","EOC153_pOme1_DNA3","EOC153_pOme1_DNA3","EOC153_pOme1_DNA3","EOC153_pPer1_DNA3","EOC153_pPer1_DNA3"],"subclone":[1,2,4,6,8,9,4,5,8,2,8,9,3,11,12,3,11,12,3,12],"clonalPrevalence":[0.1075,0.163,0.022,0.4995,0.1345,0.074,0.06950000000000001,0.6215000000000001,0.2885,0.412,0.0395,0.5465,0.4005,0.07199999999999999,0.5205,0.3565,0.0985,0.543,0.325,0.673],"patient":["EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153","EOC153"]},"ranks":{"rank":[1,2,3,4,5,6,7,8,9,10,11,12,13],"title":["Diagnosis","Diagnosis","Diagnosis 2","Diagnosis 3","Interval","Interval","Interval 2","Interval 3","Relapse","Relapse","Relapse 2","Relapse 3","Relapse 4"]}},"options":{"crossingWeight":10,"pathLengthWeight":2,"orderMismatchWeight":2,"bundleMismatchWeight":3,"divergenceWeight":4,"bellTipShape":0.1,"bellTipSpread":0.5,"bellStrokeWidth":1,"bellStrokeDarkening":0.6,"bellPlateauPos":0.7,"sampleHeight":110,"sampleWidth":90,"inferredSampleHeight":120,"gapHeight":60,"sampleSpacing":60,"columnSpacing":90,"tentacleWidth":2,"tentacleSpacing":5,"inOutCPDistance":0.3,"bundleCPDistance":0.6,"sampleFontSize":12,"showLegend":true,"phylogenyColorScheme":true,"phylogenyHueOffset":0,"phylogenyLightnessStart":0.9399999999999999,"phylogenyLightnessEnd":0.68,"phylogenyChromaStart":0.025,"phylogenyChromaEnd":0.21,"sampleTakenGuide":"text","showRankTitles":true,"normalsAtPhylogenyRoot":false},"controls":"closed"},"evals":[],"jsHooks":[]}
```
