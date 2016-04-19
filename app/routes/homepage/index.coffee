fs = require "fs"
utils = require "../../../modules/utils"

module.exports = homepage =

  index: (request, response) ->
    utils.log "hr"
    utils.log "info", "In homepage.index()"
    templateValues =
      msg: "hello world"

    # Check to see if the known admin tag exists
    admin_file = "#{__dirname}/../../../resources/tags/admin.json"
    try
      result = fs.accessSync admin_file
      # If it does exist then show the index page based on being in admin
      # mode or not
      if global.is_admin
        response.render "homepage/admin", templateValues
      else
        response.render "homepage/kiosk", templateValues
    catch
      # Show the "we don't have an admin user yet"
      response.render "homepage/noadmin", templateValues


  save_tag: (request, response) ->
    utils.log "hr"
    utils.log "info", "In homepage.save_tag()"
    templateValues =
      msg: "hello world"
    tag_file = "#{__dirname}/../../../resources/tags/#{request.body.id}.json"
    tag_json =
      id: request.body.id
      title: request.body.title
    fs.writeFileSync tag_file, JSON.stringify(tag_json)
    templateValues.tag_id = request.body.id
    response.redirect "/"
