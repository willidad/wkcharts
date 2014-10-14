angular.module('wk.chart').directive 'brush', ($log, selectionSharing, behavior) ->
  return {
    restrict: 'A'
    require: ['^chart', '^layout', '?x', '?y']
    scope:
      brushExtent: '='
      brushChange: '&'

    link:(scope, element, attrs, controllers) ->
      chart = controllers[0]
      layout = controllers[1]
      x = controllers[2]
      y = controllers[3]
      xScale = undefined
      yScale = undefined
      _selectables = undefined
      _brushAreaSelection = undefined
      _isAreaBrush = not x and not y
      _brushGroup = undefined

      layout.isBrush(true)
      brush = chart.behavior().brush
      if not x and not y
        #layout brush, get x and y from layout scales
        scales = layout.scales().getScales(['x', 'y'])
        brush.x(scales.x)
        brush.y(scales.y)
      else
        brush.x(x)
        brush.y(y)
      brush.active(true)

      layout.lifeCycle().on 'draw.brush', (data) ->
        brush.data(data)

      ###
      overlay = layout.container().getOverlay()

      brushed = () ->
        if not brush.empty()

          if axis.isOrdinal()
            startIdx = axis.invert(brush.extent()[0])
            endIdx = axis.invert(brush.extent()[1])
            domain = axis.scale().domain()
            extent = domain.slice(startIdx, endIdx + 1)
            selectionSharing.setSelection extent, _brushGroup
          else
            selectionSharing.setSelection brush.extent(), _brushGroup

      brushEnd = () ->
        if not brush.empty()

          lower = axis.invert(brush.extent()[if axis.isHorizontal() then 0 else 1])
          upper = axis.invert(brush.extent()[if axis.isHorizontal() then 1 else 0])
          idxRange = [lower, upper]
          valRange = [axis.value(chart.getData()[lower]), axis.value(chart.getData()[upper])]
          scope.brushChange({extent:valRange, range:idxRange})
          scope.$apply()

      areaBrushed = () ->
        # scan all nodes to determine if they are in the selected area
        br = _brushAreaSelection.node().getBoundingClientRect()
        _selectables # = chart.container().getChartArea().selectAll('.selectable')
        .each((d) ->
          cr = this.getBoundingClientRect()
          xHit = br.left < cr.right - cr.width / 3 and cr.left + cr.width / 3 < br.right
          yHit = br.top < cr.bottom - cr.height / 3 and cr.top + cr.height / 3 < br.bottom
          d3.select(this).classed('selected', yHit and xHit)
        )

      areaBrushEnd = () ->
        # scan all nodes to determine if they are in the selected area
        br = _brushAreaSelection.node().getBoundingClientRect()
        _selectables # = chart.container().getChartArea().selectAll('.selectable')
          .each((d) ->
            cr = this.getBoundingClientRect()
            xHit = br.left < cr.right - cr.width / 3 and cr.left + cr.width / 3 < br.right
            yHit = br.top < cr.bottom - cr.height / 3 and cr.top + cr.height / 3 < br.bottom
            d3.select(this).classed('selected', yHit and xHit)
        )

      draw = (data, options, x, y) ->
        xScale = x
        yScale = y
        if not _isAreaBrush
          brush = if axis.isHorizontal() then brush.x(axis.scale()) else brush.y(axis.scale())
          brush
            .extent(if axis.isOrdinal() then axis.scale().rangeExtent() else axis.scale().domain())
            .on('brush', brushed)
            .on('brushend', brushEnd)
        else
          brush
            .x(x.scale())
            .y(y.scale())
            .on('brush', areaBrushed)
            .on('brushend', areaBrushEnd)

        bs = this.call(brush)
        if not _isAreaBrush
          bs.selectAll('rect')
            .attr(if axis.isHorizontal() then {height: options.height} else {width: options.width})
          bs.selectAll('.resize rect')
            .style('visibility','visible')

        _selectables = chart.container().getChartArea().selectAll('.selectable')
        _brushAreaSelection = chart.container().getBrushArea().select('.extent')

      #layout.onDrawBrush(draw) #todo Switch to eventhandler
      ###
      attrs.$observe 'brush', (val) ->
        if _.isString(val) and val.length > 0
          _brushGroup = val
          brush.brushGroup(val)
        else
          _brushGroup = undefined
          brush.brushGroup(undefined)
  }