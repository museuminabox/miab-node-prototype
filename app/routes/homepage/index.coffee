fs = require "fs"
utils = require "../../../modules/utils"

module.exports = homepage =

  index: (request, response) ->
    utils.log "hr"
    utils.log "info", "In homepage.index()"
    utils.log "alert", global.current_id

    templateValues =
      msg: "hello world"
      current_id: global.current_id
      reshow: global.reshow

    # Check to see if the known admin tag exists
    admin_file = "./resources/tags/admin.json"
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
    tag_file = "./resources/tags/#{request.body.id}.json"
    tag_json =
      id: request.body.id
      title: request.body.title

    # Set the image file to null, if we already have an image specified
    # then we grab the filename, and then also check to see if a new one
    # has been uploaded
    image_file = null
    mp3_file = null

    try
      tag_json_check = fs.readFileSync tag_file, "utf-8"
      tag_json_check = JSON.parse(tag_json_check)
      if "image" of tag_json_check
        image_file = tag_json_check.image
      if "mp3" of tag_json_check
        mp3_file = tag_json_check.mp3

    # Check to see if we have an image file
    if "image" of request.files
      fs.rename "./tmp/uploads/#{request.files.image[0].filename}",
        "./resources/tag_image/#{request.files.image[0].filename}.jpg"
      image_file = "#{request.files.image[0].filename}.jpg"

    # Check to see if we have an mp3 file
    if "mp3" of request.files
      fs.rename "./tmp/uploads/#{request.files.mp3[0].filename}",
        "./resources/tag_audio/#{request.files.mp3[0].filename}.mp3"
      mp3_file = "#{request.files.mp3[0].filename}.mp3"

    if image_file isnt null
      tag_json.image = image_file

    if mp3_file isnt null
      tag_json.mp3 = mp3_file

    fs.writeFileSync tag_file, JSON.stringify(tag_json)
    templateValues.tag_id = request.body.id
    global.reshow = true
    response.redirect "/"
    return
