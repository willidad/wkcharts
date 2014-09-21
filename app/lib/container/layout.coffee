angular.module('wk.chart').directive 'layout', ($log, layout, container) ->
  layoutCnt = 0
  return {
    restrict: 'AE'
    require: ['layout','^chart']

    controller: ($element) ->
      me = layout().id('layout' + layoutCnt++)
      $log.log 'creating controller', me.id()
      return me
    link: (scope, element, attrs, controllers) ->

      me = controllers[0]
      chart = controllers[1]
      me.owner(chart)

      element.addClass(me.id())

      $log.log 'linking layout id:', me.id(), 'chart:', chart.id()
      chart.addLayout(me)

      attrs.$observe 'container', (val) ->
        if val isnt undefined and typeof val is 'string' and val.length > 0
          # the chart is drawn in an specifically assigned div. setup the container and remove the chart from its current container
          $log.log 'separate container assigned for layout', me.id(), 'div', val
          contnr = container().element(val)
          chart.addContainer(contnr)
          contnr.addLayout(me)
          me.container(contnr)
        else
          chart.container().addLayout(me)
          me.container(chart.container())
  }