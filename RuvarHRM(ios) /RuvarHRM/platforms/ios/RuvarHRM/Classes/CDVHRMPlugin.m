// HRM 通用接口实现
// Create:Qin
// CreateDate:2014-10-17
// CreateBy: www.ruvar.com
#import "CDVHRMPlugin.h"
#import "XGPush.h"
#import "MainViewController.h"
@implementation CDVHRMPlugin
#import <SystemConfiguration/CaptiveNetwork.h>

/* 获取信息wifi信息  */
- (void)WifiInfo:(CDVInvokedUrlCommand *)command
    {
        NSLog(@"%s","HRMPlugin============>Action_WifiInfo,nocomperlied");
        //NSString* device=app.deviceID;
        CDVPluginResult* pluginResult=nil;
        NSMutableDictionary* mdic=[NSMutableDictionary dictionaryWithCapacity:1];
        NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
        for (NSString *ifnam in ifs) {
            NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            if (info[@"BSSID"]) {
                [mdic setObject:@{@"bssid":info[@"BSSID"],@"ssid":info[@"SSID"]} forKey:@"wifiJson"];
            }else{
                [mdic setObject:@"0" forKey:@"wifiJson"];
            }
        }
        pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:mdic];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

/* 获取信息Token  */
- (void)XG_GetToken:(CDVInvokedUrlCommand *)command
{
	NSLog(@"%s","HRMPlugin============>XG_GetToken,nocomperlied");
    NSString * UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"UUID = %@",UUID);
	//NSString* device=app.deviceID;
	CDVPluginResult* pluginResult=nil;
	NSMutableDictionary* mdic=[NSMutableDictionary dictionaryWithCapacity:1];
	if(UUID !=nil){
        [mdic setObject:UUID forKey:@"token"];
	}else{
		[mdic setObject:@"0" forKey:@"token"];
	}
	pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:mdic];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


/* 提交登录信息  */
- (void)RV_Login_Submit:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginResult=nil;
    NSLog(@"HRMPlugin=============>loginsave");
	NSString* callback = @"[{ret_code:-1,message:'写入数据出错！'}]";
	pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callback];
	NSArray	* arr=command.arguments;
	if ([arr count]>0) {
        NSDictionary *dic=[arr objectAtIndex:0];
		NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
 		NSString * autoLogin =[dic valueForKey:@"AutoLogin"];
 		[defaults setValue:autoLogin forKey:@"_autologin"];
 		NSString * LoginPwd=[dic valueForKey:@"LoginPwd"];
 		[defaults setValue:LoginPwd forKey:@"_loginpwd"];
		NSString * LoginUser=[dic valueForKey:@"LoginUser"];
		[defaults setValue:LoginUser forKey:@"_loginUser"];
		NSString* SavePwd= [dic valueForKey:@"SavePwd"];
		[defaults setValue:SavePwd forKey:@"_savepwd"];
		NSString* SysUrl=[dic valueForKey:@"SysUrl"];
		[defaults setValue:SysUrl forKeyPath:@"_sysUrl"];
 		[defaults synchronize];//用synchronize方法把数据持久化到standardUserDefaults数据库
		callback=@"[{ret_code:0}]";
		pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK  messageAsString:callback];
		
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/* 读取登录信息 */
- (void)RV_Login_Read:(CDVInvokedUrlCommand*)command
{
    NSLog(@"HRMPlugin=========>startoread logininfo");
	CDVPluginResult* pluginResult=nil;
	pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString* SysUrl=[defaults objectForKey:@"_sysUrl"];
     NSString * autoLogin =[defaults objectForKey:@"_autologin"];
    NSString * LoginPwd=[defaults objectForKey:@"_loginpwd"];
    NSString * LoginUser=[defaults objectForKey:@"_loginUser"];
    NSString* SavePwd=[defaults objectForKey:@"_savepwd"];
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:6];
	[dictionary setObject:@"0" forKey:@"ret_code"];
    if(SysUrl){
        [dictionary setObject:SysUrl forKey:@"SysUrl"];
    }
    if(autoLogin){
        [dictionary setObject:autoLogin forKey:@"AutoLogin"];
    }
    if(LoginPwd){
        [dictionary setObject:LoginPwd forKey:@"LoginPwd"];
    }
    if(LoginUser){
        [dictionary setObject:LoginUser forKey:@"LoginUser"];
    }
    if(LoginUser){
        [dictionary setObject:SavePwd forKey:@"SavePwd"];
    }
	pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
    NSLog(@"HRMPlugin==========>endtoread logininfo");
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
/* 信鸽返回Url参数地址 */
- (void)RV_XGUrl:(CDVInvokedUrlCommand*)command
{
	NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
	NSString * XGUrl=[defaults valueForKey:@"_xgurl"];
	NSMutableDictionary * dictionary=[NSMutableDictionary dictionaryWithCapacity:2];
	[dictionary setObject:@"0" forKey:@"ret_code"];
	if(XGUrl!=nil){
		[dictionary setObject:XGUrl forKey:@"XGUrl"];
		//读取一次后清除信鸽跳转信息
		[defaults setObject:@"" forKey:@"_xgurl"];
		[defaults synchronize];
	}
	else{
		[dictionary setObject:@"" forKey:@"XGUrl"];
	}

	NSLog(@"OAPlugin===================>RV_XGUrl:%@",XGUrl);
	CDVPluginResult* pluginResult=nil;
	pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}
/* 是否注销app状态 */
-(void)RV_Login_Out:(CDVInvokedUrlCommand*)command
{
	NSArray* array=command.arguments;
	CDVPluginResult* resultPlugin=nil;
	resultPlugin=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	if([array count]>0){
		NSDictionary* dic=[array objectAtIndex:0];
		NSMutableDictionary * dicx=[NSMutableDictionary dictionaryWithCapacity:3];
		NSString* act=[dic valueForKey:@"act"];
		if([act isEqualToString:@"get"]){
			NSUserDefaults* defualts=[NSUserDefaults standardUserDefaults];
			NSString * autoLogin=[defualts valueForKey:@""];
			//NSMutableDictionary * mdic=[[NSMutableDictionary dictionaryWithCapacity:3];
			[dicx setObject:@"0" forKey:@"ret_code"];
			[dicx setObject:@"get" forKey:@"act"];
			[dicx setObject:autoLogin forKey:@"status"];
			[defualts setObject:@"" forKey:@"Sys_AutoLoginOut"];
			[defualts synchronize];
		}
		else{
			NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
			NSString * status=[defaults valueForKey:@""];
			if([status isEqualToString:@"1" ])
			{
				[defaults setObject:@"1" forKey:@"Sys_AutoLoginOut"];
				[defaults synchronize];
				[dicx setObject:@"0" forKey:@"ret_code"];
				[dicx setObject:@"set" forKey:@"act"];
				[dicx setObject:@"1" forKey:@"status"];
			}
		}
		resultPlugin=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dicx];
	}
	else{
		NSMutableDictionary* dicback=[NSMutableDictionary dictionaryWithCapacity:2];
		[dicback setObject:@"1" forKey:@"ret_code"];
		[dicback setObject:@"参数错误！" forKey:@"ret_message"];
		resultPlugin=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dicback];
	}
	[self.commandDelegate sendPluginResult:resultPlugin callbackId:command.callbackId];

}
/* 退出APP */
-(void)RV_Exit:(CDVInvokedUrlCommand*)command
{
	AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
     
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];}
        exit(0);
    }];
}
/* 获取服务器URL */
-(void)RV_SysUrl:(CDVInvokedUrlCommand*)command
{
	NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
	NSString * SysUrl=[defaults valueForKey:@"_sysUrl"];
	NSMutableDictionary * dictionary=[NSMutableDictionary dictionaryWithCapacity:2];
	[dictionary setObject:@"0" forKey:@"ret_code"];
	[dictionary setObject:SysUrl forKey:@"SysUrl"];
	NSLog(@"OAPlugin===================>RV_SysUrl:%@",SysUrl);
	CDVPluginResult* pluginResult=nil;
	pluginResult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dictionary];
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


/* 跳转首页 */
-(void)RV_SysHome:(CDVInvokedUrlCommand*)command
{
    NSLog(@"返回首页!");
	[self GotoURL:@"www/home.html"];
}
//跳转到resource相关的页面
-(void)GotoURL:(NSString*) htmlname{
	AppDelegate *app = [UIApplication sharedApplication].delegate;
	NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
	NSString *filePath  = [resourcePath stringByAppendingPathComponent:htmlname];

	NSString *htmlstring =[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	[app.viewController.webView loadHTMLString:htmlstring  baseURL:[NSURL fileURLWithPath: filePath]];
}
/* 重新登录 */
-(void)RV_Login:(CDVInvokedUrlCommand*)command
{
	NSArray* arr=command.arguments;
	CDVPluginResult* result=[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	NSMutableDictionary* mdic=[NSMutableDictionary dictionaryWithCapacity:2];
	if([arr count]>0){
		NSDictionary* dic=[arr objectAtIndex:0];
		NSString* backurl=[dic valueForKey:@"backurl"];
		if(![backurl isEqualToString:@""]){
			NSUserDefaults* defults=[NSUserDefaults standardUserDefaults];
			[defults setObject:backurl forKey:@"_xgurl"];
			[defults synchronize];
		}
	}
	[mdic setObject:@"0" forKey:@"ret_code"];
	[mdic setObject:@"" forKey:@"ret_message"];
	result=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:mdic];

	[self GotoURL:@"www/index.html"];
}
@end
