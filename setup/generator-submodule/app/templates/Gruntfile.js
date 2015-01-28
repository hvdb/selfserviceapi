// Generated on <%= (new Date).toISOString().split('T')[0] %> using <%= pkg.name %> <%= pkg.version %>
'use strict';

var lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet,  _os = require("os");
var mountFolder = function (connect, dir) {
    return connect.static(require('path').resolve(dir));
};

module.exports = function (grunt) {
    // load all grunt tasks
    require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

    var serverPort = grunt.option('serverPort') || 9000;
    var reloadPort = grunt.option('reloadPort') || 8889;
    var hostname = grunt.option('hostname') || '0.0.0.0';
    var protractorHostname = grunt.option('protractor-host') || _os.hostname();

    grunt.initConfig({
        livereload: {
            port: reloadPort + 1
        },
        watch: {
            options: {
                nospawn: true,
                livereload: reloadPort
            },
            livereload: {
                files: [
                    'app/{,*/}*.html',
                    'app/{css/{,*/}*.css',
                    'app/js/{,*/}*.js',
                    'app/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
                ],
                tasks: ['livereload']
            }
        },
        connect: {
            options: {
                port: serverPort,
                // change this to '0.0.0.0' to access the server from outside
                hostname: hostname
            },
            livereload: {
                options: {
                    middleware: function (connect) {
                        return [
                            lrSnippet,
                            mountFolder(connect, '.')
                        ];
                    }
                }
            },
            test: {
                options: {
                    middleware: function(connect) {
                        return [
                            mountFolder(connect, '.tmp'),
                            mountFolder(connect, '')
                        ]
                    }
                }
            }
        },
        open: {
            server: {
                path: 'http://localhost:<%= connect.options.port %>/app/index.html'
            }
        },
        protractor: {
            options: {
                keepAlive: false,
                noColor: false
            },
            e2e: {
                options: {
                    configFile: 'config/protractor.conf.js',
                    args: {
                        baseUrl: 'http://' + protractorHostname + ':' + (serverPort)
                    }
                }
            }
        },
        clean: {
            runtime: [
                '.tmp',
                'coverage',
                'reports'
            ]
        },
        jshint: {
            options: {
                jshintrc: '.jshintrc',
                reporter: require('jshint-junit-reporter'),
                reporterOutput: 'reports/jshint/jshint.xml'
            }, files: {
                src: ['app/js/{,*/}*.js']
            }
        },
        karma: {
            options: {
                singleRun: true,
                browsers: ['PhantomJS'],
                reporters: ['progress', 'coverage', 'junit']
            },
            unit: {
                configFile: 'config/karma.conf.js'
            }
        }
    });



    grunt.registerTask('build', [
        'connect:test',
        'protractor:e2e',
        'karma',
        'jshint'
    ]);

    grunt.registerTask('server', [
        'livereload-start',
        'connect:livereload',
        'open',
        'watch']);
};