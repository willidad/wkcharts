angular.module('wk.chart').directive 'simpleBar', ($log, utils)->
  return {
  restrict: 'A'
  require: '^layout'
  controller: ($scope, $attrs) ->
    me = {chartType: 'barChart', id:utils.getId()}
    $attrs.$set('chart-id', me.id)
    return me
  link: (scope, element, attrs, host) ->

    bars = null
    oldLayout = []
    oldKeys = []

    #-------------------------------------------------------------------------------------------------------------------

    getXByKey = (key, layout) ->
      for l in layout
        if l.key is key
          return l

    getPredX = (key, layout) ->
      pred = getXByKey(key, layout)
      if pred then pred.x + pred.width * 1.05 else 0

    getSuccX = (key, layout) ->
      succ = getXByKey(key, layout)
      if succ then succ.x - succ.width * 0.05 else layout[layout.length - 1].x + layout[layout.length - 1].width * 1.05


    #-------------------------------------------------------------------------------------------------------------------

    _tooltip = ()->

    ttEnter = (data) ->
      #ttLayers = data.layers.map((l) -> {name:l.layerKey, value:l.value, color: {'background-color': l.color}})
      #$log.info 'ttEnter', data.key, layers
      #@headerValue = data.key
      #@layers = @layers.concat(ttLayers)

    setTooltip = (tooltip) ->
      _tooltip = tooltip
      tooltip.on 'enter', ttEnter

    #-------------------------------------------------------------------------------------------------------------------

    draw = (data, options, x, y, color) ->

      if not bars
        bars = @selectAll('.bars')
      #$log.log "rendering stacked-bar"

      layout = data.map((d) -> {key:x.value(d), value:y.value(d), x:x.map(d), y:y.map(d), color:color.map(d), width:x.scale().rangeBand(x.value(d))})
      newKeys = layout.map((d) -> d.key)

      deletedSucc = utils.diff(oldKeys, newKeys, 1)
      addedPred = utils.diff(newKeys, oldKeys, -1)

      #$log.info 'barchart added, deleted', addedPred, deletedSucc

      bars = bars.data(layout, (d) -> d.key)

      if oldLayout.length is 0
        bars.enter().append('rect')
        .attr('class', 'bar').call(_tooltip).style('opacity', 0)
      else
        bars.enter().append('rect')
          .attr('class', 'bar').call(_tooltip)
          .attr('x', (d) -> getPredX(addedPred[d.key], oldLayout))
          .attr('width', 0)

      bars.style('fill', (d) -> d.color).transition().duration(options.duration)
        .attr('y', (d) -> d.y)
        .attr('width', (d) -> d.width)
        .attr('height', (d) -> y.scale()(0) - d.y)
        .attr('x', (d) -> d.x)
        .style('opacity', 1)

      bars.exit()
        .transition().duration(options.duration)
        .attr('x', (d) -> getSuccX(deletedSucc[d.key], layout))
        .attr('width', 0)
        .remove()

      oldLayout = layout
      oldKeys = newKeys

    #-------------------------------------------------------------------------------------------------------------------

    host.events().on 'configure', ->
      this.requiredScales(['x', 'y', 'color'])
      this.getKind('y').domainCalc('total').resetOnNewData(true)
      this.getKind('x').resetOnNewData(true)

    host.events().on 'draw', draw

    host.events().on 'tooltip', setTooltip
  }