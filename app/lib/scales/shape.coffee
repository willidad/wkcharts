angular.module('wk.chart').directive 'shape', ($log, scale, d3Shapes, scaleUtils) ->
  scaleCnt = 0
  return {
    restrict: 'E'
    require: ['shape','^chart', '?^layout']
    controller: ($element) ->
      this.me = scale()
      #$log.log 'creating controller scaleSize'

    link: (scope, element, attrs, controllers) ->
      me = controllers[0].me
      chart = controllers[1].me
      layout = controllers[2]?.me

      if not (chart or layout)
        $log.error 'scale needs to be contained in a chart or layout directive '
        return

      name = 'shape'
      me.kind(name)
      me.parent(layout or chart)
      me.chart(chart)
      me.scaleType('ordinal')
      me.scale().range(d3Shapes)
      element.addClass(me.id())

      chart.addScale(me, layout)
      me.register()

      #$log.log "linking scale #{name} id:", me.id(), 'layout:', (if layout then layout.id() else '') , 'chart:', chart.id()

      #---Directive Attributes handling --------------------------------------------------------------------------------

      scaleUtils.observeSharedAttributes(attrs, me)
      scaleUtils.observeLegendAttributes(attrs, me, layout)
  }