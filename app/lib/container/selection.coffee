angular.module('wk.chart').directive 'selection', ($log) ->
  objId = 0

  return {
    restrict: 'A'
    scope:
      selectedDomain: '='
    require: 'layout'

    link: (scope, element, attrs, layout) ->

      layout.lifeCycle().on 'configure.selection', ->

        _selection = layout.behavior().selected
        _selection.active(true)
        _selection.on 'selected', (selectedObjects) ->
          scope.selectedDomain = selectedObjects
          scope.$apply()

  }