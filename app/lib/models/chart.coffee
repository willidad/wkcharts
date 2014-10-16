angular.module('wk.chart').factory 'chart', ($log, layeredData, scaleList, container, behavior, d3Animation) ->

  chartCntr = 0

  chart = () ->

    _id = "chart#{chartCntr++}"

    me = () ->

    #--- Variable declarations and defaults ----------------------------------------------------------------------------

    _layouts = []               # List of layouts for the chart
    _container = undefined    # the charts drawing container object
    _allScales = undefined    # Holds all scales of the chart, regardless of scale owner
    _ownedScales = undefined  # holds the scles owned by chart, i.e. share scales
    _data = undefined           # pointer to the last data set bound to chart
    _showTooltip = false        # tooltip property
    _behavior = behavior()
    _animationDuration = d3Animation.duration

    #--- LifeCycle Dispatcher ------------------------------------------------------------------------------------------

    _lifeCycle = d3.dispatch('configure', 'resize', 'prepareData', 'scaleDomains', 'sizeContainer', 'drawAxis', 'drawChart', 'newData', 'update' )
    _brush = d3.dispatch('draw', 'change')

    #--- Getter/Setter Functions ---------------------------------------------------------------------------------------

    me.id = (id) ->
      return _id

    me.showTooltip = (trueFalse) ->
      if arguments.length is 0 then return _showTooltip
      else
        _showTooltip = trueFalse
        _behavior.tooltip.active(_showTooltip)
        return me

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

    me.animationDuration = (val) ->
      if arguments.length is 0 then return _animationDuration
      else
        _animationDuration = val
        return me #to enable chaining

    #--- Getter Functions ----------------------------------------------------------------------------------------------

    me.lifeCycle = (val) ->
      return _lifeCycle

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

    me.execLifeCycleFull = (data, noAnimation) ->
      if data
        _data = data
        _lifeCycle.prepareData(data, noAnimation)    # calls the registered layout types
        _lifeCycle.scaleDomains(data, noAnimation)   # calls registered the scales
        _lifeCycle.sizeContainer(data, noAnimation)  # calls container
        _lifeCycle.drawAxis(noAnimation)              # calls container
        _lifeCycle.drawChart(data, noAnimation)      # calls layout

    me.resizeLifeCycle = (noAnimation) ->
      if _data
        _lifeCycle.sizeContainer(_data, noAnimation)  # calls container
        _lifeCycle.drawAxis(noAnimation)              # calls container
        _lifeCycle.drawChart(_data, noAnimation)

    me.newDataLifeCycle = (data, noAnimation) ->
      if data
        _data = data
        _lifeCycle.prepareData(data, noAnimation)    # calls the registered layout types
        _lifeCycle.scaleDomains(data, noAnimation)
        _lifeCycle.drawAxis(noAnimation)              # calls container
        _lifeCycle.drawChart(data, noAnimation)

    me.attributeChange = (noAnimation) ->
      if _data
        _lifeCycle.sizeContainer(_data, noAnimation)
        _lifeCycle.drawAxis(noAnimation)              # calls container
        _lifeCycle.drawChart(data, noAnimation)

    me.brushExtentChanged = (noAnimation) ->
      if _data
        _lifeCycle.drawAxis(noAnimation)              # calls container
        _lifeCycle.drawChart(_data, noAnimation)

    me.lifeCycle().on 'newData.chart', me.execLifeCycleFull
    me.lifeCycle().on 'resize.chart', me.resizeLifeCycle
    me.lifeCycle().on 'update.chart', (noAnimation) ->
      $log.info 'Update Chart triggered'
      me.execLifeCycleFull(_data, noAnimation)


    #--- Initialization ------------------------------------------------------------------------------------------------

    _container = container().chart(me)   # the charts drawing container object
    _allScales = scaleList()    # Holds all scales of the chart, regardless of scale owner
    _ownedScales = scaleList()  # holds the scles owned by chart, i.e. share scales

    return me

  return chart