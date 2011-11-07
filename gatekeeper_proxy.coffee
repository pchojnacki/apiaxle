#!/usr/bin/env coffee

# extends Date
_ = require "underscore"

express      = require "express"
sys          = require "sys"
fs           = require "fs"
redis        = require "redis"

{ Application } = require "gatekeeper.base"
{ StdoutLogger  } = require "./lib/stderrlogger"
{ GatekeeperError, RedisError, NotFoundError } = require "./lib/error"

class exports.GatekeeperProxy extends Application
  @controllersPath = "#{ __dirname }/app/controller"

if not module.parent
  # taking a port from the commandline makes it much easier to cluster
  # the app
  port = ( process.argv[2] or 3000 )
  host = "127.0.0.1"

  proxy = new exports.GatekeeperProxy( )

  proxy.redisConnect ( ) ->
    proxy.run host, port, ( ) ->
      proxy.configureModels()
      proxy.configureControllers()
      proxy.configureMiddleware()

      console.log "Express server listening on port #{port}"
