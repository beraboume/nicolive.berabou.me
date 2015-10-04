return unless window? # No execute for server-side require

# Dependencies
app= require './app'

# Routes
app.config ($urlRouterProvider)->
  $urlRouterProvider.when '','/'

app.config ($stateProvider)->
  $stateProvider.state 'root',
    views:
      header:
        template: require './root/header.jade'
        controller: require './root/header.coffee'
        controllerAs: 'header'
      footer:
        template: require './root/footer.jade'
        controller: require './root/footer.coffee'
        controllerAs: 'footer'

app.config ($stateProvider)->
  $stateProvider.state 'root.top',
    url: '/'
    views:
      'container@':
        template: require './top/index.jade'

app.config ($stateProvider)->
  $stateProvider.state 'root.viewer',
    url: '/:id?sessionId'
    resolve:
      (require './viewer/index').resolve
    views:
      'container@':
        template: require './viewer/index.jade'
        controller: (require './viewer/index').controller
        controllerAs: 'viewer'
