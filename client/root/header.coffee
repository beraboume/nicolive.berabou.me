return unless window? # No execute for server-side require

module.exports= ($window,$mdDialog,notify,$state,$timeout)->
  viewModel= this
  viewModel.dialog= (event)->
    options=
      template: require './view.jade'
      controller: require './view.coffee'
      controllerAs: 'view'

      focusOnOpen: false
      clickOutsideToClose: true
      parent: angular.element document.body
      targetEvent: event

    $mdDialog.show options
    .then (storage)->
      id= storage.id
      id= id.match(/lv\d+/)[0] if id.match(/lv\d+/)
      id= id.match(/co\d+/)[0] if id.match(/co\d+/)
      id= id.match(/watch\/([\w\/]+)/)[1] if id.match(/watch\/([\w\/]+)/)
      storage.id= id

      notify '接続しています…'
      $state.go 'root.viewer',storage

  viewModel
