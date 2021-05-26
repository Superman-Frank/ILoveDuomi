//
//  NotificationService.m
//  NotificationService
//
//  Created by nongbaoling on 2021/5/26.
//

#import "NotificationService.h"
#import <GTExtensionSDK/GeTuiExtSdk.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSLog(@"----将APNs信息交由个推处理----");

       [GeTuiExtSdk handelNotificationServiceRequest:request withAttachmentsComplete:^(NSArray *attachments, NSArray* errors) {

           //注意：是否修改下发后的title内容以项目实际需求而定
           //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [需求而定]", self.bestAttemptContent.title];

           self.bestAttemptContent.attachments = attachments; //设置通知中的多媒体附件

           NSLog(@"个推处理APNs消息遇到错误：%@",errors); //如果APNs处理有错误，可以在这里查看相关错误详情

           self.contentHandler(self.bestAttemptContent); //展示推送的回调处理需要放到个推回执完成的回调中
       }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    
    [GeTuiExtSdk destory];
    self.contentHandler(self.bestAttemptContent);
}

@end
