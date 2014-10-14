angular.module('wk.chart').controller 'Page11Ctrl', ($log, $scope, $interval) ->

  tempData =
    {
      Months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
      Tokyo: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
      'New York': [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
      Berlin: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
      London: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
    }

  keys = Object.keys(tempData)

  $scope.tempData = tempData.Months.map(
    (d,i) ->
      r = {}
      keys.map((k) -> r[k] = tempData[k][i])
      return r
  )

  shapes = ['circle', 'cross', 'triangle-up', 'triangle-down', 'diamond', 'square']
  random = d3.random.normal()
  randomData= (groups, points) ->
    data = []
    for j in [0..points - 1]
      data.push({
        x: random()
      , y: random()
      , group: Math.floor(Math.random() * 10)
      , size: Math.random()   #Configure the size of each scatter point
      , shape: shapes[Math.floor(Math.random() * shapes.length - 1)]   #Configure the shape of each scatter point.
      })
    return data

  $scope.range = [20,400]

  $scope.scatterData = randomData(5,50)