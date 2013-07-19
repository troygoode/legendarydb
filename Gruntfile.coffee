module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'


  grunt.registerTask 'default', 'example', ->
    grunt.log.write('lorem ipsum dolor').ok()
