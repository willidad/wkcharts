angular.module('wk.chart').factory 'layeredData', ($log) ->

  layered = () ->
    _data = []
    _layerKeys = []
    _x = undefined
    _calcTotal = false
    _min = Infinity
    _max = -Infinity
    _tMin = Infinity
    _tMax = -Infinity

    me = () ->

    me.data = (dat) ->
      if arguments.length Is 0
        return _data
      else
        _data = dat
        return me

    me.layerKeys = (keys) ->
      if arguments.length is 0
        return _layerKeys
      else
        _layerKeys = keys
        return me

    me.x = (name) ->
      if arguments.length is 0
        return _x
      else
        _x = name
        return me

    me.calcTotal = (t_f) ->
      if arguments.length is 0
        return _calcTotal
      else
        _calcTotal = t_f
        return me

    me.min = () ->
      _min

    me.max = () ->
      _max

    me.minTotal = () ->
      _tMin

    me.maxTotal = () ->
      _tMax

    me.extent = () ->
      [me.min(), me.max()]

    me.totalExtent = () ->
      [me.minTotal(), me.maxTotal()]

    me.columns = (data) ->
      if arguments.length is 1
        #_layerKeys.map((k) -> {key:k, values:data.map((d) -> {x: d[_x], value: d[k], data: d} )})
        res = []
        _min = Infinity
        _max = -Infinity
        _tMin = Infinity
        _tMax = -Infinity

        for k, i in _layerKeys
          res[i] = {key:k, value:[], min:Infinity, max:-Infinity}
        for d, i in data
          t = 0
          xv = if typeof _x is 'string' then d[_x] else _x(d)

          for l in res
            v = +d[l.key]
            l.value.push {x:xv, value: v, key:l.key}
            if l.max < v then l.max = v
            if l.min > v then l.min = v
            if _max < v then _max = v
            if _min > v then _min = v
            if _calcTotal then t += +v
          if _calcTotal
            #total.value.push {x:d[_x], value:t, key:total.key}
            if _tMax < t then _tMax = t
            if _tMin > t then _tMin = t
        return {min:_min, max:_max, totalMin:_tMin,totalMax:_tMax, data:res}
      return me



    me.rows = (data) ->
      if arguments.length is 1
        return data.map((d) -> {x: d[_x], layers: layerKeys.map((k) -> {key:k, value: d[k], x:d[_x]})})
      return me


    return me