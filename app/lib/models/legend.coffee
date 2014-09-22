angular.module('wk.chart').factory 'legend', ($log, $compile, $rootScope, $templateCache, templateDir) ->

  legend = () ->

    _position = 'top-right'
    _scale = undefined
    _templatePath = undefined
    _legendScope = $rootScope.$new(true)
    _template = undefined
    _parsedTemplate = undefined
    _containerDiv = undefined
    _legendDiv = undefined
    _label = undefined
    _layout = undefined
    _data = undefined
    _options = undefined
    _show = false

    me = {}

    me.position = (pos) ->
      if arguments.length is 0 then return _position
      else
        _position = pos
        return me

    me.show = (val) ->
      if arguments.length is 0 then return _show
      else
        _show = val
        return me #to enable chaining

    me.div = (selection) ->
      if arguments.length is 0 then return _legendDiv
      else
        _legendDiv = selection
        return me

    me.layout = (layout) ->
      if arguments.length is 0 then return _layout
      else
        _layout = layout
        return me

    me.scale = (scale) ->
      if arguments.length is 0 then return _scale
      else
        _scale = scale
        return me

    me.label = (label) ->
      if arguments.length is 0 then return _label
      else
        _label = label
        return me

    me.template = (path) ->
      if arguments.length is 0 then return _templatePath
      else
        _templatePath = path
        _template = $templateCache.get(_templatePath)
        _parsedTemplate = $compile(_template)(_legendScope)
        return me

    me.draw = (data, options) ->
      _data = data
      _options = options
      #$log.info 'drawing Legend'
      _containerDiv = _legendDiv or d3.select(me.scale().parent().container().element()).select('.d3-chart')
      if me.show()
        if _containerDiv.select('.d3ChartColorLegend').empty()
          angular.element(_containerDiv.node()).append(_parsedTemplate)

        layers = _scale.layerKeys(data)
        s = _scale.scale()
        if me.layout()?.scales().layerScale()
          s = me.layout().scales().layerScale().scale()
        _legendScope.legendRows = layers.map((d) -> {value:d, color:{'background-color':s(d)}})
        _legendScope.showLegend = true
        _legendScope.position = {
          position:'absolute'
        }
        if not _legendDiv
          for p in _position.split('-')
            _legendScope.position[p] = "#{options.margins[p]}px"
        _legendScope.label = _label
      else
        _parsedTemplate.remove()
      return me

    me.register = (layout) ->
      layout.events().on 'draw.legend', me.draw
      return me

    me.template(templateDir + 'colorLegend.jade')

    me.redraw = () ->
      if _data and _options
        me.draw(_data, _options)
      return me

    return me

  return legend