'use strict';

/* Version directive */

angular.module('<%= _.camelize(appName) %>').
    directive('appVersion', ['version', function(version) {
        return function(scope, elm, attrs) {
            elm.text(version.version);
        };
    }]);