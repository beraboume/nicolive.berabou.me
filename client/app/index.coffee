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
require './reader'

app.constant 'angularMomentConfig',
  preprocess: 'unix'

app.config ($mdThemingProvider)->
  $mdThemingProvider.theme 'default'
    .primaryPalette 'blue-grey'
    .accentPalette 'orange'
    # .warnPalette ''
    # .backgroundPalette ''

app.run (
  $rootScope
  $localStorage
  voices

  $window
  $mdDialog

  $state
  cfpLoadingBar
  notify
)->
  $rootScope.$storage= $localStorage.$default {voice:'off'}
  $rootScope.voices= voices

  $rootScope.outside= (event,url)->
    options=
      locals: {url}
      template: require './outside.jade'
      controller: require './outside.coffee'
      controllerAs: 'outside'
      bindToController: yes

      focusOnOpen: false
      clickOutsideToClose: true
      parent: angular.element document.body
      targetEvent: event

    $mdDialog.show options
  
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
