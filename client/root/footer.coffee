return unless window? # No execute for server-side require

module.exports= (socket)->
  viewModel= this

  viewModel.options=
    mail: '184'

  viewModel.comment= ->
    socket.emit 'comment',viewModel.text,viewModel.options

    viewModel.text= ''
  
  viewModel
