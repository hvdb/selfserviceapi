'use strict';

/* Version directive */

angular.module('bla').
    directive('appVersion', ['version', function(version) {
        return function(scope, elm, attrs) {
            elm.text(version.version);
        };
    }]);