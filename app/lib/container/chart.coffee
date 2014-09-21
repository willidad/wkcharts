angular.module('wk.chart').directive 'chart', ($log, chart, container) ->
  chartCnt = 0
  return {
    restrict: 'E'
    require: 'chart'
    scope:
      data: '='
    controller: ($element) ->
      me = chart().id("chart#{chartCnt++}")
      me.container(container())
      me.addContainer(me.container())
      $log.log 'creating controller', me.id()
      return me

    link: (scope, element, attrs, controller) ->
      me = controller

      deepWatch = false
      element.addClass(me.id())

      $log.log 'linking chart id:', me.id()

      me.container().element(element[0])

      me.events().configure()

      attrs.$observe 'tooltips', (val) ->
        if val isnt undefined and (val is '' or val is 'true')
          me.showTooltip(true)
        else
          me.showTooltip(false)

      attrs.$observe 'deepWatch', (val) ->
        if val isnt undefined and val isnt 'false'
          deepWatch = true

      scope.$watch 'data', (val) ->
        if val
          $log.log 'data changed, chart id:', me.id()
          me.draw(val)
      , deepWatch

  }