angular.module('wk.chart').directive 'pie', ($log, utils) ->
  pieCntr = 0

  return {
  restrict: 'EA'
  require: '^layout'
  link: (scope, element, attrs, layout) ->

    # set chart specific defaults

    _id = "pie#{pieCntr++}"

    arcs = null
    oldKeys = []
    _scaleList = []
    _selected = undefined
    _tooltip = undefined

    #-------------------------------------------------------------------------------------------------------------------

    ttEnter = (data) ->
      @headerName = _scaleList.color.axisLabel()
      @headerValue = _scaleList.size.axisLabel()
      @layers.push({name: _scaleList.color.formattedValue(data.data), value: _scaleList.size.formattedValue(data.data), color:{'background-color': _scaleList.color.map(data.data)}})

    #-------------------------------------------------------------------------------------------------------------------

    initialShow = true

    init = (s) ->
      if initialShow
        s.style('opacity', 0)

    draw = (data, options, x, y, color, size) ->
      #$log.debug 'drawing pie chart v2'

      if not arcs
        arcs = @selectAll('.arc')

      r = Math.min(options.width, options.height) / 2 - 10 #for glow shadow

      arc = d3.svg.arc()
        .outerRadius(r)
        .innerRadius(0)

      pie = d3.layout.pie()
        .sort(null)
        .value(size.value)

      arcTween = (a) ->
        i = d3.interpolate(this._current, a)
        this._current = i(0)
        return (t) ->
          arc(i(t))

      oldPie = arcs.data()
      newPie = pie(data)

      getNeighbour = (d, i, from) ->
        # find neighbour in the data
        domain = color.scale.domain()
        domIdx = domain.indexOf(key(d))
        a = findArc(domain, domIdx, from)
        #$log.info a
        return a or d

      #-----------------------------------------------------------------------------------------------------------------

      findArcByKey = (key, pie) ->
        for a in pie
          if color.value(a.data) is key
            return a

      getPred = (key, d) ->
        pred = findArcByKey(key, oldPie)
        if pred then {startAngle:pred.endAngle, endAngle:pred.endAngle} else if oldPie.length >0 then {startAngle:0, endAngle:0} else d

      getSucc = (key,d) ->
        succ = findArcByKey(key, newPie)
        if succ
          d.startAngle = succ.startAngle
          d.endAngle = succ.startAngle
        else
          d.startAngle = Math.PI * 2
          d.endAngle = Math.PI * 2
        return d

      newKeys = color.value(data)

      deletedSucc = utils.diff(oldKeys, newKeys, 1)
      addedPred = utils.diff(newKeys, oldKeys, -1)

      #$log.info 'Pie: deleted, added', deletedSucc, addedPred

      #-----------------------------------------------------------------------------------------------------------------

      arcs = arcs
        .data(newPie,(d) -> color.value(d.data))

      arcs.enter().append('path')
        .each((d) -> this._current = getPred(addedPred[color.value(d.data)], d))
        .attr('class','arc selectable')
        .style('fill', (d) ->  color.map(d.data))
        .call(init)
        .call(_tooltip.tooltip)
        .call(_selected)

      arcs
        .attr('transform', "translate(#{options.width / 2},#{options.height / 2})")
        .transition().duration(options.duration)
          .style('opacity', 1)
          .attrTween('d',arcTween)

      arcs.exit().datum((d) -> getSucc(deletedSucc[color.value(d.data)],d))
        .transition().duration(options.duration)
        .attrTween('d',arcTween)
      .remove()

      oldKeys = newKeys
      initialShow = false

    #-------------------------------------------------------------------------------------------------------------------

    layout.lifeCycle().on 'configure', ->
      _scaleList = this.getScales(['size', 'color'])
      _tooltip = layout.behavior().tooltip
      _selected = layout.behavior().selected
      _tooltip.on "enter.#{_id}", ttEnter

    layout.lifeCycle().on 'draw', draw
  }