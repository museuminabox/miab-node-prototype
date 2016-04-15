express = require 'express'
hbs = require 'express-handlebars'
routes = require "./app/routes"

fs = require "fs"
utils = require "./modules/utils"
lame = require "lame"
speaker = require "speaker"

hbsInstance = hbs.create(
  extname: '.html'
)

app = express()
app.engine 'html', hbsInstance.engine
app.set "view engine", "html"
app.set "views", "#{__dirname}/app/views"
app.use express.static("#{__dirname}/app/public")
app.use "/", routes

app.listen process.env.FRONTEND_PORT, ->
  utils.log "hr"
  utils.log "hr"
  console.log ">> Front-end running on port: #{process.env.FRONTEND_PORT}".alert
  return

stream = fs.createReadStream(__dirname + '/resources/audio/welcome.mp3')
  .pipe(new lame.Decoder)
stream.pipe new speaker()
