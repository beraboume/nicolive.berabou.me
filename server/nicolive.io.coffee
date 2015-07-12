# Dependencies
NicoliveIo= (require 'nicolive.io').NicoliveIo
express= require 'express'
browserify= require 'browserify-middleware'
stylus= require 'stylus'
jade= require 'jade'

koutoSwiss= require 'kouto-swiss'

path= require 'path'
fs= require 'fs'

# Environment
appRoot= path.resolve __dirname,'..','client'
appDebug= process.env.NODE_ENV isnt 'production'

# Setup express
app= express()
app.set 'json spaces',2

# Setup static files
app.use express.static appRoot

# Setup coffee-script middleware
browserify.settings.production 'minify',false
browserify.settings 'transform',[
  'coffeeify'
  'browserify-plain-jade'
]
app.get '/index.js',browserify appRoot+path.sep+'index.coffee',
  extensions: ['.coffee']
  bundleExternal: false

# Setup jade (view engine)
app.set 'view engine','jade'
app.set 'views',appRoot
app.locals.basedir= appRoot
app.locals.pretty= appDebug
app.get '/',(req,res)->
  res.render 'index'

# Setup stylus middleware
cssCache= null
app.get '/index.css',(req,res)->
  if cssCache?
    res.set 'Content-type','text/css'
    res.set 'Content-length',Buffer.byteLength cssCache,'utf8'
    res.end cssCache
    return

  styl= appRoot+path.sep+'index.styl'
  stylData= fs.readFileSync styl,'utf8'

  stylus stylData
  .set 'filename',styl
  .set 'sourcemap',{inline:yes}
  .use koutoSwiss()
  .import 'kouto-swiss'
  .render (error,css)->
    throw error if error?

    cssCache?= css unless appDebug

    res.set 'Content-type','text/css'
    res.set 'Content-length',Buffer.byteLength css,'utf8'
    res.end css

module.exports= new NicoliveIo app
