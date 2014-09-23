angular.module('wk.chart').directive 'shape', ($log, scale, d3Shapes) ->
  scaleCnt = 0
  return {
    restrict: 'E'
    require: ['shape','^chart', '?^layout']
    controller: ($element) ->
      me = scale()
      $log.log 'creating controller scaleSize'
      return me

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      chart = controllers[1]
      layout = controllers[2]

      if not (chart or layout)
        $log.error 'scale needs to be contained in a chart or layout directive '
        return

      name = 'shape'
      me.kind(name)
      me.parent(layout or chart)
      me.scaletype('ordinal')
      me.range(d3Shapes)
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
            $log.error "Error: illegal scale value: #{val}. Using 'ordinal' scale instead"
            me.scaletype('ordinal')

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
          else
            $log.error "domain #{name}: must be array, or comma-separated list, got", val

      attrs.$observe 'domainRange', (val) ->
        if val
          me.domainCalc(val)

      attrs.$observe 'label', (val) ->
        if val isnt undefined
          if val.length > 0
            me.axisLabel(val).drawAxis()
          else
            me.axisLabel('').drawAxis()
  }