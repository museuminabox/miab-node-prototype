utils = require "../../../modules/utils"

module.exports = fake_rfid =

  index: (request, response) ->
    utils.log "hr"
    utils.log "info", "In fake_rfid.index()"
    templateValues =
      msg: "hello world"
    response.render "fake-rfid/index", templateValues
