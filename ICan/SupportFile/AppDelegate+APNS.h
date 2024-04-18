//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 2019/9/4
- System_Version_MACOS: 10.14
- EasyPay
- File name:  AppDelegate+APNS.h
- Description:
- Function List: 
- History:
*/
        

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <NIMSDK/NIMSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (APNS)<UNUserNotificationCenterDelegate>



-(void)registerNotification:(UIApplication*)application;

- (void)applicationAPNS:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;


- (void)receiveNotification:(NSDictionary *)userInfo;
//- (void)applicationAPNS:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo;

//-(void)applicationAPNS:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
