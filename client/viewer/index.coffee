return unless window? # No execute for server-side require

module.exports.resolve=
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
            console.log playerStatus
            $rootScope.title= playerStatus.title

            resolve socket

module.exports.controller= ($localStorage,server,$window,$timeout)->
  viewModel= this

  server.removeAllListeners 'thread'
  server.on 'thread',(thread)->
    console.log 'thread',thread

  viewModel.chats= []
  server.removeAllListeners 'chat'
  server.on 'chat',(chat)->
    viewModel.chats.push chat

    $timeout ->
      $window.scrollBy 0,$window.document.body.clientHeight

  viewModel.comment= ->
    console.log 'comment to',viewModel.text

    server.emit 'comment',viewModel.text
    server.once 'chat_result',(chat_result)->
      console.log chat_result

    viewModel.text= ''

  viewModel
