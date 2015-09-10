library(stockchartR)
library(quantmod)

spy <- getSymbols("SPY", auto.assign = F)

stockchart(tail(spy,200))

aapl <- getSymbols("AAPL", auto.assign = FALSE)
# look at the static plot for reference
chartSeries(adjustOHLC(aapl),theme="white")
# now make an interactive plot
stockchart(adjustOHLC(aapl))
