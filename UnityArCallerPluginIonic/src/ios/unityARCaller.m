#import "unityARCaller.h"
#import "AppDelegate.h"

@implementation unityARCaller

- (void)launchAR:(CDVInvokedUrlCommand*)command
{
	/*self.cachedCallbackId = [command.callbackId copy];
	[(AppDelegate *)[UIApplication sharedApplication].delegate assignIonicComms:self];
	[(AppDelegate *)[UIApplication sharedApplication].delegate showUnityWindow];

	NSLog(@"Launching Unity");

	if( command.arguments != nil && [command.arguments count] > 0 )
	{
		NSString* param = [command.arguments objectAtIndex:0];
		[(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToUnity:param];
	}*/
}

- (void)sendMessage:(CDVInvokedUrlCommand*)command
{
	/*NSLog(@"Calling Unity function");

	if( command.arguments != nil && [command.arguments count] > 1 )
	{
		NSString* func = [command.arguments objectAtIndex:0];
		NSString* param = [command.arguments objectAtIndex:1];
		[(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToUnity:func parameter:param];
	}*/
}

- (void)receivedMessageFromUnity:(NSString*)message
{
	NSLog(@"Message received from Unity");

	CDVPluginResult* cdvResult = [CDVPluginResult
							resultWithStatus:CDVCommandStatus_OK
							messageAsString:[NSString stringWithFormat:@"%@%@",@"MESSAGE",message]];

	[cdvResult setKeepCallbackAsBool:YES];
	[self.commandDelegate sendPluginResult:cdvResult callbackId:self.cachedCallbackId];
}

- (void)returnResult:(NSString*)result
{
	NSLog(@"Result returned");

	CDVPluginResult* cdvResult = [CDVPluginResult
							resultWithStatus:CDVCommandStatus_OK
							messageAsString:[NSString stringWithFormat:@"%@%@",@"RETURN",result]];

	[cdvResult setKeepCallbackAsBool:NO];
	[self.commandDelegate sendPluginResult:cdvResult callbackId:self.cachedCallbackId];
}

@end