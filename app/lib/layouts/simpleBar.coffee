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
    _scaleList = {}
    _selected = host.selected()

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
      @headerName = _scaleList.x.axisLabel()
      @headerValue = _scaleList.y.axisLabel()
      @layers.push({name: _scaleList.color.formattedValue(data.data), value: _scaleList.y.formattedValue(data.data), color:{'background-color': _scaleList.color.map(data.data)}})



    setTooltip = (tooltip) ->
      _tooltip = tooltip
      tooltip.on 'enter', ttEnter

    #-------------------------------------------------------------------------------------------------------------------

    draw = (data, options, x, y, color) ->

      if not bars
        bars = @selectAll('.bars')
      #$log.log "rendering stacked-bar"

      layout = data.map((d) -> {data:d, key:x.value(d), value:y.value(d), x:x.map(d), y:y.map(d), color:color.map(d), width:x.scale().rangeBand(x.value(d))})
      newKeys = layout.map((d) -> d.key)

      deletedSucc = utils.diff(oldKeys, newKeys, 1)
      addedPred = utils.diff(newKeys, oldKeys, -1)

      #$log.info 'barchart added, deleted', addedPred, deletedSucc

      bars = bars.data(layout, (d) -> d.key)

      if oldLayout.length is 0
        bars.enter().append('rect')
          .attr('class', 'bar')
          .style('opacity', 0)
          .call(_tooltip)
          .call(_selected)
      else
        bars.enter().append('rect')
          .attr('class', 'bar selectable')
          .attr('x', (d) -> getPredX(addedPred[d.key], oldLayout))
          .attr('width', 0)
          .call(_tooltip)
          .call(_selected)

      bars.style('fill', (d) -> d.color).transition().duration(options.duration)
        .attr('y', (d) -> Math.min(y.scale()(0), d.y))
        .attr('width', (d) -> d.width)
        .attr('height', (d) -> Math.abs(y.scale()(0) - d.y))
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

    host.lifeCycle().on 'configure', ->
      _scaleList = @getScales(['x', 'y', 'color'])
      @getKind('y').domainCalc('total').resetOnNewData(true)
      @getKind('x').resetOnNewData(true)

    host.lifeCycle().on 'draw', draw

    host.lifeCycle().on 'tooltip', setTooltip
  }