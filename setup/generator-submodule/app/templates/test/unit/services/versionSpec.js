'use strict';

/* jasmine specs for the version service. */
describe('Given the version service', function () {
    beforeEach(module('<%= _.camelize(appName) %>'));

    describe('The version', function () {
        it('should return current version', inject(function (version) {
            expect(version.version).toEqual('1.0.0-SNAPSHOT');
        }));
    });
});
