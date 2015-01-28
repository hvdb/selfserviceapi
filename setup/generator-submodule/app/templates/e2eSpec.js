'use strict';

/* https://docs.angularjs.org/guide/e2e-testing */
describe('<%= _.camelize(appName) %>', function() {
    beforeEach(function() {
        browser().navigateTo('../../app/index.html');
    });

    it('should open the <%= _.camelize(appName) %>', function() {
        expect(element('div:eq(1)').text()).toContain("<%= _.camelize(appName) %> app: v1.0.0-SNAPSHOT");
        expect(element('div:eq(2)').text()).toContain("ING global: v1.0.0-SNAPSHOT");
    })
});