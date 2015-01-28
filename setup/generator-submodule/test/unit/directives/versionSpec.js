'use strict';

/* jasmine specs for the version directive, */
describe('Given the version directive', function () {
    beforeEach(module('bla'));

    describe('The version', function () {
        it('should provide the current version', function () {

            module(function ($provide) {
                $provide.provider('version', function () {
                    this.$get = function () {
                        return {version: 'TEST_VER'};
                    }
                });
            });

            inject(function ($compile, $rootScope) {
                var element = $compile('<span app-version></span>')($rootScope);
                expect(element.text()).toEqual('TEST_VER');
            });
        });
    });
});
