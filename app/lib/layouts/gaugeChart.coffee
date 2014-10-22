angular.module('wk.chart').directive 'gauge', ($log, utils) ->
  return {
    restrict: 'A'
    require: '^layout'
    controller: ($scope, $attrs) ->
      me = {chartType: 'GaugeChart', id:utils.getId()}
      $attrs.$set('chart-id', me.id)
      return me
    
    link: (scope, element, attrs, controller) ->
      layout = controller.me

      initalShow = true

      #-----------------------------------------------------------------------------------------------------------------

      draw = (data, options, x, y, color) ->
        $log.info 'drawing Gauge Chart'

        dat = [data]

        yDomain = y.scale().domain()
        colorDomain = angular.copy(color.scale().domain())
        colorDomain.unshift(yDomain[0])
        colorDomain.push(yDomain[1])
        ranges = []
        for i in [1..colorDomain.length-1]
          ranges.push {from:+colorDomain[i-1],to:+colorDomain[i]}

        #draw color scale

        bar = @selectAll('.bar')
        bar = bar.data(ranges, (d, i) -> i)
        if initalShow
          bar.enter().append('rect').attr('class', 'bar')
            .attr('x', 0).attr('width', 50)
            .style('opacity', 0)
        else
          bar.enter().append('rect').attr('class', 'bar')
            .attr('x', 0).attr('width', 50)

        bar.transition().duration(options.duration)
          .attr('height',(d) -> y.scale()(0) - y.scale()(d.to - d.from))
          .attr('y',(d) -> y.scale()(d.to))
          .style('fill', (d) -> color.scale()(d.from))
          .style('opacity', 1)

        bar.exit().remove()

        # draw value

        addMarker = (s) ->
          s.append('rect').attr('width', 55).attr('height', 4).style('fill', 'black')
          s.append('circle').attr('r', 10).attr('cx', 65).attr('cy',2).style('stroke', 'black')

        marker = @selectAll('.marker')
        marker = marker.data(dat, (d) -> 'marker')
        marker.enter().append('g').attr('class','marker').call(addMarker)

        if initalShow
          marker.attr('transform', (d) -> "translate(0,#{y.scale()(d.value)})").style('opacity', 0)

        marker
          .transition().duration(options.duration)
            .attr('transform', (d) -> "translate(0,#{y.scale()(d.value)})")
            .style('fill',(d) -> color.scale()(d.value)).style('opacity', 1)

        initalShow = false

      #-----------------------------------------------------------------------------------------------------------------


      layout.lifeCycle().on 'configure', ->
        this.requiredScales(['y', 'color'])
        @getKind('color').resetOnNewData(true)

      layout.lifeCycle().on 'draw', draw

  }