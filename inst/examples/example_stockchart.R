library(stockchartR)
library(quantmod)

spy <- getSymbols("SPY", auto.assign = F)

stockchart(tail(spy,200))

aapl <- getSymbols("AAPL", auto.assign = FALSE)
stockchart(adjustOHLC(aapl))
