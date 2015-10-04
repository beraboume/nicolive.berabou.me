# Dependencies
app= angular.module process.env.APP

# Public
app.controller 'settingController',($scope,$localStorage,$mdDialog,voices,reader)->
  viewModel= this
  viewModel.words= 'ゆっくりしていってね'
  viewModel.voices= voices
  viewModel.$storage= $localStorage
  viewModel.emotions= [
    ''
    'happiness'
    'anger'
    'sadness'
  ]
  viewModel.emotionNames= [
    'ふつう'
    '楽しい'
    '怒り'
    '悲しい'
  ]

  $scope.$watch ->
    viewModel.$storage.reader

  ,(options,old)->
    viewModel.voice= (voice for voice in voices when voice.name is $localStorage.reader?.speaker)[0]

    return viewModel.read() if options.speaker isnt old.speaker
    return viewModel.read() if options.volume isnt old.volume
    return viewModel.read() if options.pitch isnt old.pitch
    return viewModel.read() if options.speed isnt old.speed
    return viewModel.read() if options.emotion isnt old.emotion
    return viewModel.read() if options.emotion_level isnt old.emotion_level
  ,true

  viewModel.read= ->
    reader.read viewModel.words

  viewModel.close= ->
    $mdDialog.hide()

  viewModel
