angular.module('wk.chart').controller 'Page9Ctrl', ($log, $scope, $interval) ->

  loadFile = (geoFile) ->
    d3.json $scope.geoFile, (de) ->
      $scope.de = de
      $log.log de

      $scope.genList = de.features.map((p) ->
        {RS:p.properties[$scope.idMap[0]], DES:p.properties[$scope.geoDesc], status: Math.round(Math.random()*20)}
      )
      $scope.$apply()

  $scope.genList = [{}]
  $scope.idMap = ['adm0_a3', 'RS']
  $scope.geoDesc = 'formal_en'
  $scope.fileList = ['world100M.json', 'de_laender.geojson', 'uk.json']
  $scope.geoFile = $scope.fileList[0]

  loadFile($scope.geoFile)
  $scope.fileChanged = (val) ->
    $log.log 'geofile loaded', $scope.geoFile
    loadFile($scope.geoFile)
