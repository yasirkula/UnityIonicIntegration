#import <Cordova/CDV.h>

@interface unityARCaller : CDVPlugin

@property (readwrite, strong) NSString* cachedCallbackId;

- (void) launchAR:(CDVInvokedUrlCommand*)command;
- (void) sendMessage:(CDVInvokedUrlCommand*)command;
- (void) receivedMessageFromUnity:(NSString*)message;
- (void) returnResult:(NSString*)result;

@end