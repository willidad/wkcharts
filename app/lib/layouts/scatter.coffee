angular.module('wk.chart').directive 'scatter', ($log, utils) ->
  scatterCnt = 0
  return {
    restrict: 'A'
    require: '^layout'
    link: (scope, element, attrs, layout) ->

      _tooltip = undefined
      _id = 'scatter' + scatterCnt++

      prepData = (x, y, color, size, shape) ->

      ttEnter = (data) ->
        $log.log data
        @layers = d3.entries(data)
        #this.headerName = d3Chart.scales.color.property
        #this.headerValue = d3Chart.scales.color.value(data)
        #this.layers.push({name:d3Chart.scales.x.property, value:d3Chart.scales.x.value(data), color:d3Chart.scales.color.map(data)})
        #this.layers.push({name:d3Chart.scales.y.property, value:d3Chart.scales.y.value(data), color:d3Chart.scales.color.map(data)})
        #this.layers.push({name:d3Chart.scales.size.property, value:d3Chart.scales.size.value(data), color:d3Chart.scales.color.map(data)})

      setTooltip = (tooltip) ->
        _tooltip = tooltip
        _tooltip.on "enter.#{_id}", ttEnter


      #-----------------------------------------------------------------------------------------------------------------

      initialShow = true

      draw = (data, options, x, y, color, size, shape) ->
        #$log.debug 'drawing scatter chart'

        points = @selectAll('.points')
          .data(data)
        points.enter()
          .append('path').attr('class', 'points')
          .call(_tooltip)
          .attr('transform', (d)-> "translate(#{x.map(d)},#{y.map(d)})")#.call(init)

        points
          .attr('d', d3.svg.symbol().type((d) -> shape.map(d)).size((d) -> size.map(d) * size.map(d)))
          .style('fill', color.map)
          .transition().duration(options.duration)
          .attr('transform', (d)-> "translate(#{x.map(d)},#{y.map(d)})").style('opacity', 1)

        points.exit().remove()


      #-----------------------------------------------------------------------------------------------------------------

      layout.events().on 'configure', ->
        @requiredScales(['x', 'y', 'color', 'size', 'shape'])
        @getKind('y').domainCalc('extent').resetOnNewData(true)
        @getKind('x').resetOnNewData(true).domainCalc('extent')

      layout.events().on 'draw', draw

      layout.events().on 'tooltip', setTooltip
  }
