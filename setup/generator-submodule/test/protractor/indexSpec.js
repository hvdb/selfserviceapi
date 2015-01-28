
describe('given the application', function () {

    var ptor = protractor.getInstance();

    describe('given the application version', function() {
        beforeEach(function () {
            ptor.get('/test/protractor/index.html');
        });

        it('it should be the correct version', function () {
           expect(element(by.id('appVersion')).isDisplayed()).toBeThruthy();
           expect(element(by.id('appVersion')).getText()).toEqual('1.0.0-SNAPSHOT');
        });

    });


    describe('given the ING version', function() {
        beforeEach(function () {
            ptor.get('/test/protractor/index.html');
        });

        it('it should be the correct version', function () {
            expect(element(by.id('ingVersion')).isDisplayed()).toBeThruthy();
            expect(element(by.id('ingVersion')).getText()).toEqual('1.0.0-SNAPSHOT');
        });

    });



});