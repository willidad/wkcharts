angular.module('wk.chart').directive 'y', ($log, scale, legend) ->
  scaleCnt = 0
  return {
    restrict: 'E'
    require: ['y','^chart', '?^layout']
    controller: ($element) ->
      me = scale()
      $log.log 'creating controller scaleY'
      return me

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      chart = controllers[1]
      layout = controllers[2]

      if not (chart or layout)
        $log.error 'scale needs to be contained in a chart or layout directive '
        return

      name = 'y'
      me.kind(name)
      me.parent(layout or chart)
      me.isVertical(true)
      me.resetOnNewData(true)
      element.addClass(me.id())

      chart.addScale(me, layout)
      $log.log "linking scale #{name} id:", me.id(), 'layout:', (if layout then layout.id() else '') , 'chart:', chart.id()

      #---Directive Attributes handling --------------------------------------------------------------------------------

      parseList = (val) ->
        if val
          l = val.trim().replace(/^\[|\]$/g, '').split(',').map((d) -> d.replace(/^[\"|']|[\"|']$/g, ''))
          return if l.length is 1 then return l[0] else l
        return undefined

      attrs.$observe 'type', (val) ->
        if val isnt undefined
          if d3.scale.hasOwnProperty(val) or val is 'time'
            me.scaleType(val)
          else
            ## no scale defined, use default
            $log.error "Error: illegal scale value: #{val}. Using #{defaultScale} scale instead"
            me.scaletype('linear')

      attrs.$observe 'property', (val) ->
        me.property(parseList(val))

      attrs.$observe 'layerProperty', (val) ->
        if val and val.length > 0
          me.layerProperty(val)

      attrs.$observe 'range', (val) ->
        range = parseList(val)
        if Array.isArray(range)
          me.range(range)

      attrs.$observe 'format', (val) ->
        if val
          if me.scaleType() is 'time'
            me.dataFormat(d3.time.format(val))

      attrs.$observe 'domain', (val) ->
        if val
          #$log.info 'domain', val
          parsedList = parseList(val)
          if Array.isArray(parsedList)
            me.domain(parsedList)
            domainAttr = parsedList
          else
            $log.error "domain #{name}: must be array, or comma-separated list, got", val

      attrs.$observe 'domainRange', (val) ->
        if val
          me.domainCalc(val)

      attrs.$observe 'legend', (val) ->
        if val isnt undefined
          l = me.legend()
          if val isnt 'false'
            l.position('top-right').show(true)
            switch val
              when 'top-left', 'top-right', 'bottom-left', 'bottom-right'
                l.position(val).div(undefined)
              when ''

              else
                legendDiv = d3.select(val)
                if legendDiv.empty()
                  $log.warn 'legend reference does not exist:', val
                else
                  l.div(legendDiv).position('top-left')
          else
            me.legend().show(false)

          l.scale(me).layout(layout)
          if me.parent()
            l.register(me.parent())
          l.redraw()

      attrs.$observe 'axis', (val) ->
        me.showAxis(false)
        if val isnt undefined and val isnt 'false'
          if val in ['left', 'right']
            me.axisOrient(val).showAxis(true)
          else
            me.axisOrient('left').showAxis(true)
        me.update()

      attrs.$observe 'tickFormat', (val) ->
        if val isnt undefined
          me.axis().tickFormat(d3.format(val))

      attrs.$observe 'ticks', (val) ->
        if val isnt undefined
          me.axis().ticks(val)
          me.drawAxis()

      attrs.$observe 'grid', (val) ->
        if val isnt undefined
          me.showGrid(val is '' or val is 'true').drawAxis()

      attrs.$observe 'label', (val) ->
        if val isnt undefined and val.length > 0
          me.axisLabel(val)

  }