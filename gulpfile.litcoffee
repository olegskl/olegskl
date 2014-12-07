Build system
================================================================================

This is the build system for the main site at [olegskl.com](http://olegskl.com).

 - Run `gulp` or `gulp dev` when developing.
 - Run `gulp dist` to build a distribution version.

By default both *dev* and *dist* will write the generated code to the *./build*
folder. Use `--dest` option to modify this behavior. Useful when deploying to
the production environment, e.g. `gulp dist --dest="/srv/olegskl"`.

    'use strict'

Dependencies
--------------------------------------------------------------------------------

    argv = (require 'minimist') process.argv[2..]

    gulp = require 'gulp'
    sequence = require 'run-sequence'
    del = require 'del'
    inject = require 'gulp-inject'
    connect = require 'gulp-connect'
    open = require 'gulp-open'
    concat = require 'gulp-concat'
    autoprefixer = require 'gulp-autoprefixer'
    minifyJS = require 'gulp-uglify'
    minifyCSS = require 'gulp-minify-css'
    minifyHTML = require 'gulp-minify-html'

Options
--------------------------------------------------------------------------------

    port = 1337

Source files
--------------------------------------------------------------------------------

    source =
      server: ['src/server.js', 'package.json']
      html: 'src/static/index.html'
      favicon: 'src/static/favicon.ico'
      styles: ['src/static/styles/**/*.css', 'src/static/fonts/**/*.css']
      scripts: 'src/static/scripts/**/*.js'

Destination
--------------------------------------------------------------------------------

    destination = {}

    destination.build = argv.dest or 'build'
    destination.static = "#{destination.build}/static"

Transforms for `gulp-inject`
--------------------------------------------------------------------------------

    transform =
      scripts: (filePath, file) ->
        "<script>#{file.contents.toString 'utf8'}</script>"
      styles: (filePath, file) ->
        "<style>#{file.contents.toString 'utf8'}</style>"

Clean task
--------------------------------------------------------------------------------

    gulp.task 'clean', ->
      del destination.build, force: true

Favicon task
--------------------------------------------------------------------------------

    gulp.task 'favicon', ->
      gulp
        .src source.favicon
        .pipe gulp.dest destination.build

Server script task
--------------------------------------------------------------------------------

    gulp.task 'server', ->
      gulp
        .src source.server
        .pipe gulp.dest destination.build

Distribution build task
--------------------------------------------------------------------------------
Not supposed to be used directly. Use `gulp dist` instead.

    gulp.task 'build-dist', ['server', 'favicon'], ->

      scripts = gulp
        .src source.scripts
        .pipe concat 'all.js'
        .pipe do minifyJS

      styles = gulp
        .src source.styles
        .pipe concat 'all.css'
        .pipe autoprefixer
          browsers: ['last 2 versions']
          cascade: false
        .pipe do minifyCSS

      gulp
        .src source.html
        .pipe inject styles, transform: transform.styles
        .pipe inject scripts, transform: transform.scripts
        .pipe do minifyHTML
        .pipe gulp.dest destination.static

Clean distribution build task
--------------------------------------------------------------------------------

    gulp.task 'dist', (cb) ->
      sequence 'clean', 'build-dist', cb

Development build task
--------------------------------------------------------------------------------
Not supposed to be used directly. Use `gulp dev` instead.

    gulp.task 'build-dev', ['favicon'], ->

      scripts = gulp
        .src source.scripts
        .pipe gulp.dest "#{destination.build}/scripts"

      styles = gulp
        .src source.styles
        .pipe autoprefixer
          browsers: ['last 2 versions']
          cascade: false
        .pipe gulp.dest "#{destination.build}/styles"

      gulp
        .src source.html
        .pipe inject styles, ignorePath: destination.build
        .pipe inject scripts, ignorePath: destination.build
        .pipe gulp.dest destination.build
        .pipe do connect.reload

Clean development build task
--------------------------------------------------------------------------------

    gulp.task 'dev', (cb) ->
      sequence 'clean', 'build-dev', cb

Open-in-browser task
--------------------------------------------------------------------------------
Convenience task to open the served app in the default browser.

    gulp.task 'open', ->
      gulp
        .src "#{destination.build}/index.html"
        .pipe open '', url: "http://localhost:#{port}"

Watch task
--------------------------------------------------------------------------------

    gulp.task 'watch-dev', ->
      gulp.watch 'src/**/*', ['dev']

Serve task
--------------------------------------------------------------------------------
Prefer using `gulp serve-dist` or `gulp serve-dev` instead.

    gulp.task 'serve', ->
      connect.server
        root: destination.build
        port: port
        livereload: true

Serve development task
--------------------------------------------------------------------------------

    gulp.task 'serve-dev', (cb) ->
      sequence 'dev', ['serve', 'watch-dev'], 'open', cb

Serve distribution task
--------------------------------------------------------------------------------
Do not use for production. This is just to check if the app compiles.

    gulp.task 'serve-dist', (cb) ->
      sequence 'dist', 'serve', cb

Default task
--------------------------------------------------------------------------------
This task is your best friend. Run `gulp` to start the development environment.

    gulp.task 'default', ['serve-dev']
