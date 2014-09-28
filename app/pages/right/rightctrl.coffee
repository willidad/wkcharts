angular.module 'app'
  .controller 'RightCtrl', ($log, $scope, $interval) ->

    data = {
      label: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U',
              'V', 'W', 'X', 'Y', 'Z'],
      frequency: [.08167, .01492, .02782, .04253, .12702, .02288, .02015, .06094, .06966, .00153, .00772, .04025,
                  .02406, .06749, .07507, .01929, .00095, .05987, .06327, .09056, .02758, .00978, .02360, .00150,
                  .01974, .00074]
    }

    $scope.data = []

    for l, i in data.label
      $scope.data.push({label:l, frequency:data.frequency[i]})

    $scope.title = 'Chart Test'

    $scope.pieData = JSON.parse('[{"age":"<5","population":2704659},{"age":"5-13","population":4499890},{"age":"14-17","population":2159981},{"age":"18-24","population":3853788},{"age":"25-44","population":14106543},{"age":"45-64","population":8819342},{"age":"≥65","population":612463}]')
    $scope.pieData.forEach((d)-> d.selected = true)
    $scope.selData  = $scope.pieData.filter((d) -> d.selected)
    ###
    $interval(() ->
      i = Math.floor(Math.random() * ($scope.pieData.length - 1))
      old = $scope.pieData[i].population
      $scope.pieData[i].population *= Math.random()
      #$log.debug 'pie change', i, old, $scope.pieData[i].population
    , 1200,20)
###

    $scope.selChange = () ->
      $scope.selData  = $scope.pieData.filter((d) -> d.selected).map((d) -> {age:d.age, population:d.population})