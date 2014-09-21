angular.module('app').controller 'Page6Ctrl', ($log, $scope, $interval) ->

  hpq = intc = msft = googl = []
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
          $log.log $scope.combo
          $scope.$apply()
        )
      )
    )
  )

  d3.tsv('temperature.tsv', (error, rows) ->
    $scope.temperature = rows
    $scope.$apply()
  )

  d3.tsv('ageGroups.csv', (error, rows) ->
    $scope.ageGroups = rows
    $scope.layerKeys = Object.keys(rows[0]).filter((d) -> d isnt 'State')
    $scope.$apply()
  )