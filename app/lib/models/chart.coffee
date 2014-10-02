angular.module('wk.chart').factory 'chart', ($log, layeredData, scaleList, tooltip) ->

  chart = () ->
    _id = ''
    _allScales = scaleList()
    _layouts = []
    _containers = []
    _ownedScales = scaleList()

    _container = undefined
    _data = undefined
    _showTooltip = false

    _brush = d3.dispatch('draw', 'change')
    _chartEvents = d3.dispatch('configure', 'draw', 'redraw', 'drawAxis', 'update')

    me = () ->

    me.id = (id) ->
      if arguments.length is 0 then return _id
      else
        _id = id
        return me

    me.addLayout = (layout) ->
      if arguments.length is 0 then return _layouts
      else
        _layouts.push(layout)
        return me

    me.layouts = () ->
      return _layouts

    me.addContainer = (container) ->
      _containers.push(container)

    me.containers = () ->
      return _containers

    me.scales = () ->
      return _ownedScales

    me.allScales = () ->
      return _allScales

    me.addScale = (scale, layout) ->
      _allScales.add(scale)
      if layout
        layout.scales().add(scale)
      else
        _ownedScales.add(scale)
      return me

    me.hasScale = (scale) ->
      return !!_allScales.has(scale)

    me.container = (obj) ->
      if arguments.length is 0 then return _container
      else
        _container = obj
        return me

    me.showTooltip = (trueFalse) ->
      if arguments.length is 0 then return _showTooltip
      else
        _showTooltip = trueFalse

        for c in _containers
          c.setTooltip(_showTooltip)
        return me

    #me.tooltip = () ->
    # # if _showTooltip then _tooltip else _noop


    me.brush = () ->
      return _brush

    me.draw = (data) ->
      _data = data
      # set domain for shared scales (other scales will be set in layout draw (called from container)
      for id, s of _ownedScales.getOwned()
        if s.resetOnNewData()
          s.scale().domain(s.getDomain(data))
      for c in _containers
        c.sizeContainer()
        c.prepData(data)
        c.drawAxis()
        c.draw(data)
      options = {height:_container.height(), width:_container.width(), margins:_container.margins(), duration: 0}
      me.events().draw(data, options)
      me.events().on 'drawAxis', () ->
        for c in _containers
          c.drawAxis()
      me.events().on 'update', () ->
        me.draw(_data)

      return me

    me.events = () ->
      return _chartEvents

    me.getData = () ->
      return _data


    return me

  return chart