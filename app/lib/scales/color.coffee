angular.module('wk.chart').directive 'color', ($log, scale, legend) ->
  scaleCnt = 0
  return {
    restrict: 'E'
    require: ['color','^chart', '?^layout']
    controller: ($element) ->
      me = scale()
      $log.log 'creating controller scaleColor'
      return me

    link: (scope, element, attrs, controllers) ->
      me = controllers[0]
      chart = controllers[1]
      layout = controllers[2]
      l = undefined

      if not (chart or layout)
        $log.error 'scale needs to be contained in a chart or layout directive '
        return

      name = 'color'
      me.kind(name)
      me.parent(layout or chart)
      element.addClass(me.id())

      chart.addScale(me, layout)
      chart.events().on 'configure', () ->
        $log.log 'Color Container ', me.parent().container()
      #$log.log "linking scale #{name} id:", me.id(), 'layout:', (if layout then layout.id() else '') , 'chart:', chart.id()

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
          $log.info 'domain', val
          parsedList = parseList(val)
          if Array.isArray(parsedList)
            me.domain(parsedList)
            domainAttr = parsedList
          else
            $log.error "domain #{name}: must be array, or comma-separated list, got", val

      attrs.$observe 'legend', (val) ->
        if val isnt undefined
          l = legend()
          l.position('top-right')
          switch val
            when 'top-left', 'top-right', 'bottom-left', 'bottom-right'
              l.position(val)
            when ''

            else
              legendDiv = d3.select(val)
              if legendDiv.empty()
                $log.warn 'legend reference does not exist:', val
              else
                l.div(legendDiv)
          #$log.info 'Legend', l.position()
          l.scale(me)
          if me.parent()
            l.register(me.parent())

      attrs.$observe 'label', (val) ->
        if val isnt undefined and val.length > 0 and l
          l.label(val)
  }