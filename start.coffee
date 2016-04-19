colours = require "colors"
spawn = require "child_process"
spawn = spawn.spawn

colours.setTheme
  info: 'green'
  data: 'grey'
  help: 'cyan'
  warn: 'yellow'
  debug: 'blue'
  error: 'red'
  alert: 'magenta'

console.log "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-".rainbow
console.log "Starting Coffee".rainbow

coffeeServer = spawn "coffee", ["-cw", "server.coffee"]
coffeeServer.stdout.on "data", (data) ->
  console.log data.toString().alert
coffeeServer.stderr.on "data", (data) ->
  console.log "coffeeServer: #{data}".alert
coffeeServer.on "exit", (code) ->
  console.log "coffeeServer exited with code #{code}".alert

coffeeModules = spawn "coffee", ["-cw", "./modules"]
coffeeModules.stdout.on "data", (data) ->
  console.log data.toString().warn
coffeeModules.stderr.on "data", (data) ->
  console.log "coffeeModules: #{data}".warn
coffeeModules.on "exit", (code) ->
  console.log "coffeeModules exited with code #{code}".warn

coffeeModules = spawn "coffee", ["-cw", "./app"]
coffeeModules.stdout.on "data", (data) ->
  console.log data.toString().warn
coffeeModules.stderr.on "data", (data) ->
  console.log "coffeeModules: #{data}".warn
coffeeModules.on "exit", (code) ->
  console.log "coffeeModules exited with code #{code}".warn

console.log "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-".rainbow
console.log "Starting Compass".rainbow

compass = spawn "compass", ["watch", "./app/public"]
compass.stdout.on "data", (data) ->
  console.log data.toString().cyan

compass.on "exit", (code) ->
  console.log  "compass exited with code #{code}".alert

console.log "Now do: env $(cat ./profile) nodemon server.js".info
