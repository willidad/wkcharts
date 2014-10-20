angular.module('wk.chart').service 'timing', ($log) ->

  timers = {}
  elapsedStart = 0
  elapsed = 0

  this.init = () ->
    elapsedStart = Date.now()

  this.start = (topic) ->
    top = timers[topic]
    if not top
      top = timers[topic] = {name:topic, start:0, total:0, callCnt:0, active: false}
    top.start = Date.now()
    top.active = true

  this.stop = (topic) ->
    if top = timers[topic]
      top.active = false
      top.total += Date.now() - top.start
      top.callCnt += 1
    elapsed = Date.now() - elapsedStart

  this.report = () ->
    for topic, val of timers
      val.avg = val.total / val.callCnt
    $log.info timers
    $log.info 'Elapsed Time (ms)', elapsed
    return timers

  this.clear = () ->
    timers = {}

  return this