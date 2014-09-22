angular.module('wk.chart').directive 'brush', ($log) ->
  return {
    restrict: 'A'
    require: ['^chart', '^layout', 'x']
    link:(scope, element, attrs, controllers) ->
      chart = controllers[0]
      layout = controllers[1]
      x = controllers[2]

      layout.isBrush(true)

      brush = d3.svg.brush()
      brushed = () ->
        if not brush.empty()
          if x.isOrdinal()
            domain = x.scale().domain()
            range = x.scale().range()
            interv = range[1] - range[0]
            startIdx = Math.floor(brush.extent()[0] / interv)
            endIdx = Math.floor(brush.extent()[1] / interv)
            extent = domain.slice(startIdx, endIdx + 1)
            chart.brush().change(extent)
          else
            chart.brush().change(brush.extent())

      draw = (data, options, x) ->

        brush = brush
          .x(x.scale())
          .extent(if x.isOrdinal() then x.scale().rangeExtent() else x.scale().domain())
          .on('brush', brushed)

        bs = this.call(brush)
        bs.selectAll('rect')
          .attr('height', options.height)
        bs.selectAll('.resize rect')
          .style('visibility','visible')


      layout.onDrawBrush(draw)
  }