Fixed:d3a5e10 1. Chrome / Firefox : drawing area gets resized after first data change. Seems to be a problem with the browser size calculation timing - seems to assume it needs a vertical page scoll bar at initial sizing. (no problem in IE)
Fixed:d3a5e10 2. (related to 1.) brush extent cannot be moved to very right border.
Fixed:d3a5e10 3. Charts so not resize when browser window resizes (not related to 1 and 2)
Fixed:eeb0213 4. Stacked Area chart:  Enter animations wrong
Fixed:938bb94 5. Stacked Bar: layer enter animation wrong
Fixed:91eaba5 6. Clustered Bar: Exit animation for top layer wrong (65+years)
Fixed:1b4fbcd 7. Line Chart: lines not positioned correctly after deletion of last data records on ordinal x scale. Does not re-calculate position
8. Line Chart: Enter and exit animation look bad. need better appearance
9. Area Charts (hor and verAreas): areas are colored with opacity 0.7. Color legends and tooltip colors are Use opacity there too, or go back to opacity 1 for ares
Fixed:6efb665 10. Line Charts, Area Charts: Tooltip markers (line and bubbles) are not on top of of drawing area (i.e. are hidden by area chart if area opacity = 1). See 9 also
11. Clustered bar chart: Tooltips flicker (show / hide) when moving over a cluster. Should only change when moving between clusters (page 5)
Fixed: 12. Page 6: Brush resize handles are not shown - should we bring these back. 
13. Page 6: Brush area are not set initially -empty brush. Should we set to full range again (as in earlier versions)
Fixed:34db808 14. Page 7: Legend is not reset to a internal position after placed in external div once
15. Inconsistent animations of axis and chart after changing axis position or removing axis display or axis label
16. Spider Chart (all chart) long tooltip lists do not fit on screen. Need to find a way to display all values (scrolling? two columns?)
Fixed:20fa409 17. Brush (All charts) While brushing, moving mouse over legend or outside drawing area causes HTML text selection highlighting.
Fixed:20fa409 18. Brush: (FireFox, IE only) in certain (unknown cause) situations pressing mouse and moving causes a image drag and drop instead if brush move. Appearently browser treats SVG as image and drags it. 
19. Legend: enter / exit animation inconsistent, ugly and with inconsistent timing
20. Selection Marker (red line around selected object) ugly. Need better solution for highlighting selection
21. GeoMap: Maps: water areas can not be dragged (is a geoJson problem, not a in charts code)
Fixed:4adfe3f 22. when parsing tooltip or legend template angular throws error when interpolating path value for shape(works correctly though). Error: Invalid value for <path> attribute d="{{ttRow.path}}" 
23: BrushArea does not resize when chart container resizes -> selection changes if browser viewport gets changed
Fixed:eeb0213 24: Page 6 chart at Top Right Area layout does not show tooltip market
24: Area Chart enter and exit animation looks bad (related to 8)
25: When axis are re-configured or new data, brush extent is removed and full range is shown. Should maintain the configured brush extent (Page 7) or reset the brush
26: Page 7: Axis are animated on initial load. Not true for all other charts on other pages. Must be some special case due to bound attributes. 