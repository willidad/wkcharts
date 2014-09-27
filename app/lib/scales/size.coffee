angular.module('wk.chart').directive 'size', ($log, scale, scaleUtils) ->
  scaleCnt = 0
  return {
    restrict: 'E'
    require: ['size','^chart', '?^layout']
    controller: ($element) ->
      me = scale()
      #$log.log 'creating controller scaleSize'
      return me

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      chart = controllers[1]
      layout = controllers[2]

      if not (chart or layout)
        $log.error 'scale needs to be contained in a chart or layout directive '
        return

      name = 'size'
      me.kind(name)
      me.parent(layout or chart)
      me.scaleType('linear')
      me.resetOnNewData(true)
      element.addClass(me.id())

      chart.addScale(me, layout)

      #$log.log "linking scale #{name} id:", me.id(), 'layout:', (if layout then layout.id() else '') , 'chart:', chart.id()

      #---Directive Attributes handling --------------------------------------------------------------------------------

      scaleUtils.observeSharedAttributes(attrs, me)
      scaleUtils.observeLegendAttributes(attrs, me, layout)
  }