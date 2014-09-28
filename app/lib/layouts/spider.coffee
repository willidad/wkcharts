angular.module('wk.chart').directive 'spider', ($log, utils) ->
  spiderCntr = 0
  return {
  restrict: 'A'
  require: 'layout'

  link: (scope, element, attrs, layout) ->
    #$log.debug 'bubbleChart linked'

    _tooltip = undefined
    _scaleList = {}
    _id = 'spider' + spiderCntr++

    prepData = (x, y, color, size) ->

    ttEnter = (data) ->
      for sName, scale of _scaleList
        @layers.push({name: scale.axisLabel(), value: scale.formattedValue(data), color: if sName is 'color' then {'background-color':scale.map(data)} else undefined})

    setTooltip = (tooltip) ->
      _tooltip = tooltip
      _tooltip.on "enter.#{_id}", ttEnter

    draw = (data, options, x, y, color) ->
      null
      $log.log data
      # compute center of area
      centerX = options.width/2
      centerY = options.height/2
      radius = d3.min([centerX, centerY]) * 0.8
      textOffs = 20
      nbrAxis = data.length
      arc = Math.PI * 2 / nbrAxis
      degr = 360 / nbrAxis

      ticks = y.scale().ticks(y.ticks())
      $log.log 'scale Ticks', ticks
      y.scale().range([radius,0]) # tricks the way axis are drawn. Not pretty, but works :-)
      axis = d3.svg.axis().scale(y.scale()).orient('right').tickValues(ticks).tickFormat(y.tickFormat())
      this.append('g').attr('class', 'axis').call(axis).attr('transform', "translate(#{centerX},#{centerY-radius})")
      y.scale().range([0,radius])

      lines = this.selectAll('.axisLine').data(data,(d) -> d.axis)
      lines.enter()
        .append('line').attr('class', 'axisLine')
        .style('stroke', 'darkgrey')
        .attr({x1:0, y1:0, x2:0, y2:radius})
        .attr('transform',(d,i) -> "translate(#{centerX}, #{centerY})rotate(#{degr * i})")
      #lines
      lines.exit().remove()

      #draw tick lines
      tickLine = d3.svg.line().x((d) -> d.x).y((d)->d.y)
      tickPath = this.selectAll('.tickPath').data(ticks)
      tickPath.enter().append('path').attr('class', 'tickPath')
        .attr('d',(d) ->
          p = data.map((a, i) -> {x:Math.sin(arc*i) * y.scale()(d),y:Math.cos(arc*i) * y.scale()(d)})
          tickLine(p) + 'Z')
        .attr('transform', "translate(#{centerX}, #{centerY})")
        .style('fill', 'none').style('stroke', 'lightgrey')
      tickPath.exit().remove()

      axisLabels = this.selectAll('.axisText').data(data,(d) -> x.value(d))
      axisLabels.enter().append('text')
        .attr('class', 'axisText')
        .style('fill', 'black')
        .attr('dy', '0.8em')
        .attr('text-anchor', 'middle')
      axisLabels
        .attr({
            x: (d, i) -> centerX + Math.sin(arc * i) * (radius + textOffs)
            y: (d, i) -> centerY + Math.cos(arc * i) * (radius + textOffs)
          })
        .text((d) -> x.value(d))

      # draw data lines

      dataPath = d3.svg.line().x((d) -> d.x).y((d) -> d.y)

      dataLine = this.selectAll('.dataLine').data(y.layerKeys(data))
      dataLine.enter().append('path').attr('class', 'dataLine')
        .style({
          stroke:(d) -> color.scale()(d)
          fill:(d) -> color.scale()(d)
          'fill-opacity': 0.2
          'stroke-width': 2
        })
      dataLine.attr('d', (d) ->
          p = data.map((a, i) -> {x:Math.sin(arc*i) * y.scale()(a[d]),y:Math.cos(arc*i) * y.scale()(a[d])})
          dataPath(p) + 'Z'
        )
        .attr('transform', "translate(#{centerX}, #{centerY})")


    #-----------------------------------------------------------------------------------------------------------------

    layout.events().on 'configure', ->
      _scaleList = @getScales(['x', 'y', 'color'])
      _scaleList.y.domainCalc('max')
      _scaleList.x.resetOnNewData(true)
      @layerScale('color')

    layout.events().on 'draw', draw

    #layout.events().on 'tooltip', setTooltip

  }