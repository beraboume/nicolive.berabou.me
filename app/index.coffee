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

app.constant 'Bluebird', require 'bluebird'
app.constant 'throat', require 'throat'

# ref: http://stackoverflow.com/questions/14692640/angularjs-directive-to-replace-text
app.constant 'urlPattern',/(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/gi

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
  $rootScope.$storage= $localStorage.$default {
    reader:
      voice: 'off'
      pitch: 100
      speed: 100
      volume: 100
      emotion: ''
      emotion_level: 1
  }
  $rootScope.voices= voices

  $rootScope.outside= (event,url)->
    options=
      locals: {url}
      template: (require './services/outside.jade')()
      controller: 'outsideController as outside'
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
