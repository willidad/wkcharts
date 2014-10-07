#Architectural overview

## Core Components

    Chart
        |
        Container 
            |
            Layout
                |
                Scale
                |
                Scale

            

### Chart Object

The chart object corresponds to the chart directive and is the central registry for the components of the chart. It coordinates the chart lifecycle and triggers draw / redraw related actions in the sub-components.
The chart object is responsible for updating domains for all scales whenever new data arrives. 
It triggers the containers to redraw the components to owns (axis, labels,  legends, etc.) and the layouts to redraw the charts themselves. 

### Container Object

The container object has no corresponding directive. It creates and owns the SVG container structure and maintains the list of layouts and other objects that are drawn into its SVG area. 
It is responsible for drawing the x and y axis, corresponding grids and labels, and for defining the scale ranges for the x and y axis. 
It also scales and configures the drawing are for the layouts. 

### Layout Object

The layout object is primarily a proxy for the layout type directive and provides the interfaces for the types. 

### Scale / Dimension Object

This object handles all the task and definitions required to translate a data value to an visual representation. Apart form setters and getter to configure the Scale/Dimension it provides groups of interfaces to the other components: 
* Mapping interfaces to the layout types. These interfaces translate data to pixes positions, color values or shape paths.
* Range configuration interfaces to the container objects. 
* Domain configuration interfaces to the chart object
* It hosts the d3 Axis objects for the containers (Axis are configured as part of the dimension directives, so it is kept her for simplicity reasons)
* Access to the scale properties for several components

### ScaleList Object

This object maintains a the scale lists for the layouts and the chart object (for global scales). 
Apart from maintaining the list it exposes a 'kind' interface that hides the shared / local scale difference for the components that need access to the scales

### Legend Object

The legend object is responsible for creating, positioning and drawing the legends. It is triggered by the container object whenever a legend needs to be drawn

### Tooltip Object

This object is responsible for drawing the tooltips. It creates and removes the corresponding DOM objects and Angular Scopes, positions and moves the tooltips. 
It provides to key interfaces to the layout types
* a registration interface that registers mouse event handers withthe objects that have tooltips
* a data request interface that is called when a tooltip is created and moved. The interfaces provides the tooltip Scope and information about the tooltip object.


### The selection object

TBD

# The Chart Lifecycle

## Chart definition phase

The chart is defined by the chart directives and their attributes. Angular parses these creates the controllers and triggers the attribute watchers to initialize the values.

In doing so it creates the controllers top down, and triggers the watchers in reverse order. Thus, a attribute or element directive can assume that the controller for its parent is created and initialized, it cannot assume 
that any of the parents attributes has been parsed. It also needs to assume that attributes are initialized in an arbitrary sequence, and cannot make any assumptions about sister (i.e. with the same parent) directives. 
The of parsing a directives attributes res. attribute directives is depending on the writing orders, and thus not deterministic. Therefore all attribute handlers are async and cannot make any assumptions about other handlers being triggered before. 

## Chart drawing phase

Chart drawing starts when the data watcher is triggered. At this point we can assume that all directives have been parsed, this dimension and container objects have been parsed and initialized. We cannot assume that all attribute 
watchers have been triggered. 

The Angular digest phase that triggers the data watcher however will also trigger these watchers, so at the end of this phase everything will be evaluated.  

As pointed out above, the chart object drives the drawing life cycle. 

### Drawing life cycle

The steps in the live cycle are executed using the d3 dispatch mechanism. The components that are involved in the life cycle listen for the phase events they are involved in and do their work when it is triggered. 
The d3 dispatch mechanism is synchronous and chart object triggers the events in a defined sequence, so the event handlers can safely assume that the previous phases are completed when triggered.

The life cycle events are triggered in the following sequence

1. prepeare data: during this phase the layout types and scales can re-format the data and calculate certain additional values, like totals, averages, required to scale the axes and other elements. 
Any operations that depend on scales cannot be done in this phase

2. set scale domains: set the domain attributes for the scales based on the new data. 

3. size the container: this computes the container sizes and and sets the scales range accordingly. The sizing process reserves space for axis, legends etc, and creates the corresponding SVG groups

4. draw axis: Axis, labels grids and legends get drawn

5. draw chart: finally, the chart itself get drawn. Behaviours like tooltips, brushing, zoo, etc get registered

The cycle starts over whenever the data watcher fires on changed data. Other asynchronous changed, like a attribute change, restart the life cycle at a later stage, dependent on the type of change. 
Some of the watchers execute just one phase, like changing a label does not require that the full chart is re-drawn (see description of attributes for details)

# Chart behaviors

if registered, charts show interactive behaviors. These exist outside of the drawing life cycle, however may trigger the life cycle at a certain stage if necessary. 

## tooltips

Tooltips are HTML divs that get absolutely positioned in the document body to follow the cursor. 
 
Tooltips are self contained and temporary, and does not trigger the life cycle. During phase 5 the chart type calls the tooltip object to register its event handlers on the objects that receive tooltips. 
Tooltips then registers *mouseenter*, *mousemove* and *mouseleave* events. 

on creation of the tooltip object loads a (configuable) template from the Angular template cache, compiles it, binds it to an Angular scope. 

On *mouseenter* the tooltip template is appended to the document body.

It then calls a data callback registered by the layout type. This callback receives the scope of the tooltip and has to provide the data shown in the tooltip. 
After the exit returns the div positions get computed and added, and tooltip triggers the Angular digest phase to ensure the data is displayed in the right place. 

During *mousemove* the tooltip div is re-positioned to track the mouse position. Depending on the layout type, the data callback is called again to update the data.

On *mouseleave* the template is removed from the dom. The compiled template however is retained and reused whenever a tooltip is displayed. 

## Legend Object

The legend object draws and positions legends. Like the tooltip, a legend is a HTML Div that gets created form a template, compiled, linked to a scope and the appended and positioned in its container, typically 
the layout container. Legend objects are drawn through phase 4. 

## Selection Object

TBD