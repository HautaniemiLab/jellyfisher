#' Extract samples, phylogeny, and subclonal compositions from ClonEvol results
#'
#' Extracts data frames that can be used to create a Jellyfish plot.
#'
#' @param y A ClonEvol object
#' @param model The model to extract from
#'
#' @import dplyr
#' @import stringr
#' @import clonevol
#'
#' @export
#'
extract_tables_from_clonevol <- function(y, model = 1, explicit_parents = list()) {
  library(dplyr)
  library(stringr)
  library(clonevol)

  y <- convert.consensus.tree.clone.to.branch(y)

  tree <- y$matched$merged.trees[[model]]

  # Split the cluster table into separate sample-specific proportions
  all <- matrix(ncol = 4)
  colnames(all) <- c("cluster", "sample", "lower", "upper")
  for (cluster in tree$lab) {
    fracs <- tree |>
      filter(lab == cluster) |>
      pull(sample.with.cell.frac.ci)

    samples <- str_split(fracs, ",")[[1]]
    matched <- cbind(
      cluster,
      matrix(str_match(samples, "^[°*]?([A-Za-z0-9_]+).* : (-?[0-9.]+)-([0-9.]+)")[, (2:4)], ncol = 3)
    )

    all <- rbind(all, matched)
  }

  subclonal_compositions <- as.data.frame(all) |>
    filter(!is.na(cluster)) |>
    mutate(
      cluster = as.integer(cluster),
      lower = as.numeric(lower) / 100,
      upper = as.numeric(upper) / 100,
      frac = (lower + upper) / 2
    ) |>
    arrange(cluster, sample) |>
    transmute(sample,
      subclone = cluster,
      clonalPrevalence = round(frac, 4)
    )

  phylogeny <- tree |>
    transmute(
      subclone = as.integer(lab),
      parent = as.integer(parent),
      color,
      branchLength = blengths
    ) |>
    arrange(subclone)

  samples <- data.frame(
    sample = subclonal_compositions |>
      pull(sample) |>
      unique()
  ) |>
    mutate(parent = NA)

  for (i in seq_len(nrow(samples))) {
    parent <- explicit_parents[[samples$sample[[i]]]]
    if (!is.null(parent)) {
      samples$parent[[i]] <- parent
    } else {
      samples$parent[[i]] <- NA
    }
  }

  return(list(
    samples = samples,
    phylogeny = phylogeny,
    compositions = subclonal_compositions
  ))
}

#' Create a Jellyfish plot from a ClonEvol object
#'
#' Takes a ClonEvol result object, extracts the necessary data, and creates
#' a Jellyfish plot.
#'
#' @param y A ClonEvol object
#' @param model The model to extract from
#'
#' @export
#'
jellyfisher_clonevol <- function(y, model = 1, explicit_parents = list()) {
  x <- extract_tables_from_clonevol(y, model, explicit_parents)

  jellyfisher(
    samples = x$samples,
    phylogeny = x$phylogeny,
    compositions = x$compositions
  )
}
