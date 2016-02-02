var exec = require('cordova/exec');

var swift = function () {
    this.name = "cordova-swift";
};

swift.prototype.freeCall = function (succ,error,type,option) {
	return exec(succ, error, "CallCordovaPlugin", "freeCall");
};

swift.prototype.getCallerID = function (succ,error,type,option) {
	return exec(succ, error, "CallCordovaPlugin", "getCallerID");
};

module.exports = new swift();