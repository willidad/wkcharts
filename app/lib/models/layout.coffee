angular.module('wk.chart').factory 'layout', ($log, scale, scaleList) ->

  layoutCntr = 0

  layout = () ->
    _id = "layout#{layoutCntr++}"
    _container = undefined
    _data = undefined
    _chart = undefined
    _scaleList = scaleList()
    _layoutLifeCycle = d3.dispatch('configure', 'draw', 'prepareData', 'brush', 'redraw', 'drawAxis', 'update', 'updateAttrs')

    me = () ->

    me.id = (id) ->
      return _id

    me.chart = (chart) ->
      if arguments.length is 0 then return _chart
      else
        _chart = chart
        _scaleList.parentScales(chart.scales())
        _chart.lifeCycle().on "configure.#{me.id()}", () -> _layoutLifeCycle.configure.apply(me.scales()) #passthrough
        _chart.lifeCycle().on "drawChart.#{me.id()}", me.draw # register for the drawing event
        _chart.lifeCycle().on "prepareData.#{me.id()}", me.prepareData
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

    me.behavior = () ->
      me.chart().behavior()

    me.prepareData = (data) ->
      args = []
      for kind in ['x','y', 'color']
        args.push(_scaleList.getKind(kind))
      _layoutLifeCycle.prepareData.apply(data, args)

    me.lifeCycle = ()->
      return _layoutLifeCycle

    me.draw = (data, notAnimated) ->
      _data = data
      #$log.log 'drawing layout:', me.id()
      container = _container.getChartArea()
      drawArea = container.select(".#{me.id()}")
      if drawArea.empty()
        drawArea = container.append('g').attr('class', (d) -> me.id())

      options = {
        height:_container.height(),
        width:_container.width(),
        margins:_container.margins(),
        duration: if notAnimated then 0 else me.chart().animationDuration()
      }

      args = [data, options]
      for kind in ['x','y', 'color', 'size', 'shape']
        args.push(_scaleList.getKind(kind))

      _layoutLifeCycle.draw.apply(drawArea, args)

      _layoutLifeCycle.on 'redraw', me.redraw
      _layoutLifeCycle.on 'update', me.chart().lifeCycle().update
      _layoutLifeCycle.on 'drawAxis', me.chart().lifeCycle().drawAxis
      _layoutLifeCycle.on 'updateAttrs', me.chart().lifeCycle().updateAttrs
      _layoutLifeCycle.on 'brush', (axis, notAnimated) ->
        _container.drawSingleAxis(axis)
        if _data
          me.draw(_data, notAnimated)

    return me

  return layout