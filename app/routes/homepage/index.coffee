utils = require "../../../modules/utils"

module.exports = homepage =

  index: (request, response) ->
    utils.log "hr"
    utils.log "info", "In homepage.index()"
    templateValues =
      msg: "hello world"
    response.render "homepage/index", templateValues
