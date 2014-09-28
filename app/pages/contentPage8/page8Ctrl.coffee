angular.module('wk.chart').controller 'Page8Ctrl', ($log, $scope, $interval) ->


  $scope.spiderData = [
    {axis:"Email",Smartphone:0.59,Tablet:0.48},
    {axis:"Social Networks",Smartphone:0.56,Tablet:0.41},
    {axis:"Internet Banking",Smartphone:0.42,Tablet:0.27},
    {axis:"News Sportsites",Smartphone:0.34,Tablet:0.28},
    {axis:"Search Engine",Smartphone:0.48,Tablet:0.46},
    {axis:"View Shopping sites",Smartphone:0.14,Tablet:0.29},
    {axis:"Paying Online",Smartphone:0.11,Tablet:0.11},
    {axis:"Buy Online",Smartphone:0.05,Tablet:0.14},
    {axis:"Stream Music",Smartphone:0.07,Tablet:0.05},
    {axis:"Online Gaming",Smartphone:0.12,Tablet:0.19},
    {axis:"Navigation",Smartphone:0.27,Tablet:0.14},
    {axis:"App connected to TV program",Smartphone:0.03,Tablet:0.06},
    {axis:"Offline Gaming",Smartphone:0.12,Tablet: 0.24},
    {axis:"Photo Video",Smartphone:0.4,Tablet:0.17},
    {axis:"Reading",Smartphone:0.03,Tablet:0.15},
    {axis:"Listen Music",Smartphone:0.22,Tablet:0.12},
    {axis:"Watch TV",Smartphone:0.03,Tablet:0.1},
    {axis:"TV Movies Streaming",Smartphone:0.03,Tablet:0.14},
    {axis:"Listen Radio",Smartphone:0.07,Tablet:0.06},
    {axis:"Sending Money",Smartphone:0.18,Tablet:0.16},
    {axis:"Other",Smartphone:0.07,Tablet:0.07},
    {axis:"Use less Once week",Smartphone:0.08, Tablet:0.17}
  ]

  $scope.map = {
    center: {
      latitude: 48.1265,
      longitude: 11.5433
    },
    zoom: 18
  }