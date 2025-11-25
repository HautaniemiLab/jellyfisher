# Shiny bindings for jellyfisher

Output and render functions for using jellyfisher within Shiny
applications and interactive Rmd documents.

## Usage

``` r
jellyfisherOutput(outputId, width = "100%", height = "400px")

renderJellyfisher(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  output variable to read from

- width, height:

  Must be a valid CSS unit (like `'100%'`, `'400px'`, `'auto'`) or a
  number, which will be coerced to a string and have `'px'` appended.

- expr:

  An expression that generates a jellyfisher

- env:

  The environment in which to evaluate `expr`.

- quoted:

  Is `expr` a quoted expression (with
  [`quote()`](https://rdrr.io/r/base/substitute.html))? This is useful
  if you want to save an expression in a variable.

## Value

- `jellyfisherOutput()`:

  A `shiny.tag` object that can be included in a Shiny UI definition.

- `renderJellyfisher()`:

  A `shiny.render.function` that returns an `htmlwidget` object for use
  in a Shiny server function.
