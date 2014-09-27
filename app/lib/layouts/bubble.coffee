angular.module('wk.chart').directive 'bubble', ($log, utils) ->
  bubbleCntr = 0
  return {
    restrict: 'A'
    require: 'layout'

    link: (scope, element, attrs, layout) ->
      #$log.debug 'bubbleChart linked'

      _tooltip = undefined
      _scaleList = {}
      _id = 'bubble' + bubbleCntr++

      prepData = (x, y, color, size) ->

      ttEnter = (data) ->
        for sName, scale of _scaleList
          @layers.push({name: scale.axisLabel(), value: scale.formattedValue(data), color: if sName is 'color' then {'background-color':scale.map(data)} else undefined})

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

      #-----------------------------------------------------------------------------------------------------------------

      layout.events().on 'configure', ->
        _scaleList = @getScales(['x', 'y', 'color', 'size'])
        @getKind('y').resetOnNewData(true)
        @getKind('x').resetOnNewData(true)

      layout.events().on 'draw', draw

      layout.events().on 'tooltip', setTooltip

  }
