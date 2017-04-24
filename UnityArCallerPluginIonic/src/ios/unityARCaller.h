#import <Cordova/CDV.h>

@interface unityARCaller : CDVPlugin

@property (readwrite, strong) NSString* cachedCallbackId;

- (void) launchAR:(CDVInvokedUrlCommand*)command;
- (void) returnResult:(NSString*)result;

@end