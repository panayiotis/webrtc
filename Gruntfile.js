module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    
    // Jasmine
    // remember also to edit jasmine jade view
    jasmine: {
      test: {
        src: ['assets/js/compiled/backbone.js',
              'assets/js/compiled/templates.js',
              'assets/js/compiled/models/*.js',
              'assets/js/compiled/collections/*.js',
              'assets/js/compiled/views/*.js',
              'assets/js/compiled/router.js'
             ],
        options: {
            //keepRunner:true,
            specs: 'public/spec/NewSpec.js',
            vendor: ['assets/js/vendor/jquery.min.js',
                     'public/lib/jasmine-jquery.js',
                     'assets/js/vendor/jade.js',
                     'assets/js/vendor/lodash.js',
                     'assets/js/vendor/peer.js',
                     'assets/js/vendor/foundation/foundation.js',
                     'assets/js/vendor/backbone.js'
                    ]
        }
      }
    },
    // Coffee
    coffee: {
      backbone: {
        sourceMap: true,
        expand:true,
        cwd: 'assets/js',           // Src matches are relative to this path.
        src: ['models/*.coffee',    // Actual pattern(s) to match.
              'views/*.coffee',
              'collections/*.coffee',
              'backbone.coffee',
              'router.coffee'
             ],
        dest: 'assets/js/compiled/',   // Destination path prefix.
        ext: '.js'
      },
      specs: {
        expand:true,
        sourceMap: true,
        cwd: 'spec/',   // Src matches are relative to this path.
        src: ['*.coffee'     // Actual pattern(s) to match.
             ],
        dest: 'public/spec', // Destination path prefix.
        ext: '.js'
      }
      
    },
    
    // Jade
    jade: {
      compile: {
        options: {
          data: {
            debug: false
          },
          client:true,
          processName: function(filename) {
            filename = filename.replace("assets/js/", "");
            filename = filename.replace(".jst.jade", "");
            return filename;
          }
        },
        files: {
          "assets/js/compiled/templates.js": ["assets/js/templates/*.jade"]
        }
      }
    },
    
    // Watch
    watch: {
      scripts: {
        files: [
          'assets/js/*.js',
          'assets/js/*.coffee',
          'assets/js/**/*.coffee',
          'spec/*.coffee',
          'Gruntfile.js'
        ],
        tasks: ['docco','test'],
        options: {
          spawn: false,
          livereload: true
        },
      },
    },
    
    // Nodemon
    nodemon: {
      dev: {
        script: 'app.coffee',
        options: {
          cwd: __dirname,
          ignore: ["assets/*", "views/*", "spec/*"],
          watch: ["app.coffee"],
          delay: 0.1
        }
      }
    },
    
    // Coffeelint
    coffeelint: {
      options: {
        no_unnecessary_double_quotes:{level:'warn'},
        prefer_english_operator:{level:'warn'},
        arrow_spacing:{level:'warn'},
        missing_fat_arrows:{level:'warn'},
        no_empty_functions:{level:'warn'},
        no_empty_param_list:{level:'warn'},
        no_stand_alone_at:{level:'warn'},
        force:false
      },
       app:[
         '*.coffee',
          'spec/*.coffee',
          'assets/js/*.coffee',
          'assets/js/models/*.coffee',
          'assets/js/controllers/*.coffee',
          'assets/js/views/*.coffee'
         ]
    },
    
    // Docco
    docco: {
      debug: {
        src: ['*.coffee', 'assets/js/*.coffee',
              'assets/js/**/*.coffee','spec/*.coffee'
             ],
        options: {
          output: 'public/doc/'
        }
      }
    }
  });


  grunt.registerTask('reset_screen', 'reset terminal', function() {
    process.stdout.write('\033c');
  });

  grunt.loadNpmTasks('grunt-contrib-coffee');
  
  grunt.loadNpmTasks('grunt-contrib-jade');
  
  grunt.loadNpmTasks('grunt-contrib-jasmine');
  
  grunt.loadNpmTasks('grunt-contrib-watch');
  
  grunt.loadNpmTasks('grunt-nodemon');
  
  grunt.loadNpmTasks('grunt-coffeelint');
  
  grunt.loadNpmTasks('grunt-docco');
  
  grunt.registerTask('test',
    ['reset_screen',
    'coffee',
    'jade',
    'coffeelint',
    'jasmine']
  );

  grunt.registerTask('server', 'Start Node server', function() {
    grunt.task.run('reset_screen', 'nodemon');
  });

  grunt.registerTask('doc', 'Run docco', function() {
    grunt.task.run('reset_screen', 'docco');
  });
  
  grunt.registerTask('sleep', 'Example async task', function() {
    var done = this.async();
    
    var options = {
      cmd: 'sleep',
      args: ['10s']
    }
    
    grunt.util.spawn( options, function() {
      grunt.log.writeln('Sleep ended');
      done();
    });
  });
};
