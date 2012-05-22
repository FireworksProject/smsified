require('coffee-script');

var FS = require('fs')
  , PATH = require('path')
  , TRM = require('treadmill')
  , LIVE = process.argv[2]

global.INDEX = '../smsified/index';

if (LIVE) {
    global.USERNAME = process.argv[2]
    global.PASSWORD = process.argv[3]
    global.ADDRESS = process.argv[4]
    global.TARGET = process.argv[5]
} else {
    global.USERNAME = 'mocked_username'
    global.PASSWORD = 'mocked_password'
    global.ADDRESS = '5555555555'
    global.TARGET = '5555555555'
}

function checkTestFile(filename) {
    if (LIVE) {
        return /^live/.test(filename);
    } else {
        return /^test/.test(filename);
    }
}

function resolvePath(filename) {
    return PATH.join(__dirname, filename);
}

var listing = FS.readdirSync(__dirname);
var filepaths = listing.filter(checkTestFile).map(resolvePath);

TRM.run(filepaths, function (err) {
    if (err) process.exit(2);
    process.exit();
});
