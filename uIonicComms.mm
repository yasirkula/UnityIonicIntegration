//
//  HideUnity.m
//  NativeUnity
//
//  Created by Shaw Walters on 8/25/16.
//  Edited by Suleyman Yasir Kula on 7/20/17
//  Copyright © 2016 Shaw Walters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface MyIonicUnityPlugin:NSObject
+ (void)hideUnityWindow;
+ (void)sendMessageToIonic:(char*)message;
+ (void)sendResultToIonic:(char*)result;
+ (void)notifyUnityReady;
@end

@implementation MyIonicUnityPlugin

+ (void)hideUnityWindow
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel hideUnityWindow];
}

+ (void)sendMessageToIonic:(char*)message
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel sendMessageToIonic:[NSString stringWithUTF8String:message]];
}

+ (void)sendResultToIonic:(char*)result
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel sendResultToIonic:[NSString stringWithUTF8String:result]];
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
    
	void uSendMessageToIonic( char* message )
    {
        [MyIonicUnityPlugin sendMessageToIonic:message];
    }
	
    void uSendResultToIonic( char* result )
    {
        [MyIonicUnityPlugin sendResultToIonic:result];
    }
    
    void uNotifyUnityReady()
    {
        [MyIonicUnityPlugin notifyUnityReady];
    }
}