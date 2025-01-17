#' Extract samples, phylogeny, and subclonal compositions from ClonEvol results
#'
#' Extracts data frames that can be used to create a Jellyfish plot.
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
#' \dontrun{
#' # Run ClonEvol. Check the ClonEvol documentation for details.
#' y <- infer.clonal.models(...)
#' y <- convert.consensus.tree.clone.to.branch(y)
#'
#' # Plot the results
#' extract_tables_from_clonevol(y, model = 1) |>
#'   jellyfisher()
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
