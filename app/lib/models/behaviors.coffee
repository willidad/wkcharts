angular.module('wk.chart').factory 'behavior', ($log, $window, behaviorTooltip, behaviorBrush) ->

  behavior = () ->

    _tooltip = behaviorTooltip()
    _brush = behaviorBrush()
    _brush.tooltip(_tooltip)

    area = (area) ->
      _brush.area(area)
      _tooltip.area(area)

    container = (container) ->
      _brush.container(container)

    return {tooltip:_tooltip, brush:_brush, overlay:area, container:container}
  return behavior