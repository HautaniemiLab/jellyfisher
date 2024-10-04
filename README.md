# <img src="man/figures/logo.webp" alt="Jellyfisher hexagon" align="right" height="138" style="margin-left: 0.5em" /> Jellyfisher: Visualizing Tumor Evolution with Jellyfish Plots in R

**Jellyfisher** is an R package that generates Jellyfish plots for visualizing
tumor evolution and subclonal compositions. The package is based on the
[Jellyfish](https://github.com/HautaniemiLab/jellyfish) visualization tool,
bringing its functionality to R users. The package is designed to work with with
plain data frames or ClonEvol results, providing an easy way to visualize tumor
evolution directly in R.

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

Input data format is the same as for Jellyfish itself. Consult the [Jellyfish
documentation](https://github.com/HautaniemiLab/jellyfish?tab=readme-ov-file#input-data)
for more information.

### Plotting Data Frames

#### Example

```R
library(jellyfisher)

# Plot the bundled example data
jellyfisher(samples = samples.example,
            phylogeny = phylogeny.example,
            compositions = compositions.example)
```

### Plotting ClonEvol Results

#### Example

```R
library(clonevol)
library(jellyfisher)

# Run ClonEvol
y <- infer.clonal.models(...)

# Plot the results
jellyfisher_clonevol(y)
```

### Extracting Data Frames from ClonEvol Results

The package also includes a function to extract the data frames from ClonEvol for
further processing or plotting:

```R
extract_tables_from_clonevol(y, model = 1, explicit_parents = list())
```

## About

Copyright (c) 2024 Kari Lavikka. See [LICENSE](LICENSE) for details.

Jellyfish Plotter is developed in [The Systems Biology of Drug Resistance in
Cancer](https://www.helsinki.fi/en/researchgroups/systems-biology-of-drug-resistance-in-cancer)
group at the [University of Helsinki](https://www.helsinki.fi/en).

This project has received funding from the European Union's Horizon 2020
research and innovation programme under grant agreement No. 965193
([DECIDER](https://www.deciderproject.eu/)) and No. 847912
([RESCUER](https://www.rescuer.uio.no/)).
