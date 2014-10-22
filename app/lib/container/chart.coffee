angular.module('wk.chart').directive 'chart', ($log, chart, container) ->
  chartCnt = 0
  return {
    restrict: 'E'
    require: 'chart'
    scope:
      data: '='
    controller: () ->
      this.me = chart()

    link: (scope, element, attrs, controller) ->
      me = controller.me

      deepWatch = false
      watcherRemoveFn = undefined
      element.addClass(me.id())

      me.container().element(element[0])

      me.lifeCycle().configure()

      attrs.$observe 'tooltips', (val) ->
        if val isnt undefined and (val is '' or val is 'true')
          me.showTooltip(true)
        else
          me.showTooltip(false)

      attrs.$observe 'animationDuration', (val) ->
        if val and _.isNumber(+val) and +val >= 0
          me.animationDuration(val)

      attrs.$observe 'deepWatch', (val) ->
        if val isnt undefined and val isnt 'false'
          deepWatch = true
        else
          deepWatch = false
        if watcherRemoveFn
          watcherRemoveFn()

        watcherRemoveFn = scope.$watch 'data', (val) ->
          if val
            me.lifeCycle().newData(val)
        , deepWatch
  }