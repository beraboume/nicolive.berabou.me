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

  viewModel.voiceNames= []
  return if viewModel.voiceNames.length

  voices= $window.speechSynthesis?.getVoices() or []
  if voices.length
    viewModel.voiceNames.push 'off'
    for voice in voices when voice.lang is 'ja-JP'
      viewModel.voiceNames.push voice.name unless voice.name in viewModel.voiceNames

  # polyfill for chrome
  $window.speechSynthesis.onvoiceschanged= ->
    return if viewModel.voiceNames.length

    voices= $window.speechSynthesis?.getVoices() or []
    viewModel.voiceNames.push 'off'
    viewModel.voiceNames.push voice.name for voice in voices when voice.lang is 'ja-JP'

  viewModel
