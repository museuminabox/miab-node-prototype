fs = require "fs"
utils = require "./modules/utils"
lame = require "lame"
Speaker = require "speaker"

utils.log "hr"
utils.log "info", "server.js just ran"
utils.log "info", __dirname

stream = fs.createReadStream(__dirname + '/resources/audio/welcome.mp3')
  .pipe(new lame.Decoder)
stream.pipe new Speaker()
