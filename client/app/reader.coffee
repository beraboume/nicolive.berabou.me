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

  voices= (
    for voice in ['hikari','haruka','show','takeru','santa','bear']
      {lang:'ja-VT',name:voice}
  ).concat voices

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

# TODO: 複数のコメントを同時に読み上げるので、directiveのキューを実装したい
app.factory 'Voicetext',(Sound)->
  url= 'http://voicetext.berabou.me/'

  class Voicetext
    constructor: (@text,@speaker='hikari')->
      sound= new Sound url+encodeURIComponent(@text.slice(0,200))
      sound.play()

  Voicetext
