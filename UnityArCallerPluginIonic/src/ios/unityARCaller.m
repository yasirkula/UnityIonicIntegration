#import "unityARCaller.h"
#import "AppDelegate.h"

@implementation unityARCaller

- (void)launchAR:(CDVInvokedUrlCommand*)command
{
	/*self.cachedCallbackId = [command.callbackId copy];
	[(AppDelegate *)[UIApplication sharedApplication].delegate assignIonicComms:self];
    [(AppDelegate *)[UIApplication sharedApplication].delegate showUnityWindow];

    NSLog(@"Plugin Invoked");

	if( command.arguments != nil && [command.arguments count] > 0 )
	{
		NSString* param = [command.arguments objectAtIndex:0];
        [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToUnity:param];
	}*/
}

- (void)returnResult:(NSString*)result
{
    NSLog(@"Result returned");

	CDVPluginResult* cdvResult = [CDVPluginResult
						   resultWithStatus:CDVCommandStatus_OK
						   messageAsString:result];

	[self.commandDelegate sendPluginResult:cdvResult callbackId:self.cachedCallbackId];
}

@end