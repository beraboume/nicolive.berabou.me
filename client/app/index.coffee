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
  
  $rootScope.$on '$stateChangeStart',(event,to,toParams,from,fromParams)->
    cfpLoadingBar.start()

    # nicolive.berabou.me-boot-buttonからのquerystring「?sessionId=」を受け取る
    if toParams.sessionId
      event.preventDefault()
      $localStorage.session= toParams.sessionId
      delete toParams.sessionId
      
      $state.go to,toParams

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
