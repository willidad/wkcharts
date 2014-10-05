angular.module('wk.chart').controller 'Page9Ctrl', ($log, $scope, $interval) ->

  loadFile = (geoFile) ->
    d3.json $scope.geoFile, (de) ->
      $scope.de = de
      $log.log de
      $scope.projection = parmList[geoFile]
      $scope.genList = de.features.map((p) ->
        {RS:p.properties[$scope.projection.idMap[0]], DES:p.properties[$scope.projection.geoDesc], status: Math.round(Math.random()*20)}
      )
      $scope.$apply()

  $scope.genList = [{}]

  $scope.fileList = ['world100M.json', 'de_laender.geojson', 'uk.json', 'uk.geojson']
  parmList = {
    'world100M.json': {
      file: 'world100M.json'
      type: 'geoJson'
      projection: 'orthographic'
      center: [0, 0]
      rotate: [0,0]
      parallels: [1,0]
      clipAngle: 90
      scale: 300
      idMap: ['adm0_a3', 'RS']
      geoDesc: 'formal_en'
    }
    'de_laender.geojson' : {
      file: 'de_laender.geojson'
      type: 'geoJson'
      projection: 'mercator'
      center: [10, 51.5]
      rotate: [0,0]
      parallels: [1,0]
      clipAngle: null
      scale: 3000
      idMap: ['RS', 'RS']
      geoDesc: 'GEN'
    }
    'uk.json' : {
      file : 'uk.json'
      type: 'geoJson'
      projection: 'mercator'
      center: [-3, 55]
      rotate: [0,0]
      parallels: [1,0]
      clipAngle: null
      scale: 2000
      idMap: ['RS', 'RS']
      geoDesc: 'GEN'
    }
    'uk.geojson' : {
      file: 'uk.geojson'
      type: 'geoJson'
      projection: 'mercator'
      center: [-5, 56]
      rotate: [0,0]
      parallels: [1,0]
      clipAngle: null
      scale: 1800
      idMap: ['brk_a3', 'RS']
      geoDesc: 'geounit'
    }
  }
  $scope.geoFile = $scope.fileList[0]
  loadFile($scope.geoFile)

  $scope.fileChanged = (val) ->
    $log.log 'geofile loaded', $scope.geoFile
    loadFile($scope.geoFile)

