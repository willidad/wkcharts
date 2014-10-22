angular.module('wk.chart').directive 'clusteredBar', ($log, utils)->

  clusteredBarCntr = 0
  return {
    restrict: 'A'
    require: '^layout'

    link: (scope, element, attrs, controller) ->
      host = controller.me

      _id = "clusteredBar#{clusteredBarCntr++}"

      layers = null
      layerKeysOld = []
      xKeysOld = []
      clusterOld = []

      #-----------------------------------------------------------------------------------------------------------------

      getXByKey = (stack, key) ->
        i = 0
        while i < stack.length
          if stack[i].key is key
            return stack[i]
          i++

      getLayerByKey = (layout, xKey, layerKey) ->
        s = getXByKey(layout, xKey)
        if s
          i = 0
          while i < s.layers.length
            if s.layers[i].layerKey is layerKey
              return s.layers[i]
            i++

      getXPredX = (key, layout) ->
        pred = getXByKey(layout, key)
        if pred then pred.x + pred.width * 1.05 else 0

      getXSuccX = (key, layout) ->
        succ = getXByKey(layout, key)
        if succ then succ.x - succ.width * 0.05 else layout[layout.length-1].x + layout[layout.length-1].width * 1.05

      getLPredX = (xKey, layerKey, layout) ->
        pred = getLayerByKey(layout, xKey, layerKey)
        if pred then pred.x + pred.width * 1.05 else 0

      getLSuccX = (xKey, layerKey, layout) ->
        succ = getLayerByKey(layout, xKey, layerKey)
        if succ then succ.x + succ.width * 0.05 else getXByKey(layout,xKey).width

      #-----------------------------------------------------------------------------------------------------------------

      _tooltip = undefined
      _scaleList = {}

      ttEnter = (data) ->
        ttLayers = data.layers.map((l) -> {name:l.layerKey, value:_scaleList.y.formatValue(l.value), color: {'background-color': l.color}})
        @headerName = _scaleList.x.axisLabel()
        @headerValue = _scaleList.x.formatValue(data.key)
        @layers = @layers.concat(ttLayers)

      #-----------------------------------------------------------------------------------------------------------------

      draw = (data, options, x, y, color) ->
        #$log.info "rendering clustered-bar"

        # map data to the right format for rendering
        layerKeysNew = y.layerKeys(data)
        xKeysNew = x.value(data)

        lDeletedSucc = utils.diff(layerKeysOld,layerKeysNew,1)
        lAddedPred = utils.diff(layerKeysNew, layerKeysOld, -1)
        xDeletedSucc = utils.diff(xKeysOld, xKeysNew,1)
        xAddedPred = utils.diff(xKeysNew,xKeysOld,-1)

        clusterX = d3.scale.ordinal().domain(y.layerKeys(data)).rangeBands([0,x.scale().rangeBand()], 0.1)

        cluster = data.map((d) -> l = {
          key:x.value(d), data:d, x:x.map(d), width: x.scale().rangeBand(x.value(d))
          layers: layerKeysNew.map((k) -> {layerKey: k, color:color.scale()(k), key:x.value(d), value: d[k], x:clusterX(k), y: y.scale()(d[k]), height:y.scale()(0) - y.scale()(d[k]), width:clusterX.rangeBand(k)})}
        )

        if not layers
          layers = @selectAll('.layer')

        layers = layers.data(cluster, (d) -> d.key)

        if clusterOld.length is 0
          layers.enter().append('g')
            .attr('class', 'layer').call(_tooltip.tooltip)
            .attr('transform',(d) -> "translate(#{d.x},0) scale(1,1)")
            .style({opacity: 0})

        else
          layers.enter().append('g')
            .attr('class', 'layer').call(_tooltip.tooltip)
            .attr('transform', (d)-> "translate(#{getXPredX(xAddedPred[d.key], clusterOld)}, 0) scale(1,1)")

        layers
          .transition().duration(options.duration)
            .attr('transform',(d) -> "translate(#{d.x},0) scale(1,1)")
            .style('opacity', 1)

        layers.exit()
          .transition().duration(options.duration)
            .attr('transform',(d) ->
              null
              "translate(#{getXSuccX(xDeletedSucc[d.key], cluster)},#{y.scale()(0)}) scale(0,0)")
            .remove()

        enterScale = 0

        bars = layers.selectAll('.bar')
          .data(
            (d) -> d.layers
          , (d) -> d.layerKey + '|' + d.key
          )

        if clusterOld.length is 0
          bars.enter().append('rect')
          .attr('class', 'bar selectable')
        else
          bars.enter().append('rect')
            .attr('class', 'bar selectable')
            .attr('x', (d) -> getLPredX(d.key, lAddedPred[d.layerKey], clusterOld))
            .attr('width',  0)
            .attr('height', 0)
            .attr('y', y.scale()(0))


        bars.style('fill', (d) -> color.scale()(d.layerKey)).transition().duration(options.duration)
          .attr('width', (d) -> d.width)
          .attr('x', (d) -> d.x)
          .attr('y', (d) -> Math.min(y.scale()(0), d.y))
          .attr('height', (d) -> Math.abs(d.height))

        bars.exit()
          .transition().duration(options.duration)
          .attr('width',0)
          .attr('height', 0)
          .attr('x', (d) ->
            null
            getLSuccX(d.key, lDeletedSucc[d.layerKey], cluster))
          .attr('y', y.scale()(0))
          .remove()

        layerKeysOld = layerKeysNew
        clusterOld = cluster
        xKeysOld = xKeysNew

      #-------------------------------------------------------------------------------------------------------------------

      host.lifeCycle().on 'configure', ->
        _scaleList = @getScales(['x', 'y', 'color'])
        @getKind('y').domainCalc('max').resetOnNewData(true)
        @getKind('x').resetOnNewData(true)
        @layerScale('color')
        _tooltip = host.behavior().tooltip
        _tooltip.on "enter.#{_id}", ttEnter

      host.lifeCycle().on 'draw', draw
      host.lifeCycle().on 'brushDraw', draw
  }