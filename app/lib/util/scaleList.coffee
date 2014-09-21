angular.module('wk.chart').factory 'scaleList', ($log) ->
  return scaleList = () ->
    _list = {}
    _kindList = {}
    _parentList = {}
    _owner = undefined
    _requiredScales = []
    _layerScale = undefined

    me = () ->

    me.owner = (owner) ->
      if arguments.length is 0 then return _owner
      else
        _owner = owner
        return me

    me.add = (scale) ->
      if _list[scale.id()]
        $log.error "scaleList.add: scale #{scale.id()} already defined in scaleList of #{_owner.id()}. Duplicate scales are not allowed"
      _list[scale.id()] = scale
      _kindList[scale.kind()] = scale
      return me

    me.hasScale = (scale) ->
      s = me.getKind(scale.kind())
      return s.id() is scale.id()

    me.getKind = (kind) ->
      if _kindList[kind] then _kindList[kind] else if _parentList.getKind then _parentList.getKind(kind) else undefined

    me.hasKind = (kind) ->
      return !!me.getKind(kind)

    me.remove = (scale) ->
      if not _list[scale.id()]
        $log.warn "scaleList.delete: scale #{scale.id()} not defined in scaleList of #{_owner.id()}. Ignoring"
        return me
      delete _list[scale.id()]
      delete me[scale.id]
      return me

    me.parentScales = (scaleList) ->
      if arguments.length is 0 then return _parentList
      else
        _parentList = scaleList
        return me

    me.getOwned = () ->
      _list

    me.allKinds = () ->
      ret = {}
      if _parentList.allKinds
        for k, s of _parentList.allKinds()
          ret[k] = s
      for k,s of _kindList
        ret[k] = s
      return ret

    me.requiredScales = (req) ->
      if arguments.length is 0 then return _requiredScales
      else
        _requiredScales = req
        for k in req
          if not me.hasKind(k)
            throw "Fatal Error: scale '#{k} required but not defined"
      return me

    me.layerScale = (kind) ->
      if arguments.length is 0
        if _layerScale
          return me.getKind(_layerScale)
        return undefined
      else
        _layerScale = kind
        return me

    return me
