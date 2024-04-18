//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/9/4
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  AppDelegate+APNS.m
 - Description:
 - Function List:
 - History:
 */


#import "AppDelegate+APNS.h"
#import "ChatViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "C2CHelperViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@implementation AppDelegate (APNS)
-(void)registerNotification:(UIApplication*)application{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //必须写代理，不然无法监听通知的接收与点击事件
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error && granted) {
            //用户点击允许
            DDLogInfo(@"注册成功");
        }else{
            //用户点击不允许
            DDLogInfo(@"注册失败");
        }
    }];
    
    // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
    //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        DDLogInfo(@"========%@",settings);
    }];
    
    //注册远程推送
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
- (void)applicationAPNS:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
        if (![deviceToken isKindOfClass:[NSData class]]) {
            //记录获取token失败的描述
            return;
        }
        const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
        NSString *strToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                              ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                              ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                              ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
        [UserInfoManager sharedManager].deviceToken=strToken;
        
    } else {
        NSString *token = [NSString
                           stringWithFormat:@"%@",deviceToken];
        token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        [UserInfoManager sharedManager].deviceToken=token;
    }
    if ([UserInfoManager sharedManager].loginStatus) {
        [WebSocketManager.sharedManager pushDeviceToken];
    }
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    NSData *pushKitToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushKitToken"];
    [[NIMSDK sharedSDK] updatePushKitToken:pushKitToken];
}
/// 收到推送后，会先调用这个方法，它可以设置推送要显示的方式是啥 常用的配置如代码所示
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    //    NSLog(@"willPresentNotification");
    //    UNNotificationPresentationOptions options = UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge;
    //    completionHandler(options);
}

// 上面的代理方法走了之后，会在用户与你推送的通知进行交互时被调用，包括用户通过通知打开了你的应用，或者点击或者触发了某个 action
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    UNNotificationContent *content = response.notification.request.content;
    NSLog(@"didReceiveNotificationResponse %@", content);
    NSDictionary *responseDict = content.userInfo;
    NSLog(@"didReceiveNotificationResponse %@", responseDict);
    [self receiveNotification:responseDict];
    completionHandler();
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
}

-(void)dimssVc{
    UIViewController*topVc=[AppDelegate shared].topVC;
    if (topVc.presentingViewController) {
        [topVc dismissViewControllerAnimated:NO completion:^{
            [self dimssVc];
        }];
    }else if (topVc.navigationController.viewControllers.count>1) {
        [[AppDelegate shared].curNav popToRootViewControllerAnimated:NO];
        [self dimssVc];
    }
}

- (void)receiveNotification:(NSDictionary *)userInfo {
    NSTimeInterval delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (userInfo) {
            BaseMessageInfo *info = [BaseMessageInfo mj_objectWithKeyValues:[userInfo objectForKey:@"k1"]];
            if ([info.msgType isEqualToString:C2COrderMessageType]) {
                [self dimssVc];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    C2CHelperViewController *vc = [[C2CHelperViewController alloc]init];
                    AppDelegate.shared.curNav.tabBarController.selectedIndex = 0;
                    [[AppDelegate shared]pushViewController:vc animated:NO];
                });
            }else{
                if (info.fromId||info.groupId) {
                    NSString *chatId = info.groupId?:info.fromId;
                    NSString *chatType = info.groupId?GroupChat:UserChat;
                    NSString *autype = info.authorityType;
                    NSString *circleUserid = info.fromCircleUserId;
                    [self dimssVc];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UIViewController *vc;
                        AppDelegate.shared.curNav.tabBarController.selectedIndex = 0;
                        if ([autype isEqualToString:AuthorityType_circle]) {
                            vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatId,kchatType:chatType,kauthorityType:autype,kcircleUserId:circleUserid}];
                        }else if([autype isEqualToString:AuthorityType_friend]){
                            vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatId,kchatType:chatType,kauthorityType:autype}];
                        }else if([autype isEqualToString:AuthorityType_secret]){
                            vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatId,kchatType:chatType,kauthorityType:autype}];
                        }else {
                            if([info.msgType isEqualToString:Notice_AddFriendMessageType]){
                                NoticeAgreeFriendInfo *msgInfo = [NoticeAgreeFriendInfo mj_objectWithKeyValues:[NSString decodeUrlString: info.msgContent]];
                                if ([msgInfo.process isEqualToString:@"apply"]) {
                                    vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForNewFriendsViewController];
                                }else if([msgInfo.process isEqualToString:@"agree"]){
                                    vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatId,kchatType:chatType,kauthorityType:AuthorityType_friend}];
                                }
                            }
                        }
                        [[AppDelegate shared]pushViewController:vc animated:NO];
                    });
                }
            }
        }
    });
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(nullable UNNotification *)notification{
    
}
@end
