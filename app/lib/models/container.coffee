angular.module('wk.chart').factory 'container', ($log, $window, d3ChartMargins, scaleList, axisConfig, d3Animation, behavior) ->

  containerCnt = 0

  container = () ->

    _containerId = 'cntnr' + containerCnt++
    _chart = undefined

    _element = undefined
    _elementSelection = undefined
    _layouts = []
    _legends = []
    _svg = undefined
    _container = undefined
    _spacedContainer = undefined
    _chartArea = undefined
    _brushArea = undefined
    _margin = angular.copy(d3ChartMargins.default)
    _innerWidth = 0
    _innerHeight = 0
    _data = undefined
    _overlay = undefined
    _behavior = undefined

    me = ()->

    me.id = () ->
      return _containerId

    me.chart = (chart) ->
      if arguments.length is 0 then return _chart
      else
        _chart = chart
        return me

    _genChartFrame = ()->
      _svg = _elementSelection.append('div').attr('class', 'd3-chart')
        .append('svg')
      _svg.append('defs').append('clipPath').attr('id', "clip-#{_containerId}").append('rect')
      _container= _svg.append('g').attr('class','d3-chart-container')
      _overlay = _container.append('g').attr('class', 'overlay').style('pointer-events', 'all')
      _overlay.append('rect').style('visibility', 'hidden').attr('class', 'background').datum({name:'background'})
      _chartArea = _container.append('g').attr('class', 'chartArea')

    _getAxis = (orient) ->
      axis = _container.select(".axis.#{orient}")
      if axis.empty()
        axis = _container.append('g').attr('class',"axis #{orient}")
      if orient is 'bottom'
        axis.attr('transform', (d) -> "translate(0, #{_innerHeight})")
      if orient is 'right'
        axis.attr('transform', (d) -> "translate(#{_innerWidth}, 0)")
      return axis

    _removeAxis = (orient) ->
      _container.select(".axis.#{orient}").remove()

    _getLabel = (orient) ->
      label = _container.select(".label.#{orient}")
      if label.empty()
        label = _container.append('g').attr('class',"label #{orient}")
      switch orient
        when 'top'
          label.attr('transform', (d) -> "translate(#{_innerWidth/2}, #{-_margin.top})")
        when 'bottom'
          label.attr('transform', (d) -> "translate(#{_innerWidth/2},#{_innerHeight+_margin.bottom})")
        when 'left'
          label.attr('transform', (d) -> "translate(#{-_margin.left},#{_innerHeight/2})rotate(-90)")
        when 'right'
          label.attr('transform', (d) ->"translate(#{_innerWidth+_margin.right},#{_innerHeight/2})rotate(90)")
      return label

    _removeLabel = (orient) ->
      _container.select(".label.#{orient}").remove()

    me.addLayout = (layout) ->
      _layouts.push(layout)
      return me

    me.addLegend = (legend) ->
      _legends.push(legend)
      return me

    me.sizeContainer = () ->
      #collect axis and label information about layouts registered with container
      #$log.log 'sizing container. Owner:', me.id()
      _margin = angular.copy(d3ChartMargins.default)
      for l in _layouts
        for k, s of l.scales().allKinds()  # shared scales will be hit multiple times. ist this a problem?
          #$log.log ' scaling:', s.id(), s.showAxis(), s.axisOrient()
          if s.showAxis()
            axisPos = s.axisOrient()
            _margin[axisPos] = d3ChartMargins.axis[axisPos]
            if s.showLabel()
              _margin[axisPos] += d3ChartMargins.label[axisPos]
      $log.info "Element Margins #{me.id()}",_margin

      bounds = _elementSelection.node().getBoundingClientRect()
      $log.info "Element Bounds #{me.id()}", bounds
      _innerWidth = bounds.width - _margin.left - _margin.right
      _innerHeight = bounds.height - _margin.top - _margin.bottom
      _svg.select("#clip-#{_containerId} rect").attr('width', _innerWidth).attr('height', _innerHeight)
      _spacedContainer = _container.attr('transform', (d) -> "translate(#{_margin.left}, #{_margin.top})")
      _spacedContainer.select('.chartArea').style('clip-path', "url(#clip-#{_containerId})")
      _spacedContainer.select('.overlay>.background').attr('width', _innerWidth).attr('height', _innerHeight)
      _chart.behavior().overlay(_overlay)
      _chart.behavior().container(_spacedContainer)

      return me

    me.element = (elem) ->
      if arguments.length is 0 then return _element
      else
        _element = elem
        _elementSelection = d3.select(_element)
        if _elementSelection.empty()
          $log.error "Error: Element #{_element} does not exist"
        else
          _genChartFrame()
        return me

    me.height = () ->
      return _innerHeight

    me.width = () ->
      return _innerWidth

    me.margins = () ->
      return _margin

    me.getChartArea = () ->
      return _spacedContainer.select('.chartArea')

    me.getBrushArea = () ->
      return _brushArea

    me.getOverlay = () ->
      return _overlay

    me.getContainer = () ->
      return _spacedContainer

    me.prepData = (data) ->
      for l in _layouts
        l.prepareData(data)

    me.drawAxis = () ->
      # set scales before drawing the axis
      for l in _layouts
        for k, s of l.scales().allKinds()
          if s.isHorizontal()
            s.range([0, _innerWidth])
          if s.isVertical()
            s.range([_innerHeight, 0])

          if s.showAxis()
            s.axis().scale(s.scale())
            a = _getAxis(s.axisOrient())
            if s.showGrid()
              s.axis().tickSize(if s.isHorizontal() then -_innerHeight else -_innerWidth).tickPadding(6)
            else
              s.axis().tickSize(6)
            s.axis().orient(s.axisOrient())
            a.transition().duration(d3Animation.duration).call(s.axis())
            a.selectAll('.tick').style('pointer-events', 'none')  # avoid fading of tooltip wne hovering over grid lines
            if s.showLabel()
              offs = axisConfig[s.kind()].labelOffset[s.axisOrient()]
              lbl = _getLabel(s.axisOrient())
              txt = lbl.selectAll('.label-text')
              if txt.empty()
                txt = lbl.append('text').attr('class','label-text').attr('dy', (d) -> offs)
              txt.text(s.axisLabel()).attr('text-anchor','middle').style('font-size', axisConfig.labelFontSize)
            else
              _removeLabel(s.axisOrient())
          if s.axisOrientOld() and s.axisOrientOld() isnt s.axisOrient()
            me.removeAxis(s.axisOrientOld())
            _removeLabel(s.axisOrientOld())

    me.removeAxis = (orient) ->
      _removeAxis(orient)
      _removeLabel(orient)


    me.draw = (data, doNotAnimate) ->
      _data = data
      #$log.log 'Drawing container Layout', me.id()
      for l in _layouts
        l.draw(data, doNotAnimate)
      return me

    me.brushed = (s) ->
      if s.showAxis()
        a = _spacedContainer.select(".axis.#{s.axis().orient()}")
        if s.isHorizontal()
          s.range([0, _innerWidth], true)
        if s.isVertical()
          s.range([_innerHeight, 0], true)
        if s.showGrid()
          s.axis().tickSize(if s.isHorizontal() then -_innerHeight else -_innerWidth).tickPadding(6) # required for shared scales!
        a.call(s.axis())
      return me

    angular.element($window).on('resize', () ->
      if _data
        me.sizeContainer()
        me.draw(_data, true) #do not animate when resizing the window
    )

    return me

  return container