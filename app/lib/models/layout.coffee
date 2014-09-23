angular.module('wk.chart').factory 'layout', ($log, scale, scaleList, d3Animation) ->

  layout = () ->
    _id = ''
    _container = undefined
    _drawBrushFn = undefined
    _isBrush = false
    _data = undefined
    _owner = undefined
    _scaleList = scaleList()
    _layoutEvents = d3.dispatch('configure', 'draw', 'prepData', 'brush', 'redraw', 'drawAxis', 'update', 'tooltip')

    me = () ->

    me.id = (id) ->
      if arguments.length is 0 then return _id
      else
        _id = id
        return me

    me.owner = (owner) ->
      if arguments.length is 0 then return _owner
      else
        _owner = owner
        _scaleList.parentScales(owner.scales())
        _owner.events().on "configure.#{me.id()}", ()->
          _layoutEvents.configure.apply(me.scales())
          null
        return me

    me.scales = () ->
      return _scaleList

    me.scaleProperties = () ->
      props = []
      for k, s of _scaleList.allKinds()
        prop = s.property()
        if prop
          if Array.isArray(prop)
            props.concat(prop)
          else
            props.push(prop)
      return props

    me.container = (obj) ->
      if arguments.length is 0 then return _container
      else
        _container = obj
        return me

    me.setTooltip = (tooltip, overlay) ->
      _layoutEvents.tooltip(tooltip, overlay)
      return me

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

      _layoutEvents.prepData.apply(data, args)

    me.events = ()->
      return _layoutEvents

    me.draw = (data, notAnimated) ->
      _data = data
      $log.log 'drawing layout:', me.id()
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

      _layoutEvents.draw.apply(drawArea, args)

      if _drawBrushFn
        brushArea = _container.getContainer().select('.brushArea')
        _drawBrushFn.apply(brushArea, args)

      _layoutEvents.on 'redraw', me.redraw
      _layoutEvents.on 'update', me.owner().events().update
      _layoutEvents.on 'drawAxis', me.owner().events().drawAxis

    me.redraw = (notAnimated) ->
      if _data
        me.draw(_data, notAnimated)

    me.brushed = (x) ->

    me.update = (notAnimated) ->
      me.prepareData(_data)
      me.redraw(notAnimated)

    return me

  return layout