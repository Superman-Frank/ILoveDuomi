/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  RuvarHRM
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "XGPush.h"
#import "XGSetting.h"
#import <CoreLocation/CoreLocation.h>
#import <Cordova/CDVPlugin.h>

#define _IPHONE80_ 80000
@implementation AppDelegate

@synthesize window, viewController,deviceID;
/**************************开始注册信息鸽服务**************************/
-(void) registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    #endif
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
	[XGPush startApp:2200196239 appKey:@"I562J1P7WKFM"];
	void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //[XGPush registerPush];  //注册Push服务，注册后才能收到推送

    //[XGPush setAccount:@"testAccount1"];
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    //[XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    
    //本地推送示例
    /*
    NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:10];
    
    NSMutableDictionary *dicUserInfo = [[NSMutableDictionary alloc] init];
    [dicUserInfo setValue:@"myid" forKey:@"clockID"];
    NSDictionary *userInfo = dicUserInfo;
    
    [XGPush localNotification:fireDate alertBody:@"测试本地推送" badge:2 alertAction:@"确定" userInfo:userInfo];
    */
     
    // Override point for customization after application launch.


	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	//CGRect screenBounds=[[UIScreen mainScreen] applicationFrame];

#if __has_feature(objc_arc)
        self.window = [[UIWindow alloc] initWithFrame:screenBounds];
#else
        self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
#endif
    self.window.autoresizesSubviews = YES;


#if __has_feature(objc_arc)
        self.viewController = [[MainViewController alloc] init];
#else
        self.viewController = [[[MainViewController alloc] init] autorelease];
#endif

	

    // Set your app's start page by setting the <content src='foo.html' /> tag in config.xml.
    // If necessary, uncomment the line below to override it.
    // self.viewController.startPage = @"home.html";
	//[self.viewController.webView setScalesPageToFit:YES];

	//[slef.viewController.webView se]
	//self.viewController.webView.scalesPageToFit=YES;
	//self.viewController.webView.detectsPhoneNumbers = YES;

    // NOTE: To customize the view's frame size (which defaults to full screen), override
    // [self.viewController viewWillAppear:] in your view controller.
	//[self.viewController.webView setScalesPageToFit:YES];
	//[self.viewController.webView set];
	self.window.rootViewController = self.viewController;
    // 显示状态栏设置
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
	[self.viewController.webView setScalesPageToFit:YES];
    [self.window makeKeyAndVisible];

    //return YES;

    return YES;
}

/******************** 注册信鸽服务代码结束 *******************/
/******************** 注册成功获取token *******************/
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
		
        deviceID=deviceTokenStr;
		NSLog(@"Appdelegate===============>GetXGPushToken:%@",deviceID);
		
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    //[[XGSetting getInstance] setChannel:@"appstore"];
    //[[XGSetting getInstance] setGameServer:@"巨神峰"];
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    deviceID=deviceTokenStr;
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}/******************** 注册成功获取token结束 *******************/


- (id)init
{
    /** If you need to do any extra app-specific initialization, you can do it here
     *  -jm
     **/
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
    int cacheSizeDisk = 32 * 1024 * 1024; // 32MB
#if __has_feature(objc_arc)
        NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
#else
        NSURLCache* sharedCache = [[[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] autorelease];
#endif
    [NSURLCache setSharedURLCache:sharedCache];

    self = [super init];
    return self;
}

#pragma mark UIApplicationDelegate implementation

/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
//- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
//{
//    CGRect screenBounds = [[UIScreen mainScreen] bounds];
//
//#if __has_feature(objc_arc)
//        self.window = [[UIWindow alloc] initWithFrame:screenBounds];
//#else
//        self.window = [[[UIWindow alloc] initWithFrame:screenBounds] autorelease];
//#endif
//    self.window.autoresizesSubviews = YES;
//
//#if __has_feature(objc_arc)
//        self.viewController = [[MainViewController alloc] init];
//#else
//        self.viewController = [[[MainViewController alloc] init] autorelease];
//#endif

    // Set your app's start page by setting the <content src='foo.html' /> tag in config.xml.
    // If necessary, uncomment the line below to override it.
    // self.viewController.startPage = @"index.html";

    // NOTE: To customize the view's frame size (which defaults to full screen), override
    // [self.viewController viewWillAppear:] in your view controller.

//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];
//
//    return YES;
//}

// this happens while we are running ( in the background, or from within our own app )
// only valid if RuvarHRM-Info.plist specifies a protocol to handle
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    if (!url) {
        return NO;
    }
    
    // calls into javascript global function 'handleOpenURL'
    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];

    // all plugins will get the notification, and their handlers will be called
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:CDVPluginHandleOpenURLNotification object:url]];

    return YES;
}

// repost all remote and local notification using the default NSNotificationCenter so multiple plugins may respond
- (void)            application:(UIApplication*)application
    didReceiveLocalNotification:(UILocalNotification*)notification
{
    // re-post ( broadcast )
    [[NSNotificationCenter defaultCenter] postNotificationName:CDVLocalNotification object:notification];
}

//#ifndef DISABLE_PUSH_NOTIFICATIONS
//
//    - (void)                                 application:(UIApplication*)application
//        didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
//    {
//        // re-post ( broadcast )
//        NSString* token = [[[[deviceToken description]
//            stringByReplacingOccurrencesOfString:@"<" withString:@""]
//            stringByReplacingOccurrencesOfString:@">" withString:@""]
//            stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:CDVRemoteNotification object:token];
//    }
//
//    - (void)                                 application:(UIApplication*)application
//        didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
//    {
//        // re-post ( broadcast )
//        [[NSNotificationCenter defaultCenter] postNotificationName:CDVRemoteNotificationError object:error];
//    }
//#endif
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
//#else
//- (UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
//#endif
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    NSUInteger supportedInterfaceOrientations = (1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight) | (1 << UIInterfaceOrientationPortraitUpsideDown);

    return supportedInterfaceOrientations;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
    {
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
            {
                if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                    [self.locationManager requestAlwaysAuthorization];
                }
                NSLog(@"用户还未决定授权");
                break;
            }
            case kCLAuthorizationStatusRestricted:
            {
                NSLog(@"访问受限");
                break;
            }
            case kCLAuthorizationStatusDenied:
            {
                // 类方法，判断是否开启定位服务
                if ([CLLocationManager locationServicesEnabled]) {
                    NSLog(@"定位服务开启，被拒绝");
                } else {
                    NSLog(@"定位服务关闭，不可用");
                }
                break;
            }
            case kCLAuthorizationStatusAuthorizedAlways:
            {
                NSLog(@"获得前后台授权");
                break;
            }
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            {
                NSLog(@"获得前台授权");
                break;
            }
            default:
            break;
        }
}

@end
