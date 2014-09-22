angular.module('wk.chart').factory 'tooltip', ($log, $document, $rootScope, $compile, $templateCache, templateDir) ->
  tooltip = () ->

    _events = d3.dispatch('enter', 'move', 'leave')
    _x = undefined
    _data = undefined
    _refreshMove = false
    _active = false

    _templ = $templateCache.get(templateDir + 'toolTip.jade')
    _templScope = $rootScope.$new(true)
    _compiledTempl = $compile(_templ)(_templScope)
    body = $document.find('body')

    bodyRect = body[0].getBoundingClientRect()

    mouseEnter = () ->
      if not _active then return
      body.append(_compiledTempl)
      _templScope.layers = []
      if _x
        xValue = _x.scale().invert(d3.mouse(this)[0])
        _events.enter.apply(_templScope,[xValue])
      else
        _events.enter.apply(_templScope, [d3.select(this).data()[0]])
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
      _templScope.ttShow = true
      _templScope.$apply()

    mouseMove = () ->
      if not _active then return
      if _refreshMove
        _templScope.layers = []
        if _x
          xValue = _x.scale().invert(d3.mouse(this)[0])
          _events.move.apply(_templScope,[xValue])
        else
          _events.move.apply(_templScope, [d3.select(this).data()[0]])

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
      _templScope.ttShow = false
      _templScope.$apply()
      _compiledTempl.remove()

    me = (selection) ->
      if arguments.length is 0 then return me
      else
        selection.on 'mouseenter', mouseEnter
        selection.on 'mousemove', mouseMove
        selection.on 'mouseleave', mouseLeave
      return me

    me.on = (event, callback) ->
      _events.on(event, callback)
      return me

    me.refreshOnMove = (trueFalse) ->
      if arguments.length is 0 then return _refreshMove
      else
        _refreshMove = trueFalse

    me.x = (x) ->
      if arguments.length is 0  then return _x
      else
        _x = x
        return me

    me.active = (val) ->
      if arguments.length is 0 then return _active
      else
        _active = val
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
