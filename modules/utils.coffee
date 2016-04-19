################################################################################
#
# A quick holder for handy dandy functions we'll need all over the place
#
################################################################################
util = require "util"
colours = require "colors"
fs = require "fs"
lame = require "lame"
speaker = require "speaker"

colours.setTheme
  info: 'green'
  data: 'grey'
  help: 'cyan'
  warn: 'yellow'
  debug: 'blue'
  error: 'red'
  alert: 'magenta'

utils =

  ##############################################################################
  #
  # This is our own logging function to replace console.log
  # This means we can happily log a whole bunch of stuff on DEV
  # but doesn't on PROD or STAGING. This means we don't fill up the .log files
  # on PROD, and any messages in those logs are probably something we should
  # pay attention to.
  #
  log: (level, msg) ->

    #  These are valid error levels which will output with colour from the
    #  colours module. If the level is not in here then it'll just dump the
    #  results out, because sometimes we are passing over objects or dicts
    #  like... utils.log "dump", myJSONObject
    #
    #  You can also pass in "hr" to get a nice fancy break
    errorLevels = ["info", "data", "help", "warn", "debug", "error", "alert"]
    hr = "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    dr = "---------------------------------------------------------------------"
    onDev = process.env.NODE_ENV is "DEV"
    onProd = process.env.NODE_ENV is "PRODUCTION"
    onStaging = process.env.NODE_ENV is "STAGING"

    # Build up the output
    output = ">> #{level.toUpperCase()}: "

    unless typeof msg is 'string'
      msg = util.inspect msg

    #  if its one we know about then output it here
    if level in errorLevels
      output += msg
      switch level
        #  If it's an error then we always output it, and we may want to
        #  throw it to something like rollbar.com
        #
        #  Otherwise we just output it. We may want to add more fine grain
        #  controls at some point which is why we're using a switch
        when "error"

          #  If it's a 404, or 500 then replace the text warning of ERROR
          #  to warning to make it less scary
          isNumberError = false
          numberError = 404

          if output.indexOf("404:") >= 0 or
          output.indexOf("500:") >= 0
            output = output.replace "ERROR", "WARNING"
            level = "warn"
            isNumberError = true
            numberError = 500 if output.indexOf("500:") >= 0

          #  If we are on Prod, then send it to rollbar
          #if onProd
            #console.log ">> Reporting to rollbar...".alert

          #   And now actually log it.
          console.log output[level]
        else
          #  Only putput this if we're on DEV
          if onDev
            console.log output[level]
    else
      if level is "hr"
        if onDev
          console.log hr.rainbow
      else
        #  we only dump this out if we are on "DEV" or the level
        #  is "dumpPROD"
        if onDev or level is "dumpPROD"
          console.log output
          console.log msg
          console.log dr.rainbow

  play_boop: () ->
    try
      stream = fs.createReadStream "./resources/audio/boop.mp3"
        .pipe new lame.Decoder
      stream.pipe new speaker()
    catch err
      # don't do anything
      x = 1

  play_admin: () ->
    try
      stream =
        fs.createReadStream "./resources/audio/admin_mode.mp3"
        .pipe new lame.Decoder
      stream.pipe new speaker()
    catch err
      # don't do anything
      x = 1

  play_kiosk: () ->
    try
      stream =
        fs.createReadStream "./resources/audio/kiosk_mode.mp3"
        .pipe new lame.Decoder
      stream.pipe new speaker()
    catch err
      # don't do anything
      x = 1

module.exports = utils = utils
