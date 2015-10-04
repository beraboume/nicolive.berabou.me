return unless window? # No execute for server-side require

# Dependencies
app= angular.module process.env.APP

# Private
AudioContext= (window.AudioContext or window.webkitAudioContext)
audioContext= new AudioContext if AudioContext

# Public
app.factory 'Sound',($http)->
  class Sound
    constructor: (url)->
      return new Audio url unless audioContext# Fix >=IE11

      $http.get url,{responseType:'arraybuffer'}
      .then (response)=>
         audioContext.decodeAudioData response.data,(@buffer)=>
           @play() if @onloadplay

    play: ->
      unless @buffer
        @onloadplay= yes
      else
        source= audioContext.createBufferSource()
        source.buffer= @buffer
        source.connect audioContext.destination
        source.start 0

  Sound
