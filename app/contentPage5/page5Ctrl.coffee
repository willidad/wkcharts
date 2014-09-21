angular.module('wk.chart').controller 'Page5Ctrl', ($log, $scope, $interval) ->

  hpq = intc = msft = googl = []
  combo = []
  d3.csv('hpq.csv', (error, rows) ->
    $scope.hpq = hpq = rows
    $scope.$apply()
    d3.csv('intc.csv', (error,rows) ->
      intc = rows
      d3.csv('msft.csv', (error, rows) ->
        msft = rows
        d3.csv('googl.csv', (error, rows) ->
          googl = rows

          $scope.combo = d3.zip(hpq,intc, msft).map((d) -> {date:d[0].date, hpq:d[0], intc:d[1], msft:d[2]})
          $log.log $scope.combo
          $scope.$apply()
        )
      )
    )
  )