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
//  MainViewController.h
//  RuvarHRM
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"
#import "RLog.h"

@implementation MainViewController
@synthesize ProgressBar;//,activityIndicator;
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    //self.view.backgroundColor = [UIColor colorWithRed:70/255.0 green:202/255.0 blue:94/255.0 alpha:1]; //设置 背景颜色
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        CGRect viewBounds = [self.webView bounds];
//        viewBounds.origin.y = 20;
//        viewBounds.size.height = viewBounds.size.height - 20;
//        self.webView.frame = viewBounds;
//    }

    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
	NSLog(@"=========>viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	NSLog(@"==========>viewDidUnLoad");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}
*/

#pragma mark UIWebDelegate implementation

// star progressbar

//- (void) webViewDidStartLoad:(UIWebView*)theWebView
- (void) webViewDidStartLoad:(UIWebView*)webView
{
//    return [super webViewDidStartLoad:theWebView];
	return [super webViewDidStartLoad:webView];

}


//- (void)webViewDidFinishLoad:(UIWebView*)theWebView
//{
-(void)webViewDidFinishLoad:(UIWebView*) webView{
    // Black base color for background matches the native apps
//    theWebView.backgroundColor = [UIColor blackColor];
//    return [super webViewDidFinishLoad:theWebView];
    if(webView.isLoading){
        return;
    }
    
    webView.backgroundColor=[UIColor blackColor];
    /* 2016-04-25 注销 if(ProgressBar!=nil){
     [ProgressBar dismissWithClickedButtonIndex:0 animated:YES];
     ProgressBar=nil;
     }
     if(ProgressBar!=nil){
     [activityIndicator stopAnimating];
     [ProgressBar removeFromSuperview];
     }*/
    NSLog(@"加载网页结束!");
    return [super webViewDidFinishLoad:webView];
    
}

/* Comment out the block below to over-ride */





- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    NSLog(@"faild:%@",error);
    //忽略没加载完发起下一次请求-999
	
    if([error code] == NSURLErrorCancelled){
        return;
    }
    [ProgressBar dismissWithClickedButtonIndex:0 animated:YES];
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
    return [super webView:theWebView didFailLoadWithError:error];
}

- (BOOL) webView:(UIWebView*)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    //捕获404错误
    
    //捕获404end
    
    NSURL * url=[request URL];
    if([[url scheme] isEqual:@"pwInvoke"]&&ProgressBar!=nil){
        //2016 04-25 注销 [ProgressBar dismissWithClickedButtonIndex:0 animated:YES];
        //2016-04-25  ProgressBar=nil;
        NSLog(@"finish:/.......%@",[url scheme]);
    }else
    {
        if([[url scheme] isEqual:@"gap"]&&ProgressBar!=nil){
            //2016-05-25 [ProgressBar dismissWithClickedButtonIndex:0 animated:YES];
            //2016-04-05/ iyqi ProgressBar=nil;
            NSLog(@"finish:/.......%@",[url scheme]);
            
        }
        
        /**
         此处为发件人卡死修复,添加判断
         
         
         &&[nurl rangeOfString:eurl].location == NSNotFound
         */
        NSString *eurl=@"emailaddr.html";
        NSString *nurl=[url absoluteString];
        if([[url scheme] isEqual:@"http"]&&[nurl rangeOfString:eurl].location == NSNotFound){
            NSLog(@"http调用	");
            /* 2016-04-25注销
             if(ProgressBar==nil){
             
             ProgressBar=[[UIAlertView alloc] initWithTitle:nil message:@"正在加载数据..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
             
             UIActivityIndicatorView *activieView=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)]; //initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];//initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
             //activieView.center=CGPointMak	e(self.view.center.x, 240);
             activieView.frame=CGRectMake(120.f,48.0f,37.0f,37.0f);
             //[self.navigationController.view addSubview:activieView];
             
             [ProgressBar addSubview:activieView];
             [activieView startAnimating];
             [ProgressBar setDelegate:self];
             [ProgressBar show];
             }
             else{
             
             }*/
            
            //NSString * _url=theWebView.request.URL.absoluteString;
            //NSLog(@"准备加载的页面!\n address is:%@",_url);
            //NSLog(@"\naddress1 is:%@",theWebView.request.URL.absoluteString);
            //NSString * requestURL=theWebView.request.URL.absoluteString;
            //NSLog(@"待加载网页地址为:%@",requestURL);
            //NSString* tempurl=[NSString localizedStringWithFormat:@"%D  %@",Count,requestURL];
            //[RLog TestString:tempurl RString:@"/www/index.html" Times:Count];
            //[RLog TestString:tempurl RString:@"/www/home.html" Times:Count];
            //Count++;
            /*
             NSRange isHome=[url.absoluteString rangeOfString:@"www/home.html"];
             NSRange isIndex=[url.absoluteString rangeOfString:@"www/index.html"];
             if([url.absoluteString isEqualToString:@""]){
             //NSLog(@"第一次开始加载^");
             }
             else{
             //NSLog(@"StarLoadUrl:%@",requestURL);
             // *if(ProgressBar==nil){
             ProgressBar =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 340, 480)];
             [ProgressBar setTag:103];
             [ProgressBar setBackgroundColor:[UIColor blackColor] ];
             [ProgressBar setAlpha:0.4];
             [webView addSubview:ProgressBar];
             activityIndicator =[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
             [activityIndicator setCenter:ProgressBar.center];
             [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
             [ProgressBar addSubview:activityIndicator];
             //[ProgressBar release];
             
             }
             else{
             [webView addSubview:ProgressBar];
             }* //
             
             if(ProgressBar==nil){
             //NSString* requestURl=;
             //NSLog(@"WebViewUrl:%@",webView.request.URL.absoluteString);
             
             
             if(isHome.location==NSNotFound && isIndex.location==NSNotFound){
             //NSLog(@"加载网页....:HaveHome");
             [ProgressBar show];
             }
             }
             else{
             if(isHome.location==NSNotFound && isIndex.location==NSNotFound){
             // NSLog(@"加载网页:%@",NSStringFromRange(isHome));
             [ProgressBar show];
             }
             }
             }*/
        }
    }
    return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
    
    
    
    
    
//    NSURL * url=[request URL];
//    if([[url scheme] isEqualToString:@"gap"]){
//        return NO;
//    }
//    return [super webView:theWebView shouldStartLoadWithRequest:request navigationType:navigationType];
}


@end

@implementation MainCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
   in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

/*
   NOTE: this will only inspect execute calls coming explicitly from native plugins,
   not the commandQueue (from JavaScript). To see execute calls from JavaScript, see
   MainCommandQueue below
*/
- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
   in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end
