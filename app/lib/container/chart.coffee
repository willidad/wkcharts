angular.module('wk.chart').directive 'chart', ($log, chart, container) ->
  chartCnt = 0
  return {
    restrict: 'E'
    require: 'chart'
    scope:
      data: '='
    controller: ($element) ->
      me = chart().id("chart#{chartCnt++}")
      #$log.log 'creating controller', me.id()
      return me

    link: (scope, element, attrs, controller) ->
      me = controller

      deepWatch = false
      dataWatcher = undefined
      element.addClass(me.id())

      #$log.log 'linking chart id:', me.id()

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
        else
          deepWatch = false
        if dataWatcher
          dataWatcher()
        dataWatcher = scope.$watch 'data', (val) ->
          if val
            #$log.log 'data changed, chart id:', me.id()
            me.execLifeCycleFull(val)
            #me.draw(val)
        , deepWatch
  }