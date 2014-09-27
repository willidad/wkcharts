angular.module('wk.chart').controller 'Page7Ctrl', ($log, $scope, $interval) ->

  hpq = intc = msft = googl = []
  $scope.checkModel = [true, true, true]
  combo = []
  d3.csv('hpq.csv', (error, rows) ->
    hpq = rows.map((d) ->
      ds = d.date.split('/')
      d.date = new Date(ds[0], ds[1], ds[2])
      d
    )
    $scope.hpq = hpq = rows.sort((a,b) -> a.date - b.date)
    $scope.$apply()
    d3.csv('intc.csv', (error,rows) ->
      intc = rows #.sort((a,b) -> b.date > a.date)
      d3.csv('msft.csv', (error, rows) ->
        msft = rows #.sort((a,b) -> b.date > a.date)
        d3.csv('googl.csv', (error, rows) ->
          googl = rows #.sort((a,b) -> b.date > a.date)

          $scope.combo = d3.zip(hpq,intc, msft).map((d) -> {date:d[0].date, hpq:d[0], intc:d[1], msft:d[2]})
          #$log.log $scope.combo
          $scope.$apply()
        )
      )
    )
  )

  $scope.$watch 'checkModel', (val) ->
      $scope.props = ['hpq', 'intc', 'msft'].filter((d, i) -> $scope.checkModel[i])
    ,true