//
//  CDVOAPlugin.h
//  ruvarhrm
// OAPlugin:OA通用接口
//  Created by qin on 14-10-16.
//
//

#import <Cordova/CDVPlugin.h>
#import "AppDelegate.h"
#import "JSONKit.h"
@interface CDVOAPlugin : CDVPlugin
/* 获取信息Token  */
- (void)XG_GetToken:(CDVInvokedUrlCommand*)command;
/* 保存登录信息  */
- (void)RV_Login_Submit:(CDVInvokedUrlCommand*)command;
/* 读取登录信息 */
- (void)RV_Login_Read:(CDVInvokedUrlCommand*)command;
/* 信鸽返回Url参数地址 */
- (void)RV_XGUrl:(CDVInvokedUrlCommand*)command;
/* 是否注销app状态 */
-(void)RV_Login_Out:(CDVInvokedUrlCommand*)command;
/* 退出APP */
-(void)RV_Exit:(CDVInvokedUrlCommand*)command;
/* 获取服务器URL */
-(void)RV_SysUrl:(CDVInvokedUrlCommand*)command;
/* 跳转首页 */
-(void)RV_SysHome:(CDVInvokedUrlCommand*)command;
/* 重新登录 */
-(void)RV_Login:(CDVInvokedUrlCommand*)command;

@end
