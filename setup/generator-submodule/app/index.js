'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


var SubmoduleGenerator = module.exports = function SubmoduleGenerator(args, options, config) {
    yeoman.generators.Base.apply(this, arguments);

        this.argument('name', {
            required: true,
            type: String,
            desc: 'The application name'
        });

        this.appName = this.arguments;

    this.on('end', function () {
    });

    this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(SubmoduleGenerator, yeoman.generators.Base);


SubmoduleGenerator.prototype.app = function app() {
    this.directory('app', 'app');
    this.directory('config', 'config');
    this.directory('test', 'test');
    this.directory('scripts', 'scripts');

    this.copy('applicationApp.js', 'app/js/' + this.appName + '.js');
    this.copy('partial-index.html', 'app/partials/' + this.appName + '-index.html');

};

SubmoduleGenerator.prototype.projectfiles = function projectfiles() {
    this.copy('README.md','README.md');
    this.copy('editorconfig', '.editorconfig');
    this.copy('jshintrc', '.jshintrc');
    this.copy('gitignore', '.gitignore');
    this.copy('bowerrc', '.bowerrc');
    this.copy('bower.json', 'bower.json');
    this.copy('package.json', 'package.json');
    this.copy('Gruntfile.js', 'Gruntfile.js');
};
