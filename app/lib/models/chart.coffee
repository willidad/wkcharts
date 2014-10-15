angular.module('wk.chart').factory 'chart', ($log, layeredData, scaleList, container, behavior) ->

  chart = () ->
    _id = ''

    me = () ->

    _layouts = []               # List of layouts for the chart
    _container = container()    # the charts drawing container object
    _allScales = scaleList()    # Holds all scales of the chart, regardless of scale owner
    _ownedScales = scaleList()  # holds the scles owned by chart, i.e. share scales
    _data = undefined           # pointer to the last data set bound to chart
    _showTooltip = false        # tooltip property
    _behavior = behavior()

    _container.chart(me)        # register the chart with the container object

    _brush = d3.dispatch('draw', 'change')
    _chartEvents = d3.dispatch('configure', 'draw', 'redraw', 'drawAxis', 'update')



    #--- Getter/Setter Functions ---------------------------------------------------------------------------------------

    me.id = (id) ->
      if arguments.length is 0 then return _id
      else
        _id = id
        return me

    me.showTooltip = (trueFalse) ->
      if arguments.length is 0 then return _showTooltip
      else
        _showTooltip = trueFalse
        _behavior.tooltip.active(_showTooltip)
        return me

    #--- Setter and registration functions -----------------------------------------------------------------------------

    me.addLayout = (layout) ->
      if arguments.length is 0 then return _layouts
      else
        _layouts.push(layout)
        return me

    me.addScale = (scale, layout) ->
      _allScales.add(scale)
      if layout
        layout.scales().add(scale)
      else
        _ownedScales.add(scale)
      return me

    #--- Getter Functions ----------------------------------------------------------------------------------------------

    me.layouts = () ->
      return _layouts

    me.scales = () ->
      return _ownedScales

    me.allScales = () ->
      return _allScales

    me.hasScale = (scale) ->
      return !!_allScales.has(scale)

    me.container = () ->
      return _container

    me.brush = () ->
      return _brush

    me.getData = () ->
      return _data

    me.behavior = () ->
      return _behavior

    #--- Chart drawing life cycle --------------------------------------------------------------------------------------

    _lifeCycle = d3.dispatch('prepareData', 'scaleDomains', 'sizeContainer', 'drawAxis', 'drawLegend', 'drawChart', 'newData', 'update' )

    me.events = () ->
      return _chartEvents

    me.lifeCycle = (val) ->
     return _lifeCycle

    me.execLifeCycleFull = (data, noAnimation) ->
      if data
        $log.info 'LifeCycle triggered'
        _data = data
        _lifeCycle.prepareData(data, noAnimation)    # calls the registered layout types
        _lifeCycle.scaleDomains(data, noAnimation)   # calls registered the scales
        _container.sizeContainer(data, noAnimation)  # calls container #TODO: implement through dispatch mechanism
        _container.drawAxis(data, noAnimation)       # calls container #TODO: implement through dispatch mechanism
        _lifeCycle.drawLegend(data, noAnimation)     # calls container #TODO: separate from container object
        _lifeCycle.drawChart(data, noAnimation)      # calls layout

    me.lifeCycle().on 'newData.chart', me.execLifeCycleFull
    me.lifeCycle().on 'update.chart', (noAnimation) ->
      $log.info 'Update Chart triggered'
      me.execLifeCycleFull(_data, noAnimation)

    #-------------------------------------------------------------------------------------------------------------------

    return me

  return chart