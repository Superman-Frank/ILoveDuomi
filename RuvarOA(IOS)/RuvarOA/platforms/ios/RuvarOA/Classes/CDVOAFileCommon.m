/*
 OAFileCommon 文件操作接口
 create:qin
 createDate:2014-10-17
 createBy:www.ruvar.com
*/
#import "CDVOAFileCommon.h"
#import "JSONKit.h"

@implementation CDVOAFileCommon
/* 下载文件 */
-(void)RF_DownLoadFile:(CDVInvokedUrlCommand*)command
{
	NSLog(@"OAPlugin===============>RF_DownLoadFile:not enabled!!");
}

/* 打开缓存文件 */
-(void)RF_OpenFile:(CDVInvokedUrlCommand*)command
{
	CDVPluginResult* pluginresult=nil;
	NSMutableDictionary* mdic=[NSMutableDictionary dictionaryWithCapacity:3];

	NSArray* array=command.arguments;
	NSLog(@"filename:======>%@",array);
	if([array count]>0){
		NSDictionary* dic=[array objectAtIndex:0];
		NSString* path=[dic valueForKey:@"path"];
		NSString* filetype=[dic valueForKey:@"filetype"];

		
		if(![path isEqualToString:@""]){
			//NSString* path=
			NSLog(@"OAFileCommon===========>%@",path);
			NSLog(@"OAFileCommon===========>%@",filetype);
		
        	// calls into javascript global function 'handleOpenURL'
			AppDelegate *app = [UIApplication sharedApplication].delegate;
			NSString *filePath = path;
			//NSLog(@"filepath========>%@",path);
			NSURL *fileURL = [NSURL fileURLWithPath:filePath];
			NSLog(@"file serverpath=======>%@",fileURL);
			[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
			NSData* data=[NSData dataWithContentsOfURL:fileURL];
			[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
			NSLog(@"filedata=========>%@",data);
			[app.viewController.webView loadData:data MIMEType:filetype  textEncodingName:@"UTF-8" baseURL:nil];
			//[app.viewController.webview]
			//NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
			//[app.viewController.webView loadRequest:request];
			//NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", [app.viewController.webView fileURL description]];
			//[self.webView stringByEvaluatingJavaScriptFromString:jsString];
        	//self.openURL = nil;
			[mdic setObject:@"0" forKey:@"ret_code"];
			[mdic setObject:@"调用成功！" forKey:@"ret_message"];
  

			NSLog(@"OAFileCommon================>%@",path);
			
		}
		else{
			[mdic setObject:@"1" forKey:@"ret_code"];
			[mdic setObject:@"没有文件地址信息!" forKey:@"ret_errmeassage"];
			[mdic setObject:@"缓存文件失败或者没有文件信息!" forKey:@"ret_message"];
		}
		
		
	}
	else{
		[mdic setObject:@"-1" forKey:@"ret_code"];
		[mdic setObject:@"没有找到相关参数！" forKey:@"ret_errmessage"];
		[mdic setObject:@"没有找到文件信息！" forKey:@"ret_message"];
	}
	pluginresult=[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:mdic	];
	[self.commandDelegate sendPluginResult:pluginresult callbackId:command.callbackId];
}
/*  获取文件类型    */
-(NSString*)GetFileType:(NSString*) filename{
	// 获取文件后缀名
	//NSString* fileextent=[[filename componentsSeparatedByString:@"."] lastObject];
	NSMutableArray* arr=[[NSMutableArray alloc] init];

	NSString* returnstr=@"";
	// doc 1-2
	[arr addObject:@"doc"];
	[arr addObject:@"docx"];
	//excel 3-4
	[arr addObject:@"xls"];
	[arr addObject:@"xlsx"];
	//ppt 5-6
	[arr addObject:@"ppt"];
	[arr addObject:@"pptx"];
	//pdf 7
	[arr addObject:@"pdf"];
	// img 8-12
	[arr addObject:@"jpg"];
	[arr addObject:@"png"];
	[arr addObject:@"gif"];
	[arr addObject:@"bmp"];
	[arr addObject:@"jpeg"];
	// txt 13-14
	[arr addObject:@"txt"];
	[arr addObject:@"log"];
	// htm 15-17
	[arr addObject:@"htm"];
	[arr addObject:@"html"];
	[arr addObject:@"shtml"];
	// chm 18
	[arr addObject:@"chm"];
	// wav 19-24
	[arr addObject:@"mp3"];
	[arr addObject:@"wav"];
	[arr addObject:@"wma"];
	[arr addObject:@"ogg"];
	[arr addObject:@"ape"];
	[arr addObject:@"acc"];
	// video 25-36
	[arr addObject:@"avi"];
	[arr addObject:@"mov"];
	[arr addObject:@"asf"];
	[arr addObject:@"wmv"];
	[arr addObject:@"navi"];
	[arr addObject:@"3gp"];
	[arr addObject:@"ram"];
	[arr addObject:@"mkv"];
	[arr addObject:@"flv"];
	[arr addObject:@"mp4"];
	[arr addObject:@"rmvb"];
	[arr addObject:@"mpg"];




	return returnstr;

}
@end