#' Interactive d3/React Stockcharts
#'
#' Create interactive stock charts using the d3.js + React
#'   \href{http://rrag.github.io/react-stockcharts/}{react-stockcharts}.  Currently
#'   only the pan+zoom candlestick with volume histogram is available, but expect
#'   complete coverage and full functionality soon.
#'
#' @param data time series price data ideally \code{\link{xts}}.  OHCLV is required.
#'
#' @example ./inst/examples/example_stockchart.R
#'
#' @import htmlwidgets
#'
#' @export
stockchart <- function(data = NULL, width = NULL, height = NULL) {
  # force xts data
  tryCatch({
      data <- as.xts(data)
    }
    , error = function(e) "please provide data that is xts or can convert into xts."
  )

  data <- data.frame(
    date = format( index( data ), "%Y-%m-%d" )
    , open = as.vector( Op( data ) )
    , high = as.vector( Hi( data ) )
    , low = as.vector( Lo( data ) )
    , close = as.vector( Cl( data ) )
    , volume = as.vector( Vo( data ) )
    , adjusted = as.vector( Ad( data ) )
  )

  # forward options using x
  x = list(
    data = data
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

stockchart_html <- function(name, package, id, style, class, ...){
  htmltools::tagList(
    htmltools::tags$div(id = id, style = style, class = class, class = "react-stockchart", ...)
    ,htmltools::tags$script(type="text/jsx;harmony=true"
      ,
htmltools::HTML('

var { ChartCanvas, Chart, DataSeries, EventCapture } = ReStock;
var { CandlestickSeries, HistogramSeries } = ReStock.series;
var { MouseCoordinates } = ReStock.coordinates;

var { TooltipContainer, OHLCTooltip } = ReStock.tooltip;
var { StockscaleTransformer } = ReStock.transforms;

var { XAxis, YAxis } = ReStock.axes;
var { ChartWidthMixin } = ReStock.helper;

var CandleStickChartWithZoomPan = React.createClass({
mixins: [ChartWidthMixin],
propTypes: {
data: React.PropTypes.array.isRequired,
type: React.PropTypes.oneOf(["svg", "hybrid"]).isRequired,
},
render() {
if (this.state === null || !this.state.width) return <div />;
var { data, type } = this.props;
var dateFormat = d3.time.format("%Y-%m-%d");

return (
<ChartCanvas width={this.state.width} height={400}
margin={{left: 70, right: 70, top:10, bottom: 30}} initialDisplay={200}
dataTransform={[ { transform: StockscaleTransformer } ]}
data={data} type={type}>
<Chart id={1} yMousePointerDisplayLocation="right" yMousePointerDisplayFormat={(y) => y.toFixed(2)}>
<XAxis axisAt="bottom" orient="bottom"/>
<YAxis axisAt="right" orient="right" ticks={5} />
<DataSeries id={0} yAccessor={CandlestickSeries.yAccessor} >
<CandlestickSeries />
</DataSeries>
</Chart>
<Chart id={2} yMousePointerDisplayLocation="left" yMousePointerDisplayFormat={d3.format(".4s")}
height={150} origin={(w, h) => [0, h - 150]}>
<YAxis axisAt="left" orient="left" ticks={5} tickFormat={d3.format("s")}/>
<DataSeries id={0} yAccessor={(d) => d.volume} >
<HistogramSeries fill={(d) => d.close > d.open ? "#6BA583" : "red"} />
</DataSeries>
</Chart>
<MouseCoordinates xDisplayFormat={dateFormat} type="crosshair" />
<EventCapture mouseMove={true} zoom={true} pan={true} mainChart={1} defaultFocus={false} />
<TooltipContainer>
<OHLCTooltip forChart={1} origin={[-40, 0]}/>
</TooltipContainer>
</ChartCanvas>
);
}
});
')
    )
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
