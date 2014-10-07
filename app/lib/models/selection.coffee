angular.module('wk.chart').factory 'selection', ($log) ->
    selectionCnt = 0
    selection = () ->
      _id = 'selection' + selectionCnt++
      _selectable = true
      myGlow = glow("myGlow").rgb("#0f0").stdDeviation(4)

      clicked = () ->
        null
        obj = d3.select(this)
        isSelected = obj.classed 'selected'
        if not isSelected
          obj.style('filter', 'url(#myGlow)')
        else
          obj.style('filter', null)

        obj.classed 'selected', not isSelected

      me = (d3Selection) ->
        if arguments.length is 0 then return me
        else
          if _selectable
            d3Selection.on 'click', clicked
            d3Selection.classed 'selected', false
          else
            d3.selection.on 'click', null
            d3Selection.classed 'selected', false
          return me

      me.id = () ->
          return _id

      me.selectable = (val) ->
        if arguments.length is 0 then return _selectable
        else
          _selectable = val
          return me #to enable chaining

      return me

    return selection