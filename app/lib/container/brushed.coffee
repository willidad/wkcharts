angular.module('wk.chart').directive 'brushed', ($log,selectionSharing, timing) ->
  sBrushCnt = 0
  return {
    restrict: 'A'
    require: ['^chart', '?^layout', '?x', '?y']
    link: (scope, element, attrs, controllers) ->
      chart = controllers[0]
      layout = controllers[1]
      x = controllers[2]
      y = controllers[3]

      axis = x or y
      _brushGroup = undefined

      brusher = (extent) ->
        timing.start("brusher#{axis.id()}")
        if not axis then return
        #axis
        axis.domain(extent).scale().domain(extent)
        for l in chart.layouts() when l.scales().hasScale(axis) #need to do it this way to ensure the right axis is chosen in case of several layouts in a container
          l.lifeCycle().brush(axis, true) #no animation
        timing.stop("brusher#{axis.id()}")

      attrs.$observe 'brushed', (val) ->
        if _.isString(val) and val.length > 0
          _brushGroup = val
          selectionSharing.register _brushGroup, brusher
        else
          _brushGroup = undefined

      scope.$on '$destroy', () ->
        selectionSharing.unregister _brushGroup, brusher

  }