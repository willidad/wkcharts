angular.module('wk.chart').directive 'line', ($log) ->
  lineCntr = 0
  return {
    restrict: 'A'
    require: 'layout'
    link: (scope, element, attrs, host) ->
      #$log.log 'linking s-line'
      layerKeys = []
      _layout = []
      _tooltip = undefined
      _ttHighlight = undefined
      _circles = undefined
      _scaleList = {}
      _id = 'line' + lineCntr++

      prepData = (x, y, color) ->
        #layerKeys = y.layerKeys(@)
        #_layout = layerKeys.map((key) => {key:key, color:color.scale()(key), value:@map((d)-> {x:x.value(d),y:y.layerValue(d, key)})})

      ttEnter = (x, axisX, cntnr) ->
        cntnrSel = d3.select(cntnr)
        cntnrHeight = cntnrSel.attr('height')
        parent = d3.select(cntnr.parentElement)
        _ttHighlight = parent.append('g')
        _ttHighlight.append('line').attr({y1:0, y2:cntnrHeight}).style({'pointer-events':'none', stroke:'lightgrey', 'stroke-width':1})
        _circles = _ttHighlight.selectAll('circle').data(_layout,(d) -> d.key)
        _circles.enter().append('circle').attr('r', 5).attr('fill', (d)-> d.color).attr('fill-opacity', 0.6).attr('stroke', 'black').style('pointer-events','none')

        _ttHighlight.attr('transform', "translate(#{axisX})")

      ttMove = (x, axisX,  cntnr) ->
        bisect = d3.bisector((d) -> d.x).left
        idx = bisect(_layout[0].value, x) - 1
        idx = if idx < 0 then 0 else if idx >= _layout[0].value.length then _layout[0].value.length - 1 else idx
        ttLayers = _layout.map((l) -> {name:l.key, value:_scaleList.y.formatValue(l.value[idx].y), color:{'background-color': l.color}})

        _circles.attr('cy', (d) ->
          null
          _scaleList.y.scale()(d.value[idx].y))
        _ttHighlight.attr('transform', "translate(#{axisX})")

        @headerName = _scaleList.x.axisLabel()
        @headerValue = _scaleList.x.formatValue(x)
        @layers = @layers.concat(ttLayers)

      ttLeave = (x, axisX, cntnr)->
        _ttHighlight.remove()



      setTooltip = (tooltip, overlay) ->
        _tooltip = tooltip
        tooltip(overlay)
        tooltip.refreshOnMove(true)
        tooltip.on "move.#{_id}", ttMove
        tooltip.on "enter.#{_id}", ttEnter
        tooltip.on "leave.#{_id}", ttLeave


      draw = (data, options, x, y, color) ->
        layerKeys = y.layerKeys(data)
        _layout = layerKeys.map((key) => {key:key, color:color.scale()(key), value:data.map((d)-> {x:x.value(d),y:y.layerValue(d, key)})})

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

      host.lifeCycle().on 'configure', ->
        _scaleList = @getScales(['x', 'y', 'color'])
        @layerScale('color')
        @getKind('y').domainCalc('extent').resetOnNewData(true)
        @getKind('x').resetOnNewData(true).domainCalc('extent')

      host.lifeCycle().on 'draw', draw

      host.lifeCycle().on 'prepData', prepData

      host.lifeCycle().on "tooltip.#{_id}", setTooltip




  }