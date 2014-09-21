angular.module('wk.chart').directive 'axis', ($log) ->
  return {
    restrict: 'A'
    require: ['axis', '?x', '?y']
    controller: ()->

    link: (scope,element,attrs,controllers) ->
      me = controllers[0]
      x = controllers[1]
      y = controllers[2]

      owner = x or y
      if not owner
        $log.error 'Axis can only be set for x and y scales'

      $log.log 'linking axis for', owner.id()

      attrs.$observe 'axis', (val) ->
        if val isnt undefined
          owner.showAxis(true)
          if y
            if val in ['left', 'right']
              owner.axis().orient(val)
            else
              owner.axis().orient('left')

          if x
            if val in ['top', 'bottom']
              owner.axis().orient(val)
            else
              owner.axis().orient('bottom')

          $log.log 'Axis set', owner.id()

      attrs.$observe 'tickFormat', (val) ->
        if val isnt undefined
          owner.axis().tickFormat(d3.format(val))

      attrs.$observe 'ticks', (val) ->
        if val isnt undefined
          owner.axis().ticks(val)

      attrs.$observe 'grid', (val) ->
        if val isnt undefined
          owner.showGrid(val is '' or val is 'true')
          null

      attrs.$observe 'label', (val) ->
        if val isnt undefined and val.length > 0
          owner.axisLabel(val)


  }