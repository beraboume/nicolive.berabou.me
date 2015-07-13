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
            $rootScope.picture_url= playerStatus.picture_url
            $rootScope.default_community= playerStatus.default_community

            resolve socket

module.exports.controller= (
  $localStorage
  server
  $window
  $timeout
  $state
  reader
)->
  viewModel= this

  server.once 'thread',(thread)->

  # 次枠ある？
  server.once 'end_of_thread',(chat)->
    i= 0
    intervalId= setInterval ->
      return clearInterval intervalId if i++>=30 # 5分で再施行停止

      server.emit 'current'
    ,1000* 10# sec
    server.once 'current',(playerStatus)->
      clearInterval intervalId

      $state.go $state.current,playerStatus,{reload:true}

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
    reader text

  viewModel
