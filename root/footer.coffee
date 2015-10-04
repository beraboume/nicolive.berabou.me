# Dependencies
app= angular.module process.env.APP

# Public
app.controller 'footerController',($localStorage,socket)->
  viewModel= this

  viewModel.$storage= $localStorage.$default {chat:{mail:'184'}}

  viewModel.comment= ->
    socket.emit 'comment',viewModel.text,viewModel.$storage.chat

    viewModel.text= ''
  
  viewModel
