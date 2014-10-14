angular.module('wk.chart').directive 'horizontalClusteredBar', ($log, utils)->

  hClusteredBarCntr = 0

  return {
    restrict: 'A'
    require: '^layout'

    link: (scope, element, attrs, host) ->

      _id = "hClusteredBar#{hClusteredBarCntr++}"

      layers = null
      layerKeysOld = []
      yKeysOld = []
      clusterOld = []

      #-----------------------------------------------------------------------------------------------------------------

      getXByKey = (stack, key) ->
        i = 0
        while i < stack.length
          if stack[i].key is key
            return stack[i]
          i++

      getLayerByKey = (layout, yKey, layerKey) ->
        s = getyByKey(layout, yKey)
        if s
          i = 0
          while i < s.layers.length
            if s.layers[i].layerKey is layerKey
              return s.layers[i]
            i++

      getYPredY = (key, layout) ->
        pred = getYByKey(layout, key)
        if pred then pred.x + pred.width * 1.05 else 0

      getYSuccY = (key, layout) ->
        succ = getYByKey(layout, key)
        if succ then succ.y - succ.width * 0.05 else layout[layout.length-1].y + layout[layout.length-1].width * 1.05

      getLPredy = (yKey, layerKey, layout) ->
        pred = getLayerByKey(layout, xKey, layerKey)
        if pred then pred.x + pred.width * 1.05 else 0

      getLSuccy = (yKey, layerKey, layout) ->
        succ = getLayerByKey(layout, yKey, layerKey)
        if succ then succ.y + succ.width * 0.05 else layout[layout.length-1].y + layout[layout.length-1].width * 1.05


      #-----------------------------------------------------------------------------------------------------------------

      _tooltip = undefined
      _scaleList = {}

      ttEnter = (data) ->
        ttLayers = data.layers.map((l) -> {name:l.layerKey, value:_scaleList.y.formatValue(l.value), color: {'background-color': l.color}})
        @headerName = _scaleList.y.axisLabel()
        @headerValue = _scaleList.y.formatValue(data.key)
        @layers = @layers.concat(ttLayers)

      #-----------------------------------------------------------------------------------------------------------------

      draw = (data, options, x, y, color) ->
        #$log.info "rendering clustered-bar"

        # map data to the right format for rendering
        layerKeysNew = x.layerKeys(data)
        yKeysNew = y.value(data)

        #yDeletedSucc = utils.diff(layerKeysOld,layerKeysNew,1)
        #yAddedPred = utils.diff(layerKeysNew, layerKeysOld, -1)
        #lDeletedSucc = utils.diff(yKeysOld, xKeysNew,1)
        #lAddedPred = utils.diff(yKeysNew,xKeysOld,-1)

        clusterY = d3.scale.ordinal().domain(x.layerKeys(data)).rangeBands([0,y.scale().rangeBand()], 0.1)

        cluster = data.map((d) -> l = {
          key:y.value(d), data:d, y:y.map(d), width: y.scale().rangeBand(y.value(d))
          layers: layerKeysNew.map((k) -> {layerKey: k, color:color.scale()(k), key:y.value(d), value: d[k], y:clusterY(k), x: x.scale()(d[k]), width:x.scale()(0) - x.scale()(d[k]), height:clusterY.rangeBand(k)})}
        )

        if not layers
          layers = @selectAll('.layer')

        layers = layers.data(cluster, (d) -> d.key)

        if clusterOld.length is 0
          layers.enter().append('g')
            .attr('class', 'layer').call(_tooltip.tooltip)
            .attr('transform',(d) -> "translate(0,#{d.y}) scale(1,1)")
            .style({opacity: 0})
        ###
        else
          layers.enter().append('g')
            .attr('class', 'layer').call(_tooltip.tooltip)
            .attr('transform', (d)-> "translate(0, #{getyPredy(yAddedPred[d.key], clusterOld)}) scale(1,1)")
        ###
        layers
          .transition().duration(options.duration)
            .attr('transform',(d) -> "translate(0, #{d.y}) scale(1,1)")
            .style('opacity', 1)
        ###
        layers.exit()
          .transition().duration(options.duration)
            .attr('transform',(d) -> "translate(#{x.scale()(0)},#{getySuccy(yDeletedSucc[d.key], cluster)}) scale(0,0)")
            .remove()
        ###
        enterScale = 0

        bars = layers.selectAll('.bar')
          .data(
            (d) -> d.layers
          , (d) -> d.layerKey + '|' + d.key
          )

        if clusterOld.length is 0
          bars.enter().append('rect')
          .attr('class', 'bar')
        ###
        else
          bars.enter().append('rect')
            .attr('class', 'bar')
            .attr('x', (d) -> getLPredX(d.key, lAddedPred[d.layerKey], clusterOld))
            .attr('width',  0)
            .attr('height', 0)
            .attr('y', y.scale()(0))
        ###

        bars.style('fill', (d) -> color.scale()(d.layerKey)).transition().duration(options.duration)
          .attr('width', (d) -> Math.abs(d.width))
          .attr('x', (d) -> Math.min(x.scale()(0), d.x))
          .attr('y', (d) -> d.y)
          .attr('height', (d) -> d.height)
        ###
        bars.exit()
          .transition().duration(options.duration)
          .attr('width',0)
          .attr('height', 0)
          .attr('x', (d) -> getLSuccX(d.key, lDeletedSucc[d.layerKey], cluster))
          .attr('y', y.scale()(0))
          .remove()

        layerKeysOld = layerKeysNew
        clusterOld = cluster
        xKeysOld = xKeysNew
        ###
      #-------------------------------------------------------------------------------------------------------------------

      host.lifeCycle().on 'configure', ->
        _scaleList = @getScales(['x', 'y', 'color'])
        @getKind('y').domainCalc('max').resetOnNewData(true)
        @getKind('x').resetOnNewData(true)
        @layerScale('color')
        _tooltip = host.behavior().tooltip
        _tooltip.on "enter.#{_id}", ttEnter

      host.lifeCycle().on 'draw', draw

  }