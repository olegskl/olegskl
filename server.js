/* A basic static file server on port 8000 */
/*jslint node: true */
'use strict';

var path = require('path'),
    connect = require('connect'),
    directory = path.join(__dirname, 'static');

connect()
    .use(connect.static(directory))
    .listen(8000);