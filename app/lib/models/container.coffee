angular.module('wk.chart').factory 'container', ($log, $window, d3ChartMargins, scaleList, axisConfig, d3Animation, tooltip) ->

  containerCnt = 0

  container = () ->

    _containerId = 'cntnr' + containerCnt++

    _element = undefined
    _elementSelection = undefined
    _layouts = []
    _legends = []
    _svg = undefined
    _container = undefined
    _spacedContainer = undefined
    _chartArea = undefined
    _margin = angular.copy(d3ChartMargins.default)
    _innerWidth = 0
    _innerHeight = 0
    _data = undefined
    _overlay = undefined
    _tooltip = tooltip()

    me = ()->

    me.id = () ->
      return _containerId

    _genChart = ()->
      _svg = _elementSelection.append('div').attr('class', 'd3-chart')
        .append('svg')
      _svg.append('defs').append('clipPath').attr('id', "clip-#{_containerId}").append('rect')
      _container= _svg.append('g').attr('class','d3-chart-container')
      _container.append('g').attr('class', 'x axis top')
      _container.append('g').attr('class', 'x axis bottom')
      _container.append('g').attr('class', 'y axis left')
      _container.append('g').attr('class', 'y axis right')
      _container.append('g').attr('class', 'x label top')
      _container.append('g').attr('class', 'x label bottom')
      _container.append('g').attr('class', 'y label left')
      _container.append('g').attr('class', 'y label right')
      _chartArea = _container.append('g').attr('class', 'chartArea')
      _overlay= _chartArea.append('rect').attr('class', 'overlay').style({opacity: 0, 'pointer-events': 'none'})
      _container.append('g').attr('class', 'brushArea')
      #_tooltip.behavior(_overlay)

    me.addLayout = (layout) ->
      _layouts.push(layout)
      return me

    me.addLegend = (legend) ->
      _legends.push(legend)
      return me

    me.sizeContainer = () ->
      #collect axis and label information about layouts registered with container
      $log.log 'sizing container. Owner:', me.id()
      _margin = angular.copy(d3ChartMargins.default)
      for l in _layouts
        for k, s of l.scales().allKinds()  # shared scales will be hit multiple times. ist this a problem?
          $log.log ' scaling:', s.id(), s.showAxis(), s.axisOrient()
          if s.showAxis()
            axisPos = s.axisOrient()
            _margin[axisPos] = d3ChartMargins.axis[axisPos]
            if s.axisLabel()
              _margin[axisPos] += d3ChartMargins.label[axisPos]
      #$log.debug _margin

      bounds = _elementSelection.node().getBoundingClientRect()
      _innerWidth = bounds.width - _margin.left - _margin.right
      _innerHeight = bounds.height - _margin.top - _margin.bottom
      _svg.select("#clip-#{_containerId} rect").attr('width', _innerWidth).attr('height', _innerHeight)
      _spacedContainer = _container.attr('transform', (d) -> "translate(#{_margin.left}, #{_margin.top})")
      _spacedContainer.select('.bottom').attr('transform', (d) -> "translate(0, #{_innerHeight})")
      _spacedContainer.select('.right').attr('transform', (d) -> "translate(#{_innerWidth}, 0)")
      _spacedContainer.select('.chartArea').style('clip-path', "url(#clip-#{_containerId})")
      _spacedContainer.select('.x.label.top').attr('transform', (d) -> "translate(#{_innerWidth/2}, #{-_margin.top})")
      _spacedContainer.select('.x.label.bottom').attr('transform', (d) -> "translate(#{_innerWidth/2},#{_innerHeight+_margin.bottom})")
      _spacedContainer.select('.y.label.left').attr('transform', (d) -> "translate(#{-_margin.left},#{_innerHeight/2})rotate(-90)")
      _spacedContainer.select('.y.label.right').attr('transform', (d) ->"translate(#{_innerWidth+_margin.right},#{_innerHeight/2})rotate(90)")
      _overlay = _spacedContainer.select('.overlay').attr('width', _innerWidth).attr('height', _innerHeight)
      return me

    me.element = (elem) ->
      if arguments.length is 0 then return _element
      else
        _element = elem
        _elementSelection = d3.select(_element)
        if _elementSelection.empty()
          $log.error "Error: Element #{_element} does not exist"
        else
          _genChart()
        return me

    me.height = () ->
      return _innerHeight

    me.margins = () ->
      return _margin

    me.getChartArea = () ->
      return _spacedContainer.select('.chartArea')

    me.getContainer = () ->
      return _spacedContainer

    me.prepData = (data) ->
      for l in _layouts
        props = l.scaleProperties()
        for k, s of l.scales().getOwned()
          s.layerExclude(props)
          if s.resetOnNewData()
            s.scale().domain(s.getDomain(data))
        l.prepareData(data)

    me.setTooltip = (trueFalse) ->
      for l in _layouts
        if not l.isBrush() and trueFalse
          _overlay.style('pointer-events', 'auto')
          _tooltip.active(true)
          l.setTooltip(_tooltip, _overlay)
        else
          _overlay.style('pinter-events', 'none')
          _tooltip.active(false)

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
            a = _spacedContainer.select(".axis.#{s.axisOrient()}")
            if s.showGrid()
              s.axis().tickSize(if s.isHorizontal() then -_innerHeight else -_innerWidth).tickPadding(6)
            else
              s.axis().tickSize(6)
            s.axis().orient(s.axisOrient())
            a.transition().duration(d3Animation.duration).call(s.axis())
            $log.warn 'drawing axis', ".axis.#{s.axisOrient()}", s.axis().orient()
            if s.axisLabel()
              offs = axisConfig[s.kind()].labelOffset[s.axisOrient()]
              ls = _spacedContainer.select(".label.#{s.axisOrient()}").selectAll('.label-text').data([s.axisLabel()])
              ls.enter().append('text').attr('class','label-text').attr('dy', (d) -> offs)
              ls.text((d) -> d).attr('text-anchor','middle').style('font-size', axisConfig.labelFontSize)
              ls.exit().remove()
          else
            if s.axisOrient()
              a = _spacedContainer.select(".axis.#{s.axisOrient()}")
              a.selectAll('.tick').remove()
              a.selectAll('.domain').remove()
              l = _spacedContainer.select(".label.#{s.axisOrient()}").selectAll('.label-text').remove()


    me.draw = (data, doNotAnimate) ->
      _data = data
      $log.log 'Drawing container Layout', me.id()
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