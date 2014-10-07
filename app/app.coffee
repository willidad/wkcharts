angular.module('wk.chart', [])

angular.module('app', ['ui.router','ui.bootstrap','ngAnimate', 'app.templates', 'wk.chart']).config(($stateProvider, $urlRouterProvider) ->
  #$locationProvider.html5Mode(true)
    pagesPath = 'app/pages/'

    $urlRouterProvider
      .otherwise "/"

    $stateProvider
      .state 'page1',
        views:
          'top':
            templateUrl: pagesPath + 'topnav/top.jade'
            controller: 'TopCtrl'
          'left':
            templateUrl: pagesPath + 'left/left.jade'
            controller: 'LeftCtrl'
          'content':
            templateUrl: pagesPath + 'contentPage1/page1.jade'
            controller: 'Page1Ctrl'
          'right':
            templateUrl: pagesPath + 'right/right.jade'
            controller: 'RightCtrl'
          'footer':
            templateUrl: pagesPath + 'footer/footer.jade'
            controller: 'FooterCtrl'
        url: '/'
      .state 'page2',
        views:
          'top':
            templateUrl: pagesPath + 'topnav/top.jade'
            controller: 'TopCtrl'
          'content':
            templateUrl: pagesPath + 'contentPage2/page2.jade'
            controller: 'Page2Ctrl'
          'right':
            templateUrl: pagesPath + 'right/right.jade'
            controller: 'RightCtrl'
          'footer':
            templateUrl: pagesPath + 'footer/footer.jade'
            controller: 'FooterCtrl'
        url: '/page2'
    .state 'page3',
      views:
        'top':
          templateUrl: pagesPath + 'topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: pagesPath + 'contentPage3/page3.jade'
          controller: 'Page3Ctrl'
        'right':
          templateUrl: pagesPath + 'right/right.jade'
          controller: 'RightCtrl'
        'footer':
          templateUrl: pagesPath + 'footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page3'
    .state 'page4',
      views:
        'top':
          templateUrl: pagesPath + 'topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: pagesPath + 'contentPage4/page4.jade'
          controller: 'Page4Ctrl'
        'right':
          templateUrl: pagesPath + 'right/right.jade'
          controller: 'RightCtrl'
        'footer':
          templateUrl: pagesPath + 'footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page4'
    .state 'page5',
      views:
        'top':
          templateUrl: pagesPath + 'topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: pagesPath + 'contentPage5/page5.jade'
          controller: 'Page5Ctrl'
        'right':
          templateUrl: pagesPath + 'right/right.jade'
          controller: 'RightCtrl'
        'footer':
          templateUrl: pagesPath + 'footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page5'
    .state 'page6',
      views:
        'top':
          templateUrl: pagesPath + 'topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: pagesPath + 'contentPage6/page6.jade'
          controller: 'Page6Ctrl'
        'right':
          templateUrl: pagesPath + 'contentPage6/right.jade'
        'footer':
          templateUrl: pagesPath + 'footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page6'
    .state 'page7',
        views:
          'top':
            templateUrl: pagesPath + 'topnav/top.jade'
            controller: 'TopCtrl'
          'content':
            templateUrl: pagesPath + 'contentPage7/page7.jade'
            controller: 'Page7Ctrl'
          'footer':
            templateUrl: pagesPath + 'footer/footer.jade'
            controller: 'FooterCtrl'
        url: '/page7'
    .state 'page8',
      views:
        'top':
          templateUrl: pagesPath + 'topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: pagesPath + 'contentPage8/page8.jade'
          controller: 'Page8Ctrl'
        'footer':
          templateUrl: pagesPath + 'footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page8'
    .state 'page9',
      views:
        'top':
          templateUrl: pagesPath + 'topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: pagesPath + 'contentPage9/page9.jade'
          controller: 'Page9Ctrl'
        'footer':
          templateUrl: pagesPath + 'footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page9'
    .state 'page10',
      views:
        'top':
          templateUrl: pagesPath + 'topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: pagesPath + 'contentPage10/page10.jade'
          controller: 'Page10Ctrl'
        'footer':
          templateUrl: pagesPath + 'footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page10'


)