path = require 'path'
data = require './data'

module.exports = (grunt) ->

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'

  grunt.registerTask 'default', [
    'clean:build'
    'copy:build'
    'compile-ingredients'
    'concat:ingredients'
    'clean:ingredients'
    'jade:build'
  ]

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    clean:
      build: ['build']
      ingredients: [
        'build/chrome-app/data/*.js'
        '!build/chrome-app/data/legendaries.js'
      ]
    concat:
      ingredients:
        options:
          separator: '\n'
          process: (data, file_path) ->
            key = path.basename file_path, path.extname(file_path)
            "window.LegendaryApp.legendaries.#{key} = #{data};"
        src: 'build/chrome-app/data/*.js'
        dest: 'build/chrome-app/data/legendaries.js'
    copy:
      build:
        files: [
          expand: true
          src: ['chrome-app/**']
          dest: 'build'
        ]
    jade:
      build:
        files:
          'build/chrome-app/home.html': ['views/home.jade']

  grunt.registerTask 'compile-ingredients', 'Compile legendary ingredient trees.', ->
    for key, legendary of data.legendaries
      file_path = "build/chrome-app/data/#{key}.js"
      grunt.file.write file_path, JSON.stringify(legendary)
      grunt.log.write("Creating #{file_path}...").ok()
