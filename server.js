/* A basic static file server on port 8000 */
/*jslint node: true */
'use strict';

var path = require('path'),
    connect = require('connect'),
    directory = path.join(__dirname, 'static'),
    threeHours = 10800000, // 10800 seconds
    port = 8000;

connect()
    .use(connect.compress())
    .use(connect.static(directory, {maxAge: threeHours}))
    .listen(port);