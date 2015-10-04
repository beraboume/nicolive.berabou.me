# Dependencies
app= angular.module process.env.APP

# Public
app.controller 'outsideController',($window,$mdDialog)->
  viewModel= this
  viewModel.jump= ->
    $window.open viewModel.url
    $mdDialog.hide()
  viewModel.cancel= ->
    $mdDialog.cancel()

  viewModel
