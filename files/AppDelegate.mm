#import "AppDelegate.h"
#import "MainViewController.h"

//for vuforia:
//#import "VuforiaRenderDelegate.h"
//extern "C" void VuforiaRenderEvent(int marker);

@implementation AppDelegate

- (void)shouldAttachRenderDelegate
{
    NSLog(@"should attach render delgate");
    if( self.initialized )
    {
        //for vuforia:
        //self.unityController.renderDelegate = [[VuforiaRenderDelegate alloc] init];
        //UnityRegisterRenderingPlugin(NULL, &VuforiaRenderEvent);
    }
}

- (UIWindow *)unityWindow {
    return UnityGetMainWindow();
}

- (void) showUnityWindow {
    NSLog(@"showUnityWindow");
    
    if (!self.initialized)
    {
        self.unityController = [[UnityAppController alloc] init];
        [self.unityController application:self.m_application didFinishLaunchingWithOptions:self.m_options];
        
        self.m_waitingMessage = nil;
        self.m_application = nil;
        self.m_options = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillTerminateCallback:)
                                                     name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActiveCallback:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActiveCallback:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForegroundCallback:)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackgroundCallback:)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        self.initialized = YES;
    }
    
    [self onAppDidBecomeActiveCallback:nil];
    [self.unityWindow makeKeyAndVisible];
}

-(void) hideUnityWindow {
    NSLog(@"hideUnityWindow");
    
    //[self onAppWillResignActiveCallback:nil];
    [self.window makeKeyAndVisible];
}

-(void)notifyUnityReady {
    NSLog(@"unityReady notified");
    
    self.unityInitialized = YES;
    
    if( self.m_waitingMessage != nil )
    {
        [self sendMessageToUnity:self.m_waitingMessage];
        self.m_waitingMessage = nil;
    }
}

// Source: https://the-nerd.be/2014/08/07/call-methods-on-unity3d-straight-from-your-objective-c-code/
- (void)sendMessageToUnity:(NSString*)parameter
{
	if( !parameter || [parameter isKindOfClass:[NSNull class]] )
		return;

    if( self.unityInitialized )
        UnitySendMessage("IonicComms", "OnMessageReceivedFromIonic", [parameter UTF8String]);
    else
        self.m_waitingMessage = parameter;
}

- (void)sendMessageToUnity:(NSString*)func parameter:(NSString*)parameter
{
	if( !func || [func isKindOfClass:[NSNull class]] )
		return;
	
	if( !parameter || [parameter isKindOfClass:[NSNull class]] )
		return;
	
    if( self.unityInitialized )
        UnitySendMessage("IonicComms", [func UTF8String], [parameter UTF8String]);
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    self.viewController = [[MainViewController alloc] init];
    
    self.m_application = application;
    self.m_options = launchOptions;
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)assignIonicComms:(unityARCaller*)comms
{
    self.ionicComms = comms;
}

- (void)sendMessageToIonic:(NSString*)message
{
	if( !message || [message isKindOfClass:[NSNull class]] )
		return;
	
    [self.ionicComms receivedMessageFromUnity:message];
}

- (void)sendResultToIonic:(NSString*)result
{
	if( !result || [result isKindOfClass:[NSNull class]] )
		return;
	
    [self.ionicComms returnResult:result];
}

- (void)onAppWillTerminateCallback:(NSNotification*)notification
{
    [self.unityController applicationWillTerminate:[UIApplication sharedApplication]];
}

- (void)onAppWillResignActiveCallback:(NSNotification*)notification
{
    [self.unityController applicationWillResignActive:[UIApplication sharedApplication]];
}

- (void)onAppWillEnterForegroundCallback:(NSNotification*)notification
{
    [self.unityController applicationWillEnterForeground:[UIApplication sharedApplication]];
}

- (void)onAppDidBecomeActiveCallback:(NSNotification*)notification
{
    [self.unityController applicationDidBecomeActive:[UIApplication sharedApplication]];
}

- (void)onAppDidEnterBackgroundCallback:(NSNotification*)notification
{
    [self.unityController applicationDidEnterBackground:[UIApplication sharedApplication]];
}

-(void)applicationWillResignActive:(UIApplication *)application{
    //[self.unityController applicationWillResignActive:application];
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    //[self.unityController applicationDidEnterBackground:application];
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    //[self.unityController applicationWillEnterForeground:application];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    //[self.unityController applicationDidBecomeActive:application];
}

-(void)applicationWillTerminate:(UIApplication *)application{
    //[self.unityController applicationWillTerminate:application];
}

@end
