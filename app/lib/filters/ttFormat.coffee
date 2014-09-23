angular.module('wk.chart').filter 'ttFormat', ($log) ->
  return (value) ->
    if typeof value is 'object' and value.getUTCDate
      df = d3.time.format('%d.%m.%Y')
      return df(value)
    if typeof value is 'number' or not isNaN(+value)
      df = d3.format(',')
      return df(+value)
    return value