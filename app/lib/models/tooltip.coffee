angular.module('wk.chart').factory 'tooltip', ($log, $document, $rootScope, $compile, $templateCache, templateDir) ->
  tooltip = () ->

    _events = d3.dispatch('enter', 'move', 'leave')
    _scale = undefined
    _data = undefined
    _refreshMove = false
    _active = false
    _isHorizontal = false
    _brushElement = undefined
    _posIdx = 0
    _showScales = []

    _templ = $templateCache.get(templateDir + 'toolTip.jade')
    _templScope = $rootScope.$new(true)
    _compiledTempl = $compile(_templ)(_templScope)
    body = $document.find('body')

    bodyRect = body[0].getBoundingClientRect()

    setLayerData = (data, scales, headerScale) ->
      if headerScale
        @headerName = scales[headerScale].property()
        @headerValue = scales[headerScale].formattedValue(data)

    mouseEnter = () ->
      if not _active then return
      body.append(_compiledTempl)
      _templScope.layers = []
      if _scale
        offset = d3.mouse(this)[_posIdx]
        idx = _scale.invert(offset)
        _events.enter.apply(_templScope, [idx, offset, this])
      else
        _events.enter.apply(_templScope, [d3.select(this).datum()])

      _templScope.ttShow = true
      _templScope.$apply()
      rect = _compiledTempl[0].getBoundingClientRect()
      clientX = if bodyRect.right - 20 > d3.event.clientX + rect.width + 10 then d3.event.clientX + 10 else d3.event.clientX - rect.width - 10
      clientY = if bodyRect.bottom - 20 > d3.event.clientY + rect.height + 10 then d3.event.clientY + 10 else d3.event.clientY - rect.height - 10
      _templScope.position = {
        position: 'absolute'
        left: clientX + 'px'
        top: clientY + 'px'
        'z-index': 1500
        opacity: 1
      }

      _templScope.$apply()

    mouseMove = () ->
      if not _active then return
      if _refreshMove
        _templScope.layers = []
        if _scale
          offset = d3.mouse(this)[_posIdx]
          idx = _scale.invert(offset)
          _events.move.apply(_templScope, [idx, offset, this])
        else
          _events.move.apply(_templScope, [d3.select(this).datum()])

      rect = _compiledTempl[0].getBoundingClientRect()
      clientX = if bodyRect.right - 20 > d3.event.clientX + rect.width + 10 then d3.event.clientX + 10 else d3.event.clientX - rect.width - 10
      clientY = if bodyRect.bottom - 20 > d3.event.clientY + rect.height + 10 then d3.event.clientY + 10 else d3.event.clientY - rect.height - 10
      _templScope.position = {
        position: 'absolute'
        left: clientX + 'px'
        top: clientY + 'px'
        'z-index': 1500
        opacity: 1
      }
      _templScope.ttShow = true
      _templScope.$apply()

    mouseLeave = () ->
      if not _active then return
      if _scale
        offset = d3.mouse(this)[_posIdx]
        idx = _scale.invert(offset)
        _events.leave.apply(_templScope, [idx, offset, this])
      _templScope.ttShow = false
      _templScope.$apply()
      _compiledTempl.remove()

    forwardToBrush = () ->
      if _brushElement
        new_click_event = new Event('mousedown')
        new_click_event.pageX = d3.event.pageX
        new_click_event.clientX = d3.event.clientX
        new_click_event.pageY = d3.event.pageY
        new_click_event.clientY = d3.event.clientY
        _brushElement.dispatchEvent(new_click_event)


    #-------------------------------------------------------------------------------------------------------------------

    me = (selection) ->
      if arguments.length is 0 then return me
      else
        selection.on 'mouseenter', mouseEnter
        selection.on 'mousemove', mouseMove
        selection.on 'mouseleave', mouseLeave
        selection.on 'mousedown', forwardToBrush
      return me

    me.on = (event, callback) ->
      _events.on(event, callback)
      return me

    me.refreshOnMove = (trueFalse) ->
      if arguments.length is 0 then return _refreshMove
      else
        _refreshMove = trueFalse

    me.scale = (scale) ->
      if arguments.length is 0  then return _scale
      else
        _scale = scale
        return me

    me.isHorizontal = (trueFalse) ->
      if arguments.length is 0 then return _isHorizontal
      else
        _isHorizontal = trueFalse
        _posIdx = if trueFalse then 1 else 0
        return me #to enable chaining

    me.active = (val) ->
      if arguments.length is 0 then return _active
      else
        _active = val
        return me #to enable chaining

    me.brushElement = (val) ->
      if arguments.length is 0 then return _brushElement
      else
        _brushElement = val
        return me #to enable chaining

    me.showScales = (val) ->
      if arguments.length is 0 then return _showScales
      else
        _showScales = val
        return me #to enable chaining

    me.data = (data) ->
      if arguments.length is 0 then return _data
      else
        _data = data
        return me

    me.templatePath = (templ) ->
      if arguments.length is 0 then return _template
      else
        _template = templ

    return me

  return tooltip
