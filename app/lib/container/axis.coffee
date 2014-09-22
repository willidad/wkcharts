angular.module('wk.chart').directive 'aaxis', ($log) ->
  return {
    restrict: 'A'
    require: ['aaxis', '?x', '?y']
    controller: ()->

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      x = controllers[1]
      y = controllers[2]

      owner = x or y
      if not owner
        $log.error 'Axis can only be set for x and y scales'

      $log.log 'linking axis for', owner.id()

      attrs.$observe 'axis', (val) ->
        owner.showAxis(false)
        if val isnt undefined and val isnt 'false'
          if y
            if val in ['left', 'right']
              owner.axisOrient(val).showAxis(true)
            else
              owner.axisOrient('left').showAxis(true)
          if x
            if val in ['top', 'bottom']
              owner.axisOrient(val).showAxis(true)
            else
              owner.axisOrient('bottom').showAxis(true)

      attrs.$observe 'tickFormat', (val) ->
        if val isnt undefined
          owner.axis().tickFormat(d3.format(val))

      attrs.$observe 'ticks', (val) ->
        if val isnt undefined
          owner.axis().ticks(val)

      attrs.$observe 'grid', (val) ->
        if val isnt undefined
          owner.showGrid(val is '' or val is 'true')

      attrs.$observe 'label', (val) ->
        if val isnt undefined and val.length > 0
          owner.axisLabel(val)


  }