/*
 OAFileCommon 文件操作接口
 create:qin
 createDate:2014-10-17
 createBy:www.ruvar.com
*/
#import <Cordova/CDVPlugin.h>
#import "AppDelegate.h"
@interface CDVOAFileCommon :CDVPlugin
/* 下载文件 */
-(void)RF_DownLoadFile:(CDVInvokedUrlCommand*)command;
/* 打开缓存文件 */
-(void)RF_OpenFile:(CDVInvokedUrlCommand*)command;

@end