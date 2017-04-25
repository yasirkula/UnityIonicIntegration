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
@property (readwrite, assign) unityARCaller* ionicComms;

- (void)shouldAttachRenderDelegate;

- (void)showUnityWindow;
- (void)hideUnityWindow;

- (void)assignIonicComms:(unityARCaller*)comms;
- (void)sendResultToIonic:(NSString*)message;

@end