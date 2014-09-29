angular.module('wk.chart').controller 'Page9Ctrl', ($log, $scope, $interval) ->

  $scope.genList = [{}]


  d3.json 'de_laender.geojson', (de) ->
    $scope.de = de
    $log.log de

    $scope.genList = de.features.map((p) ->
      {RS:p.properties.RS, DES:p.properties.DES, GEN:p.properties.GEN, status: Math.round(Math.random()*20)}
    )
    $scope.$apply()