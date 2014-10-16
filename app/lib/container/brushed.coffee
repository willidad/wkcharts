angular.module('wk.chart').directive 'brushed', ($log,selectionSharing) ->
  sBrushCnt = 0
  return {
    restrict: 'A'
    require: ['^chart', '?^layout', 'x']
    link: (scope, element, attrs, controllers) ->
      chart = controllers[0]
      layout = controllers[1]
      x = controllers[2]

      _brushGroup = undefined

      brusher = (extent) ->
        x.scale().domain(extent)
        for l in chart.layouts() when l.scales().hasScale(x) #TODO Need a better way using events
          l.container().brushed(x)
          l.redraw(true)

      attrs.$observe 'brushed', (val) ->
        if _.isString(val) and val.length > 0
          _brushGroup = val
          selectionSharing.register _brushGroup, brusher
        else
          _brushGroup = undefined
          #selectionSharing.register _brushGroup, brusher

  }