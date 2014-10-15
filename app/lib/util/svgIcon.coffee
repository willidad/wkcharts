angular.module('wk.chart').directive 'svgIcon', ($log) ->
  ## insert svg path into interpolated HTML. Required prevent Angular from throwing error (Fix 22)
  return {
    restrict: 'E'
    template: '<svg style="height:20px; width:{{width}}px;vertical-align:middle;"><path></path></svg>'
    scope:
      path: "="
      width: "@"
    link: (scope, elem, attrs ) ->
      scope.width = 15
      scope.$watch 'path', (val) ->
        if val
          d3.select(elem[0]).select('path').attr('d', val).attr('transform', "translate(8,8)")
  }