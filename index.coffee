# Environment
process.env.APP= 'nicolive.io'

# Dependencies
app= require './app'

require './root/header.coffee'
require './root/footer.coffee'
require './root/setting.coffee'
require './root/view.coffee'
require './viewer'

# Routes
app.config ($urlRouterProvider)->
  $urlRouterProvider.when '','/'

app.config ($stateProvider)->
  $stateProvider.state 'root',
    views:
      header:
        template: (require './root/header.jade')()
        controller: 'headerController as header'
      footer:
        template: (require './root/footer.jade')()
        controller: 'footerController as footer'

app.config ($stateProvider)->
  $stateProvider.state 'root.top',
    url: '/'
    views:
      'container@':
        template: (require './top/index.jade')()

app.config ($stateProvider)->
  $stateProvider.state 'root.viewer',
    url: '/:id?sessionId'
    resolve:
      server:
        ($q,$localStorage,$stateParams,socket,$rootScope)->
          $q.when()
          .then ->
            $q (resolve)->
              socket.emit 'auth',$localStorage.session
              socket.removeAllListeners 'authorized'
              socket.on 'authorized',resolve
          .then ->
            $q (resolve)->
              socket.emit 'view',decodeURIComponent($stateParams.id),{res_from:100}
              socket.removeAllListeners 'getplayerstatus'
              socket.on 'getplayerstatus',(playerStatus)->
                $rootScope.title= playerStatus.title
                $rootScope.picture_url= playerStatus.picture_url
                $rootScope.default_community= playerStatus.default_community

                resolve socket
    views:
      'container@':
        template: (require './viewer/index.jade')()
        controller: 'viewerController as viewer'
