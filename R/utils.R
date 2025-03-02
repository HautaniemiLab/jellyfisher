#' Filter Jellyfish tables by patient
#'
#' Given a list of tables, filter them by patient.
#'
#' @param tables A list of tables (samples, phylogeny, compositions, ranks)
#' @param patient The patient or patients to filter by
#'
#' @return A list of tables filtered by patient
#'
#' @examples
#' jellyfisher_example_tables |>
#'   select_patients("EOC809")
#'
#' @export
#'
select_patients <- function(tables, patient) {
  validate_tables(tables)
  list(
    samples = tables$samples[tables$samples$patient %in% patient, ],
    phylogeny = tables$phylogeny[tables$phylogeny$patient %in% patient, ],
    compositions = tables$compositions[tables$compositions$patient %in% patient, ],
    ranks = tables$ranks
  )
}

#' Validate Jellyfish tables
#'
#' Superficially validate that the tables are in the correct format.
#'
#' @param tables A list of tables (samples, phylogeny, compositions, ranks)
#'
validate_tables <- function(tables) {
  stopifnot(
    is.data.frame(tables$samples),
    is.data.frame(tables$phylogeny),
    is.data.frame(tables$compositions)
  )

  if (!is.null(tables$ranks)) {
    stopifnot(is.data.frame(tables$ranks))
  }

  stopifnot(
    all(c("sample") %in% colnames(tables$samples)),
    all(c("subclone", "parent") %in% colnames(tables$phylogeny)),
    all(c("sample", "subclone", "clonalPrevalence") %in% colnames(tables$compositions))
  )
}

#' Set parents for samples
#'
#' Given a list of jellyfish input tables and a named list of parents for each
#' sample, set the parent for each sample.
#'
#' By default, all samples that have no explicit parent are children of the
#' _inferred root_ sample. You can customize the parent-child relationships by
#' modifying the `parent` column in the `samples` data frame before plotting.
#'
#' You can also modify the relationships using the `set_parents` function.
#'
#' For example, if you have three samples, A, B, and C, they will have the
#' following relationships by default:
#'
#' ```
#'     Root
#'    / | \
#'   A  B  C
#' ```
#'
#' With the explicit parents, you can customize the relationships:
#'
#' ```R
#' tables |>
#'   set_parents(list(
#'     # The parent of C is B
#'     C = "B"
#'   ) |>
#'   jellyfisher()
#' ```
#'
#' ```
#'     Root
#'    /  \
#'   A    B
#'         \
#'          C
#' ```
#'
#' @param tables A list of tables (samples, phylogeny, compositions, ranks)
#' @param parents A named list of parents for each sample. Keys are the samples
#'  and values are their new parents
#' @param unset_missing If TRUE, unset the parent for samples that are not in
#'  the parent list
#'
#' @return A list of tables with parents set for each sample
#'
#' @examples
#' jellyfisher_example_tables |>
#'   select_patients("EOC809") |>
#'   set_parents(list("EOC809_r1Bow1_DNA1" = "EOC809_p2Per1_cO_DNA2")) |>
#'   jellyfisher()
#'
#' @export
#'
set_parents <- function(tables, parents, unset_missing = FALSE) {
  validate_tables(tables)
  # Check that all samples in the samples table are unique
  stopifnot(length(unique(tables$samples$sample)) == nrow(tables$samples))

  samples <- tables$samples

  # Check that all samples in the parent list are in the samples table
  stopifnot(all(names(parents) %in% samples$sample))
  stopifnot(all(unlist(parents) %in% samples$sample))

  for (i in seq_len(nrow(samples))) {
    parent <- parents[[samples$sample[[i]]]]
    if (!is.null(parent)) {
      samples$parent[[i]] <- parent
    } else if (unset_missing) {
      samples$parent[[i]] <- NA
    }
  }

  list(
    samples = samples,
    phylogeny = tables$phylogeny,
    compositions = tables$compositions,
    ranks = tables$ranks
  )
}

#' Set ranks for samples
#'
#' Given a list of jellyfish input tables and a named list of ranks for each
#' sample, set the rank for each sample.
#'
#' @param tables A list of tables (samples, phylogeny, compositions, ranks)
#' @param ranks A named list of ranks for each sample
#' @param default The default rank to use when a sample is not in the rank list
#'   (default: 1)
#'
#' @return A list of tables with ranks set for each sample
#'
#' @examples
#' jellyfisher_example_tables |>
#'   select_patients("EOC809") |>
#'   set_ranks(list("EOC809_r1Bow1_DNA1" = 2, "EOC809_p2Per1_cO_DNA2" = 2),
#'     default = 1
#'   ) |>
#'   jellyfisher()
#'
#' @export
#'
set_ranks <- function(tables, ranks, default = 1) {
  validate_tables(tables)
  # Check that all samples in the samples table are unique
  stopifnot(length(unique(tables$samples$sample)) == nrow(tables$samples))

  samples <- tables$samples

  # Check that all samples in the rank list are in the samples table
  stopifnot(all(names(ranks) %in% samples$sample))

  for (i in seq_len(nrow(samples))) {
    rank <- ranks[[samples$sample[[i]]]]
    if (!is.null(rank)) {
      samples$rank[[i]] <- rank
    } else {
      samples$rank[[i]] <- default
    }
  }

  list(
    samples = samples,
    phylogeny = tables$phylogeny,
    compositions = tables$compositions,
    ranks = tables$ranks
  )
}

#' Shiny bindings for jellyfisher
#'
#' Output and render functions for using jellyfisher within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a jellyfisher
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @return \describe{
#'   \item{\code{jellyfisherOutput()}}{
#'     A `shiny.tag` object that can be included in a Shiny UI definition.}
#'   \item{\code{renderJellyfisher()}}{
#'     A `shiny.render.function` that returns an `htmlwidget` object for use in
#'     a Shiny server function.}
#' }
#'
#' @name jellyfisher-shiny
#'
#' @export
jellyfisherOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(outputId, "jellyfisher", width, height, package = "jellyfisher")
}

#' @rdname jellyfisher-shiny
#' @export
renderJellyfisher <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  } # force quoted
  htmlwidgets::shinyRenderWidget(expr, jellyfisherOutput, env, quoted = TRUE)
}
