angular.module('wk.chart').directive 'horizontalLine', ($log) ->
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
      _showMarkers = false
      _scaleList = {}
      offset = 0
      _id = 'line' + lineCntr++

      prepData = (x, y, color) ->
        #layerKeys = y.layerKeys(@)
        #_layout = layerKeys.map((key) => {key:key, color:color.scale()(key), value:@map((d)-> {x:x.value(d),y:y.layerValue(d, key)})})

      ttEnter = (idx, axisX, cntnr) ->
        cntnrSel = d3.select(cntnr)
        cntnrWidth = cntnrSel.attr('width')
        parent = d3.select(cntnr.parentElement)
        _ttHighlight = parent.append('g')
        _ttHighlight.append('line').attr({x1:0, x2:cntnrWidth}).style({'pointer-events':'none', stroke:'lightgrey', 'stroke-width':1})
        _circles = _ttHighlight.selectAll('circle').data(_layout,(d) -> d.key)
        _circles.enter().append('circle').attr('r', 5).attr('fill', (d)-> d.color).attr('fill-opacity', 0.6).attr('stroke', 'black').style('pointer-events','none')

        _ttHighlight.attr('transform', "translate(0,#{_scaleList.y.scale()(_layout[0].value[idx].y)+offset})")

      ttMoveData = (idx) ->
        ttLayers = _layout.map((l) -> {name:l.key, value:_scaleList.x.formatValue(l.value[idx].x), color:{'background-color': l.color}})
        @headerName = _scaleList.y.axisLabel()
        @headerValue = _scaleList.y.formatValue(_layout[0].value[idx].y)
        @layers = @layers.concat(ttLayers)

      ttMoveMarker = (idx) ->
        _circles = this.selectAll('circle').data(_layout, (d) -> d.key)
        _circles.enter().append('circle')
        .attr('r', if _showMarkers then 8 else 5)
        .style('fill', (d)-> d.color)
        .style('fill-opacity', 0.6)
        .style('stroke', 'black')
        .style('pointer-events','none')
        _circles.attr('cx', (d) -> _scaleList.x.scale()(d.value[idx].x))
        _circles.exit().remove()
        this.attr('transform', "translate(0,#{_scaleList.y.scale()(_layout[0].value[idx].y) + offset})")


      setTooltip = (tooltip, overlay) ->
        _tooltip = tooltip
        tooltip(overlay)
        tooltip.isHorizontal(true)
        tooltip.refreshOnMove(true)
        tooltip.on "move.#{_id}", ttMove
        tooltip.on "enter.#{_id}", ttEnter
        tooltip.on "leave.#{_id}", ttLeave


      draw = (data, options, x, y, color) ->
        layerKeys = x.layerKeys(data)
        _layout = layerKeys.map((key) => {key:key, color:color.scale()(key), value:data.map((d)-> {y:y.value(d),x:x.layerValue(d, key)})})

        offset = if y.isOrdinal() then y.scale().rangeBand() / 2 else 0

        if _tooltip then _tooltip.data(data)

        line = d3.svg.line()
          .x((d) -> x.scale()(d.x))
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
        layers.select('.line')
          .attr('transform', "translate(0,#{offset})")
          .transition().duration(options.duration)
            .attr('d', (d) -> line(d.value))
            .style('opacity', 1).style('pointer-events', 'none')
        layers.exit().transition().duration(options.duration)
          .style('opacity', 0)
          .remove()

      #--- Configuration and registration ------------------------------------------------------------------------------

      host.lifeCycle().on 'configure', ->
        _scaleList = @getScales(['x', 'y', 'color'])
        @layerScale('color')
        @getKind('y').domainCalc('extent').resetOnNewData(true)
        @getKind('x').resetOnNewData(true).domainCalc('extent')
        _tooltip = host.behavior().tooltip
        _tooltip.markerScale(_scaleList.y)
        _tooltip.on "enter.#{_id}", ttMoveData
        _tooltip.on "moveData.#{_id}", ttMoveData
        _tooltip.on "moveMarker.#{_id}", ttMoveMarker

      host.lifeCycle().on 'draw', draw

      #--- Property Observers ------------------------------------------------------------------------------------------

      attrs.$observe 'markers', (val) ->
        if val is '' or val is 'true'
          _showMarkers = true
        else
          _showMarkers = false


  }