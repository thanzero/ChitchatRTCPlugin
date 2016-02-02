var exec = require('cordova/exec');

var swift = function () {
    this.name = "cordova-swift";
};

swift.prototype.freeCall = function (succ,error,type,option) {
	return exec(succ, error, "CallCordovaPlugin", "freeCall");
};

swift.prototype.videoCall = function (succ,error,type,option) {
	return exec(succ, error, "CallCordovaPlugin", "videoCall");
};

module.exports = new swift();