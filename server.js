/* A simple static file server on port 8000 */

/*jslint node: true */
'use strict';

var path = require('path'),
    connect = require('connect'),
    directoryPath = path.join(__dirname, 'public'),
    faviconPath = path.join(directoryPath, 'favicon.ico'),
    oneDay = 86400000, // 86400 seconds, 24 hours
    port = 8000;

connect()
    .use(connect.favicon(faviconPath))
    .use(connect.compress())
    .use(connect.static(directoryPath, {maxAge: oneDay}))
    .listen(port);