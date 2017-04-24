var exec = require('cordova/exec');

module.exports = {
	launchAR: function(param, successCallback, failCallback) {
		exec(successCallback, failCallback, "LaunchAR", "launchAR", [param]);
	}
};