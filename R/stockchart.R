#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
stockchart <- function(message, width = NULL, height = NULL) {

  # forward options using x
  x = list(
    message = message
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'stockchart',
    x,
    width = width,
    height = height,
    package = 'stockchartR'
  )
}

#' Shiny bindings for stockchart
#'
#' Output and render functions for using stockchart within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a stockchart
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name stockchart-shiny
#'
#' @export
stockchartOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'stockchart', width, height, package = 'stockchartR')
}

#' @rdname stockchart-shiny
#' @export
renderStockchart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, stockchartOutput, env, quoted = TRUE)
}
