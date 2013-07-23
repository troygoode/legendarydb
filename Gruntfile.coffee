path = require 'path'
data = require './data'

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  grunt.registerTask 'default', [
    'clean:build'
    'copy:build'
    'compile-ingredients'
    'concat:ingredients'
    'clean:ingredients'
    'js'
    'jade:build'
    'stylus:build'
    'concat:css'
  ]

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      build: ['build']
      ingredients: [
        '.build/chrome-app/data/*.js'
        '!.build/chrome-app/data/legendaries.js'
      ]
      js: [
        '.build/chrome-app/**/*.js'
        '.build/chrome-app/data'
        '.build/chrome-app/lib'
        '!.build/chrome-app/index.js'
      ]
    coffee:
      build:
        options:
          join: true
        files:
          '.build/chrome-app/app.js': 'assets/coffee-script/**/*.coffee'
    concat:
      css:
        src: [
          'assets/css/bootstrap.css'
          'assets/css/bootstrap-responsive.css'
          '.build/chrome-app/index.css'
        ]
        dest: '.build/chrome-app/index.css'
      js:
        src: [
          'assets/js/lib/**/*.js'
          'assets/js/data.js'
          '.build/chrome-app/data/*.js'
          '.build/chrome-app/app.js'
        ]
        dest: '.build/chrome-app/index.js'
      js_libraries:
        src: ['assets/js/data.js', 'assets/js/lib/**/*.js']
        dest: '.build/chrome-app/lib.js'
      ingredients:
        options:
          process: (data, file_path) ->
            key = path.basename file_path, path.extname(file_path)
            "window.LegendaryApp.legendaries.#{key} = #{data};"
        src: '.build/chrome-app/data/*.js'
        dest: '.build/chrome-app/data/legendaries.js'
    copy:
      build:
        files: [
          expand: true
          src: ['chrome-app/**']
          dest: '.build'
        ]
    jade:
      build:
        files:
          '.build/chrome-app/index.html': ['assets/views/home.jade']
    stylus:
      build:
        files:
          '.build/chrome-app/index.css': ['assets/styles/*.styl']
    uglify:
      js:
        files:
          '.build/chrome-app/index.js': ['.build/chrome-app/index.js']

  grunt.registerTask 'js', [
    'coffee:build'
    'concat:js'
    'uglify:js'
    'clean:js'
  ]

  grunt.registerTask 'compile-ingredients', 'Compile legendary ingredient trees.', ->
    for key, legendary of data.legendaries
      file_path = ".build/chrome-app/data/#{key}.js"
      grunt.file.write file_path, JSON.stringify(legendary)
      grunt.log.write("Creating #{file_path}...").ok()
