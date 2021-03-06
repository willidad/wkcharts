angular.module('wk.chart').directive 'color', ($log, scale, legend, scaleUtils) ->
  scaleCnt = 0
  return {
    restrict: 'E'
    require: ['color','^chart', '?^layout']
    controller: ($element) ->
      me = scale()
      #$log.log 'creating controller scaleColor'
      return me

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      chart = controllers[1]
      layout = controllers[2]
      l = undefined

      if not (chart or layout)
        $log.error 'scale needs to be contained in a chart or layout directive '
        return

      name = 'color'
      me.kind(name)
      me.parent(layout or chart)
      me.chart(chart)
      me.scaleType('category20')
      element.addClass(me.id())

      chart.addScale(me, layout)
      me.register()

      #$log.log "linking scale #{name} id:", me.id(), 'layout:', (if layout then layout.id() else '') , 'chart:', chart.id()

      #---Directive Attributes handling --------------------------------------------------------------------------------

      scaleUtils.observeSharedAttributes(attrs, me)
      scaleUtils.observeLegendAttributes(attrs, me, layout)

  }