#' Filter Jellyfish tables by patient
#'
#' Given a list of tables, filter them by patient.
#'
#' @param tables A list of tables
#' @param patient The patient to filter by
#'
#' @return A list of tables filtered by patient
#'
#' @export
#'
filter_tables <- function(tables, patient) {
  validate_tables(tables)
  list(
    samples = tables$samples[tables$samples$patient == patient, ],
    phylogeny = tables$phylogeny[tables$phylogeny$patient == patient, ],
    compositions = tables$compositions[tables$compositions$patient == patient, ]
  )
}

validate_tables <- function(tables) {
  stopifnot(
    is.data.frame(tables$samples),
    is.data.frame(tables$phylogeny),
    is.data.frame(tables$compositions)
  )

  stopifnot(
    all(c("sample") %in% colnames(tables$samples)),
    all(c("subclone", "parent") %in% colnames(tables$phylogeny)),
    all(c("sample", "subclone", "clonalPrevalence") %in% colnames(tables$compositions))
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
