'use strict';

/* Version service */
angular.module('<%= _.camelize(appName) %>').
    factory('version', function() {
        return {
            version:'1.0.0-SNAPSHOT'
        };
    });
