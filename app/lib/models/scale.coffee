angular.module('wk.chart').factory 'scale', ($log, legend) ->

  scale = () ->
    _id = ''
    _scale = d3.scale.linear()
    _scaleType = 'linear'
    _isOrdinal = false
    _domain = undefined
    _domainCalc = undefined
    _resetOnNewData = false
    _property = ''
    _layerProp = ''
    _layerExclude = []
    _range = undefined
    _rangePadding = 0.1
    _rangeOuterPadding = 0
    _dataFormatString = undefined
    _dataFormatFn = (data) -> if isNaN(+data) then data else +data

    _showAxis = false
    _axisOrient = undefined
    _axis = undefined
    _axisLabel = undefined
    _showGrid = false
    _isHorizontal = false
    _isVertical = false
    _kind = undefined
    _parent = undefined
    _legend = legend()

    me = () ->

    #---- utility functions ----------------------------------------------------------------------------------------

    layerTotal = (d, layerKeys) ->
      layerKeys.reduce(
        (prev, next) -> +prev + +me.layerValue(d,next)
      , 0)

    layerMax = (data, layerKeys) ->
      d3.max(data, (d) -> d3.max(layerKeys, (k) -> me.layerValue(d,k)))

    layerMin = (data, layerKeys) ->
      d3.min(data, (d) -> d3.min(layerKeys, (k) -> me.layerValue(d,k)))

    uniqueValues = (arr) ->
      set = {}
      for e in arr
        set[e] = 0
      return Object.keys(set)

    parsedValue = (v) ->
      if _dataFormatFn.parse then _dataFormatFn.parse(v) else _dataFormatFn(v)

    #-------------------------------------------------------------------------------------------------------------------

    me.id = () ->
      return _kind + '.' + _parent.id()

    me.scale = () ->
      return _scale

    me.kind = (kind) ->
      if arguments.length is 0 then return _kind
      else
        _kind = kind
        return me

    me.parent = (parent) ->
      if arguments.length is 0 then return _parent
      else
        _parent = parent
        return me

    me.legend = () ->
      return _legend

    me.isOrdinal = () ->
      _isOrdinal

    me.isHorizontal = (trueFalse) ->
      if arguments.length is 0 then return _isHorizontal
      else
        _isHorizontal = trueFalse
        if trueFalse
          _isVertical = false

    me.isVertical = (trueFalse) ->
      if arguments.length is 0 then return _isVertical
      else
        _isVertical = trueFalse
        if trueFalse
          _isHorizontal = false

    me.scaleType = (type) ->
      if arguments.length is 0 then return _scaleType
      else
        if d3.scale.hasOwnProperty(type)
          _scale = d3.scale[type]()
          _scaleType = type
        else if type is 'time'
          _scale = d3.time.scale()
          _scaleType = 'time'
          if _dataFormatString
            me.dataFormat(_dataFormatString)
        else
          $log.error 'Error: illegal scale type:', type

        _isOrdinal = _scaleType in ['ordinal', 'category10', 'category20', 'category20b', 'category20c']
        if _range
          me.setRange(_range)

        if _showAxis
          _axis.scale(_scale)
        return me

    me.domain = (dom) ->
      if arguments.length is 0 then return _domain
      else
        _domain = dom
        me.setDomain()
        return me

    me.domainCalc = (rule) ->
      if arguments.length is 0
        return if _isOrdinal then undefined else _domainCalc
      else
        if rule in ['min', 'max', 'extent', 'total', 'totalExtent']
          _domainCalc = rule
        else
          $log.error 'illegal domain calculation rule:', rule, " expected 'min', 'max', 'extent', 'total' or 'totalExtent'"
        me.parent().events().redraw(false)
        return me

    me.getDomain = (data) ->
      if arguments.length is 0 then return _scale.domain()
      else
        switch me.domainCalc()
          when 'extent'
            layerKeys = me.layerKeys(data)
            return [layerMin(data, layerKeys), layerMax(data,layerKeys)]
          when 'max'
            layerKeys = me.layerKeys(data)
            return [0, layerMax(data,layerKeys)]
          when 'totalExtent'
            if data[0].hasOwnProperty('total')
              return d3.extent(data.map((d) -> d.total))
            else
                layerKeys = me.layerKeys(data)
                return d3.extent(data.map((d) -> layerTotal(d, layerKeys)))
          when 'total'
            if data[0].hasOwnProperty('total')
              return [0, d3.max(data.map((d) -> d.total))]
            else
              layerKeys = me.layerKeys(data)
              return [0, d3.max(data.map((d) -> layerTotal(d, layerKeys)))]
          else
            if _domain
              return _domain
            else
              return me.value(data)

    me.range = (range, notAnimated) ->
      if arguments.length is 0 then return _scale.range()
      else
        _range = range
        if _isOrdinal
          _scale.rangeBands(range, _rangePadding, _rangeOuterPadding)
        else
          _scale.range(range)
        me.parent().events().redraw(notAnimated)
        return me

    me.resetOnNewData = (trueFalse) ->
      if arguments.length is 0 then return _resetOnNewData
      else
        _resetOnNewData = trueFalse
        return me

    me.property = (name) ->
      if arguments.length is 0 then return _property
      else
        _property = name
        me.parent().events().update(false)
        return me

    me.layerProperty = (name) ->
      if arguments.length is 0 then return _layerProp
      else
        _layerProp = name
        me.parent().events().update(false)
        return me

    me.layerExclude = (excl) ->
      if arguments.length is 0 then return _layerExclude
      else
        _layerExclude = excl
        return me

    me.layerKeys = (data) ->
      if _property
        if Array.isArray(_property)
          return _property.filter((d) -> !!data[0][d])
        else
          return [_property]
      else
        Object.keys(data[0]).filter((d) -> not (d in _layerExclude))

    me.layers = (data) ->


    me.dataFormat = (format) ->
      if arguments.length is 0 then return _dataFormatString
      else
        _dataFormatString = format
        if _scaleType is 'time'
          _dataFormatFn = d3.time.format(format)
        else
          _dataFormatFn = (d) -> d
        me.parent().events().redraw(false)
        return me()

    me.value = (data) ->
      if _layerProp
        if Array.isArray(data) then data.map((d) -> parsedValue(d[_property][_layerProp])) else parsedValue(data[_property][_layerProp])
      else
        if Array.isArray(data) then data.map((d) -> parsedValue(d[_property])) else parsedValue(data[_property])

    me.layerValue = (data, layerKey) ->
      if _layerProp
        parsedValue(data[layerKey][_layerProp])
      else
        parsedValue(data[layerKey])

    me.map = (data) ->
      if Array.isArray(data) then data.map((d) -> _scale(me.value(data))) else _scale(me.value(data))

    me.showAxis = (trueFalse) ->
      if arguments.length is 0 then return _showAxis
      else
        _showAxis = trueFalse
        if trueFalse
          _axis = d3.svg.axis()
        else
          _axis = undefined
        return me

    me.axisOrient = (val) ->
      if arguments.length is 0 then return _axisOrient
      else
        _axisOrient = val
        return me #to enable chaining

    me.axis = () ->
      return _axis

    me.axisLabel = (text) ->
      if arguments.length is 0 then return _axisLabel
      else
        _axisLabel = text
        return me

    me.showGrid = (trueFalse) ->
      if arguments.length is 0 then return _showGrid
      else
        _showGrid = trueFalse
        return me

    me.update = () ->
      me.parent().events().update()
      return me

    me.drawAxis = () ->
      me.parent().events().drawAxis()
      return me

    return me

  return scale