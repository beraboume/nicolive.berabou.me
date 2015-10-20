# Dependencies
app= angular.module process.env.APP

# Public
app.factory 'Sound',($http,Bluebird)->
  class Sound
    constructor: (url)->
      @audio= new Audio url

    play: ->
      new Bluebird (resolve)=>
        @audio.play()
        @audio.onended= resolve

  Sound
