# Dependencies
express= require 'express'
dhs= require 'difficult-http-server'
NicoliveIo= (require 'nicolive.io').NicoliveIo
socketIoRedis= require 'socket.io-redis'

# Environment
cwd= __dirname
bundleExternal= yes
process.env.DOCKER_IP?= 'localhost'# for redis
process.env.PORT?= 59798

# Setup express
app= express()
app.set 'json spaces',2

# Routes
app.use dhs {cwd,bundleExternal}

# Setup socket.io
server= new NicoliveIo app
server.adapter socketIoRedis {host:process.env.DOCKER_IP,port:'6379'}

# Boot
server.listen process.env.PORT,->
  console.log 'Listen to http://localhost:'+process.env.PORT
