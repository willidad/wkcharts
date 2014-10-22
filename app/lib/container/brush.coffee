angular.module('wk.chart').directive 'brush', ($log, selectionSharing, behavior) ->
  return {
    restrict: 'A'
    require: ['^chart', '^layout', '?x', '?y']
    scope:
      brushExtent: '='
      selectedValues: '='
      selectedDomain: '='
      change: '&'

    link:(scope, element, attrs, controllers) ->
      chart = controllers[0].me
      layout = controllers[1]?.me
      x = controllers[2]?.me
      y = controllers[3]?.me
      xScale = undefined
      yScale = undefined
      _selectables = undefined
      _brushAreaSelection = undefined
      _isAreaBrush = not x and not y
      _brushGroup = undefined

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

      brush.events().on 'brush', (idxRange, valueRange, domain) ->
        if attrs.brushExtent
          scope.brushExtent = idxRange
        if attrs.selectedValues
          scope.selectedValues = valueRange
        if attrs.selectedDomain
          scope.selectedDomain = domain
        scope.$apply()

      layout.lifeCycle().on 'draw.brush', (data) ->
        brush.data(data)


      attrs.$observe 'brush', (val) ->
        if _.isString(val) and val.length > 0
          brush.brushGroup(val)
        else
          brush.brushGroup(undefined)
  }