angular.module('wk.chart').directive 'scatter', ($log, utils) ->
  scatterCnt = 0
  return {
    restrict: 'A'
    require: '^layout'
    link: (scope, element, attrs, controller) ->
      layout = controller.me
      _tooltip = undefined
      _selected = undefined
      _id = 'scatter' + scatterCnt++
      _scaleList = []

      ttEnter = (data) ->
        for sName, scale of _scaleList
          @layers.push({
            name: scale.axisLabel(),
            value: scale.formattedValue(data),
            color: if sName is 'color' then {'background-color':scale.map(data)} else undefined,
            path: if sName is 'shape' then d3.svg.symbol().type(scale.map(data)).size(80)() else undefined
            class: if sName is 'shape' then 'tt-svg-shape' else ''
          })

      #-----------------------------------------------------------------------------------------------------------------

      initialShow = true



      draw = (data, options, x, y, color, size, shape) ->
        #$log.debug 'drawing scatter chart'
        init = (s) ->
          if initialShow
            s.style('fill', color.map)
            .attr('transform', (d)-> "translate(#{x.map(d)},#{y.map(d)})").style('opacity', 1)
          initialShow = false

        points = @selectAll('.points')
          .data(data)
        points.enter()
          .append('path').attr('class', 'points selectable')
          .attr('transform', (d)-> "translate(#{x.map(d)},#{y.map(d)})")
          .call(init)
          .call(_tooltip.tooltip)
          .call(_selected)
        points
          .transition().duration(options.duration)
          .attr('d', d3.svg.symbol().type((d) -> shape.map(d)).size((d) -> size.map(d) * size.map(d)))
          .style('fill', color.map)
          .attr('transform', (d)-> "translate(#{x.map(d)},#{y.map(d)})").style('opacity', 1)

        points.exit().remove()


      #-----------------------------------------------------------------------------------------------------------------

      layout.lifeCycle().on 'configure', ->
        _scaleList = @getScales(['x', 'y', 'color', 'size', 'shape'])
        @getKind('y').domainCalc('extent').resetOnNewData(true)
        @getKind('x').resetOnNewData(true).domainCalc('extent')
        _tooltip = layout.behavior().tooltip
        _selected = layout.behavior().selected
        _tooltip.on "enter.#{_id}", ttEnter

      layout.lifeCycle().on 'draw', draw
  }
