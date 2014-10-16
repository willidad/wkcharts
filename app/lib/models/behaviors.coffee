angular.module('wk.chart').factory 'behavior', ($log, $window, behaviorTooltip, behaviorBrush, behaviorSelect) ->

  behavior = () ->

    _tooltip = behaviorTooltip()
    _brush = behaviorBrush()
    _selection = behaviorSelect()
    _brush.tooltip(_tooltip)

    area = (area) ->
      _brush.area(area)
      _tooltip.area(area)

    container = (container) ->
      _brush.container(container)
      _selection.container(container)
      _tooltip.container(container)

    chart = (chart) ->
      _brush.chart(chart)

    return {tooltip:_tooltip, brush:_brush, selected:_selection, overlay:area, container:container, chart:chart}
  return behavior