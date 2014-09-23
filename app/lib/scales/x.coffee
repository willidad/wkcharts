angular.module('wk.chart').directive 'x', ($log, scale) ->
  scaleCnt = 0
  return {
    restrict: 'E'
    require: ['x','^chart', '?^layout']
    controller: ($element) ->
      me = scale()
      $log.log 'creating controller scaleX'
      return me

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      chart = controllers[1]
      layout = controllers[2]

      if not (chart or layout)
        $log.error 'scale needs to be contained in a chart or layout directive '
        return

      name = 'x'
      me.kind(name)
      me.parent(layout or chart)
      me.resetOnNewData(true)
      me.isHorizontal(true)
      element.addClass(me.id())

      chart.addScale(me, layout)

      $log.log "linking scale #{name} id:", me.id(), 'layout:', (if layout then layout.id() else '') , 'chart:', chart.id()

      #---Directive Attributes handling --------------------------------------------------------------------------------

      parseList = (val) ->
        if val
          l = val.trim().replace(/^\[|\]$/g, '').split(',').map((d) -> d.replace(/^[\"|']|[\"|']$/g, ''))
          l = l.map((d) -> if isNaN(d) then d else +d)
          return if l.length is 1 then return l[0] else l
        return undefined

      attrs.$observe 'type', (val) ->
        if val isnt undefined
          if d3.scale.hasOwnProperty(val) or val is 'time'
            me.scaleType(val)
          else
            ## no scale defined, use default
            $log.error "Error: illegal scale value: #{val}. Using 'linear' scale instead"
            me.scaleType('linear')

      attrs.$observe 'property', (val) ->
        me.property(parseList(val))

      attrs.$observe 'range', (val) ->
        range = parseList(val)
        if Array.isArray(range)
          me.range(range)

      attrs.$observe 'format', (val) ->
        if val
          if me.scaleType() is 'time'
            me.dataFormat(val)

      attrs.$observe 'domain', (val) ->
        if val
          $log.info 'domain', val
          parsedList = parseList(val)
          if Array.isArray(parsedList)
            me.domain(parsedList)
            domainAttr = parsedList
          else
            $log.error "domain #{name}: must be array, or comma-separated list, got", val

      attrs.$observe 'domainRange', (val) ->
        if val
          me.domainCalc(val)

      attrs.$observe 'axis', (val) ->
        if val isnt undefined
          if val isnt 'false'
            if val in ['top', 'bottom']
              me.axisOrient(val).showAxis(true)
            else
              me.axisOrient('bottom').showAxis(true)
          else
            me.showAxis(false).axisOrient(undefined)
          me.update()

      attrs.$observe 'tickFormat', (val) ->
        if val isnt undefined and me.axis()
          me.axis().tickFormat(d3.format(val)).drawAxis()

      attrs.$observe 'ticks', (val) ->
        if val isnt undefined and me.axis()
          me.axis().ticks(+val)
          me.drawAxis()

      attrs.$observe 'grid', (val) ->
        if val isnt undefined
          me.showGrid(val is '' or val is 'true').drawAxis()

      attrs.$observe 'label', (val) ->
        if val isnt undefined
          me.axisLabel(val).drawAxis()

      attrs.$observe 'showLabel', (val) ->
        if val isnt undefined
          me.showLabel(val is '' or val is 'true').update()
  }