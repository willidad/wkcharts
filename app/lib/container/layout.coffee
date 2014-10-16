angular.module('wk.chart').directive 'layout', ($log, layout, container) ->
  layoutCnt = 0
  return {
    restrict: 'AE'
    require: ['layout','^chart']

    controller: ($element) ->
      me = layout()
      return me
    link: (scope, element, attrs, controllers) ->

      me = controllers[0]
      chart = controllers[1]
      me.chart(chart)

      element.addClass(me.id())

      #$log.log 'linking layout id:', me.id(), 'chart:', chart.id()
      chart.addLayout(me)
      chart.container().addLayout(me)
      me.container(chart.container())

  }