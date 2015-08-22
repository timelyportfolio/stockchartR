HTMLWidgets.widget({

  name: 'stockchart',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    }

  },

  renderValue: function(el, x, instance) {

    var parseDate = d3.time.format("%Y-%m-%d").parse;
      d3.tsv("http://rrag.github.io/react-stockcharts/data/MSFT.tsv", function(err, data) {
      /* change MSFT.tsv to MSFT_full.tsv above to see how this works with lots of data points */
      data.forEach(function(d, i) {
        d.date = new Date(parseDate(d.date).getTime());
        d.open = +d.open;
        d.high = +d.high;
        d.low = +d.low;
        d.close = +d.close;
        d.volume = +d.volume;
        // console.log(d);
      });

      React.render(React.createElement(CandleStickChartWithZoomPan, {data: data}), document.getElementById(el.id));
    });

  },

  resize: function(el, width, height, instance) {

  }

});
