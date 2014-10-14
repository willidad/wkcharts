angular.module('wk.chart').directive 'stackedArea', ($log, utils) ->
  stackedAreaCntr = 0
  return {
    restrict: 'A'
    require: 'layout'
    link: (scope, element, attrs, host) ->

      stack = d3.layout.stack()
      offset = 'zero'
      layers = null
      _showMarkers = false
      layerKeys = []
      layerData = []
      layoutNew = []
      deletedSucc = {}
      addedPred = {}
      _tooltip = undefined
      _ttHighlight = undefined
      _circles = undefined
      _scaleList = {}
      scaleY = undefined
      offs = 0
      _id = 'area' + stackedAreaCntr++

      #--- Tooltip Event Handlers --------------------------------------------------------------------------------------

      ttMoveData = (idx) ->
        ttLayers = layerData.map((l) -> {name:l.key, value:_scaleList.y.formatValue(l.layer[idx].yy), color: {'background-color': l.color}})
        @headerName = _scaleList.x.axisLabel()
        @headerValue = _scaleList.x.formatValue(layerData[0].layer[idx].x)
        @layers = @layers.concat(ttLayers)

      ttMoveMarker = (idx) ->
        _circles = this.selectAll('circle').data(layerData, (d) -> d.key)
        _circles.enter().append('circle')
        .attr('r', if _showMarkers then 8 else 5)
        .style('fill', (d)-> d.color)
        .style('fill-opacity', 0.6)
        .style('stroke', 'black')
        .style('pointer-events','none')
        _circles.attr('cy', (d) -> scaleY(d.layer[idx].y + d.layer[idx].y0))
        _circles.exit().remove()
        this.attr('transform', "translate(#{_scaleList.x.scale()(layerData[0].layer[idx].x)+offs})")

      #-------------------------------------------------------------------------------------------------------------------

      getLayerByKey = (key, layout) ->
        for l in layout
          if l.key is key
            return l

      layout = stack.values((d)->d.layer).y((d) -> d.yy)

      layoutOld = undefined
      layerKeysOld = []
      area = undefined

      #-------------------------------------------------------------------------------------------------------------------
      ###
      prepData = (x,y,color) ->

        layoutOld = layoutNew.map((d) -> {key: d.key, path: area(d.layer.map((p) -> {x: p.x, y: 0, y0: p.y + p.y0}))})
        layerKeysOld = layerKeys

        layerKeys = y.layerKeys(@)
        layerData = layerKeys.map((k) => {key: k, color:color.scale()(k), layer: @map((d) -> {x: x.value(d), yy: +y.layerValue(d,k), y0: 0})}) # yy: need to avoid overwriting by layout calc -> see stack y accessor
        #layoutNew = layout(layerData)

        deletedSucc = utils.diff(layerKeysOld, layerKeys, 1)
        addedPred = utils.diff(layerKeys, layerKeysOld, -1)
      ###
      #--- Draw --------------------------------------------------------------------------------------------------------

      draw = (data, options, x, y, color) ->
        #$log.log "rendering Area Chart"
        layoutOld = layoutNew.map((d) -> {key: d.key, path: area(d.layer.map((p) -> {x: p.x, y: 0, y0: p.y + p.y0}))})
        layerKeysOld = layerKeys

        layerKeys = y.layerKeys(data)
        layerData = layerKeys.map((k) => {key: k, color:color.scale()(k), layer: data.map((d) -> {x: x.value(d), yy: +y.layerValue(d,k), y0: 0})}) # yy: need to avoid overwriting by layout calc -> see stack y accessor
        #layoutNew = layout(layerData)

        deletedSucc = utils.diff(layerKeysOld, layerKeys, 1)
        addedPred = utils.diff(layerKeys, layerKeysOld, -1)

        offs = if x.isOrdinal() then x.scale().rangeBand() / 2 else 0

        if _tooltip then _tooltip.data(data)

        layoutNew = layout(layerData)

        if not layers
          layers = this.selectAll('.layer')

        if offset is 'expand'
          scaleY = y.scale().copy()
          scaleY.domain([0, 1])
        else scaleY = y.scale()

        area = d3.svg.area()
          .x((d) ->  x.scale()(d.x))
          .y0((d) ->  scaleY(d.y0 + d.y))
          .y1((d) ->  scaleY(d.y0))

        layers = layers
          .data(layoutNew, (d) -> d.key)

        if layoutOld.length is 0
          layers.enter()
            .append('path').attr('class', 'area')
            .style('fill', (d, i) -> color.scale()(d.key)).style('opacity', 0)
            .style('pointer-events', 'none')
        else
          layers.enter()
            .append('path').attr('class', 'area')
            .attr('d', (d) ->
              if addedPred[d.key] then getLayerByKey(addedPred[d.key], layoutOld).path else area(d.layer.map((p) ->
                {x: p.x, y: 0, y0: 0}))
            )
          .style('fill', (d, i) ->
            color.scale()(d.key))
          .style('pointer-events', 'none')

        layers.transition().duration(options.duration)
          .attr('d', (d) -> area(d.layer)).attr('transform', "translate(#{offs})")
          .style('opacity', 0.7)

        layers.exit().transition().duration(options.duration)
          .attr('d', (d) ->
            succ = deletedSucc[d.key]
            if succ then area(getLayerByKey(succ, layoutNew).layer.map((p) -> {x: p.x, y: 0, y0: p.y0})) else area(layoutNew[layoutNew.length - 1].layer.map((p) -> {x: p.x, y: 0, y0: p.y0 + p.y}))
          )
          .remove()

      #--- Configuration and registration ------------------------------------------------------------------------------



      host.lifeCycle().on 'configure', ->
        _scaleList = @getScales(['x', 'y', 'color'])
        @layerScale('color')
        @getKind('y').domainCalc('total').resetOnNewData(true)
        @getKind('x').resetOnNewData(true).domainCalc('extent')
        _tooltip = host.behavior().tooltip
        _tooltip.markerScale(_scaleList.x)
        _tooltip.on "enter.#{_id}", ttMoveData
        _tooltip.on "moveData.#{_id}", ttMoveData
        _tooltip.on "moveMarker.#{_id}", ttMoveMarker

      host.lifeCycle().on 'draw', draw

      #--- Property Observers ------------------------------------------------------------------------------------------

      attrs.$observe 'stackedArea', (val) ->
        if val in ['zero', 'silhouette', 'expand', 'wiggle']
          offset = val
        stack.offset(offset)
        host.lifeCycle().redraw()

      attrs.$observe 'markers', (val) ->
        if val is '' or val is 'true'
          _showMarkers = true
        else
          _showMarkers = false
  }