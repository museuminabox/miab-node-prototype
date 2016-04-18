utils = require "../../../modules/utils"

module.exports = api =

  tag_detect: (request, response) ->
    if "id" of request.query
      global.io.emit "chat message", "Tag detected: #{request.query.id}"
    else
      global.io.emit "chat message",
        "You need to pass an ID to that API endpoint"
    response.writeHead 200, { 'Content-Type': 'application/json' }
    response.end JSON.stringify { status: "ok" }

  tag_lost: (request, response) ->
    global.io.emit 'chat message', "Tag lost."
    response.writeHead 200, { 'Content-Type': 'application/json' }
    response.end JSON.stringify { status: "ok" }
