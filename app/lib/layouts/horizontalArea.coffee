angular.module('wk.chart').directive 'horizontalArea', ($log) ->
  lineCntr = 0
  return {
    restrict: 'A'
    require: 'layout'
    link: (scope, element, attrs, host) ->
      #$log.log 'linking s-line'
      layerKeys = []
      _layout = []
      _tooltip = undefined
      _ttHighlight = undefined
      _circles = undefined
      _scaleList = {}
      offset = 0
      _id = 'line' + lineCntr++

      prepData = (x, y, color) ->
        #layerKeys = y.layerKeys(@)
        #_layout = layerKeys.map((key) => {key:key, color:color.scale()(key), value:@map((d)-> {x:x.value(d),y:y.layerValue(d, key)})})

      ttEnter = (idx, axisX, cntnr) ->
        cntnrSel = d3.select(cntnr)
        cntnrWidth = cntnrSel.attr('width')
        parent = d3.select(cntnr.parentElement)
        _ttHighlight = parent.append('g')
        _ttHighlight.append('line').attr({x1:0, x2:cntnrWidth}).style({'pointer-events':'none', stroke:'lightgrey', 'stroke-width':1})
        _circles = _ttHighlight.selectAll('circle').data(_layout,(d) -> d.key)
        _circles.enter().append('circle').attr('r', 5).attr('fill', (d)-> d.color).attr('fill-opacity', 0.6).attr('stroke', 'black').style('pointer-events','none')

        _ttHighlight.attr('transform', "translate(0,#{_scaleList.y.scale()(_layout[0].value[idx].y)+offset})")

      ttMove = (idx, axisX,  cntnr) ->
        ttLayers = _layout.map((l) -> {name:l.key, value:_scaleList.x.formatValue(l.value[idx].x), color:{'background-color': l.color}})

        _circles.attr('cx', (d) ->
          null
          _scaleList.x.scale()(d.value[idx].x))
        _ttHighlight.attr('transform', "translate(0, #{_scaleList.y.scale()(_layout[0].value[idx].y) + offset})")

        @headerName = _scaleList.y.axisLabel()
        @headerValue = _scaleList.y.formatValue(_layout[0].value[idx].y)
        @layers = @layers.concat(ttLayers)

      ttLeave = (x, axisX, cntnr)->
        _ttHighlight.remove()



      setTooltip = (tooltip, overlay) ->
        _tooltip = tooltip
        tooltip(overlay)
        tooltip.isHorizontal(true)
        tooltip.refreshOnMove(true)
        tooltip.on "move.#{_id}", ttMove
        tooltip.on "enter.#{_id}", ttEnter
        tooltip.on "leave.#{_id}", ttLeave


      draw = (data, options, x, y, color) ->
        layerKeys = x.layerKeys(data)
        _layout = layerKeys.map((key) => {key:key, color:color.scale()(key), value:data.map((d)-> {y:y.value(d),x:x.layerValue(d, key)})})

        offset = if y.isOrdinal() then y.scale().rangeBand() / 2 else 0

        if _tooltip then _tooltip.scale(y).data(data)

        area = d3.svg.area()    # tricky. Draw this like a vertical chart and then rotate and position it.
        .x((d) ->   options.width - y.scale()(d.y))
        .y0((d) ->  x.scale()(d.x))
        .y1((d) ->  x.scale()(0))

        layers = this.selectAll(".layer")
          .data(_layout, (d) -> d.key)
        layers.enter().append('g')
          .attr('class', "layer")
          .append('path')
          .attr('class','line')
          .style('stroke', (d) -> d.color)
          .style('fill', (d) -> d.color)
          .style('opacity', 0)
          .style('pointer-events', 'none')
        layers.select('.line')
          .attr('transform', "translate(0,#{options.width + offset})rotate(-90)") #rotate and position chart
          .transition().duration(options.duration)
          .attr('d', (d) -> area(d.value))
          .style('opacity', 0.3).style('pointer-events', 'none')
        layers.exit().transition().duration(options.duration)
          .style('opacity', 0)
          .remove()

      host.lifeCycle().on 'configure', ->
        _scaleList = @getScales(['x', 'y', 'color'])
        @layerScale('color')
        @getKind('y').domainCalc('extent').resetOnNewData(true)
        @getKind('x').resetOnNewData(true).domainCalc('extent')

      host.lifeCycle().on 'draw', draw

      host.lifeCycle().on 'prepData', prepData

      host.lifeCycle().on "tooltip.#{_id}", setTooltip




  }