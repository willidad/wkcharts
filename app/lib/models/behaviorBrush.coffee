angular.module('wk.chart').factory 'behaviorBrush', ($log, $window, selectionSharing) ->

  behaviorBrush = () ->

    me = () ->

    _active = false
    _overlay = undefined
    _extent = undefined
    _startPos = undefined
    _evTargetData = undefined
    _area = undefined
    _data = undefined
    _areaSelection = undefined
    _areaBox = undefined
    _container = undefined
    _selectables =  undefined
    _brushGroup = undefined
    _x = undefined
    _y = undefined
    _tooltip = undefined
    _brushXY = false
    _brushX = false
    _brushY = false
    _boundsIdx = undefined
    _boundsValues = undefined
    _boundsDomain = undefined
    _brushEvents = d3.dispatch('brushStart', 'brush', 'brushEnd')

    left = top = right = bottom = startTop = startLeft = startRight = startBottom = undefined

    #--- Brush utility functions ----------------------------------------------------------------------------------------

    positionBrushElements = (left, right, top, bottom) ->
      width = right - left
      height = bottom - top

      # position resize-handles into the right corners
      if _brushXY
        _overlay.selectAll('.n').attr('transform', "translate(#{left},#{top})").select('rect').attr('width', width)
        _overlay.selectAll('.s').attr('transform', "translate(#{left},#{bottom})").select('rect').attr('width', width)
        _overlay.selectAll('.w').attr('transform', "translate(#{left},#{top})").select('rect').attr('height', height)
        _overlay.selectAll('.e').attr('transform', "translate(#{right},#{top})").select('rect').attr('height', height)
        _overlay.selectAll('.ne').attr('transform', "translate(#{right},#{top})")
        _overlay.selectAll('.nw').attr('transform', "translate(#{left},#{top})")
        _overlay.selectAll('.se').attr('transform', "translate(#{right},#{bottom})")
        _overlay.selectAll('.sw').attr('transform', "translate(#{left},#{bottom})")
        _extent.attr('width', width).attr('height', height).attr('x', left).attr('y', top)
      if _brushX
        _overlay.selectAll('.w').attr('transform', "translate(#{left},0)").select('rect').attr('height', height)
        _overlay.selectAll('.e').attr('transform', "translate(#{right},0)").select('rect').attr('height', height)
        _overlay.selectAll('.e').select('rect').attr('height', _areaBox.height)
        _overlay.selectAll('.w').select('rect').attr('height', _areaBox.height)
        _extent.attr('width', width).attr('height', _areaBox.height).attr('x', left).attr('y', 0)
      if _brushY
        _overlay.selectAll('.n').attr('transform', "translate(0,#{top})").select('rect').attr('width', width)
        _overlay.selectAll('.s').attr('transform', "translate(0,#{bottom})").select('rect').attr('width', width)
        _overlay.selectAll('.n').select('rect').attr('width', _areaBox.width)
        _overlay.selectAll('.s').select('rect').attr('width', _areaBox.width)
        _extent.attr('width', _areaBox.width).attr('height', height).attr('x', 0).attr('y', top)

    #-------------------------------------------------------------------------------------------------------------------

    getSelectedObjects = () ->
      er = _extent.node().getBoundingClientRect()
      _selectables.each((d) ->
          cr = this.getBoundingClientRect()
          xHit = er.left < cr.right - cr.width / 3 and cr.left + cr.width / 3 < er.right
          yHit = er.top < cr.bottom - cr.height / 3 and cr.top + cr.height / 3 < er.bottom
          d3.select(this).classed('selected', yHit and xHit)
        )
      return _selectables.data()


    #-------------------------------------------------------------------------------------------------------------------

    setSelection = (left, right, top, bottom) ->
      if _brushX
        _boundsIdx = [me.x().invert(left), me.x().invert(right)]
        if me.x().isOrdinal()
          _boundsValues = _data.map((d) -> me.x().value(d)).slice(_boundsIdx[0], _boundsIdx[1] + 1)
        else
          _boundsValues = [me.x().value(_data[_boundsIdx[0]]), me.x().value(_data[_boundsIdx[1]])]
        _boundsDomain = _data.slice(_boundsIdx[0], _boundsIdx[1] + 1)
      if _brushY
        _boundsIdx = [me.y().invert(bottom), me.y().invert(top)]
        if me.y().isOrdinal()
          _boundsValues = _data.map((d) -> me.y().value(d)).slice(_boundsIdx[0], _boundsIdx[1] + 1)
        else
          _boundsValues = [me.y().value(_data[_boundsIdx[0]]), me.y().value(_data[_boundsIdx[1]])]
        _boundsDomain = _data.slice(_boundsIdx[0], _boundsIdx[1] + 1)
      if _brushXY
        _boundsIdx = []
        _boundsValues = []
        _boundsDomain = getSelectedObjects()
      $log.debug 'bounds', _boundsIdx, _boundsValues, _boundsDomain

    #--- BrushStart Event Handler --------------------------------------------------------------------------------------

    brushStart = () ->
      #register a mouse handlers for the brush
      _evTargetData = d3.select(d3.event.target).datum()
      #_area = this
      #_areaBox = _area.getBBox()
      $log.debug 'AreaBox', _areaBox
      _startPos = d3.mouse(_area)
      startTop = top
      startLeft = left
      startRight = right
      startBottom = bottom
      d3.select(_area).style('pointer-events','none').selectAll(".resize").style("display", null)
      d3.select('body').style('cursor', d3.select(d3.event.target).style('cursor'))

      d3.select($window).on 'mousemove.brush', brushMove
      d3.select($window).on 'mouseup.brush', brushEnd

      _tooltip.hide(true)
      _boundsIdx = undefined
      _brushEvents.brushStart()

    #--- BrushEnd Event Handler ----------------------------------------------------------------------------------------

    brushEnd = () ->
      #de-register handlers
      #_evTargetData = d3.select(_area).attr('class')
      #$log.debug 'brushEnd', _area, _evTargetData
      d3.select($window).on 'mousemove.brush', null
      d3.select($window).on 'mouseup.brush', null
      d3.select(_area).style('pointer-events','all').selectAll('.resize').style('display', null) # show the resize handlers
      d3.select('body').style('cursor', null)
      if bottom - top is 0 or right - left is 0
        #brush is empty
        d3.select(_area).selectAll('.resize').style('display', 'none')
      _tooltip.hide(false)
      _brushEvents.brushEnd(_boundsIdx)

    #--- BrushMove Event Handler ---------------------------------------------------------------------------------------

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
      setSelection(left, right, top, bottom)
      _brushEvents.brush(_boundsIdx, _boundsValues, _boundsDomain)
      selectionSharing.setSelection _boundsValues, _brushGroup

      #--- Brush ---------------------------------------------------------------------------------------------------------

    me.brush = (s) ->
      if arguments.length is 0 then return _overlay
      else
        if not _active then return
        #_area = s.node()
        _overlay = s
        _brushXY = me.x() and me.y()
        _brushX = me.x() and not me.y()
        _brushY = me.y() and not me.x()
        # create the handler elements and register the handlers
        s.style({'pointer-events': 'all', cursor: 'crosshair'})
        #s.append('rect').attr('class', 'background').style({visibility:'hidden'}).datum({name:'background', cursor:''})
        _extent = s.append('rect').attr({class:'extent', x:0, y:0, width:0, height:0}).style('cursor','move').datum({name:'extent'})
        # resize handles for the sides
        if _brushY or _brushXY
          s.append('g').attr('class', 'resize n').style({cursor:'ns-resize', display:'none'})
            .append('rect').attr({x:0, y: -3, width:0, height:6}).style('visibility', 'hidden').datum({name:'n'})
          s.append('g').attr('class', 'resize s').style({cursor:'ns-resize', display:'none'})
            .append('rect').attr({x:0, y: -3, width:0, height:6}).style('visibility', 'hidden').datum({name:'s'})
        if _brushX or _brushXY
          s.append('g').attr('class', 'resize w').style({cursor:'ew-resize', display:'none'})
            .append('rect').attr({y:0, x: -3, width:6, height:0}).style('visibility', 'hidden').datum({name:'w'})
          s.append('g').attr('class', 'resize e').style({cursor:'ew-resize', display:'none'})
            .append('rect').attr({y:0, x: -3, width:6, height:0}).style('visibility', 'hidden').datum({name:'e'})
        # resize handles for the corners
        if _brushXY
          s.append('g').attr('class', 'resize nw').style({cursor:'nwse-resize', display:'none'})
          .append('rect').attr({x: -3, y: -3, width:6, height:6}).style('visibility', 'hidden').datum({name:'nw'})
          s.append('g').attr('class', 'resize ne').style({cursor:'nesw-resize', display:'none'})
          .append('rect').attr({x: -3, y: -3, width:6, height:6}).style('visibility', 'hidden').datum({name:'ne'})
          s.append('g').attr('class', 'resize sw').style({cursor:'nesw-resize', display:'none'})
          .append('rect').attr({x: -3, y: -3, width:6, height:6}).style('visibility', 'hidden').datum({name:'sw'})
          s.append('g').attr('class', 'resize se').style({cursor:'nwse-resize', display:'none'})
          .append('rect').attr({x: -3, y: -3, width:6, height:6}).style('visibility', 'hidden').datum({name:'se'})
        #register handler. Please note, brush wants the mouse down exclusively !!!
        s.on 'mousedown.brush', brushStart
        return me

    #--- Brush Properties --------------------------------------------------------------------------------------------

    me.active = (val) ->
      if arguments.length is 0 then return _active
      else
        _active = val
        return me #to enable chaining

    me.x = (val) ->
      if arguments.length is 0 then return _x
      else
        _x = val
        return me #to enable chaining

    me.y = (val) ->
      if arguments.length is 0 then return _y
      else
        _y = val
        return me #to enable chaining

    me.area = (val) ->
      if arguments.length is 0 then return _areaSelection
      else
        _areaSelection = val
        _area = _areaSelection.node()
        _areaBox = _area.getBBox()
        $log.debug 'area set', _areaBox
        me.brush(_areaSelection)
        return me #to enable chaining

    me.container = (val) ->
      if arguments.length is 0 then return _container
      else
        _container = val
        _selectables = _container.selectAll('.selectable')
        return me #to enable chaining

    me.data = (val) ->
      if arguments.length is 0 then return _data
      else
        _data = val
        return me #to enable chaining

    me.brushGroup = (val) ->
      if arguments.length is 0 then return _brushGroup
      else
        _brushGroup = val
        return me #to enable chaining

    me.tooltip = (val) ->
      if arguments.length is 0 then return _tooltip
      else
        _tooltip = val
        return me #to enable chaining

    me.on = (name, callback) ->
      _brushEvents.on name, callback

    me.extent = () ->
      return _boundsIdx

    me.empty = () ->
      return _boundsIdx is undefined

    return me
  return behaviorBrush