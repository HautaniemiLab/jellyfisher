# Introduction to Jellyfisher

``` r
library(jellyfisher)
```

**Jellyfisher** is an R package (a
[htmlwidget](https://www.htmlwidgets.org/)) for visualizing tumor
evolution and subclonal compositions using Jellyfish plots. The package
is based on the [Jellyfish](https://github.com/HautaniemiLab/jellyfish)
visualization tool, bringing its functionality to R users. Jellyfisher
supports both [ClonEvol](https://github.com/hdng/clonevol) results and
plain data frames, making it compatible with various tools and
workflows.

## Input data

The input data should follow specific structures for *samples*,
*phylogeny*, subclonal *compositions*, and optional *ranks*.

The `jellyfisher` package includes an example data set
(`jellyfisher_example_tables`) based on the following publication:  
Lahtinen, A., Lavikka, K., Virtanen, A., et al. “Evolutionary states and
trajectories characterized by distinct pathways stratify patients with
ovarian high-grade serous carcinoma.” *Cancer Cell* **41**,
1103–1117.e12 (2023). DOI:
[10.1016/j.ccell.2023.04.017](https://doi.org/10.1016/j.ccell.2023.04.017).

### Samples

- `sample` (string): specifies the unique identifier for each sample.
- `displayName` (string, optional): allows for specifying a custom name
  for each sample. If the column is omitted, the `sample` column is used
  as the display name.
- `rank` (integer): specifies the position of each sample in the
  Jellyfish plot. For example, different stages of a disease can be
  ranked in chronological order: diagnosis (1), interval (2), and
  relapse (3). The zeroth rank is reserved for the root of the sample
  tree. Ranks can be any integer, and unused ranks are automatically
  excluded from the plot. If the `rank` column is absent, ranks are
  assigned based on each sample’s depth in the sample tree.
- `parent` (string): identifies the parent sample for each entry.
  Samples without a specified parent are treated as children of an
  imaginary root sample.

``` r
head(jellyfisher_example_tables$samples, 25)
#>                    sample displayName rank               parent patient
#> 35       EOC69_pOme1_DNA1       pOme1    1                        EOC69
#> 36       EOC69_pOva1_DNA2       pOva1    1                        EOC69
#> 37      EOC69_r1Vag1_DNA1      r1Vag1   10                        EOC69
#> 82      EOC153_iOme1_DNA4       iOme1    5    EOC153_pOme1_DNA3  EOC153
#> 83     EOC153_iOvaR1_DNA1      iOvaR1    5                       EOC153
#> 84      EOC153_iPer1_DNA4       iPer1    5    EOC153_pPer1_DNA3  EOC153
#> 85      EOC153_pAsc1_DNA1       pAsc1    1                       EOC153
#> 86      EOC153_pOme1_DNA3       pOme1    1                       EOC153
#> 87      EOC153_pPer1_DNA3       pPer1    1                       EOC153
#> 257     EOC495_pLNL1_DNA1       pLNL1    1                       EOC495
#> 258     EOC495_pLNL2_DNA1       pLNL2    1                       EOC495
#> 259      EOC495_pLNR_DNA1        pLNR    1                       EOC495
#> 260    EOC495_pOvaL6_DNA1      pOvaL6    1                       EOC495
#> 261    EOC495_pOvaL7_DNA1      pOvaL7    1                       EOC495
#> 262     EOC495_pPerL_DNA1       pPerL    1                       EOC495
#> 317      EOC677_pAsc_DNA1        pAsc    1                       EOC677
#> 318      EOC677_pPer1_DNA       pPer1    1                       EOC677
#> 319      EOC677_r2Asc_DNA       r2Asc   11     EOC677_rAsc_DNA4  EOC677
#> 320      EOC677_rAsc_DNA4        rAsc    9     EOC677_pAsc_DNA1  EOC677
#> 363  EOC809_p2Bow1_c_DNA2    p2Bow1_c    3                       EOC809
#> 364  EOC809_p2Ome1_c_DNA1    p2Ome1_c    3                       EOC809
#> 365 EOC809_p2OvaL1_c_DNA6   p2OvaL1_c    3                       EOC809
#> 366 EOC809_p2Per1_cO_DNA2   p2Per1_cO    3                       EOC809
#> 367    EOC809_r1Bow1_DNA1      r1Bow1   10 EOC809_p2Bow1_c_DNA2  EOC809
```

### Phylogeny

- `subclone` (string): specifies subclone IDs, which can be any string.
- `parent` (string): designates the parent subclone. The subclone
  without a parent is considered the root of the phylogeny.
- `color` (string, optional): specifies the color for the subclone. If
  the column is omitted, colors will be generated automatically.
- `branchLength` (number): specifies the length of the branch leading to
  the subclone. The length may be based on, for example, the number of
  unique mutations in the subclone. The branch length is shown in the
  Jellyfish plot’s legend as a bar chart. It is also used when
  generating a phylogeny-aware color scheme.

``` r
head(jellyfisher_example_tables$phylogeny, 25)
#>     subclone parent   color branchLength patient
#> 44         1     -1 #cccccc         2742   EOC69
#> 45         2     12 #a6cee3          478   EOC69
#> 46         5      9 #ff99ff           68   EOC69
#> 47         6      5 #fdbf6f          244   EOC69
#> 48         8      1 #bbbb77         2433   EOC69
#> 49         9      8 #cf8d30          313   EOC69
#> 50        11      8 #ff7f00          868   EOC69
#> 51        12      1 #3de4c5         4762   EOC69
#> 52        13      9 #ff1aff         1017   EOC69
#> 126        1     -1 #cccccc         1678  EOC153
#> 127        2      4 #a6cee3          631  EOC153
#> 128        3     11 #b2df8a         1869  EOC153
#> 129        4      1 #cab2d6         7783  EOC153
#> 130        5      9 #ff99ff          812  EOC153
#> 131        6      9 #fdbf6f          191  EOC153
#> 132        8      4 #bbbb77          263  EOC153
#> 133        9      4 #cf8d30         2034  EOC153
#> 134       11      1 #ff7f00          676  EOC153
#> 135       12      3 #3de4c5         2748  EOC153
#> 411        1     -1 #cccccc         1426  EOC495
#> 412        2      5 #a6cee3          184  EOC495
#> 413        3      6 #b2df8a          246  EOC495
#> 414        4      1 #cab2d6         2874  EOC495
#> 415        5      7 #ff99ff          864  EOC495
#> 416        6      5 #fdbf6f          154  EOC495
```

### Subclonal compositions

Subclonal compositions are specified in a
[tidy](https://vita.had.co.nz/papers/tidy-data.pdf) format, where each
row represents a subclone in a sample.

- `sample` (string): specifies the sample ID.
- `subclone` (string): specifies the subclone ID.
- `clonalPrevalence` (number): specifies the clonal prevalence of the
  subclone in the sample. The clonal prevalence is the proportion of the
  subclone in the sample. The clonal prevalences in a sample must sum to
  1.

``` r
head(jellyfisher_example_tables$compositions, 25)
#>                 sample subclone clonalPrevalence patient
#> 98    EOC69_pOme1_DNA1        5           0.2250   EOC69
#> 99    EOC69_pOme1_DNA1        6           0.0965   EOC69
#> 100   EOC69_pOme1_DNA1       13           0.6660   EOC69
#> 101   EOC69_pOva1_DNA2        6           0.4175   EOC69
#> 102   EOC69_pOva1_DNA2       11           0.5225   EOC69
#> 103   EOC69_pOva1_DNA2       13           0.0360   EOC69
#> 104  EOC69_r1Vag1_DNA1        2           0.3845   EOC69
#> 105  EOC69_r1Vag1_DNA1       12           0.5970   EOC69
#> 273  EOC153_iOme1_DNA4        1           0.1075  EOC153
#> 274  EOC153_iOme1_DNA4        2           0.1630  EOC153
#> 275  EOC153_iOme1_DNA4        4           0.0220  EOC153
#> 276  EOC153_iOme1_DNA4        6           0.4995  EOC153
#> 277  EOC153_iOme1_DNA4        8           0.1345  EOC153
#> 278  EOC153_iOme1_DNA4        9           0.0740  EOC153
#> 279 EOC153_iOvaR1_DNA1        4           0.0695  EOC153
#> 280 EOC153_iOvaR1_DNA1        5           0.6215  EOC153
#> 281 EOC153_iOvaR1_DNA1        8           0.2885  EOC153
#> 282  EOC153_iPer1_DNA4        2           0.4120  EOC153
#> 283  EOC153_iPer1_DNA4        8           0.0395  EOC153
#> 284  EOC153_iPer1_DNA4        9           0.5465  EOC153
#> 285  EOC153_pAsc1_DNA1        3           0.4005  EOC153
#> 286  EOC153_pAsc1_DNA1       11           0.0720  EOC153
#> 287  EOC153_pAsc1_DNA1       12           0.5205  EOC153
#> 288  EOC153_pOme1_DNA3        3           0.3565  EOC153
#> 289  EOC153_pOme1_DNA3       11           0.0985  EOC153
```

### Ranks

The ranks in the example data set are used to indicate the time points
when the samples were acquired.

- `rank` (integer): specifies the rank number. The zeroth rank is
  reserved for the inferred root of the sample tree. However, you are
  free to define a title for it.
- `title` (string): specifies the title for the rank.

``` r
head(jellyfisher_example_tables$ranks, 6)
#>   rank       title
#> 1    1   Diagnosis
#> 2    2   Diagnosis
#> 3    3 Diagnosis 2
#> 4    4 Diagnosis 3
#> 5    5    Interval
#> 6    6    Interval
```

## Plotting

### Basic plotting

The three tables are passed to the `jellyfisher` function as a named
list. The function generates an interactive Jellyfish plot based on the
input data. If the data set contains multiple patients, the Jellyfisher
htmlwidget shows navigation buttons to switch between patients.

``` r
jellyfisher(jellyfisher_example_tables,
            width = "100%", height = 450)
```

### Plotting with custom options

``` r
jellyfisher(jellyfisher_example_tables,
            options = list(
              sampleHeight = 70,
              sampleTakenGuide = "none",
              tentacleWidth = 3,
              showLegend = FALSE
            ),
            width = "100%", height = 400)
```

### Plotting a single patient

When plotting multiple patients, Jellyfisher shows buttons (Previous and
Next) to navigate between patients. When the data contains only one
patient, these buttons are hidden. The package also provides a
`select_patients` function to filter the data set with ease.

``` r
jellyfisher_example_tables |>
  select_patients("EOC677") |>
  jellyfisher(width = "100%", height = 400)
```

## Adjusting the sample tree structure

The sample trees in the example data set were constructed as follows:

*“For each sample, we checked whether an earlier time point included
exactly one sample from the same anatomical location. If such a sample
existed, it was assigned as the parent; otherwise, the inferred root was
used as the parent.”*

However, this mechanistic approach may not always produce credible
sample trees.

### Changing parent

The *r1Bow1* (bowel) sample in the following jellyfish plot is derived
from an earlier bowel sample *p2Bow1_c*, which has no traces of the
subclone 12.

``` r
jellyfisher_example_tables |>
  select_patients("EOC809") |>
  jellyfisher(width = "100%", height = 600)
```

Using the `set_parents` function, we can adjust the parent of the
*r1Bow1* sample to be *p2Per1_cO* (peritoneum), which is a possible
source of the metastasis due to its proximity. The high prevalence of
subclone 12 in this sample suggests that it is the likely source of the
metastasis in the *r1Bow1* sample.

``` r
jellyfisher_example_tables |>
  select_patients("EOC809") |>
  set_parents(list("EOC809_r1Bow1_DNA1" = "EOC809_p2Per1_cO_DNA2")) |>
  jellyfisher(width = "100%", height = 600)
```

### Changing topology

While ranks (the columns) can indicate the time points when the samples
were acquired, they can also be used to simply show the sample’s depth
in the sample tree. For instance, the following plot shows all the
samples on the same rank, indicating that they were diagnostic samples
acquired at the same time.

``` r
jellyfisher_example_tables |>
  select_patients("EOC495") |>
  jellyfisher(width = "100%", height = 650)
```

However, one can argue that the LN (lymph node) samples represent a
later development in the disease, and thus, they should be placed on a
later rank. We can remove the existing ranks, define new parent-child
relationships, and let Jellyfisher assign the ranks based on the sample
tree depth.

``` r
tables <- jellyfisher_example_tables |>
  select_patients("EOC495")

# Remove existing ranks. The ranks will be assigned automatically based
# on samples' depths in the sample tree.
tables$samples$rank <- NA

# Rank titles should be removed as well because they are no longer valid.
tables$ranks <- NULL

tables |>
  set_parents(list("EOC495_pLNL1_DNA1" = "EOC495_pLNR_DNA1",
                   "EOC495_pLNL2_DNA1" = "EOC495_pLNL1_DNA1")) |>
  jellyfisher(width = "100%", height = 500)
```

If we think that the lymph node samples represent an even later
development, we can manually assign ranks to the samples. The
`set_ranks` function provides an easy way to do this.

``` r
tables |>
  set_parents(list("EOC495_pLNL1_DNA1" = "EOC495_pLNR_DNA1",
                   "EOC495_pLNL2_DNA1" = "EOC495_pLNL1_DNA1")) |>
  set_ranks(list("EOC495_pLNR_DNA1" = 2,
                 "EOC495_pLNL1_DNA1" = 3,
                 "EOC495_pLNL2_DNA1" = 4),
            default = 1) |>
  jellyfisher(width = "100%", height = 400)
```

### Adding hypothetical samples for more plausible evolutionary scenarios

This feature is mainly useful when multiple time points are present,
since subclones that appear across several branches of the sample tree
may otherwise have their LCA placed at the inferred root. While
technically correct, this suggests that the subclone emerged before all
real samples, which may sometimes be biologically implausible.

To address this, you can insert a hypothetical **inferred sample** into
the sample tree and use it as a new parent for a subset of samples. This
creates a more plausible location for the LCA and often yields a clearer
evolutionary scenario. The same mechanism can also be used more
generally to organize the sample tree so that diverging clades are
displayed in a more structured way.

In the following example, the samples in the Diagnosis and Interval time
points of patient EOC153 contain distinct clades. The original subclones
were apparently eradicated during treatment, and new subclones emerged
at the interval debulking surgery. Without a manually inserted inferred
sample, the interval subclones’ LCA is placed at the inferred root,
suggesting an unlikely evolutionary scenario. By adding a hypothetical
intermediate sample, we can anchor the emergence of these subclones at a
more realistic position in the sample tree.

``` r
jellyfisher_example_tables |>
  select_patients("EOC153") |>
  add_inferred_sample(
    name = "EOC153_Inf",
    rank = 3,
    samples = c(
      "EOC153_iPer1_DNA4",
      "EOC153_iOme1_DNA4",
      "EOC153_iOvaR1_DNA1"
    )
  ) |>
  jellyfisher(width = "100%", height = 600)
```

The
[`add_inferred_sample()`](https://hautaniemilab.github.io/jellyfisher/reference/add_inferred_sample.md)
function performs three actions:

1.  Creates a new inferred sample with the given name and rank.
2.  Sets it as the parent of the specified samples.
3.  Updates the sample tree so that subclone LCAs can be placed at this
    new node.

The resulting plot shows the subclones emerging at the newly introduced
sample, between the diagnosis and relapse time points, producing a more
realistic and interpretable evolutionary scenario.

## Handling non-aberrant cells

Typically in tumor evolution studies, the focus is on the subclonal
compositions of the tumor cells. Thus, the root node in the phylogenetic
tree represents the founding clone. However, the data may also contain
non-aberrant cells, i.e., the tumor purity is less than 100%. For these
cases, the `normalsInPhylogenyRoot` option instructs Jellyfisher to
treat the root node as non-aberrant cells. The option has two
consequences: (1) No tentacles are drawn between the root subclones, and
(2) the root subclone is colored as white when the phylogeny-aware color
scheme is used.

``` r
# Subclone N at the root represents the non-aberrant cells.
# The letter N has no special meaning in Jellyfisher.
non_aberrant <- list(
  samples = data.frame(sample = c("A", "B")),
  compositions = data.frame(
    sample = c("A", "A", "A", "B", "B", "B"),
    subclone = c("N", "1", "2", "N", "1", "2"),
    clonalPrevalence = c(0.2, 0.4, 0.4, 0.3, 0.3, 0.4)
  ),
  phylogeny = data.frame(
    subclone = c("N", "1", "2"),
    parent = c(NA, "N", "1")
  )
)
```

``` r
non_aberrant |>
  jellyfisher(options = list(
    normalsAtPhylogenyRoot = TRUE
  ),
  width = "100%", height = 350)
```

In the above plot, the root clone, which represents the non-aberrant
cells, is hidden from the inferred root sample. However, sometimes a
patient may have multiple independent clones, and in these cases the
root clone is shown:

``` r
# Change the parent of subclone 2 to N
non_aberrant$phylogeny$parent[non_aberrant$phylogeny$subclone == "2"] <- "N"

non_aberrant |>
  jellyfisher(options = list(
    normalsAtPhylogenyRoot = TRUE
  ),
  width = "100%", height = 350)
```

## Session info

``` r
sessionInfo()
#> R version 4.5.2 (2025-10-31)
#> Platform: x86_64-pc-linux-gnu
#> Running under: Ubuntu 24.04.3 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
#> 
#> locale:
#>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
#> 
#> time zone: UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] jellyfisher_1.1.0
#> 
#> loaded via a namespace (and not attached):
#>  [1] vctrs_0.6.5       cli_3.6.5         knitr_1.50        rlang_1.1.6      
#>  [5] xfun_0.54         stringi_1.8.7     generics_0.1.4    textshaping_1.0.4
#>  [9] jsonlite_2.0.0    glue_1.8.0        htmltools_0.5.8.1 ragg_1.5.0       
#> [13] sass_0.4.10       rmarkdown_2.30    tibble_3.3.0      evaluate_1.0.5   
#> [17] jquerylib_0.1.4   fastmap_1.2.0     yaml_2.3.10       lifecycle_1.0.4  
#> [21] stringr_1.6.0     compiler_4.5.2    dplyr_1.1.4       fs_1.6.6         
#> [25] pkgconfig_2.0.3   htmlwidgets_1.6.4 systemfonts_1.3.1 digest_0.6.39    
#> [29] R6_2.6.1          tidyselect_1.2.1  pillar_1.11.1     magrittr_2.0.4   
#> [33] bslib_0.9.0       tools_4.5.2       pkgdown_2.2.0     cachem_1.1.0     
#> [37] desc_1.4.3
```
