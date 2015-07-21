return unless window? # No execute for server-side require

module.exports= ($localStorage,$mdDialog,voices)->
  viewModel= this
  viewModel.$storage= $localStorage
  
  viewModel.voices= voices
  viewModel.close= ->
    $mdDialog.hide()

  viewModel
