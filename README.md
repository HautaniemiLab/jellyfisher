# <img src="man/figures/logo.webp" alt="Jellyfisher hexagon" align="right" height="138" style="margin-left: 0.5em" /> Jellyfisher

<!-- badges: start -->

[![R-CMD-check](https://github.com/HautaniemiLab/jellyfisher/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/HautaniemiLab/jellyfisher/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

**Jellyfisher** is an R package for visualizing tumor evolution and subclonal
compositions using Jellyfish plots, which display both spatial and temporal
dimensions in a single unified figure.

The package is based on the
[Jellyfish](https://github.com/HautaniemiLab/jellyfish) visualization tool,
bringing its functionality to R users. Jellyfisher supports both
[ClonEvol](https://github.com/hdng/clonevol) results and plain data frames,
making it compatible with various tools and workflows.

![Jellyfisher Example Plot](https://raw.githubusercontent.com/HautaniemiLab/jellyfish/refs/heads/main/docs/example.svg)

## Installation

```R
# Install Devtools
install.packages("devtools")

# Install Jellyfisher
devtools::install_github("HautaniemiLab/jellyfisher", build_vignettes = TRUE)
```

## Usage

Jellyfisher is designed to work with data frames or ClonEvol results.

### Plotting Data Frames

The input data should follow specific structures for _samples_, _phylogeny_, and
subclonal _compositions_, which are described in the
[`jellyfisher`](https://hautaniemilab.github.io/jellyfisher/reference/jellyfisher.html)
function's documentation.

#### Example

```R
library(jellyfisher)

# Plot the bundled example data
jellyfisher(jellyfisher_example_tables)
```

### Plotting ClonEvol Results

Jellyfisher provides a straightforward way to visualize
[ClonEvol](https://github.com/hdng/clonevol) results using the
`extract_tables_from_clonevol` function. The function returns a list of data
frames that you can pass to the `jellyfisher` function. N.B., ClonEvol reports
clonal prevalences as confidence intervals. The function extracts the mean
values and uses them as the prevalence values.

#### Example

```R
library(clonevol)
library(jellyfisher)

# Run ClonEvol. Check the ClonEvol documentation for details.
y <- infer.clonal.models(...)
y <- convert.consensus.tree.clone.to.branch(y)

# Plot the results
extract_tables_from_clonevol(y, model = 1) |>
  jellyfisher()
```

### Setting Parent-Child Relationships of Samples

By default, all samples that have no explicit parent are children of the
_inferred root_ sample. You can customize the parent-child relationships by
modifying the `parent` column in the `samples` data frame before plotting.

You can also modify the relationships with ease using the `set_parents`
function.

For example, if you have three samples, A, B, and C, they will have the
following relationships by default:

```
    Root
   / | \
  A  B  C
```

With the explicit parents, you can customize the relationships:

```R
tables |>
  set_parents(list(
    # The parent of C is B
    "C" = "B"
  ) |>
  jellyfisher()
```

```
    Root
   /  \
  A    B
        \
         C
```

## Contributing

_Jellyfisher_ is a thin wrapper for the
[Jellyfish](https://github.com/HautaniemiLab/jellyfish) visualization tool.
Jellyfish is included as a git submodule in the
[`tools/jellyfish/`](tools/jellyfish) directory.

To build the Jellyfish JavaScript dependency, run the
[`update-and-build.sh`](tools/update-and-build.sh) script in the
[`tools/`](tools/) directory. Most of the R code is autogenerated from the
Jellyfish JavaScript code using the
[`generate-R-code.mjs`](tools/generate-R-code.mjs) script, which should be run
after building the Jellyfish dependency.

## About

Copyright (c) 2025 Kari Lavikka. MIT license, see [LICENSE.md](LICENSE.md) for details.

Jellyfisher is developed in [The Systems Biology of Drug Resistance in
Cancer](https://www.helsinki.fi/en/researchgroups/systems-biology-of-drug-resistance-in-cancer)
group at the [University of Helsinki](https://www.helsinki.fi/en).

This project has received funding from the European Union's Horizon 2020
research and innovation programme under grant agreements No. 965193
([DECIDER](https://www.deciderproject.eu/)) and No. 847912
([RESCUER](https://www.rescuer.uio.no/)).
