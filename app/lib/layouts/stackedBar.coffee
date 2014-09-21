angular.module('wk.chart').directive 'stackedBar', ($log, utils) ->
  return {
    restrict: 'A'
    require: 'layout'
    link: (scope, element, attrs, host) ->

      $log.log 'linking Stacked bar'

      layers = null

      stack = []
      oldKeys = []
      oldXKeys = []
      oldStack = []
      _tooltip = ()->

      ttEnter = (data) ->
        ttLayers = data.layers.map((l) -> {name:l.layerKey, value:l.value, color: l.color})
        $log.info 'ttEnter', data.key, layers
        @headerValue = data.key
        @layers = @layers.concat(ttLayers)

      setTooltip = (tooltip) ->
        _tooltip = tooltip
        tooltip.on 'enter', ttEnter

      #-----------------------------------------------------------------------------------------------------------------

      getXByKey = (stack, key) ->
        i = 0
        while i < stack.length
          if stack[i].key is key
            return stack[i]
          i++

      getLayerByKey = (stack, xKey, layerKey) ->
        s = getXByKey(stack, xKey)
        if s
          i = 0
          while i < s.layers.length
            if s.layers[i].layerKey is layerKey
              return s.layers[i]
            i++

      #-----------------------------------------------------------------------------------------------------------------

      draw = (data, options, x, y, color, size, shape) ->
        if not layers
          layers = @selectAll(".layer")
        #$log.debug "drawing stacked-bar"


        layerKeys = y.layerKeys(data)
        xKeys = x.value(data)

        lDeletedSucc = utils.diff(oldKeys,layerKeys,1)
        lAddedPred = utils.diff(layerKeys, oldKeys, -1)
        xDeletedSucc = utils.diff(oldXKeys, xKeys,1)
        xAddedPred = utils.diff(xKeys,oldXKeys,-1)

        stack = []
        for d in data
          y0 = 0
          l = {key:x.value(d), layers:[], data:d, x:x.map(d), width:x.scale().rangeBand()}
          if l.x isnt undefined
            l.layers = layerKeys.map((k) ->
              layer = {layerKey:k, key:l.key, value:d[k], height:  y.scale()(0) - y.scale()(+d[k]), width: x.scale().rangeBand(), y: y.scale()(+y0 + +d[k]), color: color.scale()(k)}
              y0 += +d[k]
              return layer
            )
            stack.push(l)

        layers = layers
          .data(stack, (d)-> d.key)

        if oldStack.length is 0
          layers.enter().append('g')
            .attr('class', "layer").attr('transform',(d) -> "translate(#{d.x},0) scale(1,1)").style('opacity',0).call(_tooltip)
        else
          layers.enter().append('g')
            .attr('class', "layer").attr('transform',(d) ->
              pred = getXByKey(oldStack, xAddedPred[d.key])
              x = if pred then pred.x + pred.width * 1.05 else 0
              return "translate(#{x},0) scale(0,1)"
            ).call(_tooltip)

        layers
          .transition().duration(options.duration)
          .attr('transform',(d) -> "translate(#{d.x},0) scale(1,1)").style('opacity', 1)

        layers.exit()
          .transition().duration(options.duration)
          .attr('transform',(d, i) ->
            succ = getXByKey(stack, xDeletedSucc[d.key])
            x = if succ then succ.x - succ.width * 0.05 else if stack.length > 0 then stack[stack.length-1].x + stack[stack.length-1].width else 0
            return "translate(#{x},#{y.scale()(0)}) scale(0,0)")
          .remove()

        bars = layers.selectAll('.bar')
          .data(
            (d) -> d.layers
          , (d) -> d.layerKey + '|' + d.key
          )

        if oldStack.length is 0
          bars.enter().append('rect')
            .attr('class', 'bar')
            #.call(d3Chart.behavior.toolTip)
        else
          bars.enter().append('rect')
            .attr('class', 'bar')
            .attr('y', (d) ->
              pred = getLayerByKey(oldStack, d.key, lAddedPred[d.layerKey])
              return if pred then pred.y else y.scale()(0)
            )
            .attr('height', 0)


        bars.style('fill', (d) -> d.color)
          .transition().duration(options.duration)
            .attr('y', (d) -> d.y)
            .attr('width', (d) -> d.width)
            .attr('height', (d) -> d.height)

        bars.exit()
          .transition().duration(options.duration)
          .attr('height',0)
          .attr('y', (d) ->
            succ = getLayerByKey(stack, d.key, lDeletedSucc[d.layerKey])
            if succ
              return succ.y + succ.height
            else
              x = getXByKey(stack, d.key)
              return x.layers[x.layers.length - 1].y
          )
          .remove()

        oldKeys = layerKeys
        oldXKeys = xKeys
        oldStack = stack

      #-----------------------------------------------------------------------------------------------------------------


      host.events().on 'configure', ->
        this.requiredScales(['x', 'y', 'color'])
        this.getKind('y').domainCalc('total').resetOnNewData(true)
        this.getKind('x').resetOnNewData(true)
        this.layerScale('color')

      host.events().on 'draw', draw

      host.events().on 'tooltip', setTooltip
  }