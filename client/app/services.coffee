return unless window? # No execute for server-side require

# Dependencies
app= angular.module process.env.APP

# Publish services
app.factory 'socket',(socketFactory,notify)->
  socket= socketFactory()
  socket.on 'warn',(error)->
    notify error
  socket

app.factory 'notify',($mdToast)->
  (message)->
    simpleToast=
      $mdToast.simple()
        .content message
        .position 'top right'
        .hideDelay 2000

    $mdToast.show simpleToast

app.directive 'autofocus',($timeout)->
  (scope,element)->
    $timeout ->
      element[0].focus()

app.directive 'fetchNickname',($q,socket)->
  cache= {}

  scope:
    userId: '=fetchNickname'
  link: (scope,element,attrs)->
    userId= scope.userId

    $q (resolve,reject)->
      return resolve cache[scope.userId] if cache[scope.userId]?

      socket.emit 'nickname',scope.userId,(error,nickname)->
        reject error if error
        resolve nickname
    .then (nickname)->
      element.text nickname

app.directive 'fetchAvatar',($q)->
  cache= {}
  noimage= 'http://uni.res.nimg.jp/img/user/thumb/blank.jpg'

  scope:
    userId: '=fetchAvatar'
  link: (scope,element,attrs)->
    return element.attr 'src',cache[scope.userId] if cache[scope.userId]?

    url=
      if scope.userId.match(/^\d+$/) and scope.userId isnt '900000000'
        'http://usericon.nimg.jp/usericon/'+scope.userId.slice(0,scope.userId.length-4)+'/'+scope.userId+'.jpg'
      else
        noimage

    element.attr 'src',url
    element.bind 'load',->
      cache[scope.userId]?= url
    element.bind 'error',->
      cache[scope.userId]?= noimage
      
      element.attr 'src',noimage

app.directive 'read',($window,$localStorage)->
  scope:
    chat: '=read'
  link: (scope,element,attrs)->
    {date,text}= scope.chat
    speech= null

    return unless $window.speechSynthesis

    scope.$watch ->
      $localStorage.voice
    ,(newVal)->
      $window.speechSynthesis.cancel()
      return if newVal is 'off'

      fresh= date*1000>Date.now()-1000 * 10#sec
      if fresh and $window.speechSynthesis
        speech= new SpeechSynthesisUtterance
        speech.text=  text
        speech.lang= 'ja-JP'
        for voice in $window.speechSynthesis.getVoices() or []
          continue if voice.name isnt $localStorage.voice
          speech.voice= voice

        $window.speechSynthesis.speak speech

# etc...
