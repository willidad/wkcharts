angular.module('wk.chart').factory 'behaviorTooltip', ($log, $document, $rootScope, $compile, $templateCache, templateDir) ->

  behaviorTooltip = () ->

    _active = false
    _hide = false
    _showMarkerLine = undefined
    _markerG = undefined
    _markerLine = undefined
    _areaSelection = undefined
    _area= undefined
    _markerScale = undefined
    _data = undefined
    _tooltipDispatch = d3.dispatch('enter', 'moveData', 'moveMarker', 'leave')

    _templ = $templateCache.get(templateDir + 'toolTip.jade')
    _templScope = $rootScope.$new(true)
    _compiledTempl = $compile(_templ)(_templScope)
    body = $document.find('body')

    bodyRect = body[0].getBoundingClientRect()

    me = () ->

    #--- helper Functions ----------------------------------------------------------------------------------------------

    positionBox = () ->
      rect = _compiledTempl[0].getBoundingClientRect()
      #d3.select(_compiledTempl[0]).style('height',height).style('width', width)
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

    positionInitial = () ->
      _templScope.position = {
        position: 'absolute'
        left: 0 + 'px'
        top: 0 + 'px'
        'z-index': 1500
      }
      _templScope.$apply()  # ensure tooltip gets rendered
      #wayit until it is rendered and then reposition
      _.throttle positionBox, 200

    #--- TooltipStart Event Handler ------------------------------------------------------------------------------------

    tooltipEnter = () ->
      if not _active or _hide then return
      # append data div
      body.append(_compiledTempl)
      _templScope.layers = []

      # get tooltip data value

      if _showMarkerLine
        _pos = d3.mouse(this)
        value = _markerScale.invert(if _markerScale.isHorizontal() then _pos[0] else _pos[1])
      else
        value = d3.select(this).datum()

      _templScope.ttShow = true
      _tooltipDispatch.enter.apply(_templScope, [value]) # call layout to fill in data
      positionInitial()

      # create a marker line if required
      if _showMarkerLine
        #_area = this
        _areaBox = _areaSelection.select('.background').node().getBBox()
        _pos = d3.mouse(_area)
        _markerG = _areaSelection.append('g')
          .attr('class', 'tooltipMarker')
        _markerLine = _markerG.append('line')
        if _markerScale.isHorizontal()
          _markerLine.attr({class:'markerLine', x0:0, x1:0, y0:0,y1:_areaBox.height})
        else
          _markerLine.attr({class:'markerLine', x0:0, x1:_areaBox.width, y0:0,y1:0})

        _markerLine.style({stroke: 'darkgrey', 'pointer-events': 'none'})

        _tooltipDispatch.moveMarker.apply(_markerG, [value])

    #--- TooltipMove  Event Handler ------------------------------------------------------------------------------------

    tooltipMove = () ->
      if not _active or _hide then return
      _pos = d3.mouse(_area)
      positionBox()
      if _showMarkerLine
        #_markerG.attr('transform', "translate(#{_pos[0]})")
        dataIdx = _markerScale.invert(if _markerScale.isHorizontal() then _pos[0] else _pos[1])
        _tooltipDispatch.moveMarker.apply(_markerG, [dataIdx])
        _templScope.layers = []
        _tooltipDispatch.moveData.apply(_templScope, [dataIdx])
      _templScope.$apply()

    #--- TooltipLeave Event Handler ------------------------------------------------------------------------------------

    tooltipLeave = () ->
      #$log.debug 'tooltipLeave', _area
      if _markerG
        _markerG.remove()
      _markerG = undefined
      _templScope.ttShow = false
      _compiledTempl.remove()

    #--- Interface to brush --------------------------------------------------------------------------------------------

    me.hide = (val) ->
      if arguments.length is 0 then return _hide
      else
        _hide = val
        if _markerG
          _markerG.style('visibility', if _hide then 'hidden' else 'visible')
        _templScope.ttShow = not _hide
        _templScope.$apply()
        return me #to enable chaining


    #-- Tooltip properties ---------------------------------------------------------------------------------------------

    me.active = (val) ->
      if arguments.length is 0 then return _active
      else
        _active = val
        return me #to enable chaining

    me.area = (val) ->
      if arguments.length is 0 then return _areaSelection
      else
        _areaSelection = val
        _area = _areaSelection.node()
        if _showMarkerLine
          me.tooltip(_areaSelection)
        return me #to enable chaining

    me.markerScale = (val) ->
      if arguments.length is 0 then return _markerScale
      else
        if val
          _showMarkerLine = true
          _markerScale = val
        else
          _showMarkerLine = false
        return me #to enable chaining

    me.data = (val) ->
      if arguments.length is 0 then return _data
      else
        _data = val
        return me #to enable chaining

    me.on = (name, callback) ->
      _tooltipDispatch.on name, callback

    #--- Tooltip -------------------------------------------------------------------------------------------------------

    me.tooltip = (s) -> # register the tooltip events with the selection
      if arguments.length is 0 then return me
      else  # set tooltip for an objects selection
        s.on 'mouseenter.tooltip', tooltipEnter
          .on 'mousemove.tooltip', tooltipMove
          .on 'mouseleave.tooltip', tooltipLeave

    return me

  return behaviorTooltip