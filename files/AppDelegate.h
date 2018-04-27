#import <UIKit/UIKit.h>
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVAppDelegate.h>
#import "AppDelegate.h"
#import "UnityAppController.h"
#import "unityARCaller.h"

@interface AppDelegate : CDVAppDelegate

@property (nonatomic, strong) UIWindow* unityWindow;
@property (nonatomic, strong) UnityAppController *unityController;

@property (readwrite, assign) BOOL initialized;
@property (readwrite, assign) BOOL unityInitialized;

@property (readwrite, assign) unityARCaller* ionicComms;
@property (nonatomic, copy) NSString* m_waitingMessage;

@property (readwrite, strong) UIApplication* m_application;
@property (readwrite, strong) NSDictionary* m_options;

- (void)shouldAttachRenderDelegate;

- (void)showUnityWindow;
- (void)hideUnityWindow;
- (void)notifyUnityReady;

- (void)sendMessageToUnity:(NSString*)parameter;
- (void)sendMessageToUnity:(NSString*)func parameter:(NSString*)parameter;

- (void)assignIonicComms:(unityARCaller*)comms;
- (void)sendMessageToIonic:(NSString*)message;
- (void)sendResultToIonic:(NSString*)result;

@end
