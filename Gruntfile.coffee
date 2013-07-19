data = require './data'

module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

  grunt.registerTask 'default', [
    'compile-ingredients'
  ]

  grunt.registerTask 'compile-ingredients', 'Compile legendary ingredient trees.', ->
    grunt.file.mkdir 'chrome-app/data'
    for key, legendary of data.legendaries
      grunt.file.write "chrome-app/data/#{key}.js", JSON.stringify(legendary)
