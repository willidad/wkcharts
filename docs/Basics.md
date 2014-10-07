# Basic Concepts

blabla about declarative description of charts and AngularJS

## Chart

A chart represents collection of layouts, dimensions and behaviors that are exposed in a common container (a HTML Div to be precise) and share the same set of data. Within a chart layouts (e.g. a line and a bubble chart) can share dimensions, but do not need to. 
They always share teh data, and typically the area in which they are drawn. 

## Chart Dimensions

Chart dimensions are the basic building blocks to visualize data. Chart layouts support different sets of dimensions, e.g. a Pie Chart can be used to visualize two dimensions:
* a categorial dimension, represented inthe pie segment and (optionally) through the segment color
* some sort of numeric value, represented through the size of the pie segment. 
A line chart support a x and a y dimension, as well a color to represent the data series. See --- for a detailed description of capabilities

In contrast, a line chart typically represents a linear dimension on the x-axis (e.g. time or date) and one or more related sets of values (data series) mapped into the y-dimension. The series itself represents a categorial dimensions, which is typically encodes through color. 
the charts library at this time supports a number of different dimension types, which, depending int he type of chart layout selected, may be combined to form the graph:

* x : the horizontal position of a chart object
* y : the vertical position of a chart object
* color: Coloring of data depending on data attributes
* size: Size of a chart object (e.g. a circle) depending on a data attribute
* shape: defines the shape of a chart object (circle, box, arrow, cross, etx.) to represent data attributes

Dimensions can be combined to represent a specific data value. The layout type determines which dimensions are applicable, and how exactly they are represented. For details see the description of layout types

### Axis and legends

Axis and legends visualize the the mapping 'rules' for data on the visual dimension, a color legend explains which color represents which data data value or data series, the x-axis outlines where on the horizontal dimension a sepcific data value will be represented.

### Scales

Scales define how data is translated into visual representation, and are at the very core of the charting system. Scales in charts are implemented through the d3 scale system, which supports a very rich set of methods to transform data into visual representation
D3 (and thus the charting systems) supports two basic types of scales:
* Quantitive - repesenting an continous data domain, such as number or dates
* Ordinal - representing an enumeration of descrete values, such as names or categories. 
For a more detailed discussion please see <https://github.com/mbostock/d3/wiki/Scales>

The scale attributes describe how the data value is translated in the visual representation (e.g. a date value into a horizontal pixel offset) Details are with the different scale types. Please note that x,y,color and size dimensions are quantitive by nature, and ca ne used to represent quantitive domsins direcly. 
Shape scales are ordinal, thus in order to represent quantitative data through shapes the data needs to be categorized into a limited number of categories that ca then be represented through shapes. d2 (and thus charts) supports a a number of means (e.g. thresholds) to achieve this. See ... for details

## Layout

The layout defined how the dimensions are graphically represented. The Charts package supports the following layout types:

* Line 
* Area
* Bar
* Clustered Bar
* Stacked Bar
* Bubble
* Scatter
* Pie
* Gauge
* Geographic Map

Each of the layout types will be described in detail in chapter xxx

## Interactive Behaviors 

Once the chart is drawn on the screen, the Charts package supports a number o different dynamic interactions, called 'behaviors' (in alignment with d3) in this document

### Tooltips

Tooltips are displayed when the user moves the mouse over a object in the cart, and display the dimensional source values, as well as other (user defined) attributes of the represented object. While tooltis can be enabled or disabled, all layout types support them.

### Brush and Selection

Brush and selection allow the user to select a subset of the data subset and highlights the selection, and fires appropriate events to trigger action in the hosting application. Mot all layout types support brushing an selection, see description of layout types for details
Brush and Selection an be enabled and disabled for each layout instance

### Pan and Zoom

Pan and zoom allow to move a chart in its drawing window, resp allow to resize the chart with the mouse. In the current version only Geographic Maps support this behavior

## Data 

### Basic Data Format

Charts expects data to be a 'array of objects' (row oriented data) or an 'object of arrays' (column oriented data). When defined the chart dimensions, the object attribute names are used to referred to the data series, the array elements (or, in case of 'object of arrays' the index of the arrays) identify a single data element to be drawn.

### Layers (or data series) 

Charts refers to data series (e.g. the temperature over time for different cities) in the data as layers. A number of layout types (line, stacked bad or area, clustered bar, ...) can represent several layers or series. 

The data attributes that are drawn in layers can be specified explicitly (in the property attribute if the dimension), or are derived implicitly for the data supplied. The layers are derived by using the list of data properties minus the properties explicitly assigned to other chart dimensions. 
 

