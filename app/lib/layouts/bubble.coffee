angular.module('wk.chart').directive 'bubble', ($log, utils) ->
  bubbleCntr = 0
  return {
    restrict: 'A'
    require: 'layout'

    link: (scope, element, attrs, layout) ->
      #$log.debug 'bubbleChart linked'

      _tooltip = undefined
      _id = 'bubble' + bubbleCntr++

      prepData = (x, y, color, size) ->

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

      draw = (data, options, x, y, color, size) ->

        bubbles = @selectAll('.bubble').data(data, (d) -> color.value(d))
        bubbles.enter().append('circle').attr('class','bubble')
          .style('opacity', 0)
          .call(_tooltip)
        bubbles
          .style('fill', (d) -> color.map(d))
          .transition().duration(options.duration)
            .attr({
              r:  (d) -> size.map(d)
              cx: (d) -> x.map(d)
              cy: (d) -> y.map(d)
            })
            .style('opacity', 1)
        bubbles.exit()
          .transition().duration(options.duration)
            .style('opacity',0).remove()

      layout.events().on 'configure', ->
        @requiredScales(['x', 'y', 'color', 'size'])
        this.getKind('y').domainCalc('extent').resetOnNewData(true)
        this.getKind('x').resetOnNewData(true).domainCalc('extent')

      layout.events().on 'draw', draw

      layout.events().on 'tooltip', setTooltip

  }
