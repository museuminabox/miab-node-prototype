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
    global.current_id = request.query.id

    # If admin.json doesn't exist then we need to create it with
    # whatever tag has been passed over
    admin_file = "./resources/tags/admin.json"
    try
      result = fs.accessSync admin_file
    catch
      # create the tag because it doesn't exist
      admin_tag =
        id: global.current_id
        last_access: new Date()

      fs.writeFileSync admin_file, JSON.stringify(admin_tag)
      utils.log "info", "this is a new admin tag"

    # Now we need to read in the admin.json file and see if the ID in there
    # matches the admin id
    admin_json = JSON.parse fs.readFileSync(admin_file)
    if global.current_id is admin_json.id
      utils.log "info", "this is the admin tag"

      #  toggle the admin state
      if global.is_admin
        global.is_admin = false
        utils.log "info", "Exiting admin mode"
        global.io.emit "exit admin"
        utils.play_kiosk()
      else
        global.is_admin = true
        utils.log "info", "Entering admin mode"
        global.io.emit "enter admin"
        utils.play_admin()

      # Tell the front-end everything is ok
      response.writeHead 200, { 'Content-Type': 'application/json' }
      response.end JSON.stringify { status: "ok" }
      return

    # Now that we are here, we know we have dealt with all the admin
    # stuff, we can go on to find out if a file already exists for this
    # tag
    tag_file = "./resources/tags/#{global.current_id}.json"
    try
      result = fs.accessSync tag_file
      tag_json = fs.readFileSync tag_file, "utf-8"
      global.io.emit "known tag", JSON.stringify(tag_json)
      tag_json = JSON.parse tag_json

      # If there's some audio and we're not in admin mode,
      # then we should try and play it :)
      if "mp3" of tag_json and not global.is_admin
        utils.play_audio tag_json.mp3
      else
        utils.play_boop()

      global.reshow = true

    catch
      utils.log "info", "not known"
      # emit a message saying that the tag doesn't exist.
      global.io.emit "unknown tag", global.current_id

    response.writeHead 200, { 'Content-Type': 'application/json' }
    response.end JSON.stringify { status: "ok" }

  tag_lost: (request, response) ->
    utils.log "info", "tag lost"

    # Let the front-end know that we have lost a tag, and which one
    global.io.emit "tag lost", global.current_id

    # Set the global tag to null
    global.current_id = null
    global.reshow = false

    response.writeHead 200, { 'Content-Type': 'application/json' }
    response.end JSON.stringify { status: "ok" }
    return
