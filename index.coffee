# Environment
process.env.PORT?= 59798
process.env.DOCKER_IP?= 'localhost'# for redis

# Boot
io= require './server/nicolive.io'
io.listen process.env.PORT,->
  console.log 'Listen to http://localhost:'+process.env.PORT
