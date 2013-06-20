/* Default proxy server on port 80 */
/*jslint node: true */
'use strict';

var http = require('http'),
    connect = require('connect'),
    directory = './static';

connect()
    .use(connect.static(directory))
    .listen(8001);