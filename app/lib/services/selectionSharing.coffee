angular.module('wk.chart').service 'selectionSharing', ($log) ->
  selections = {}
  callbacks = {}

  this.setSelection = (selection, group) ->
    grp = group or 'default'
    selection[grp] = selection
    if callbacks[grp]
      for cb in callbacks[grp]
        cb(selection)

  this.getSelection = (group) ->
    grp = group or 'default'
    return selection[grp]

  this.register = (group, callback) ->
    grp = group or 'default'
    if not callbacks[grp]
      callbacks[grp] = []
    callbacks[grp].push(callback)

  deRegister = (callback, grp) ->

  return this

