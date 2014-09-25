angular.module('wk.chart').service 'scaleUtils', ($log) ->

  parseList = (val) ->
    if val
      l = val.trim().replace(/^\[|\]$/g, '').split(',').map((d) -> d.replace(/^[\"|']|[\"|']$/g, ''))
      l = l.map((d) -> if isNaN(d) then d else +d)
      return if l.length is 1 then return l[0] else l

  return {

    observeSharedAttributes: (attrs, me) ->
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

      attrs.$observe 'label', (val) ->
        if val isnt undefined
          me.axisLabel(val).drawAxis()

    #-------------------------------------------------------------------------------------------------------------------

    observeAxisAttributes: (attrs, me) ->

      attrs.$observe 'tickFormat', (val) ->
        if val isnt undefined and me.axis()
          me.axis().tickFormat(d3.format(val))

      attrs.$observe 'ticks', (val) ->
        if val isnt undefined and me.axis()
          me.axis().ticks(+val)
          me.drawAxis()

      attrs.$observe 'grid', (val) ->
        if val isnt undefined
          me.showGrid(val is '' or val is 'true').drawAxis()

      attrs.$observe 'showLabel', (val) ->
        if val isnt undefined
          me.showLabel(val is '' or val is 'true').update()

    #-------------------------------------------------------------------------------------------------------------------

    observeLegendAttributes: (attrs, me) ->

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



  }

