module.exports=(grunt)->
  grunt.initConfig
    pkg:grunt.file.readJSON('package.json')
    copy:
      main:
        files:[{expand: true, cwd:'assets/', src: ['**','!**/*.coffee'], dest: 'public/'}]
    clean:
      main:
        src:['public/**','public/!**/*.coffee']
    coffee:
      glob_to_multiple:
        options:
          sourceMap: true
        expand: true
        cwd: 'assets/'
        src: ['**/*.coffee']
        dest: 'public/'
        ext: '.js'
    watch:
      files:['assets/**']
      tasks:['clean', 'copy','coffee']


  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.registerTask('default', ['clean','copy', 'coffee'])