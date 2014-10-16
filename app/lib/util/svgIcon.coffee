angular.module('wk.chart').directive 'svgIcon', ($log) ->
  ## insert svg path into interpolated HTML. Required prevent Angular from throwing error (Fix 22)
  return {
    restrict: 'E'
    template: '<svg ng-style="style"><path></path></svg>'
    scope:
      path: "="
      width: "@"
    link: (scope, elem, attrs ) ->
      scope.style = {  # fix IE problem with interpolating style values
        height: '20px'
        width: scope.width + 'px'
        'vertical-align': 'middle'
      }
      scope.$watch 'path', (val) ->
        if val
          d3.select(elem[0]).select('path').attr('d', val).attr('transform', "translate(8,8)")
  }