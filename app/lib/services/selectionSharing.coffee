angular.module('wk.chart').service 'selectionSharing', ($log) ->
  selection = {}
  callbacks = {}

  this.createGroup = (group) ->


  this.setSelection = (selection, group) ->
    if group
      selection[group] = selection
      if callbacks[group]
        for cb in callbacks[group]
          cb(selection)

  this.getSelection = (group) ->
    grp = group or 'default'
    return selection[grp]

  this.register = (group, callback) ->
    if group
      if not callbacks[group]
        callbacks[group] = []
      #ensure that callbacks are not registered more than once
      if not _.contains(callbacks[group], callback)
        callbacks[group].push(callback)

  this.unregister = (group, callback) ->
    if callbacks[group]
      idx = callbacks[group].indexOf callback
      if idx >= 0
        callbacks[group].splice(idx, 1)

  return this

