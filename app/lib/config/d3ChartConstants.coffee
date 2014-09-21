charts = angular.module 'wk.chart'

charts.constant 'd3Scales', {
  linear: d3.scale.linear
  sqrt: d3.scale.sqrt
  log: d3.scale.log
  identity: d3.scale.identity
  quantize: d3.scale.quantize
  quantile: d3.scale.quantile
  threshold: d3.scale.threshold
  ordinal: d3.scale.ordinal
  category10: d3.scale.category10
  category20: d3.scale.category20
  category20b: d3.scale.category20b
  category20c: d3.scale.category20c
  time: d3.time.scale
}

charts.constant 'd3OrdinalScales', [
  'ordinal'
  'category10'
  'category20'
  'category20b'
  'category20c'
]

charts.constant 'd3ChartMargins', {
  top: 10
  left: 50
  bottom: 40
  right: 20
  topBottomMargin:{axis:25, label:18}
  leftRightMargin:{axis:40, label:20}
  minMargin:8
  default:
    top: 8
    left:8
    bottom:8
    right:10
  axis:
    top:25
    bottom:25
    left:40
    right:40
  label:
    top:18
    bottom:18
    left:20
    right:20
}

charts.constant 'd3Shapes', [
  'circle',
  'cross',
  'triangle-down',
  'triangle-up',
  'square',
  'diamond'
]

charts.constant 'axisConfig', {
  labelFontSize: '1.6em'
  x:
    axisPositions: ['top', 'bottom']
    axisOffset: {bottom:'height'}
    axisPositionDefault: 'bottom'
    direction: 'horizontal'
    measure: 'width'
    labelPositions:['outside', 'inside']
    labelPositionDefault: 'outside'
    labelOffset:
      top: '1em'
      bottom: '-0.8em'
  y:
    axisPositions: ['left', 'right']
    axisOffset: {right:'width'}
    axisPositionDefault: 'left'
    direction: 'vertical'
    measure: 'height'
    labelPositions:['outside', 'inside']
    labelPositionDefault: 'outside'
    labelOffset:
      left: '1.2em'
      right: '1.2em'
}

charts.constant 'd3Animation', {
  duration:500
}

charts.constant 'templateDir', 'app/lib/templates/'

charts.constant 'd3ScaleMap', [
  scaleX: 'x'
  scaleY: 'y'
  scaleColor: 'color'
  scaleSize: 'size'
  scaleShape: 'shape'
]

