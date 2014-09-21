angular.module('wk.chart').service 'utils', ($log) ->

  #---------------------------------------------------------------------------------------------------------------------

  @diff = (a,b,direction) ->
    notInB = (v) ->
      b.indexOf(v) < 0

    res = {}
    i = 0
    while i < a.length
      if notInB(a[i])
        res[a[i]] = undefined
        j = i + direction
        while 0 <= j < a.length
          if notInB(a[j])
            j += direction
          else
            res[a[i]] =  a[j]
            break
      i++
    return res

  #---------------------------------------------------------------------------------------------------------------------

  id = 0
  @getId = () ->
    return 'Chart' + id++

  #---------------------------------------------------------------------------------------------------------------------

  @parseList = (val) ->
    if val
      l = val.trim().replace(/^\[|\]$/g, '').split(',').map((d) -> d.replace(/^[\"|']|[\"|']$/g, ''))
      return if l.length is 1 then return l[0] else l
    return undefined

  #---------------------------------------------------------------------------------------------------------------------

  return @
