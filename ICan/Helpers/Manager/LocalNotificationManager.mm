//
//  LocalNotificationManager.m
//  GongShuQu
//  本地通知管理
//  Created by SevenCat on 16/6/17.
//  Copyright © 2016年 拱墅区. All rights reserved.
//

#import "LocalNotificationManager.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#import "VoicePlayerTool.h"
#endif

@implementation LocalNotificationManager

+ (void)setLacalNotificationWithTitle:(NSString *)title user:(NSString *)user value:(NSString*)value {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.body = title;
    content.title = user;
    if (value) {
        content.userInfo = @{@"k1":value};
    }
    NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
    NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
    content.badge = @(UnReadMsgNumber+UnReadFriendSubscriptionAmount);
    UserConfigurationInfo *info = [BaseSettingManager sharedManager].userConfigurationInfo;
    if (info.isOpenSound) {
        content.sound = [UNNotificationSound defaultSound];
    }
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"messagePush" content:content trigger:nil];
    [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:request withCompletionHandler:nil];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber+UnReadFriendSubscriptionAmount];
    SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
    nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber+UnReadFriendSubscriptionAmount]];
    [[NetworkRequestManager shareManager]startRequest:nrequest responseClass:nil contentClass:nil success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

+(void)setLacalAvdioOrAudioNotificationWithMediaType:(NSString*)type user:(NSString *)user{
    //Create a local notification
    UNUserNotificationCenter *center  = [ UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    if ([type isEqualToString:@"VIDEO"]) {//音频
        content.title = [NSMutableString stringWithString:user];
        content.body = @"InviteYouVideoCall".icanlocalized;
        content.sound = [UNNotificationSound defaultSound];
    }else{
        content.title = [NSMutableString stringWithString:user];
        content.body = @"InviteYouVoiceCall".icanlocalized;
        content.sound = [UNNotificationSound defaultSound];
    }
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
    [center addNotificationRequest:requestAuth withCompletionHandler:nil];
    [[VoicePlayerTool sharedManager] playViedoOrAudioVoice];
}

@end
