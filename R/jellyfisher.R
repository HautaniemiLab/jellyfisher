#' Creates a Jellyfish plot
#'
#' Creates a Jellyfish plot from a samples, a phylogeny, and subclonal compositions.
#' The format of the data frames are described in Jellyfish documentation:
#' https://github.com/HautaniemiLab/jellyfish?tab=readme-ov-file#input-data
#'
#' @param samples A data frame with samples
#' @param phylogeny A data frame with phylogeny
#' @param compositions A data frame with subclonal compositions
#'
#' @import htmlwidgets
#'
#' @export
jellyfisher <- function(samples, phylogeny, compositions, ranks = NULL, width = NULL, height = NULL, elementId = NULL) {
  # forward options using x
  x <- list(
    samples = samples,
    phylogeny = phylogeny,
    compositions = compositions,
    ranks = ranks
  )

  # create widget
  htmlwidgets::createWidget(
    name = "jellyfisher",
    x,
    width = width,
    height = height,
    package = "jellyfisher",
    elementId = elementId
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
