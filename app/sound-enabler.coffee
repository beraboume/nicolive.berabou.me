# Dependencies
app= angular.module process.env.APP

# Fix issue#1 https://github.com/59naga/nicolive.berabou.me/issues/1
app.run ($window,Sound)->
  sound= new Sound 'app/sound-enabler.wav'

  enable= ->
    $window.removeEventListener 'touchstart',enable
    sound.play()

  $window.addEventListener 'touchstart',enable
