# Welcome to the SpectINGular module '<%= _.camelize(appName) %>'

## Prerequisites
- nodejs
- bower
- karma

(npm install -g)

## Optional prerequisites
- grunt

## Getting started.
As each SpectINGular module has a dependency on the SpectINGular core, the dependencies need to be fetched.
We use 'bower' for that.

### Installing the project dependencies.
bower install

### Installing the build dependencies.
npm install

### Local server
grunt server

### Running tests
There are 2 options to run your tests.

- grunt karma:unit
- grunt connect:test protactor:e2e --protractor-host=YOURMACHINE

## Using grunt
- grunt --help, to see available commands or see Gruntfile.js

    
