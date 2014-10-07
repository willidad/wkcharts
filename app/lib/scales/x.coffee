angular.module('wk.chart').directive 'x', ($log, scale, scaleUtils) ->
  scaleCnt = 0
  return {
    restrict: 'E'
    require: ['x','^chart', '?^layout']
    controller: ($element) ->
      me = scale()
      #$log.log 'creating controller scaleX'
      return me

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      chart = controllers[1]
      layout = controllers[2]

      if not (chart or layout)
        $log.error 'scale needs to be contained in a chart or layout directive '
        return

      name = 'x'
      me.kind(name)
      me.parent(layout or chart)
      me.chart(chart)
      me.scaleType('linear')
      me.resetOnNewData(true)
      me.isHorizontal(true)
      me.register()
      element.addClass(me.id())

      chart.addScale(me, layout)

      #$log.log "linking scale #{name} id:", me.id(), 'layout:', (if layout then layout.id() else '') , 'chart:', chart.id()

      #---Directive Attributes handling --------------------------------------------------------------------------------

      scaleUtils.observeSharedAttributes(attrs, me)

      attrs.$observe 'axis', (val) ->
        if val isnt undefined
          if val isnt 'false'
            if val in ['top', 'bottom']
              me.axisOrient(val).showAxis(true)
            else
              me.axisOrient('bottom').showAxis(true)
          else
            me.showAxis(false).axisOrient(undefined)
          me.update()

      scaleUtils.observeAxisAttributes(attrs, me)

  }