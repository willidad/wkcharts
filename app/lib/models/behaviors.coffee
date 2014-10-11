angular.module('wk.chart').factory 'behavior', ($log, $window) ->

  behavior = () ->

    _overlay = undefined
    _extent = undefined
    _startPos = undefined
    _evTargetData = undefined
    _area = undefined
    _areaBox = undefined
    left = top = right = bottom = startTop = startLeft = startRight = startBottom = undefined

    _showMarkerLine = true
    _markerLine = undefined

    #--- Brush utility functions ----------------------------------------------------------------------------------------

    positionBrushElements = (left, right, top, bottom) ->
      width = right - left
      height = bottom - top
      _extent.attr('width', width).attr('height', height).attr('x', left).attr('y', top)
      # position resize-handles into the right corners
      _overlay.selectAll('.n').attr('transform', "translate(#{left},#{top})").select('rect').attr('width', width)
      _overlay.selectAll('.s').attr('transform', "translate(#{left},#{bottom})").select('rect').attr('width', width)
      _overlay.selectAll('.w').attr('transform', "translate(#{left},#{top})").select('rect').attr('height', height)
      _overlay.selectAll('.e').attr('transform', "translate(#{right},#{top})").select('rect').attr('height', height)
      _overlay.selectAll('.ne').attr('transform', "translate(#{right},#{top})")
      _overlay.selectAll('.nw').attr('transform', "translate(#{left},#{top})")
      _overlay.selectAll('.se').attr('transform', "translate(#{right},#{bottom})")
      _overlay.selectAll('.sw').attr('transform', "translate(#{left},#{bottom})")

    #--- BrushStart Event Handler --------------------------------------------------------------------------------------

    brushStart = () ->
      #register a mouse handlers for the brush
      _evTargetData = d3.select(d3.event.target).datum()
      _area = this
      _areaBox = _area.getBBox()
      _startPos = d3.mouse(_area)
      startTop = top
      startLeft = left
      startRight = right
      startBottom = bottom
      d3.select(_area).style('pointer-events','none').selectAll(".resize").style("display", null)
      d3.select('body').style('cursor', d3.select(d3.event.target).style('cursor'))

      d3.select($window).on 'mousemove.brush', brushMove
      d3.select($window).on 'mouseup.brush', brushEnd

      tooltipLeave()

    brushEnd = () ->
      #de-register handlers
      #_evTargetData = d3.select(_area).attr('class')
      $log.debug 'brushEnd', _area, _evTargetData
      d3.select($window).on 'mousemove.brush', null
      d3.select($window).on 'mouseup.brush', null
      d3.select(_area).style('pointer-events','all').selectAll('.resize').style('display', null) # show the resize handlers
      d3.select('body').style('cursor', null)
      if bottom - top is 0 or right - left is 0
        #brush is empty
        d3.select(_area).selectAll('.resize').style('display', 'none')

    brushMove = () ->
      pos = d3.mouse(_area)
      deltaX = pos[0] - _startPos[0]
      deltaY = pos[1] - _startPos[1]

      # this elaborate code is needed to deal with scenarios when mouse moves fast and the events do not hit x/y + delta
      # does not hi the 0 point maye there is a more elegant way to write this, but for now it works :-)

      leftMv = (delta) ->
        if startLeft + delta >= 0
          if startLeft + delta > startRight
            null
            rightMv(delta + startLeft - startRight)
          else
            left = startLeft + delta
        else
          left = 0

      rightMv = (delta) ->
        if startRight + delta <= _areaBox.width
          if startRight + delta < startLeft
            leftMv(startRight + delta - startLeft)
          else
            right = startRight + delta
        else
          _areaBox.width

      topMv = (delta) ->
        if startTop + delta >= 0
          if startTop + delta > startBottom
            bottomMv(startTop + delta - startBottom)
          else
            top = startTop + delta
        else
          top = 0

      bottomMv = (delta) ->
        if startBottom + delta <= _areaBox.height
          if startBottom + delta < startTop
            topMv(startBottom + delta - startTop)
          else
            bottom  = startBottom + delta
        else
          bottom = _areaBox.height

      horMv = (delta) ->
        if startLeft + delta >= 0
          if startRight + delta <= _areaBox.width
            left = startLeft + delta
            right = startRight + delta
          else
            right = _areaBox.width
            left = _areaBox.width - (startRight - startLeft)
        else
          left = 0
          right = startRight - startLeft


      vertMv = (delta) ->
        if startTop + delta >= 0
          if startBottom + delta <= _areaBox.height
            top = startTop + delta
            bottom = startBottom + delta
          else
            bottom = _areaBox.height
            top = _areaBox.height - (startBottom - startTop)
        else
          top = 0
          bottom = startBottom - startTop

      #$log.debug 'brushMove', _evTargetClass, pos
      switch _evTargetData.name
        when 'background' #TODO ensure that area stays within the container limit
          if deltaX + _startPos[0] > 0
            left = if deltaX < 0 then _startPos[0] + deltaX else _startPos[0]
            if left + Math.abs(deltaX) < _areaBox.width
              right = left + Math.abs(deltaX)
            else
              right = _areaBox.width
          else
            left = 0

          if deltaY + _startPos[1] > 0
            top = if deltaY < 0 then _startPos[1] + deltaY else _startPos[1]
            if top + Math.abs(deltaY) < _areaBox.height
              bottom = top + Math.abs(deltaY)
            else
              bottom = _areaBox.height
          else
            top = 0

        when 'extent'
          vertMv(deltaY); horMv(deltaX)
        when 'n'
          topMv(deltaY)
        when 's'
          bottomMv(deltaY)
        when 'w'
          leftMv(deltaX)
        when 'e'
          rightMv(deltaX)
        when 'nw'
          topMv(deltaY); leftMv(deltaX)
        when 'ne'
          topMv(deltaY); rightMv(deltaX)
        when 'sw'
          bottomMv(deltaY); leftMv(deltaX)
        when 'se'
          bottomMv(deltaY); rightMv(deltaX)

      positionBrushElements(left, right, top, bottom)

    #-------------------------------------------------------------------------------------------------------------------

    tooltipStart = () ->
      #$log.debug 'tooltipStart', _area
      # create a marker line if required
      if _showMarkerLine
        _area = this
        _areaBox = _area.getBBox()
        _pos = d3.mouse(_area)
        _markerLine = d3.select(_area).append('g').attr('class', 'tooltipMarker')
          .append('line').attr({class:'markerLine', x0:0, x1:0, y0:0,y1:_areaBox.height}).style({stroke: 'black', 'pointer-events': 'none'})
        _markerLine.attr('transform', "translate(#{_pos[0]})")


    tooltipMove = () ->
      #$log.debug 'tooltipMove', _area
      _pos = d3.mouse(_area)
      _markerLine.attr('transform', "translate(#{_pos[0]})")

    tooltipLeave = () ->
      #$log.debug 'tooltipLeave', _area
      if _markerLine
        _markerLine.remove()
      _markerLine = undefined

    me = () ->

    me.tooltip = (s) ->
      s
        .on 'mouseenter.tooltip', tooltipStart
        .on 'mousemove.tooltip', tooltipMove
        .on 'mouseleave.tooltip', tooltipLeave




    me.brush = (s) ->
      if arguments.length is 0 then return _overlay
      else
        _overlay = s
        # create the handler elements and register the handlers
        s.style({'pointer-events': 'all', cursor: 'crosshair'})
        s.append('rect').attr('class', 'background').style({visibility:'hidden'}).datum({name:'background', cursor:''})
        _extent = s.append('rect').attr({class:'extent', x:0, y:0, width:0, height:0}).style('cursor','move').datum({name:'extent', cursor:'move'})
        # resize handles for the sides
        s.append('g').attr('class', 'resize n').style({cursor:'ns-resize', display:'none'})
          .append('rect').attr({x:0, y: -3, width:0, height:6}).style('visibility', 'hidden').datum({name:'n', cursor:'ns-resize'})
        s.append('g').attr('class', 'resize w').style({cursor:'ew-resize', display:'none'})
          .append('rect').attr({y:0, x: -3, width:6, height:0}).style('visibility', 'hidden').datum({name:'w', cursor:'ew-resize'})
        s.append('g').attr('class', 'resize s').style({cursor:'ns-resize', display:'none'})
          .append('rect').attr({x:0, y: -3, width:0, height:6}).style('visibility', 'hidden').datum({name:'s', cursor:'ns-resize'})
        s.append('g').attr('class', 'resize e').style({cursor:'ew-resize', display:'none'})
          .append('rect').attr({y:0, x: -3, width:6, height:0}).style('visibility', 'hidden').datum({name:'e', cursor:'ew-resize'})
        # resize handles for the corners
        s.append('g').attr('class', 'resize nw').style({cursor:'nwse-resize', display:'none'})
          .append('rect').attr({x: -3, y: -3, width:6, height:6}).style('visibility', 'hidden').datum({name:'nw', cursor:'nwse-resize'})
        s.append('g').attr('class', 'resize ne').style({cursor:'nesw-resize', display:'none'})
          .append('rect').attr({x: -3, y: -3, width:6, height:6}).style('visibility', 'hidden').datum({name:'ne', cursor:'nesw-resize'})
        s.append('g').attr('class', 'resize sw').style({cursor:'nesw-resize', display:'none'})
          .append('rect').attr({x: -3, y: -3, width:6, height:6}).style('visibility', 'hidden').datum({name:'sw', cursor:'nesw-resize'})
        s.append('g').attr('class', 'resize se').style({cursor:'nwse-resize', display:'none'})
          .append('rect').attr({x: -3, y: -3, width:6, height:6}).style('visibility', 'hidden').datum({name:'se', cursor:'nwse-resize'})
        #register handler. Please note, brush wants the mouse down exclusively !!!
        s.on 'mousedown.brush', brushStart
        return me

    return me
  return behavior