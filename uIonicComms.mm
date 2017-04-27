//
//  HideUnity.m
//  NativeUnity
//
//  Created by Shaw Walters on 8/25/16.
//  Copyright © 2016 Shaw Walters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface MyIonicUnityPlugin:NSObject
+ (void)hideUnityWindow;
+ (void)sendResultToIonic:(char*)message;
+ (void)notifyUnityReady;
@end

@implementation MyIonicUnityPlugin

+ (void)hideUnityWindow
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel hideUnityWindow];
}

+ (void)sendResultToIonic:(char*)message
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel sendResultToIonic:[NSString stringWithUTF8String:message]];
}

+ (void)notifyUnityReady
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel notifyUnityReady];
}

@end

//C-wrapper that Unity communicates with
extern "C"
{
    void uHideUnity()
    {
        [MyIonicUnityPlugin hideUnityWindow];
    }
    
    void uSendResultToIonic( char* message )
    {
        [MyIonicUnityPlugin sendResultToIonic:message];
    }
    
    void uNotifyUnityReady()
    {
        [MyIonicUnityPlugin notifyUnityReady];
    }
}