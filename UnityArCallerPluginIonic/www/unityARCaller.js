var exec = require('cordova/exec');

module.exports = {
	launchAR: function(param, onReturnedToIonicCallback, onMessageReceivedCallback) {
		if( !param )
			param = "";
		
		exec( function( unityParam ) {
			if( unityParam )
			{
				if( unityParam.startsWith( "RETURN" ) )
				{
					if( unityParam.length > 6 )
						onReturnedToIonicCallback( unityParam.substring( 6 ) );
					else
						onReturnedToIonicCallback( "" );
				}
				else if( unityParam.startsWith( "MESSAGE" ) )
				{	
					if( unityParam.length > 7 )
						onMessageReceivedCallback( unityParam.substring( 7 ) );
					else
						onReturnedToIonicCallback( "" );
				}
				else
					console.log( 'ERROR: type of unityParam is not recognized!' );
			}
			else
			{
				console.log( 'ERROR: parameter unityParam is null in Unity2Ionic callback!' );
			}
		}, null, "LaunchAR", "launchAR", [param] );
	},
	sendMessage: function(func, param) {
		if( func && func.length > 0 )
		{
			if( !param )
				param = "";
			
			exec( null, null, "SendMessage", "sendMessage", [func, param] );
		}
		else
		{
			console.log( 'ERROR: parameter func is null or empty in sendMessage!' );
		}
	}
};