return unless window? # No execute for server-side require

# Environment
process.env.APP= 'nicolive.io'

# Setup angular module
app= angular.module process.env.APP,[
  'angular-loading-bar'
  'ui.router'
  
  'ngMaterial'
  'ngAnimate'
  'ngStorage'
  'btford.socket-io'

  'angularMoment'
]

require './services'

app.constant 'angularMomentConfig',
  preprocess: 'unix'

app.config ($mdThemingProvider)->
  $mdThemingProvider.theme 'default'
    .primaryPalette 'blue-grey'
    .accentPalette 'orange'
    # .warnPalette ''
    # .backgroundPalette ''

app.run ($rootScope,$localStorage,$state,cfpLoadingBar,notify)->
  $rootScope.$storage= $localStorage.$default {voice:'off'}
  
  $rootScope.$on '$stateChangeStart',->
    cfpLoadingBar.start()
  $rootScope.$on '$stateChangeSuccess',->
    cfpLoadingBar.complete()
  $rootScope.$on '$stateChangeError',(event,toState,toParams,fromState,fromParams,error)->
    cfpLoadingBar.complete()

    if error
      console.error error
      notify error.statusText

    $state.go 'root.top'

angular.element(document).ready ->
  angular.bootstrap document,[process.env.APP]


module.exports= app
