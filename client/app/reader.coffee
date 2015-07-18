return unless window? # No execute for server-side require

# Dependencies
app= angular.module process.env.APP

# Public
app.directive 'read',(reader)->
  scope:
    chat: '=read'
  link: (scope,element,attrs)->
    {date,text}= scope.chat

    reader.read text if date*1000>Date.now()-1000 * 10#sec  

# Private
app.factory 'voices',($window)->
  speechSynthesis= $window.speechSynthesis

  voices= []

  if speechSynthesis
    voices.push voice for voice in speechSynthesis.getVoices()

    unless voices.length
      speechSynthesis.onvoiceschanged= ->
        voices.push voice for voice in speechSynthesis.getVoices()

  for voice in ['hikari','show','haruka','takeru','santa','bear']
    voices.unshift {lang:'ja-VT',name:voice}

  voices.unshift {name:'off'}

  voices

app.factory 'reader',($localStorage,$window,$http,voices,Voicetext)->
  {
    SpeechSynthesisVoice
    SpeechSynthesisUtterance
    speechSynthesis
  }= $window

  class Reader
    read: (text)->
      voice= (voice for voice in voices when voice.name is $localStorage.voice)[0]

      return unless voice?.lang

      if voice.lang is 'ja-VT'
        voice= new Voicetext text,voice.name
        voice.play()

        console.log voice

      else
        speech= new SpeechSynthesisUtterance
        speech.text= text
        speech.lang= 'ja-JP' if voice.lang is 'ja-JP'
        speech.voice= voice

        if speech.lang is 'ja-JP'
          speechSynthesis.speak speech

        else
          $http.get 'http://romanize.berabou.me/'+encodeURIComponent(text)
          .then (response)->
            speech.text= response.data
            speechSynthesis.speak speech

            console.log speech.text

  new Reader

# TODO: 複数のコメントを同時に読み上げるので、キューを実装したい
app.factory 'Voicetext',($window,$http)->
  AudioContext= ($window.AudioContext or $window.webkitAudioContext)
  audioContext= new AudioContext

  url= 'http://voicetext.berabou.me/'

  class Voicetext
    constructor: (@text,@speaker='hikari')->
      $http
        method: 'GET'
        url: url+encodeURIComponent(@text.slice(0,200))
        params:
          speaker: @speaker
        responseType:'arraybuffer'
      .then (response)=>
        console.log response
        audioContext.decodeAudioData response.data,(buffer)=>
          @buffer= buffer
          @play() if @autoplay

    play: ->
      return if @coolTime?
      return @autoplay= on unless @buffer?

      source= audioContext.createBufferSource();
      source.buffer= @buffer
      source.connect audioContext.destination
      source.start 0
