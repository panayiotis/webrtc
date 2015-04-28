module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    
    // Jasmine
    // remember also to edit jasmine jade view
    jasmine: {
      test: {
        src: ['tmp/backbone.js',
              'tmp/templates.js',
              'tmp/models/*.js',
              'tmp/collections/*.js',
              'tmp/views/*.js',
              'tmp/router.js'
             ],
        options: {
            specs: 'public/specs.js',
            vendor: ['assets/js/vendor/jquery.min.js',
                     'public/jasmine-2.2.0/jasmine-jquery.js',
                     'assets/js/vendor/jade.js',
                     'assets/js/vendor/lodash.js',
                     'assets/js/vendor/peer.js',
                     'assets/js/vendor/modernizr.js',
                     'assets/js/vendor/foundation/foundation.js',
                     'assets/js/vendor/backbone.js',
                     'assets/js/vendor/backbone.localStorage.js'
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
        dest: 'tmp/',   // Destination path prefix.
        ext: '.js'
      },
      specs: {
        options: {
          sourceMap: true
        },
        files: {
          // concat then compile into single file
          'public/specs.js': ['spec/SpecHelper.coffee','spec/*Spec.coffee']
        }
      }
      
    },
    
    // Jade
    jade: {
      compile: {
        options: {
          pretty: true,
          data: {
            debug: true,
          },
          client:true,
          processName: function(filename) {
            filename = filename.replace("assets/js/", "");
            filename = filename.replace(".jst.jade", "");
            return filename;
          }
        },
        files: {
          "tmp/templates.js": ["assets/js/templates/*.jade"]
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
        tasks: ['doc','test'],
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
        missing_fat_arrows:{level:'ignore'},
        no_empty_functions:{level:'ignore'},
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
        // src: ['*.coffee', 'assets/js/*.coffee',
        //       'assets/js/**/*.coffee','spec/*.coffee'
        //      ],
        src: ['*.coffee', 'tmp/backbone.coffee'
             ],
        options: {
          output: 'public/doc/'
        }
      }
    },
    
    // Concaternate files
    concat: {
      dist: {
        files: {
          'tmp/backbone.coffee':[
            'assets/js/models/*.coffee',
            'assets/js/collections/*.coffee',
            'assets/js/views/*.coffee'
          ]
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
  
  grunt.loadNpmTasks('grunt-contrib-concat');
  
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
    grunt.task.run('reset_screen', 'concat', 'docco');
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
