# Dependencies
app= angular.module process.env.APP

# Public
app.controller 'viewerController',(
  $rootScope
  $localStorage
  server
  $window
  $timeout
  $state
  reader
)->
  viewModel= this

  viewModel.chats= []
  server.removeAllListeners 'chat'
  server.on 'chat',(chat)->
    viewModel.chats.push chat

    $timeout ->
      $window.scrollBy 0,$window.document.body.clientHeight

  viewModel.comment= ->
    server.emit 'comment',viewModel.text
    server.once 'chat_result',(chat_result)->

    viewModel.text= ''

  viewModel.show= (event,userId)->
    url=
      if userId.match(/^\d+$/) and userId isnt '900000000'
        "http://www.nicovideo.jp/user/#{userId}"
      else
        null

    if url
      $window.open url,'user','width=465,height=465'

    return

  viewModel.read= (text)->
    reader.read text

  viewModel
