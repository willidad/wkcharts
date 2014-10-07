angular.module('wk.chart').directive 'selection', ($log) ->
  objId = 0

  return {
    restrict: 'A'
    require: ['selection', '^chart', 'layout']

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      chart = controllers[1]
      layout = controllers[2]



  }