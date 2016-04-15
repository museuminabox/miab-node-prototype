utils = require "../../../modules/utils"

module.exports = api =

  tag_detect: (request, response) ->
    if "id" of request.query
      global.io.emit "chat message", "Tag detected: #{request.query.id}"
    else
      global.io.emit "chat message",
        "You need to pass an ID to that API endpoint"
    response.end "OK"

  tag_lost: (request, response) ->
    global.io.emit 'chat message', "Tag lost."
    response.end "OK"
