/* Default proxy server on port 80 */
/*jslint node: true */
'use strict';

var http = require('http'),
    path = require('path'),
    connect = require('connect'),
    directory = path.join(__dirname, 'static');

connect()
    .use(connect.static(directory))
    .listen(8001);