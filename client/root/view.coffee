return unless window? # No execute for server-side require

module.exports= ($localStorage,$mdDialog)->
  viewModel= this
  viewModel.$storage= $localStorage
  viewModel.submit= ->
    $mdDialog.hide $localStorage
  viewModel.cancel= ->
    $mdDialog.cancel()

  viewModel
