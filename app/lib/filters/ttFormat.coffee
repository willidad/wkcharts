angular.module('wk.chart').filter 'ttFormat', ($log,formatDefaults) ->
  return (value, format) ->
    if typeof value is 'object' and value.getUTCDate
      df = d3.time.format(formatDefaults.date)
      return df(value)
    if typeof value is 'number' or not isNaN(+value)
      df = d3.format(formatDefaults.number)
      return df(+value)
    return value