# Dependencies
app= angular.module process.env.APP

# Public
app.controller 'viewController',($localStorage,$mdDialog)->
  viewModel= this
  viewModel.$storage= $localStorage
  viewModel.submit= ->
    $mdDialog.hide $localStorage
  viewModel.cancel= ->
    $mdDialog.cancel()

  viewModel
