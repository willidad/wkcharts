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

    link: (scope, element, attrs, controller) ->
      layout = controller.me

      _tooltip = undefined
      _selected = undefined
      _scaleList = {}
      _id = 'geoMap' + mapCntr++
      _dataMapping = d3.map()

      _scale = 1
      _rotate = [0,0]
      _idProp = ''

      #-----------------------------------------------------------------------------------------------------------------

      ttEnter = (data) ->

        val = _dataMapping.get(data.properties[_idProp[0]])
        @layers.push({name:val.RS, value:val.DES})

      #-----------------------------------------------------------------------------------------------------------------
      pathSel = []

      _projection = d3.geo.orthographic()
      _width = 0
      _height = 0
      _path = undefined
      _zoom = d3.geo.zoom()
        .projection(_projection)
        #.scaleExtent([projection.scale() * .7, projection.scale() * 10])
        .on "zoom.redraw", () ->
          d3.event.sourceEvent.preventDefault();
          pathSel.attr("d", _path);

      _geoJson = undefined

      draw = (data, options, x, y, color) ->
        _width = options.width
        _height = options.height
        if data and data[0].hasOwnProperty(_idProp[1])
          for e in data
            _dataMapping.set(e[_idProp[1]], e)

        if _geoJson

          _projection.translate([_width/2, _height/2])
          pathSel = this.selectAll("path").data(_geoJson.features, (d) -> d.properties[_idProp[0]])
          pathSel
            .enter().append("svg:path")
              .style('fill','lightgrey').style('stroke', 'darkgrey')
              .call(_tooltip.tooltip)
              .call(_selected)
              .call(_zoom)

          pathSel
            .attr("d", _path)
            .style('fill', (d) ->
              val = _dataMapping.get(d.properties[_idProp[0]])
              color.map(val)
          )

          pathSel.exit().remove()

      #-----------------------------------------------------------------------------------------------------------------

      layout.lifeCycle().on 'configure', ->
        _scaleList = @getScales(['color'])
        _scaleList.color.resetOnNewData(true)

      layout.lifeCycle().on 'draw', draw
      _tooltip = layout.behavior().tooltip
      _selected = layout.behavior().selected
      _tooltip.on "enter.#{_id}", ttEnter

      # GeoMap specific properties -------------------------------------------------------------------------------------

      scope.$watch 'projection', (val) ->
        if val isnt undefined
          $log.log 'setting Projection params', val
          if d3.geo.hasOwnProperty(val.projection)
            _projection = d3.geo[val.projection]()
            _projection.center(val.center).scale(val.scale).rotate(val.rotate).clipAngle(val.clipAngle)
            _idProp = val.idMap
            if _projection.parallels
              _projection.parallels(val.parallels)
            _scale = _projection.scale()
            _rotate = _projection.rotate()
            _path = d3.geo.path().projection(_projection)
            _zoom.projection(_projection)

            layout.lifeCycle().update()

      , true #deep watch

      scope.$watch 'geojson', (val) ->
        if val isnt undefined and val isnt ''
          _geoJson = val
          layout.lifeCycle().update()


  }