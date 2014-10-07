# Defining a chart

Charts are defined in HTML markup through a set of chart-specific Angular Directives. Any type of HTML generator or templating system can be used, as long as it can generate valid HTML. For this section we are using jade in a few places to define the examples

## Defining a simple chart

The following markup defines a simple pie chart: 

    <chart data="pieData">
        <layout pie>
            <color property="age"></color>
            <size property="population"></size>
        </layout>
    </chart>
            

The ` pieData ` object looks like this:

    [
        { "age":"<5", "population":2704659 },
        { "age":"5-13", "population":4499890 },
        { "age":"14-17", "population":2159981 },
        { "age":"18-24", "population":3853788 },
        { "age":"25-44", "population":14106543 },
        { "age":"45-64", "population":8819342 },
        { "age":"≥65", "population":612463 }
    ]
    
The resulting Pie Chart looks like this: 

![Pie Chart](pie1.png) Pie Chart

While this is a very simple and there is a number of options to refine the appearance of the chart, the basic elements of the chart markup are present:

`<chart data="pieData">`

starts the chart markup binds a scope variable to the chart data. The chart watches this variable and redraws itself whenever the data changes (Note: the data valiable is not 'deep watched' by default for performance reasons. THis can be enabled however if desired (see ....)

`<layout pie>` Defines that the data should be laid out as a pie chart. `<color property="age"></color>` defines that the *age* groups should be mapped into colors. 

The segment size is derived from the *population* properties, as defined in `<size property="population"></size>`

`color` and `size` are **dimensions** in our terminology. A dimension describes how exactly the data should be mapped to the graphical layout. 

The same data can be represented as a bar chart using the following markup:


    <chart data="pieData">
        <layout simple-bar>
            x(property="age", type="ordinal")
            y(property="population")
            color(property="age")
        </layout>
    </chart>
    
![Bar Chart](simplebar1.png) Bar Chart

As you can see we are using different dimensions to represent the same data. *population* goes on the vertical axis (`y`), whereas *age* is used for two different dimension, `x` and `color`
Please note that the x-dimension has a type definition `type="ordinal"` This tells the chart that *age* is a set of discrete values, in contrast to the y dimension, which is, in our terminology, a **quantitative** dimension. 
Each dimension needs a type, however there are default types for each that do not need to  be specified. We will explain this in a later section in more detail 