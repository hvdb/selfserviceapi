exports.config = {
    //seleniumAddress: 'http://localhost:9515',
   seleniumAddress: 'http://bl00041.nl.europe.intranet:5555/wd/hub',
   //seleniumAddress: 'http://127.0.0.1:4444/wd/hub',
    specs: [
        '../test/protractor/**/*Spec.js'
    ],


    //If you only want to test against chrome you can also use this option.
    //Enable it and make sure the chromedriver is in your path.
    //It is pretty fast!
    //chromeOnly: true,
    multiCapabilities: [
        {
            browserName: 'chrome',
            shardTestFiles: true,
            maxInstances: 3
        }
    ],

    suites: {
        full: '../test/protractor/**/*Spec.js'
    },

    baseUrl: 'http://127.0.0.1:9001',
    jasmineNodeOpts: {
        // onComplete will be called just before the driver quits.
        onComplete: null,
        // If true, display spec names.
        isVerbose: false,
        // If true, print colors to the terminal.
        showColors: true,
        // If true, include stack traces in failures.
        includeStackTrace: true,
        // Default time to wait in ms before a test fails.
        defaultTimeoutInterval: 30000
    }
};
