io= require './server/nicolive.io'

port= process.env.PORT
port?= 59798

io.listen port,->
  console.log 'Listen to http://localhost:'+port
