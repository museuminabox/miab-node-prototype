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

hbsInstance = hbs.create(
  extname: '.html'
)

app.engine 'html', hbsInstance.engine
app.set "view engine", "html"
app.set "views", "#{__dirname}/app/views"
app.use express.static("#{__dirname}/app/public")
app.use "/", routes

global.io.on 'connection', (socket) ->
  socket.on 'chat message', (msg) ->
    global.io.emit 'chat message', msg
    utils.log "data", "msg: #{msg}"
    return
  return

global.is_admin = false

http.listen process.env.PORT, ->
  utils.log "hr"
  utils.log "hr"
  utils.log "hr"
  utils.log "info", "listening on *:#{process.env.PORT}"
  admin_file = "#{__dirname}/resources/tags/admin.json"
  try
    result = fs.accessSync admin_file
    stream = fs.createReadStream "#{__dirname}/resources/audio/welcome.mp3"
      .pipe new lame.Decoder
  catch
    stream =
      fs.createReadStream "#{__dirname}/resources/audio/make_admin_key.mp3"
      .pipe new lame.Decoder
  stream.pipe new speaker()
  return
