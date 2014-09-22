angular.module('wk.chart').directive 'line', ($log) ->
  lineCntr = 0
  return {
    restrict: 'A'
    require: 'layout'
    link: (scope, element, attrs, host) ->
      $log.log 'linking s-line'
      layerKeys = []
      _layout = []
      _tooltip = undefined
      _id = 'line' + lineCntr++

      prepData = (x, y, color) ->
        layerKeys = y.layerKeys(@)
        _layout = layerKeys.map((key) => {key:key, color:color.scale()(key), value:@map((d)-> {x:x.value(d),y:y.layerValue(d, key)})})

      ttMove = (x) ->
        bisect = d3.bisector((d) -> d.x).left
        idx = bisect(_layout[0].value, x) - 1
        idx = if idx < 0 then 0 else if idx >= _layout[0].value.length then _layout[0].value.length - 1 else idx
        ttLayers = _layout.map((l) -> {name:l.key, value:l.value[idx].y, color:{'background-color': l.color}})
        @headerValue = x
        @layers = @layers.concat(ttLayers)

      setTooltip = (tooltip, overlay) ->
        _tooltip = tooltip
        tooltip(overlay)
        tooltip.on "move.#{_id}", ttMove
        tooltip.refreshOnMove(true)

      draw = (data, options, x, y, color) ->

        offset = if x.isOrdinal() then x.scale().rangeBand() / 2 else 0

        if _tooltip then _tooltip.x(x).data(data)

        line = d3.svg.line()
          .x((d) -> x.scale()(d.x) + offset)
          .y((d) -> y.scale()(d.y))

        layers = this.selectAll(".layer")
          .data(_layout, (d) -> d.key)
        layers.enter().append('g')
          .attr('class', "layer")
          .append('path')
          .attr('class','line')
          .style('stroke', (d) -> d.color)
          .style('opacity', 0)
          .style('pointer-events', 'none')
        layers.select('.line').transition().duration(options.duration)
          .attr('d', (d) -> line(d.value))
          .style('opacity', 1).style('pointer-events', 'none')
        layers.exit().transition().duration(options.duration)
          .style('opacity', 0)
          .remove()

      host.events().on 'configure', ->
        this.requiredScales(['x', 'y', 'color'])
        this.layerScale('color')
        this.getKind('y').domainCalc('extent').resetOnNewData(true)
        this.getKind('x').resetOnNewData(true).domainCalc('extent')

      host.events().on 'draw', draw

      host.events().on 'prepData', prepData

      host.events().on "tooltip.#{_id}", setTooltip




  }