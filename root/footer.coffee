return unless window? # No execute for server-side require

module.exports= ($localStorage,socket)->
  viewModel= this

  viewModel.$storage= $localStorage.$default {chat:{mail:'184'}}

  viewModel.comment= ->
    socket.emit 'comment',viewModel.text,viewModel.$storage.chat

    viewModel.text= ''
  
  viewModel
