return unless window? # No execute for server-side require

module.exports= ($window,$mdDialog)->
  viewModel= this
  viewModel.jump= ->
    $window.open viewModel.url
    $mdDialog.hide()
  viewModel.cancel= ->
    $mdDialog.cancel()

  viewModel
