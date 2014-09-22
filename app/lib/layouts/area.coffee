angular.module('wk.chart').directive 'area', ($log, utils) ->
  areaCntr = 0
  return {
    restrict: 'A'
    require: 'layout'
    link: (scope, element, attrs, host) ->

      stack = d3.layout.stack()
      offset = 'zero'
      layers = null
      layerKeys = []
      layerData = []
      layoutNew = []
      deletedSucc = {}
      addedPred = {}
      _tooltip = undefined
      _id = 'area' + areaCntr++

      ttMove = (x) ->
        bisect = d3.bisector((d) -> d.x).left
        idx = bisect(layerData[0].layer, x)
        idx = if idx < 0 then 0 else if idx >= layerData[0].layer.length then layerData[0].layer.length - 1 else idx
        ttLayers = layerData.map((l) -> {name:l.key, value:l.layer[idx].yy, color: {'background-color': l.color}})
        #$log.info 'tooltip mouse move', x, layers
        @headerValue = x
        @layers = @layers.concat(ttLayers)

      setTooltip = (tooltip, overlay) ->
        _tooltip = tooltip
        tooltip(overlay)
        tooltip.on "move.#{_id}", ttMove
        tooltip.refreshOnMove(true)

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

      prepData = (x,y,color) ->

        layoutOld = layoutNew.map((d) -> {key: d.key, path: area(d.layer.map((p) -> {x: p.x, y: 0, y0: p.y + p.y0}))})
        layerKeysOld = layerKeys

        layerKeys = y.layerKeys(@)
        layerData = layerKeys.map((k) => {key: k, color:color.scale()(k), layer: @map((d) -> {x: x.value(d), yy: +y.layerValue(d,k), y0: 0})}) # yy: need to avoid overwriting by layout calc -> see stack y accessor
        #layoutNew = layout(layerData)

        deletedSucc = utils.diff(layerKeysOld, layerKeys, 1)
        addedPred = utils.diff(layerKeys, layerKeysOld, -1)

      #-------------------------------------------------------------------------------------------------------------------

      draw = (data, options, x, y, color) ->
        #$log.log "rendering Area Chart"
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
          .attr('d', (d) -> area(d.layer))
          .style('opacity', 1)

        layers.exit().transition().duration(options.duration)
          .attr('d', (d) ->
            succ = deletedSucc[d.key]
            if succ then area(getLayerByKey(succ, layoutNew).layer.map((p) -> {x: p.x, y: 0, y0: p.y0})) else area(layoutNew[layoutNew.length - 1].layer.map((p) -> {x: p.x, y: 0, y0: p.y0 + p.y}))
          )
          .remove()


      attrs.$observe 'area', (val) ->
        if val in ['zero', 'silhouette', 'expand', 'wiggle']
          offset = val
        stack.offset(offset)
        host.events().redraw()

      host.events().on 'configure', ->
        this.requiredScales(['x', 'y', 'color'])
        this.layerScale('color')
        this.getKind('y').domainCalc('total').resetOnNewData(true)
        this.getKind('x').resetOnNewData(true).domainCalc('extent')

      host.events().on 'draw', draw

      host.events().on 'prepData', prepData

      host.events().on "tooltip.#{_id}", setTooltip
  }