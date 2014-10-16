angular.module('wk.chart').directive 'y', ($log, scale, legend, scaleUtils) ->
  scaleCnt = 0
  return {
    restrict: 'E'
    require: ['y','^chart', '?^layout']
    controller: ($element) ->
      me = scale()
      #$log.log 'creating controller scaleY'
      return me

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      chart = controllers[1]
      layout = controllers[2]

      if not (chart or layout)
        $log.error 'scale needs to be contained in a chart or layout directive '
        return

      name = 'y'
      me.kind(name)
      me.parent(layout or chart)
      me.chart(chart)
      me.scaleType('linear')
      me.isVertical(true)
      me.resetOnNewData(true)
      element.addClass(me.id())

      chart.addScale(me, layout)
      me.register()
      #$log.log "linking scale #{name} id:", me.id(), 'layout:', (if layout then layout.id() else '') , 'chart:', chart.id()

      #---Directive Attributes handling --------------------------------------------------------------------------------

      scaleUtils.observeSharedAttributes(attrs, me)

      attrs.$observe 'axis', (val) ->
        if val isnt undefined
          if val isnt 'false'
            if val in ['left', 'right']
              me.axisOrient(val).showAxis(true)
            else
              me.axisOrient('left').showAxis(true)
          else
            me.showAxis(false).axisOrient(undefined)
          me.update(true)

      scaleUtils.observeAxisAttributes(attrs, me)
      scaleUtils.observeLegendAttributes(attrs, me, layout)
  }