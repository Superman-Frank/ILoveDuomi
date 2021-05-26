//
//  RLog.m
//  ruvaroa
//
//  Created by ruvar on 15/3/11.
//
//

#import <Foundation/Foundation.h>
#import "RLog.h"
@implementation RLog
-(void)TestString:(NSString *)stringvalue RString:(NSString *)rstring Times:(int)t{
    NSRange isHave=[stringvalue rangeOfString:rstring];
    NSLog(@"------------调试输出开始----------------\n");
    NSLog(@"调用次数:%d",t);
    NSLog(@"待检测字符串:%@",stringvalue);
    NSLog(@"检测字符串:%@",rstring);
    NSLog(@"Range is :%@",NSStringFromRange(isHave));
    NSLog(@"Range Value is : %d",isHave.length);
    NSLog(@"Range location is : %d",isHave.location);
    if(isHave.location==NSNotFound){
        NSLog(@"==============>未匹配指定字符串!");
    }
    
    NSLog(@"------------调试输出结束----------------\n");
}
@end