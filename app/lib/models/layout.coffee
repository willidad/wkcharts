angular.module('wk.chart').factory 'layout', ($log, scale, scaleList, d3Animation, selection) ->

  layout = () ->
    _id = ''
    _container = undefined
    _drawBrushFn = undefined
    _isBrush = false
    _data = undefined
    _chart = undefined
    _selected = selection()
    _scaleList = scaleList()
    _layoutLifeCycle = d3.dispatch('configure', 'draw', 'prepData', 'brush', 'redraw', 'drawAxis', 'update', 'tooltip')

    me = () ->

    me.id = (id) ->
      if arguments.length is 0 then return _id
      else
        _id = id
        return me

    me.chart = (chart) ->
      if arguments.length is 0 then return _chart
      else
        _chart = chart
        _scaleList.parentScales(chart.scales())
        _chart.events().on "configure.#{me.id()}", () -> _layoutLifeCycle.configure.apply(me.scales()) #passthrough
        _chart.lifeCycle().on "drawChart.#{me.id()}", me.draw # register for the drawing event
        return me

    me.scales = () ->
      return _scaleList

    me.scaleProperties = () ->
      return me.scales().getScaleProperties()

    me.container = (obj) ->
      if arguments.length is 0 then return _container
      else
        _container = obj
        return me

    me.setTooltip = (tooltip, overlay) ->
      _layoutLifeCycle.tooltip(tooltip, overlay)
      return me

    me.behavior = () ->
      me.chart().behavior()

    me.selected = (val) ->
      if arguments.length is 0 then return _selected
      else
        _selected = val
        return me #to enable chaining

    me.isBrush = (trueFalse) ->
      if arguments.length is 0 then return _isBrush
      else
        _isBrush = trueFalse

    me.onDrawBrush = (drawFn) ->
      if arguments.length is 0 then return _drawBrushFn
      else
        _drawBrushFn = drawFn

    me.prepareData = (data) ->
      args = []
      for kind in ['x','y', 'color']
        args.push(_scaleList.getKind(kind))

      _layoutLifeCycle.prepData.apply(data, args)

    me.lifeCycle = ()->
      return _layoutLifeCycle

    me.draw = (data, notAnimated) ->
      _data = data
      #$log.log 'drawing layout:', me.id()
      container = _container.getChartArea()
      drawArea = container.select(".#{me.id()}")
      if drawArea.empty()
        drawArea = container.append('g').attr('class', (d) -> me.id())

      options = {height:_container.height(), width:_container.width(), margins:_container.margins(), duration: 0}

      if notAnimated
        options.duration = 0
      else
        options.duration = d3Animation.duration

      args = [data, options]
      for kind in ['x','y', 'color', 'size', 'shape']
        args.push(_scaleList.getKind(kind))

      _layoutLifeCycle.draw.apply(drawArea, args)

      if _drawBrushFn
        brushArea = _container.getContainer().select('.brushArea')
        _drawBrushFn.apply(brushArea, args)

      _layoutLifeCycle.on 'redraw', me.redraw
      _layoutLifeCycle.on 'update', me.chart().lifeCycle().update
      _layoutLifeCycle.on 'drawAxis', me.chart().events().drawAxis

    me.redraw = (notAnimated) ->
      if _data
        me.draw(_data, notAnimated)

    me.brushed = (x) ->

    return me

  return layout