express = require 'express'
app = require('express')()
http = require('http').Server(app)
global.io = require('socket.io')(http)
hbs = require 'express-handlebars'
routes = require "./app/routes"

fs = require "fs"
utils = require "./modules/utils"
lame = require "lame"
speaker = require "speaker"

bodyParser = require "body-parser"
path = require "path"

hbsInstance = hbs.create(
  extname: '.html'
)


app.engine 'html', hbsInstance.engine
app.set "view engine", "html"
app.set "views", "./app/views"
app.use express.static("./app/public")
app.use express.static("./resources")
app.use "/", routes
app.use bodyParser.json()

global.io.on 'connection', (socket) ->
  socket.on 'chat message', (msg) ->
    global.io.emit 'chat message', msg
    utils.log "data", "msg: #{msg}"
    return
  return

global.is_admin = false
global.stream = null
global.current_id = null
global.reshow = false

http.listen process.env.PORT, ->
  utils.log "hr"
  utils.log "hr"
  utils.log "hr"
  utils.log "info", "listening on *:#{process.env.PORT}"
  admin_file = "./resources/tags/admin.json"
  try
    result = fs.accessSync admin_file
    global.stream =
      fs.createReadStream "./resources/audio/welcome.mp3"
      .pipe new lame.Decoder
  catch
    global.stream =
      fs.createReadStream "./resources/audio/make_admin_key.mp3"
      .pipe new lame.Decoder
  global.stream.pipe new speaker()

  return
