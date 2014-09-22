angular.module('wk.chart', [])

angular.module('app', ['ui.router','ui.bootstrap','ngAnimate', 'app.templates', 'wk.chart']).config(($stateProvider, $urlRouterProvider) ->
  #$locationProvider.html5Mode(true)

    $urlRouterProvider
      .otherwise "/"

    $stateProvider
      .state 'page1',
        views:
          'top':
            templateUrl: 'app/topnav/top.jade'
            controller: 'TopCtrl'
          'left':
            templateUrl: 'app/left/left.jade'
            controller: 'LeftCtrl'
          'content':
            templateUrl: 'app/contentPage1/page1.jade'
            controller: 'Page1Ctrl'
          'right':
            templateUrl: 'app/right/right.jade'
            controller: 'RightCtrl'
          'footer':
            templateUrl: 'app/footer/footer.jade'
            controller: 'FooterCtrl'
        url: '/'
      .state 'page2',
        views:
          'top':
            templateUrl: 'app/topnav/top.jade'
            controller: 'TopCtrl'
          'content':
            templateUrl: 'app/contentPage2/page2.jade'
            controller: 'Page2Ctrl'
          'right':
            templateUrl: 'app/right/right.jade'
            controller: 'RightCtrl'
          'footer':
            templateUrl: 'app/footer/footer.jade'
            controller: 'FooterCtrl'
        url: '/page2'
    .state 'page3',
      views:
        'top':
          templateUrl: 'app/topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: 'app/contentPage3/page3.jade'
          controller: 'Page3Ctrl'
        'right':
          templateUrl: 'app/right/right.jade'
          controller: 'RightCtrl'
        'footer':
          templateUrl: 'app/footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page3'
    .state 'page4',
      views:
        'top':
          templateUrl: 'app/topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: 'app/contentPage4/page4.jade'
          controller: 'Page4Ctrl'
        'right':
          templateUrl: 'app/right/right.jade'
          controller: 'RightCtrl'
        'footer':
          templateUrl: 'app/footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page4'
    .state 'page5',
      views:
        'top':
          templateUrl: 'app/topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: 'app/contentPage5/page5.jade'
          controller: 'Page5Ctrl'
        'right':
          templateUrl: 'app/right/right.jade'
          controller: 'RightCtrl'
        'footer':
          templateUrl: 'app/footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page5'
    .state 'page6',
      views:
        'top':
          templateUrl: 'app/topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: 'app/contentPage6/page6.jade'
          controller: 'Page6Ctrl'
        'right':
          templateUrl: 'app/contentPage6/right.jade'
        'footer':
          templateUrl: 'app/footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page6'
    .state 'page7',
      views:
        'top':
          templateUrl: 'app/topnav/top.jade'
          controller: 'TopCtrl'
        'content':
          templateUrl: 'app/contentPage7/page7.jade'
          controller: 'Page7Ctrl'
        'footer':
          templateUrl: 'app/footer/footer.jade'
          controller: 'FooterCtrl'
      url: '/page7'
)