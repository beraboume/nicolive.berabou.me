return unless window? # No execute for server-side require

module.exports= (socket)->
  viewModel= this

  viewModel.options=
    mail: '184'

  viewModel.comment= ->
    console.log 'comment to',viewModel.text

    socket.emit 'comment',viewModel.text,viewModel.options
    socket.once 'chat_result',(chat_result)->
      console.log chat_result

    viewModel.text= ''
  
  viewModel
