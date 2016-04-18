fs = require "fs"
utils = require "../../../modules/utils"

module.exports = api =

  tag_detect: (request, response) ->

    # Check to make sure we have an id
    if "id" not of request.query
      global.io.emit "chat message",
        "You need to pass an ID to that API endpoint"
      response.writeHead 200, { 'Content-Type': 'application/json' }
      response.end JSON.stringify { status: "error" }
      return

    # Grab the uid
    id = request.query.id

    # If admin.json doesn't exist then we need to create it with
    # whatever tag has been passed over
    admin_file = "#{__dirname}/../../../resources/tags/admin.json"
    try
      result = fs.accessSync admin_file
    catch
      # create the tag because it doesn't exist
      admin_tag =
        id: id
        last_access: new Date()

      fs.writeFileSync admin_file, JSON.stringify(admin_tag)
      utils.log "info", "this is a new admin tag"

    # Now we need to read in the admin.json file and see if the ID in there
    # matches the admin id
    admin_json = JSON.parse fs.readFileSync(admin_file)
    if id is admin_json.id
      utils.log "info", "this is the admin tag"

      #  toggle the admin state
      if global.is_admin
        global.is_admin = false
        utils.log "info", "Exiting admin mode"
        global.io.emit "exit admin"
      else
        global.is_admin = true
        utils.log "info", "Entering admin mode"
        global.io.emit "enter admin"

      # Tell the front-end everything is ok
      response.writeHead 200, { 'Content-Type': 'application/json' }
      response.end JSON.stringify { status: "ok" }
      return

    utils.log "info", "this isn't the admin tag"

    global.io.emit "chat message", "Tag detected: #{request.query.id}"
    response.writeHead 200, { 'Content-Type': 'application/json' }
    response.end JSON.stringify { status: "ok" }
    utils.play_boop()

  tag_lost: (request, response) ->
    global.io.emit 'chat message', "Tag lost."
    response.writeHead 200, { 'Content-Type': 'application/json' }
    response.end JSON.stringify { status: "ok" }
