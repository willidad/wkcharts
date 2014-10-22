angular.module('wk.chart').directive 'area', ($log) ->
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
      _showMarkers = false
      offset = 0
      _id = 'line' + lineCntr++
      area = undefined

      #--- Tooltip handlers --------------------------------------------------------------------------------------------

      ttMoveData = (idx) ->
        ttLayers = _layout.map((l) -> {name:l.key, value:_scaleList.y.formatValue(l.value[idx].y), color:{'background-color': l.color}})
        @headerName = _scaleList.x.axisLabel()
        @headerValue = _scaleList.x.formatValue(_layout[0].value[idx].x)
        @layers = @layers.concat(ttLayers)

      ttMoveMarker = (idx) ->
        _circles = this.selectAll(".marker-#{_id}").data(_layout, (d) -> d.key)
        _circles.enter().append('circle').attr('class',"marker-#{_id}")
          .attr('r', if _showMarkers then 8 else 5)
          .style('fill', (d)-> d.color)
          .style('fill-opacity', 0.6)
          .style('stroke', 'black')
          .style('pointer-events','none')
        _circles.attr('cy', (d) -> _scaleList.y.scale()(d.value[idx].y))
        _circles.exit().remove()
        this.attr('transform', "translate(#{_scaleList.x.scale()(_layout[0].value[idx].x) + offset})")

      #-----------------------------------------------------------------------------------------------------------------

      draw = (data, options, x, y, color) ->

        layerKeys = y.layerKeys(data)
        _layout = layerKeys.map((key) => {key:key, color:color.scale()(key), value:data.map((d)-> {x:x.value(d),y:y.layerValue(d, key)})})

        offset = if x.isOrdinal() then x.scale().rangeBand() / 2 else 0

        if _tooltip then _tooltip.data(data)

        area = d3.svg.area()
        .x((d) ->  x.scale()(d.x))
        .y0((d) ->  y.scale()(d.y))
        .y1((d) ->  y.scale()(0))

        layers = this.selectAll(".layer")
          .data(_layout, (d) -> d.key)
        layers.enter().append('g')
          .attr('class', "layer")
          .append('path')
          .attr('class','line')
          .attr('transfrom', "translate(#{offset})")
          .style('stroke', (d) -> d.color)
          .style('fill', (d) -> d.color)
          .style('opacity', 0)
          .style('pointer-events', 'none')
        layers.select('.line').transition().duration(options.duration)
          .attr('d', (d) -> area(d.value))
          .style('opacity', 0.7).style('pointer-events', 'none')
        layers.exit().transition().duration(options.duration)
          .style('opacity', 0)
          .remove()

      brush = (data, options,x,y,color) ->
        layers = this.selectAll(".layer")
        layers.select('.line')
          .attr('d', (d) -> area(d.value))


      #--- Configuration and registration ------------------------------------------------------------------------------

      host.lifeCycle().on 'configure', ->
        _scaleList = @getScales(['x', 'y', 'color'])
        @layerScale('color')
        @getKind('y').domainCalc('extent').resetOnNewData(true)
        @getKind('x').resetOnNewData(true).domainCalc('extent')
        _tooltip = host.behavior().tooltip
        _tooltip.markerScale(_scaleList.x)
        _tooltip.on "enter.#{_id}", ttMoveData
        _tooltip.on "moveData.#{_id}", ttMoveData
        _tooltip.on "moveMarker.#{_id}", ttMoveMarker

      host.lifeCycle().on 'draw', draw
      host.lifeCycle().on 'brushDraw', brush

      #--- Property Observers ------------------------------------------------------------------------------------------

      attrs.$observe 'markers', (val) ->
        if val is '' or val is 'true'
          _showMarkers = true
        else
          _showMarkers = false

  }