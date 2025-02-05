#' Extract Data for Jellyfisher from ClonEvol Results
#'
#' ClonEvol infers clonal evolution from multi-sample cancer sequencing data
#' and generates phylogenetic models of tumor evolution.
#' This function extracts data frames from a ClonEvol object that can be
#' used to create a Jellyfish plot.
#'
#' Note: ClonEvol reports clonal prevalences as confidence intervals.
#' This function extracts the mean values and uses them as the prevalence
#' values.
#'
#' For more details about ClonEvol, including the installation instructions,
#' visit its GitHub \href{https://github.com/hdng/clonevol}{repository} or read
#' the publication by Dang et al. (2017, \doi{doi:10.1093/annonc/mdx517}).
#'
#' @param y A ClonEvol object
#' @param model The model to extract. Defaults to 1
#'
#' @return A named list with three data frames: samples, phylogeny,
#'   and compositions
#'
#' @import dplyr
#' @import stringr
#'
#' @examples
#' if (requireNamespace("clonevol", quietly = TRUE)) {
#'   # Run ClonEvol with its example data
#'   # (refer to ClonEvol documentation for details)
#'   data <- clonevol::aml1
#'   y <- clonevol::infer.clonal.models(
#'     variants = data$variants,
#'     cluster.col.name = "cluster",
#'     vaf.col.names = data$params$vaf.col.names,
#'     subclonal.test = "bootstrap",
#'     subclonal.test.model = "non-parametric",
#'     num.boots = 1000,
#'     founding.cluster = 1,
#'     cluster.center = "mean",
#'     ignore.clusters = NULL,
#'     min.cluster.vaf = 0.01,
#'     sum.p = 0.05,
#'     alpha = 0.05
#'   )
#'   # Make branch lengths available
#'   y <- clonevol::convert.consensus.tree.clone.to.branch(y)
#'
#'   # Extract data and plot the results
#'   extract_tables_from_clonevol(y, model = 1) |>
#'     jellyfisher()
#' } else {
#'   message(
#'     "Please install the clonevol package from GitHub: devtools::install_github('hdng/clonevol')"
#'   )
#' }
#'
#' @export
#'
extract_tables_from_clonevol <- function(y, model = 1) {
  # Silence lintr
  lab <- sample.with.cell.frac.ci <- lower <- upper <- frac <- blengths <-
    subclone <- color <- parent <- NA

  if (is.null(y$matched$merged.trees)) {
    stop("Not a valid ClonEvol object")
  }

  tree <- y$matched$merged.trees[[model]]

  if (is.null(tree$blengths)) {
    stop("run \"y <- clonevol::convert.consensus.tree.clone.to.branch(y)\" before calling this function")
  }

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
      matrix(str_match(
        samples,
        "^[\u00B0*]?([A-Za-z0-9_]+).* : (-?[0-9.]+)-([0-9.]+)"
      )[, (2:4)], ncol = 3)
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

  return(list(
    samples = samples,
    phylogeny = phylogeny,
    compositions = subclonal_compositions
  ))
}
