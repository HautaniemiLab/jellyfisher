# Extract Data for Jellyfisher from ClonEvol Results

ClonEvol infers clonal evolution from multi-sample cancer sequencing
data and generates phylogenetic models of tumor evolution. This function
extracts data frames from a ClonEvol object that can be used to create a
Jellyfish plot.

## Usage

``` r
extract_tables_from_clonevol(y, model = 1)
```

## Arguments

- y:

  A ClonEvol object

- model:

  The model to extract. Defaults to 1

## Value

A named list with three data frames: samples, phylogeny, and
compositions

## Details

Note: ClonEvol reports clonal prevalences as confidence intervals. This
function extracts the mean values and uses them as the prevalence
values.

For more details about ClonEvol, including the installation
instructions, visit its GitHub
[repository](https://github.com/hdng/clonevol) or read the publication
by Dang et al. (2017,
[doi:10.1093/annonc/mdx517](https://doi.org/10.1093/annonc/mdx517) ).

## Examples

``` r
if (requireNamespace("clonevol", quietly = TRUE)) {
  # Run ClonEvol with its example data
  # (refer to ClonEvol documentation for details)
  data <- clonevol::aml1
  y <- clonevol::infer.clonal.models(
    variants = data$variants,
    cluster.col.name = "cluster",
    vaf.col.names = data$params$vaf.col.names,
    subclonal.test = "bootstrap",
    subclonal.test.model = "non-parametric",
    num.boots = 1000,
    founding.cluster = 1,
    cluster.center = "mean",
    ignore.clusters = NULL,
    min.cluster.vaf = 0.01,
    sum.p = 0.05,
    alpha = 0.05
  )
  # Make branch lengths available
  y <- clonevol::convert.consensus.tree.clone.to.branch(y)

  # Extract data and plot the results
  extract_tables_from_clonevol(y, model = 1) |>
    jellyfisher()
} else {
  message(
    "Please install the clonevol package from GitHub: devtools::install_github('hdng/clonevol')"
  )
}
#> Please install the clonevol package from GitHub: devtools::install_github('hdng/clonevol')
```
