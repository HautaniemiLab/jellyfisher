# <img src="man/figures/logo.webp" alt="Jellyfisher hexagon" align="right" height="138" style="margin-left: 0.5em" /> Jellyfisher: Visualizing Tumor Evolution with Jellyfish Plots in R

**Jellyfisher** is an R package for visualizing tumor evolution and subclonal
compositions using Jellyfish plots. The package is based on the
[Jellyfish](https://github.com/HautaniemiLab/jellyfish) visualization tool,
bringing its functionality to R users. Jellyfisher supports both ClonEvol
results and plain data frames, making it compatible with various tools and
workflows.

![Jellyfisher Example](https://raw.githubusercontent.com/HautaniemiLab/jellyfish/refs/heads/main/docs/example.svg)

The package is still under development and the API may change in the future.
Stay tuned!

## Installation

```R
# Install Devtools
install.packages("devtools")

# Install Jellyfisher
devtools::install_github("HautaniemiLab/jellyfisher")
```

## Usage

Jellyfisher is designed to work with data frames or ClonEvol results.

### Plotting Data Frames

The input data should follow specific structures for _samples_, _phylogeny_, and
subclonal _compositions_, which are described in the [Jellyfish
documentation](https://github.com/HautaniemiLab/jellyfish?tab=readme-ov-file#input-data).

#### Example

```R
library(jellyfisher)

# Plot the bundled example data
jellyfisher(samples = samples.example,
            phylogeny = phylogeny.example,
            compositions = compositions.example)
```

### Plotting ClonEvol Results

Jellyfisher provides a straightforward way to visualize ClonEvol results using
the `jellyfisher_clonevol` function. The function takes the ClonEvol results as
input and generates a Jellyfish plot.

#### Example

```R
library(clonevol)
library(jellyfisher)

# Run ClonEvol. Check the ClonEvol documentation for details.
y <- infer.clonal.models(...)

# Plot the results
jellyfisher_clonevol(y, model = 1, explicit_parents = list())
```

#### Extracting Data Frames from ClonEvol Results

If you need to process ClonEvol output further or plot it in different ways,
Jellyfisher includes a helper function to extract the relevant data frames:

```R
extract_tables_from_clonevol(y, model = 1, explicit_parents = list())
```

The function returns a list of data frames that you can pass to the
`jellyfisher` function. N.B., ClonEvol reports clonal prevalences as confidence
intervals. The function extracts the mean values and uses them as the prevalence
values.

#### Setting Parent-Child Relationships of Samples

By default, all samples that have no explicit parent are children of the
_inferred root_ sample. To define custom parent-child relationships, you can
pass a list of explicit relationships to the `explicit_parents` argument.

For example, if you have three samples, A, B, and C, they will have the
following relationships by default:

```
    Root
   / | \
  A  B  C
```

With the explicit parents, you can customize the relationships:

```R
explicit_parents = list(
  C = "B"
)
```

```
    Root
   /  \
  A    B
        \
         C
```

You can alternatively define the relationships by mutating the `samples` data
frame generated by `extract_tables_from_clonevol` before plotting.

## About

Copyright (c) 2024 Kari Lavikka. MIT license, see [LICENSE](LICENSE) for details.

Jellyfish Plotter is developed in [The Systems Biology of Drug Resistance in
Cancer](https://www.helsinki.fi/en/researchgroups/systems-biology-of-drug-resistance-in-cancer)
group at the [University of Helsinki](https://www.helsinki.fi/en).

This project has received funding from the European Union's Horizon 2020
research and innovation programme under grant agreement No. 965193
([DECIDER](https://www.deciderproject.eu/)) and No. 847912
([RESCUER](https://www.rescuer.uio.no/)).
