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

  # If a rank column exists in the samples table, ensure it's either all NA
  # (allowed) or entirely numeric with no NAs; mixtures or non-numeric columns are rejected.
  if ("rank" %in% colnames(tables$samples)) {
    rank_col <- tables$samples$rank

    # If all values are NA, that's allowed.
    if (all(is.na(rank_col))) {
      # nothing to check
    } else {
      # Otherwise the column must be numeric and contain no NAs (no mixtures).
        # If there are any non-NA values, ensure the column is numeric.
        if (!all(is.na(rank_col))) {
          stopifnot(is.numeric(rank_col))
        }
    }
  }
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

#' Insert an a hypothetical inferred sample into the sample tree and set it
#' as the parent of specified samples.
#' 
#' @param tables A list of tables (samples, phylogeny, compositions, ranks)
#' @param name The name of the inferred sample to add
#' @param rank The rank of the inferred sample
#' @param samples A character vector of samples to set the inferred sample as their parent
#' @param parent_sample The parent sample of the inferred sample. If NULL, the inferred root is used.
#' @param display_name The display name of the inferred sample (default: "Inferred")
#' 
#' @return A list of tables with a newly added inferred sample and updated parent relationships
#' 
#' @examples
#' jellyfisher_example_tables |>
#'   select_patients("EOC153") |>
#'   add_inferred_sample("EOC153_Inf",
#'                       2,
#'                       c("EOC153_iPer1_DNA4",
#'                         "EOC153_iOme1_DNA4",
#'                         "EOC153_iOvaR1_DNA1")) |>
#'   jellyfisher()
#' 
#' @export
#' 
add_inferred_sample <- function(tables, name, rank = NULL,
                                samples = character(),
                                parent_sample = NULL,
                                display_name = "Inferred") {
  validate_tables(tables)

  # Basic argument checks
  stopifnot(is.character(name), length(name) == 1, nzchar(name))
  if (!is.character(display_name) || length(display_name) != 1) {
    stop("display_name must be a single string")
  }

  if (name %in% tables$samples$sample) {
    stop(sprintf("inferred sample name '%s' already exists in tables$samples", name))
  }

  # Validate parent_sample if provided
  if (!is.null(parent_sample)) {
    stopifnot(is.character(parent_sample), length(parent_sample) == 1)
    if (!(parent_sample %in% tables$samples$sample)) {
      stop(sprintf("parent_sample '%s' not found in tables$samples", parent_sample))
    }
  }

  # Validate target samples to reparent
  if (length(samples) > 0) {
    if (!is.character(samples)) samples <- as.character(samples)
    missing_samples <- setdiff(samples, tables$samples$sample)
    if (length(missing_samples) > 0) {
      stop(sprintf("the following samples to reparent were not found: %s", paste(missing_samples, collapse = ", ")))
    }
    if (name %in% samples) stop("inferred sample 'name' cannot be one of the target samples to reparent")
  }

  # Rank is optional. If rank is provided or the samples table contains a 'rank'
  # column with at least one non-NA value, it must be present in both places
  # (argument and table). A rank column that's entirely NA is treated as absent.
  has_rank_col <- "rank" %in% colnames(tables$samples) &&
                  !all(is.na(tables$samples$rank))
  rank_provided <- !is.null(rank)
  if (xor(has_rank_col, rank_provided)) {
    stop("'rank' must be provided both as a function argument and present as a column in tables$samples, or omitted from both")
  }
  if (rank_provided) stopifnot(is.numeric(rank), length(rank) == 1)

  # If a rank column exists, ensure that the relevant rows have non-missing,
  # numeric values. We check the target samples to be reparented and the
  # parent_sample (if provided). This guarantees ranks are usable for ordering
  # checks below.
  if (has_rank_col) {
    # Check target samples' ranks
    if (length(samples) > 0) {
      target_ranks <- tables$samples$rank[tables$samples$sample %in% samples]
      if (any(is.na(target_ranks))) {
        stop("one or more target samples have missing rank values")
      }
    }

    # Check parent sample's rank
    if (!is.null(parent_sample)) {
      parent_rank <- tables$samples$rank[tables$samples$sample == parent_sample]
      if (length(parent_rank) == 0 || is.na(parent_rank)) {
        stop("parent_sample has missing rank value")
      }
    }
  }

  # If rank is used, validate ordering constraints using ranks from the table
  if (rank_provided) {
    # If reparenting samples, ensure inferred rank is strictly less than their ranks
    if (length(samples) > 0) {
      target_ranks <- tables$samples$rank[tables$samples$sample %in% samples]
      if (any(is.na(target_ranks))) {
        stop("one or more target samples have missing rank values")
      }
      if (!(rank < min(target_ranks))) {
        stop("inferred sample rank must be less than the ranks of all reparented samples")
      }
    }

    # If a parent_sample is provided, ensure inferred rank is strictly greater than parent's rank.
    # If no parent is provided, ensure inferred rank is greater than zero.
    if (!is.null(parent_sample)) {
      parent_rank <- tables$samples$rank[tables$samples$sample == parent_sample]
      if (length(parent_rank) == 0 || is.na(parent_rank)) {
        stop("parent_sample has missing rank value")
      }
      if (!(rank > parent_rank)) {
        stop("inferred sample rank must be greater than the rank of parent_sample")
      }
    } else {
      if (!(rank > 0)) {
        stop("inferred sample rank must be greater than zero when no parent_sample is provided")
      }
    }
  }

  # Determine patient for the inferred sample with a small, clear sequence
  patient_field <- NA_character_
  if ("patient" %in% colnames(tables$samples)) {
    # Prefer parent_sample's patient
    if (!is.null(parent_sample)) {
      p <- unique(stats::na.omit(as.character(tables$samples$patient[tables$samples$sample == parent_sample])))
      if (length(p) == 0) {
        patient_field <- NA_character_
      } else if (length(p) > 1) {
        stop("multiple patient values found for parent_sample")
      } else {
        patient_field <- p[[1]]
      }
    } else if (length(samples) > 0) {
      vals <- unique(stats::na.omit(as.character(tables$samples$patient[tables$samples$sample %in% samples])))
      if (length(vals) == 0) {
        patient_field <- NA_character_
      } else if (length(vals) > 1) {
        stop("target samples belong to multiple patients; inferred sample must belong to a single patient")
      } else {
        patient_field <- vals[[1]]
      }
    }
  }

  # Construct new sample row. Include `rank` only if rank is used in this dataset.
  new_sample <- data.frame(
    sample = name,
    displayName = display_name,
    parent = if (is.null(parent_sample)) NA_character_ else parent_sample,
    patient = patient_field,
    stringsAsFactors = FALSE
  )
  if ("rank" %in% colnames(tables$samples)) {
    new_sample$rank <- if (is.null(rank)) NA_real_ else rank
  }

  new_samples <- rbind(tables$samples, new_sample)

  if (length(samples) > 0) {
    for (s in samples) {
      new_samples$parent[new_samples$sample == s] <- name
    }
  }

  list(
    samples = new_samples,
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
