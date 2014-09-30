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
    scope: {
      geojson: '='
      projection: '='
    }

    link: (scope, element, attrs, layout) ->

      _tooltip = () ->
      _scaleList = {}
      _id = 'geoMap' + mapCntr++
      _dataMapping = d3.map()
      _projectionParms = {
        projection: 'mercator'
        scale:150
        clipAngle: 90
        center: [0,0]
        rotate: [0,0]
        translate: [0,0]
      }
      _idProp = ''

      #-----------------------------------------------------------------------------------------------------------------

      ttEnter = (data) ->

        val = _dataMapping.get(data.properties[_idProp[0]])
        @layers.push({name:val.RS, value:val.DES})
        $log.log 'tooltip data', data, val

      setTooltip = (tooltip) ->
        _tooltip = tooltip
        _tooltip.on "enter.#{_id}", ttEnter

      #-----------------------------------------------------------------------------------------------------------------

      _path = d3.geo.path()
      _projection = d3.geo.orthographic()

      _geoJson = undefined

      draw = (data, options, x, y, color) ->
        if data and data[0].hasOwnProperty(_idProp[1])
          for e in data
            _dataMapping.set(e[_idProp[1]], e)


        if _geoJson
          _projection.translate([options.width/2, options.height/2])
          _path.projection(_projection)
          pathSel = this.selectAll("path").data(_geoJson.features)
          pathSel
            .enter().append("svg:path")
              .style('fill','lightgrey').style('stroke', 'darkgrey')
              .call(_tooltip)

          pathSel
            .attr("d", _path)
            .style('fill', (d) ->
              val = _dataMapping.get(d.properties[_idProp[0]])
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

      scope.$watch 'projection', (val) ->
        if val isnt undefined
          $log.log 'setting Projection params', val
          if d3.geo.hasOwnProperty(val.projection)
            _projection = d3.geo[val.projection]()
            _projection.center(val.center).scale(val.scale).rotate(val.rotate).clipAngle(val.clipAngle)
            if _projection.parallels
              _projection.parallels(val.parallels)
            layout.events().redraw()
      , true #deep watch

      attrs.$observe 'idMap', (val) ->
        if val isnt undefined
          list = parseList(val)
          if Array.isArray(list) and list.length is 2
            _idProp = list

  }