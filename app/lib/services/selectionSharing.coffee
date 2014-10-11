angular.module('wk.chart').service 'selectionSharing', ($log) ->
  selections = {}
  callbacks = {}

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
      callbacks[group].push(callback)

  deRegister = (callback, grp) ->

  return this

