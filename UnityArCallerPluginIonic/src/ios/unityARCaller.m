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
		[self callUnityObject:"IonicComms" Method:"OnMessageReceivedFromIonic" Parameter:[param UTF8String]];
	}*/
}

// Source: https://the-nerd.be/2014/08/07/call-methods-on-unity3d-straight-from-your-objective-c-code/
- (void)callUnityObject:(const char*)object Method:(const char*)method Parameter:(const char*)parameter 
{
    //UnitySendMessage(object, method, parameter);
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