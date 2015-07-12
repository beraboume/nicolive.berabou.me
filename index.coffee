io= require './server/nicolive.io'

io.listen 59798,->
  console.log 'Listen to http://localhost:59798'
