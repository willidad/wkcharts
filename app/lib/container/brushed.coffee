angular.module('wk.chart').directive 'brushed', ($log) ->
  sBrushCnt = 0
  return {
    restrict: 'A'
    require: ['^chart', '?^layout', 'x']
    link: (scope, element, attrs, controllers) ->
      chart = controllers[0]
      layout = controllers[1]
      x = controllers[2]

      chart.brush().on "change.#{sBrushCnt++}", (extent) ->
        x.scale().domain(extent)
        for l in chart.layouts() when l.scales().hasScale(x)
          l.container().brushed(x)
          l.redraw(true)
  }