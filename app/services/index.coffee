# Dependencies
app= angular.module process.env.APP

require './reader'
require './sound'
require './sound-enabler'
require './outside'

# Publish services
app.factory 'notify',($state,$mdToast,$rootScope)->
  (message)->
    simpleToast=
      $mdToast.simple()
        .content message
        .position 'top right'
        .hideDelay 2000

    $mdToast.show simpleToast

    return if $rootScope.waitForNext

    $state.go 'root.top'

app.factory 'socket',(socketFactory,notify)->
  socket= socketFactory()
  socket.on 'warn',(error)->
    notify error
  socket

app.directive 'autofocus',($timeout)->
  (scope,element)->
    $timeout ->
      element[0].focus()

app.directive 'fetchNickname',(Bluebird,socket)->
  cache= {}

  scope:
    userId: '=fetchNickname'
  link: (scope,element,attrs)->
    userId= scope.userId

    promise=
      if cache[userId]
        cache[userId]

      else
        isFirst= yes
        new Bluebird (resolve,reject)->
          socket.emit 'nickname',userId,(error,nickname)->
            return reject error if error
            resolve nickname

        .catch ->
          userId

    # TODO: 大所帯だとメモリえらいことになりそう
    cache[userId]= promise

    promise
    .then (nickname)->
      element.text nickname
      element.css 'font-weight','bold' if isFirst

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

app.filter 'parseUrl',($sce)->
  # ref: http://stackoverflow.com/questions/14692640/angularjs-directive-to-replace-text
  urlPattern= /(http|ftp|https):\/\/[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:\/~+#-]*[\w@?^=%&amp;\/~+#-])?/gi;

  (text)->
    keys=
      '<':'&lt;'
      '>':'&gt;'
      '"':'&quot;'
      '\'':'&apos;'
    linked= text.replace /([<>"'])/g,(key)-> keys[key]
    linked= linked.replace urlPattern,'<a href="$&" target="_blank">$&</a>'
    # linked= linked.replace urlPattern,'<a href="#" onclick="angular.element(document.querySelector(\'main\')).scope().outside(event,\'$&\');return false;">$&</a>'
    $sce.trustAsHtml linked

# etc...
