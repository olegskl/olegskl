A simple static file server on port 8000
================================================================================

    'use strict'

    path = require 'path'
    express = require 'express'
    compression = require 'compression'
    serveStatic = require 'serve-static'

    publicDir = path.resolve __dirname, 'static'

    cacheAge = process.env.CACHE_AGE || 24 * 60 * 60 * 1000 # 24 hours
    port = process.env.PORT || 8000


Middleware
--------------------------------------------------------------------------------
Compatibility headers for Internet Explorer.
These tell IE to use the latest available version.

    compatibilityHeaders = (request, response, next) ->
      response.setHeader 'X-UA-Compatible', 'IE=edge'
      do next


Server
--------------------------------------------------------------------------------

    (do express)
      .use compatibilityHeaders
      .use do compression
      .use serveStatic publicDir, maxAge: cacheAge
      .listen port
