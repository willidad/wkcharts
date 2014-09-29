angular.module('wk.chart').directive 'geoMap', ($log, utils) ->
  mapCntr = 0

  parseList = (val) ->
    if val
      l = val.trim().replace(/^\[|\]$/g, '').split(',').map((d) -> d.replace(/^[\"|']|[\"|']$/g, ''))
      l = l.map((d) -> if isNaN(d) then d else +d)
      return if l.length is 1 then return l[0] else l

  return {
    restrict: 'A'
    require: 'layout'
    scope: {geojson: '='}

    link: (scope, element, attrs, layout) ->

      _tooltip = () ->
      _scaleList = {}
      _id = 'geoMap' + mapCntr++
      _dataMapping = d3.map()

      #-----------------------------------------------------------------------------------------------------------------

      ttEnter = (data) ->
        $log.log 'tooltip data', data
        val = _dataMapping.get(data.properties.RS)
        @layers.push({name:val.DES, value:val.GEN})


      setTooltip = (tooltip) ->
        _tooltip = tooltip
        _tooltip.on "enter.#{_id}", ttEnter

      #-----------------------------------------------------------------------------------------------------------------

      _path = d3.geo.path()
      _projection = d3.geo.conicConformal()
      _translate = _projection.translate()
      _center = _projection.center()
      _scale = _projection.scale()

      _geoJson = undefined

      draw = (data, options, x, y, color) ->
        if data
          for e in data
            _dataMapping.set(e.RS, e)


        if _geoJson
          _path.projection(_projection)
          pathSel = this.selectAll("path").data(_geoJson.features)
          pathSel
            .enter().append("svg:path")
              .style('fill','lightgrey').style('stroke', 'darkgrey')
              .call(_tooltip)

          pathSel
            .attr("d", _path)
            .style('fill', (d) ->
              val = _dataMapping.get(d.properties.RS)
              color.map(val)
          )

          pathSel.exit().remove()

      #-----------------------------------------------------------------------------------------------------------------

      layout.events().on 'configure', ->
        _scaleList = @getScales(['color'])
        #_scaleList.y.domainCalc('max')
        _scaleList.color.resetOnNewData(true)
        #@layerScale('color')

      layout.events().on 'draw', draw

      layout.events().on 'tooltip', setTooltip

      # GeoMap specific properties -------------------------------------------------------------------------------------

      scope.$watch 'geojson', (val) ->
        if val isnt undefined and val isnt ''
          _geoJson = val
          layout.events().update()


      attrs.$observe 'center', (val) ->
        if val isnt undefined and val isnt ''
          list = parseList(val)
          if Array.isArray(list) and list.length is 2
            _projection.center(list)
            layout.events().redraw()

      attrs.$observe 'scale', (val) ->
        if val isnt undefined and val isnt '' and not isNaN(+val)
          _projection.scale(val)
          layout.events().redraw()

      attrs.$observe 'translate', (val) ->
        if val isnt undefined and val isnt ''
          list = parseList(val)
          if Array.isArray(list) and list.length is 2
            _projection.translate(list)
            layout.events().redraw()
  }