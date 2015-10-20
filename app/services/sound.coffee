# Dependencies
app= angular.module process.env.APP

# Private
AudioContext= (window.AudioContext or window.webkitAudioContext)
audioContext= new AudioContext if AudioContext

# Public
app.factory 'Sound',($http,Bluebird)->
  class Sound
    constructor: (url)->
      return new Audio url unless audioContext# Fix >=IE11

      @buffer= new Bluebird (resolve)->
        $http.get url,{responseType:'arraybuffer'}
        .then (response)->
          audioContext.decodeAudioData response.data,resolve

    play: ->
      @buffer
      .then (buffer)->
        new Bluebird (resolve)->
          source= audioContext.createBufferSource()
          source.buffer= buffer
          source.connect audioContext.destination
          source.start 0
          source.onended= resolve

  Sound
