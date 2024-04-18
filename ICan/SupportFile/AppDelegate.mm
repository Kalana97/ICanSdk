/**
 112的ID是5
 113的ID是2
 */
#import "AppDelegate.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "GroupMemberInfo+WCTTableCoding.h"
#import "sys/utsname.h"
#import "AESEncryptor.h"
#import "WebSocketManager.h"
#import "AppDelegate+APNS.h"
#import "WXApi.h"
#import "GroupApplyInfo.h"
#import "ThirdKeyMacro.h"
#import "HandleOpenUrlManager.h"
#import "DDTTYLogger.h"
#import "MyCustomDDLogFormatter.h"
#import "WCDBManager.h"
#import "KeyChainTool.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import <AlipaySDK/AlipaySDK.h>
#import "VoicePlayerTool.h"
#import "ShareExtensionChaltListViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "CheckVersionTool.h"
#import "DomainExamineManager.h"
//#import "AdvertisingView.h"--- for reinstall purposes
#import "WCDBManager+UserMessageInfo.h"
#import "NERtcCallKit.h"
#import "UIDevice+Orientation.h"
#import "ChatModel.h"
#import "JudgeMessageTypeManager.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+GroupListInfo.h"
#import "GroupListInfo+WCTTableCoding.h"
#import "WCDBManager+ChatSetting.h"
#import "WCDBManager+ChatModel.h"
#import "ChatSetting.h"
#ifdef ICANTYPE // Firebase import only for iCan Meta
#import <FirebaseCore/FirebaseCore.h>
#import <Firebase/Firebase.h>
#endif
#import <PushKit/PushKit.h>
#import "PrivacyPermissionsTool.h"
#import "NeCallBaseViewController.h"
#import "WCDBManager+CircleUserInfo.h"
#import "LocalNotificationManager.h"
#import <Intents/Intents.h>
#import "WebSocketManager+HandleMessage.h"
#import "WebSocketManager.h"
#import "ChatListModel.h"
/**
 图片显示不出来 有可能是
 当项目里显示动图用到了FLAnimatedImageView，SDAnimatedImageView，YYAnimatedImageView就会有这个问题
 - (void)displayLayer:(CALayer *)layer {
 if (_curFrame) {
 layer.contents = (__bridge id)_curFrame.CGImage;
 } else {
 // If we have no animation frames, call super implementation. iOS 14+ UIImageView use this delegate method for rendering.
 if ([UIImageView instancesRespondToSelector:@selector(displayLayer:)]) {
 [super displayLayer:layer];
 }
 }
 }
 */
static NSString *const kBgTaskName = @"com.qishare.ios.wyw.QiAppRunInBackground";
#ifdef ICANTYPE
@interface AppDelegate ()<WXApiDelegate,PKPushRegistryDelegate,CXProviderDelegate,NERtcCallKitDelegate>
#else
@interface AppDelegate ()<WXApiDelegate,PKPushRegistryDelegate,NERtcCallKitDelegate>
#endif
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property(nonatomic, strong) NSMutableArray<ChatModel*> *msgItems;
@property(nonatomic,strong)  NSMutableArray<UserMessageInfo*> *friendItem;
@property (nonatomic, strong) PKPushRegistry *voipRegistry;
@property(nonatomic, strong) NeCallBaseViewController *callVC;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self registerThird];
    [UIDevice interfaceOrientation:UIInterfaceOrientationPortrait];
    self.window.backgroundColor = [UIColor whiteColor];
    UserInfoManager.sharedManager.hasShowAdver=NO;
    [self creatshortcutItem];
    [self registerNotification:application];
    [self initHttpHead];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self clearBage];
    #ifdef ICANTYPE // Firebase functions used only for iCan Meta
        [FIRApp configure];
        [FIRPerformance sharedInstance].dataCollectionEnabled = YES;
        FIRTrace *appTrace = [[FIRPerformance sharedInstance] traceWithName:@"app_launch_time"];
        [appTrace start];
//     Your app initialization code here
    #endif
    if([CHANNELTYPE isEqualToString:ICANTYPETARGET]){
        [[NERtcCallKit sharedInstance] addDelegate:self];
    }
    self.voipRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    self.voipRegistry.delegate = self;
    self.voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    return [self checkUserLoginStatusOptions:launchOptions];
}

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type {
    if (type == PKPushTypeVoIP) {
        [[NSUserDefaults standardUserDefaults] setObject:credentials.token forKey:@"PushKitToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type {
      #ifdef ICANTYPE
    if(payload.dictionaryPayload[@"callerID"] != nil){
        NSNumber *badge = payload.dictionaryPayload[@"aps"][@"badge"];
        badge = @99;
        self.callKitID = [NSUUID UUID];
        CXHandle *callHandle = [[CXHandle alloc] initWithType:CXHandleTypeGeneric value:payload.dictionaryPayload[@"callerID"]];
        self.callUpdate = [[CXCallUpdate alloc]init];
        self.callUpdate.remoteHandle = callHandle;
        self.callUpdate.localizedCallerName = payload.dictionaryPayload[@"aps"][@"alert"][@"title"];
        self.callUpdate.supportsHolding = NO;
        self.callUpdate.supportsGrouping = NO;
        self.callUpdate.supportsUngrouping = NO;
        CXProviderConfiguration *config = [[CXProviderConfiguration alloc] initWithLocalizedName:@"My App"];
        config.maximumCallsPerCallGroup = 1;
        config.maximumCallGroups = 1;
        config.iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:@"callIcon"]);
        config.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypeGeneric)];
        if([payload.dictionaryPayload[@"aps"][@"alert"][@"body"] isEqualToString:@"InviteYouVoiceCall".icanlocalized]){
            config.supportsVideo = NO;
            self.callUpdate.hasVideo = NO;
        } else{
            config.supportsVideo = YES;
            self.callUpdate.hasVideo = YES;
        }
        CXStartCallAction *startCallAction = [[CXStartCallAction alloc] initWithCallUUID:self.callKitID handle:callHandle];
        self.provider = [[CXProvider alloc]initWithConfiguration:config];
        [self.provider setDelegate:self queue:nil];
        [self.provider reportNewIncomingCallWithUUID:self.callKitID  update:self.callUpdate completion:^(NSError * _Nullable error) {
            if (@available(iOS 11.0, *)) {
                [self.callController requestTransactionWithActions:@[startCallAction] completion:^(NSError * _Nullable error) {
                    if (error) {
                        // Handle error
                    } else {
                        // Call connected successfully
                    }
                }];
            } else {
                // Fallback on earlier versions
            }
        }];
        self.callController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
    }else{
        NSLog(@"Payload failed");
    }
    #endif
}

    - (void)onInvited:(NSString *)invitor userIDs:(NSArray<NSString *> *)userIDs isFromGroup:(BOOL)isFromGroup groupID:(nullable NSString *)groupID type:(NERtcCallType)type {
        //    [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer]; --> According to requirements
        if (type == NERtcCallTypeAudio) {
            [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                [self nimCallVCWithType:type onInvited:invitor];
            } notDetermined:^{
                [self nimCallVCWithType:type onInvited:invitor];
            } failure:^{
                NSLog(@"Fail");
            }];
        }else{
            [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
                [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self nimCallVCWithType:type onInvited:invitor];
                    });
                } notDetermined:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self nimCallVCWithType:type onInvited:invitor];
                    });
                } failure:^{
                    NSLog(@"Fail");
                }];
            } failure:^{
                NSLog(@"Fail");
            }];
        }
}

-(void)nimCallVCWithType:(NERtcCallType)type onInvited:(NSString *)invitor {
    BOOL active = UIApplication.sharedApplication.applicationState == UIApplicationStateActive;
    if(!active && [CHANNELTYPE isEqualToString:ICANTYPETARGET]){
        self.callVC = [[NeCallBaseViewController alloc] initWithOtherMember:invitor isCalled:YES type:type uuid:self.callKitID];
        NSString *userID = [invitor componentsSeparatedByString:@"_"].lastObject;
        DDLogInfo(@"[NERtcCallKit sharedInstance].authorityType=%@",[NERtcCallKit sharedInstance].authorityType);
        if ([[NERtcCallKit sharedInstance].authorityType isEqualToString:AuthorityType_circle]) {
            [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithCircleUserId:[NERtcCallKit sharedInstance].circleUserId successBlock:^(CircleUserInfo * _Nonnull info) {
                self.callVC.nickname = info.nickname;
                self.callVC.avtar = info.avatar;
                self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
            }];
        }else {
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userID successBlock:^(UserMessageInfo * _Nonnull info) {
                self.callVC.nickname = info.remarkName?:info.nickname;
                self.callVC.avtar = info.headImgUrl;
                self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
            }];
        }
    }
}

#ifdef ICANTYPE
- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action {
    self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
    if(self.callVC != nil){
        if (self.callVC.type == NERtcCallTypeAudio) {
            [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                [self presentViewController:self.callVC animated:YES completion:nil];
                [self.callVC  acceptBtnAction]; 
            } notDetermined:^{
                NSLog(@"notDetermined");
            } failure:^{
                NSLog(@"Fail");
            }];
        } else{
            [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
                [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:self.callVC animated:YES completion:nil];
                        [self.callVC  acceptBtnAction];
                    });
                } notDetermined:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"notDetermined");
                    });
                } failure:^{
                    NSLog(@"Fail");
                }];
            } failure:^{
                NSLog(@"Fail");
            }];
        }
    }else {
        [self.provider invalidate];
    }
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action {
    if(self.callVC != nil){
        if (self.callVC.type == NERtcCallTypeAudio) {
            [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                [self.callVC refuseBtnAction];
            } notDetermined:^{
                NSLog(@"notDetermined");
            } failure:^{
                NSLog(@"Fail");
            }];
        } else{
            [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
                [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.callVC refuseBtnAction];
                    });
                } notDetermined:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"notDetermined");
                    });
                } failure:^{
                    NSLog(@"Fail");
                }];
            } failure:^{
                NSLog(@"Fail");
            }];
        }
    }else {
        [self.provider invalidate];
    }
    [action fulfill];
}

- (void)providerDidReset:(nonnull CXProvider *)provider {
    NSLog(@"Provider");
}
#endif

- (void)onUserCancel:(NSString *)userID {
    [[NERtcCallKit sharedInstance] hangup:nil];
    #ifdef ICANTYPE
    if(self.callKitID != nil){
        CXEndCallAction *endCallAction = [[CXEndCallAction alloc] initWithCallUUID:self.callKitID];
        CXTransaction *transaction = [[CXTransaction alloc] initWithAction:endCallAction];
        [[AppDelegate shared].callController requestTransaction:transaction completion:^(NSError * _Nullable error) {
            if (error) {
                // Handle any errors
            } else {
                //Handle success
            }
        }];
        [[AppDelegate shared].provider reportCallWithUUID:self.callKitID endedAtDate:[NSDate date] reason:CXCallEndedReasonRemoteEnded];
    }
    #endif
}

//trigger when recieve message
- (void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel {
    if ([chatModel.messageType isEqualToString:Notice_AddFriendMessageType]) {
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {
                *stop = YES;
                isExist = YES;   //trigger when recieve message
            }
        }];
        if (!isExist) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
            NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
            NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString=[nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            ChatSetting *setting = [[WCDBManager sharedManager]fetchChatSettingWith:chatModel];
            if(!setting.isNoDisturbing){
                [self getFriendRequestNotiData:chatModel];
            }
        }
    }else if([chatModel.messageType isEqualToString:PinMessageType]) {
        NSData *data = [chatModel.messageContent dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *msgContent = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        ChatModel *oldChatModel;
        oldChatModel = [[WCDBManager sharedManager]getChatModelByMessageId:[msgContent objectForKey:@"pinnedMsgId"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
        NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
        NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
        SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
        nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
        UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if([chatModel.chatType isEqualToString:UserChat]){
            GetFriendsListRequest *request = [GetFriendsListRequest request];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray <UserMessageInfo *> *response) {
                self.friendItem = [NSMutableArray arrayWithArray:response];
                NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
                NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
                for (UserMessageInfo *user in self.friendItem) {
                    if(user.userId == chatModel.chatID) {
                        content.title = user.remarkName?:user.nickname;
                        content.body = @"PinnedAMessage".icanlocalized;
                        if([[msgContent objectForKey:@"action"] isEqualToString:@"Unpin"]) {
                            content.body = @"UnpinnedAMessage".icanlocalized;
                        }
                        content.userInfo = @{@"k1":chatModel.message};
                        if(oldChatModel != nil) {
                            if(oldChatModel.message != nil) {
                                content.userInfo = @{@"k1":oldChatModel.message};
                            }else {
                                content.userInfo = @{@"k1":oldChatModel.messageContent};
                            }
                        }
                    }
                }
                content.sound = [UNNotificationSound defaultSound];
                content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
                [center addNotificationRequest:requestAuth withCompletionHandler:nil];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            }];
        }else {
            GroupListInfo *info = [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:chatModel.chatID];
            content.title = info.name;
            content.body = @"PinnedAMessage".icanlocalized;
            if([[msgContent objectForKey:@"action"] isEqualToString:@"Unpin"]) {
                content.body = @"UnpinnedAMessage".icanlocalized;
            }
            content.userInfo = @{@"k1":chatModel.message};
            if(oldChatModel != nil) {
                if(oldChatModel.message != nil) {
                    content.userInfo = @{@"k1":oldChatModel.message};
                }else {
                    content.userInfo = @{@"k1":oldChatModel.messageContent};
                }
            }
            content.sound = [UNNotificationSound defaultSound];
            content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
            UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
            [center addNotificationRequest:requestAuth withCompletionHandler:nil];
        }
    }else if([chatModel.messageType isEqualToString:ReactionMessage]) {
        ReactionMessageInfo *reactionInfo = [ReactionMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
        if([reactionInfo.action isEqualToString:@"addReaction"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
            NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
            NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString=[nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            ChatSetting *setting = [[WCDBManager sharedManager]fetchChatSettingWith:chatModel];
            if(!setting.isNoDisturbing){
                [self getReactionPushNotification:chatModel info:reactionInfo];
            }
        }
        return;
    }else if([chatModel.messageType isEqualToString:C2COrderMessageType]){
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {
                *stop = YES;
                isExist = YES;   //trigger when recieve message
            }
        }];
        if (!isExist) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
            NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
            NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            UNUserNotificationCenter *center  = [ UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"WalletAssistant".icanlocalized;
            C2COrderMessageInfo *info = [C2COrderMessageInfo mj_objectWithKeyValues:chatModel.messageContent];
            if ([info.status isEqualToString:@"Unpaid"]) {
                content.body = @"C2COrderStateUnpaid".icanlocalized;
            }else if ([info.status isEqualToString:@"Paid"]) {
                content.body = @"C2COrderStatePaid".icanlocalized;
            }else if ([info.status isEqualToString:@"Appeal"]) {
                content.body = @"C2COrderStateAppeal".icanlocalized;
            }else if ([info.status isEqualToString:@"Completed"]) {
                content.body = @"C2COrderStateCompleted".icanlocalized;
            }else if ([info.status isEqualToString:@"Cancelled"]) {
                content.body = @"C2COrderStateCancelled".icanlocalized;
            }
            content.userInfo = @{@"k1":chatModel.message};
            content.sound = [UNNotificationSound defaultSound];
            content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
            UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
            [center addNotificationRequest:requestAuth withCompletionHandler:nil];
        }
    }else if([chatModel.messageType isEqualToString:ShopHelperMessageType]){
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {
                *stop = YES;
                isExist = YES;   //trigger when recieve message
            }
        }];
        if (!isExist) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
            NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
            NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            UNUserNotificationCenter *center  = [ UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            ShopHelperMsgInfo *info = [ShopHelperMsgInfo mj_objectWithKeyValues:chatModel.messageContent];
            content.title = @"Mall Assistant".icanlocalized;
            content.body = [NSString stringWithFormat:@"%@", info.title];
            content.userInfo = @{@"k1":chatModel.message};
            content.sound = [UNNotificationSound defaultSound];
            content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
            UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
            [center addNotificationRequest:requestAuth withCompletionHandler:nil];
        }
    }else if([chatModel.messageType isEqualToString:PayHelperMessageType]){
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {
                *stop = YES;
                isExist = YES;   //trigger when recieve message
            }
        }];
        if (!isExist) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
            NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
            NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"PaymentAssistant".icanlocalized;
            PayHelperMsgInfo *info = [PayHelperMsgInfo mj_objectWithKeyValues:chatModel.messageContent];
            if ([info.payType isEqualToString:@"Transfer"]) {
                content.body = @"Transfer To Account".icanlocalized;
            }else if ([info.payType isEqualToString:@"RefundSingleRedPacket"]||[info.payType isEqualToString:@"RefundRoomRedPacket"]) {
                content.body = @"red packet Returned".icanlocalized;
            }else if ([info.payType isEqualToString:@"MobileRecharge"]) {
                content.body = @"Mobile Phone Recharge To Account".icanlocalized;
            }else if ([info.payType isEqualToString:@"GiftCard"]) {
                content.body = @"Gift Card Purchase".icanlocalized;
            }else if ([info.payType isEqualToString:@"BalanceRecharge"]) {
                content.body = @"Top Up Received".icanlocalized;
            }else if ([info.payType isEqualToString:@"WITHDRAW_CREATE"]) {
                content.body = @"Withdrawal application".icanlocalized;
            }else if ([info.payType isEqualToString:@"WITHDRAW_SUCCESS"]) {
                content.body = @"Successful withdrawal".icanlocalized;
            }else if ([info.payType isEqualToString:@"WITHDRAW_FAIL"]) {
                content.body = @"Withdrawal failed".icanlocalized;
            }else if ([info.payType isEqualToString:@"Payment"]){
                if ([info.amount containsString:@"-"]) {
                    content.body = @"Payment successful".icanlocalized;
                }else{
                    content.body = @"Successfully Received".icanlocalized;
                }
            }else if ([info.payType isEqualToString:@"ReceivePayment"]){
                if ([info.amount containsString:@"-"]) {
                    content.body = @"Payment successful".icanlocalized;
                }else{
                    content.body = @"Successfully Received".icanlocalized;
                }
            }else if ([info.payType isEqualToString:@"Dialog"]){
                content.body = @"Top-upSuccess".icanlocalized;
            }else if ([info.payType isEqualToString:@"MomentEarnings"]){
                content.body = @"PostingIncome".icanlocalized;
            }
            content.userInfo = @{@"k1":chatModel.message};
            content.sound = [UNNotificationSound defaultSound];
            content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
            UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
            [center addNotificationRequest:requestAuth withCompletionHandler:nil];
        }
    }else if([chatModel.messageType isEqualToString:SystemHelperMessageType]){
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {
                *stop = YES;
                isExist = YES;   //trigger when recieve message
            }
        }];
        if (!isExist) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
            NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
            NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"systemnotification".icanlocalized;
            SystemHelperInfo *info = [SystemHelperInfo mj_objectWithKeyValues:chatModel.messageContent];
            if ([info.type isEqualToString:@"UserAuthPass"]) {
                content.body = @"Userrealnameauthentication".icanlocalized;
            }else if ([info.type isEqualToString:@"UserAuthFail"]) {
                content.body = @"Userrealnameauthentication".icanlocalized;
            }else {
                content.body = @"Notsupportedmessagetemporarily".icanlocalized;
            }
            content.userInfo = @{@"k1":chatModel.message};
            content.sound = [UNNotificationSound defaultSound];
            content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
            UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
            [center addNotificationRequest:requestAuth withCompletionHandler:nil];
        }
    }else if([chatModel.messageType isEqualToString:AnnouncementHelperMessageType]){
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {
                *stop = YES;
                isExist = YES;   //trigger when recieve message
            }
        }];
        if (!isExist) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
            NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
            NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"AnnouncementNotification".icanlocalized;
            AnnouncementsInfo *info=[AnnouncementsInfo mj_objectWithKeyValues:chatModel.messageContent];
            content.body = [NSString stringWithFormat:@"%@", info.title];
            content.userInfo = @{@"k1":chatModel.message};
            content.sound = [UNNotificationSound defaultSound];
            content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
            UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
            [center addNotificationRequest:requestAuth withCompletionHandler:nil];
        }
    }else if([chatModel.messageType isEqualToString:NoticeOTPMessageType]){
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {
                *stop = YES;
                isExist = YES;   //trigger when recieve message
            }
        }];
        if (!isExist) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
            NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
            NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"NoticeOTP".icanlocalized;
            NoticeOTPMessageInfo *info = [NoticeOTPMessageInfo mj_objectWithKeyValues:chatModel.messageContent];
            content.body = info.appName;
            content.userInfo = @{@"k1":chatModel.message};
            content.sound = [UNNotificationSound defaultSound];
            content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
            UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
            [center addNotificationRequest:requestAuth withCompletionHandler:nil];
        }
    }
    if([chatModel.chatType isEqualToString:UserChat]){
        if ([chatModel.messageType isEqualToString:TextMessageType]||[chatModel.messageType isEqualToString:URLMessageType]||[chatModel.messageType isEqualToString:GamifyMessageType]) {
            __block BOOL isExist = NO;
            [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.messageID isEqualToString:chatModel.messageID]) {
                    *stop = YES;
                    isExist = YES;   //trigger when recieve message
                }
            }];
            if (!isExist) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
                NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
                NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                ChatSetting *setting = [[WCDBManager sharedManager]fetchChatSettingWith:chatModel];
                if(!setting.isNoDisturbing){
                    if([chatModel.chatMode isEqualToString:ChatModeOtherChat]){
                        [self getOtherChatNotificationData:chatModel];
                    }else{
                        [self getFriendsListRequestData:chatModel];
                    }
                }
            }
        }else if ([chatModel.messageType isEqualToString:RedPacketMessageType]){
            __block BOOL isExist = NO;
            [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.messageID isEqualToString:chatModel.messageID]) {
                    *stop = YES;
                    isExist = YES;   //trigger when recieve message
                }
            }];
            if (!isExist) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
                NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
                NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                ChatSetting *setting = [[WCDBManager sharedManager]fetchChatSettingWith:chatModel];
                if(!setting.isNoDisturbing){
                    [self getRedPacketPushNotiData:chatModel];
                }
            }
        }else if ([chatModel.messageType isEqualToString:VoiceMessageType]){
            __block BOOL isExist = NO;
            [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.messageID isEqualToString:chatModel.messageID]) {
                    *stop = YES;
                    isExist = YES;   //trigger when recieve message
                }
            }];
            if (!isExist) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
                NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
                NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString=[nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                ChatSetting *setting = [[WCDBManager sharedManager]fetchChatSettingWith:chatModel];
                if(!setting.isNoDisturbing){
                    [self getVoicePushNotiData:chatModel];
                }
            }
        }else if ([chatModel.messageType isEqualToString:ImageMessageType]){
            __block BOOL isExist = NO;
            [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.messageID isEqualToString:chatModel.messageID]) {
                    *stop = YES;
                    isExist = YES;   //trigger when recieve message
                }
            }];
            if (!isExist) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
                NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
                NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString=[nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                ChatSetting *setting = [[WCDBManager sharedManager]fetchChatSettingWith:chatModel];
                if(!setting.isNoDisturbing){
                    if([chatModel.chatMode isEqualToString:ChatModeOtherChat]){
                        [self getOtherChatNotificationData:chatModel];
                    }else{
                        [self getImagePushNotiData:chatModel];
                    }
                }
            }
        }
    }else if ([chatModel.chatType isEqualToString:GroupChat] && ![chatModel.messageType isEqualToString:PinMessageType]) {
        __block BOOL isExist = NO;
        [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {
                *stop = YES;
                isExist = YES;   //trigger when recieve message
            }
        }];
        if (!isExist) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
            NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
            NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString=[nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            ChatSetting *setting = [[WCDBManager sharedManager]fetchChatSettingWith:chatModel];
            if(!setting.isNoDisturbing){
                [self getUserData:chatModel];
            }
        }
    }else if([chatModel.chatType isEqualToString:C2CHelperMessageType]) {
        if ([chatModel.messageType isEqualToString:C2CExtRechargeWithdrawType]) {
            __block BOOL isExist = NO;
            [self.msgItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.messageID isEqualToString:chatModel.messageID]) {
                    *stop = YES;
                    isExist = YES;   //trigger when recieve message
                }
            }];
            if(!isExist) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postObject" object:chatModel];
                NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
                NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber + UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.title = @"WalletAssistant".icanlocalized;
                C2CExtRechargeWithdrawMessageInfo *info = [C2CExtRechargeWithdrawMessageInfo mj_objectWithKeyValues:chatModel.messageContent];
                if ([info.type isEqualToString:@"Recharge"]) {
                    content.body = @"Externalnetworkrecharge".icanlocalized;
                }else{
                    content.body = @"Withdraw".icanlocalized;
                }
                content.userInfo = @{@"k1":chatModel.message};
                content.sound = [UNNotificationSound defaultSound];
                content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
                [center addNotificationRequest:requestAuth withCompletionHandler:nil];
            }
        }
    }
}

-(void)getUserData:(ChatModel *)chatModel{
    UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    __block NSString *from = chatModel.chatID;
    GroupListInfo *info = [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:from];
    [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:from userId:chatModel.messageFrom successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
        NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
        NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
        content.title = info.name;
        if ([chatModel.messageType isEqualToString:RedPacketGroupMessageType]){
            content.body = [NSString stringWithFormat:@"%@ %@ %@", memberInfo.nickname, @":", @"RedEnvelopeTips".icanlocalized];
            content.sound = [UNNotificationSound soundNamed:@"coin.caf"];
        }else if ([chatModel.messageType isEqualToString:VoiceMessageType]){
            content.body = [NSString stringWithFormat:@"%@ %@ %@", memberInfo.nickname, @":", @"VoiceTips".icanlocalized];
            content.sound = [UNNotificationSound defaultSound];
        }else if ([chatModel.messageType isEqualToString:ImageMessageType]){
            content.body = [NSString stringWithFormat:@"%@ %@ %@", memberInfo.nickname, @":", @"ImageTips".icanlocalized];
            content.sound = [UNNotificationSound defaultSound];
        }else if ([chatModel.messageType isEqualToString:Notice_JoinGroupApplyType]){
            GroupApplyInfo *applyInfo = [GroupApplyInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
            content.body = [NSString stringWithFormat:@"%@:", chatModel.showMessage];
            content.sound = [UNNotificationSound defaultSound];
        }else{
            content.body = [NSString stringWithFormat:@"%@ %@ %@", memberInfo.nickname, @":", chatModel.showMessage];
            content.sound = [UNNotificationSound defaultSound];
        }
        content.userInfo = @{@"k1":chatModel.message};
        content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
        UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber: UnReadMsgNumber+UnReadFriendSubscriptionAmount];
        SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
        nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
        [center addNotificationRequest:requestAuth withCompletionHandler:nil];
    }];
}

-(void)getFriendsListRequestData:(ChatModel *)chatModel {
    UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    GetFriendsListRequest *request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray <UserMessageInfo *> *response) {
        self.friendItem = [NSMutableArray arrayWithArray:response];
        NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
        NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
        for (UserMessageInfo *user in self.friendItem) {
            if (user.userId == chatModel.chatID){
                content.title = user.remarkName?:user.nickname;
                content.body = chatModel.showMessage;
                content.userInfo = @{@"k1":chatModel.message};
                content.sound = [UNNotificationSound defaultSound];
                content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber: UnReadMsgNumber+UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                [center addNotificationRequest:requestAuth withCompletionHandler:nil];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}

-(void)getReactionPushNotification:(ChatModel *)chatModel info:(ReactionMessageInfo *)reactionInfo{
    ChatModel *reactionModel = [[WCDBManager sharedManager]getChatModelByMessageId:reactionInfo.reactedMsgId];
    UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
    NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
    if([chatModel.chatType isEqualToString:UserChat]){
        GetFriendsListRequest *request = [GetFriendsListRequest request];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray <UserMessageInfo *> *response) {
            self.friendItem = [NSMutableArray arrayWithArray:response];
            for (UserMessageInfo *user in self.friendItem) {
                if (user.userId == chatModel.chatID){
                    content.title = user.remarkName?:user.nickname;
                    NSString *pushBodyString = [[WebSocketManager sharedManager] getPushBodyStr:reactionModel msgType:reactionModel.messageType];
                    content.body = [NSString stringWithFormat:@"%@ %@ %@ \"%@\"", @"Reacted".icanlocalized, reactionInfo.reaction, @"to".icanlocalized, pushBodyString];
                    content.userInfo = @{@"k1":chatModel.message};
                    content.sound = [UNNotificationSound defaultSound];
                    content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
                    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                    UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
                    [[UIApplication sharedApplication]setApplicationIconBadgeNumber: UnReadMsgNumber+UnReadFriendSubscriptionAmount];
                    SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                    nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                    [center addNotificationRequest:requestAuth withCompletionHandler:nil];
                }
            }
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        }];
    } else {
        __block NSString *from = chatModel.chatID;
        GroupListInfo *info = [[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:from];
        [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:from userId:chatModel.messageFrom successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
            content.title = info.name;
            NSString *pushBodyString = [[WebSocketManager sharedManager] getPushBodyStr:chatModel msgType:chatModel.messageType];
            content.body = [NSString stringWithFormat:@"%@ %@ %@ \"%@\"", @"Reacted".icanlocalized, reactionInfo.reaction, @"to".icanlocalized, pushBodyString];
            content.userInfo = @{@"k1":chatModel.message};
            content.sound = [UNNotificationSound defaultSound];
            content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
            UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
            [[UIApplication sharedApplication]setApplicationIconBadgeNumber: UnReadMsgNumber+UnReadFriendSubscriptionAmount];
            SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
            nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
            [center addNotificationRequest:requestAuth withCompletionHandler:nil];
        }];
    }
}

-(void)getRedPacketPushNotiData:(ChatModel *)chatModel {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    GetFriendsListRequest *request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray <UserMessageInfo *> *response) {
        self.friendItem = [NSMutableArray arrayWithArray:response];
        NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
        NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
        for (UserMessageInfo *user in self.friendItem) {
            if (user.userId == chatModel.chatID){
                content.title = user.remarkName?:user.nickname;
                content.body = @"RedEnvelopeTips".icanlocalized;
                content.userInfo = @{@"k1":chatModel.message};
                content.sound = [UNNotificationSound soundNamed:@"coin.caf"];
                content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber: UnReadMsgNumber+UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                [center addNotificationRequest:requestAuth withCompletionHandler:nil];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}

-(void)getImagePushNotiData:(ChatModel *)chatModel {
    UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    GetFriendsListRequest *request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray <UserMessageInfo *> *response) {
        self.friendItem = [NSMutableArray arrayWithArray:response];
        NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
        NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
        for (UserMessageInfo *user in self.friendItem) {
            if (user.userId == chatModel.chatID){
                content.title = user.remarkName?:user.nickname;
                content.body = @"ImageTips".icanlocalized;
                content.userInfo = @{@"k1":chatModel.message};
                content.sound = [UNNotificationSound defaultSound];
                content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber: UnReadMsgNumber+UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                [center addNotificationRequest:requestAuth withCompletionHandler:nil];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}

-(void)getOtherChatNotificationData:(ChatModel *)chatModel{
    UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
    NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
    NSArray *chatListArray = [[WCDBManager sharedManager]getAllIcanChatListModel];
    for (ChatListModel *listModel in chatListArray) {
        if([listModel.chatID isEqualToString:chatModel.chatID]){
            content.title = listModel.showName;
        }
    }
    if([chatModel.messageType isEqualToString:ImageMessageType]){
        content.body = @"ImageTips".icanlocalized;
    }else{
        content.body = chatModel.showMessage;
    }
    content.userInfo = @{@"k1":chatModel.message};
    content.sound = [UNNotificationSound defaultSound];
    content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber: UnReadMsgNumber+UnReadFriendSubscriptionAmount];
    SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
    nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
    [center addNotificationRequest:requestAuth withCompletionHandler:nil];
}

-(void)getFriendRequestNotiData:(ChatModel *)chatModel {
    UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    GetUserListRequest *request = [GetUserListRequest request];
    request.parameters = [[NSArray arrayWithObject:chatModel.chatID] mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray <UserMessageInfo *> *response) {
        self.friendItem = [NSMutableArray arrayWithArray:response];
        NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
        NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
        for (UserMessageInfo *user in self.friendItem) {
            if (user.userId == chatModel.chatID){
                NoticeAgreeFriendInfo *msgInfo = [NoticeAgreeFriendInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
                content.title = @"Friend request".icanlocalized;
                if ([msgInfo.process isEqualToString:@"apply"]) {
                    content.body =  [NSString stringWithFormat:@"%@ %@",user.remarkName?:user.nickname,@"Sent you a friend request".icanlocalized];
                }else if([msgInfo.process isEqualToString:@"agree"]){
                    content.body = [NSString stringWithFormat:@"%@ %@",user.remarkName?:user.nickname,@"AcceptedYourFriendRequest".icanlocalized];
                }
                content.userInfo = @{@"k1":chatModel.message};
                content.sound = [UNNotificationSound defaultSound];
                content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber: UnReadMsgNumber+UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                [center addNotificationRequest:requestAuth withCompletionHandler:nil];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}

-(void)getVoicePushNotiData:(ChatModel *)chatModel {
    UNUserNotificationCenter *center = [ UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    GetFriendsListRequest *request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray <UserMessageInfo *> *response) {
        self.friendItem = [NSMutableArray arrayWithArray:response];
        NSInteger UnReadMsgNumber = [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
        NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
        for (UserMessageInfo *user in self.friendItem) {
            if (user.userId == chatModel.chatID){
                content.title = user.remarkName?:user.nickname;
                content.body = @"VoiceTips".icanlocalized;
                content.userInfo = @{@"k1":chatModel.message};
                content.sound = [UNNotificationSound defaultSound];
                content.badge = @(UnReadMsgNumber + UnReadFriendSubscriptionAmount);
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationRequest *requestAuth = [UNNotificationRequest requestWithIdentifier:@"UYLocalNotification" content:content trigger:trigger];
                [[UIApplication sharedApplication]setApplicationIconBadgeNumber: UnReadMsgNumber+UnReadFriendSubscriptionAmount];
                SetApplicationIconBadgeNumberRequest *nrequest = [SetApplicationIconBadgeNumberRequest request];
                nrequest.pathUrlString = [nrequest.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber + UnReadFriendSubscriptionAmount]];
                [center addNotificationRequest:requestAuth withCompletionHandler:nil];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
    }];
}

-(NSMutableArray<ChatModel *> *)msgItems{
    if (!_msgItems) {
        _msgItems=[NSMutableArray array];
    }
    return _msgItems;
}

// Initialize the third party
- (void)registerThird {
//    [OpenInstallSDK initWithDelegate:self] --- for reinstall purposes;
    //设置打印格式 - Set print format
    [DDTTYLogger sharedInstance].logFormatter = [[MyCustomDDLogFormatter alloc]init];
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:ddLogLevel];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [WXApi registerApp:KWeiXinAppID universalLink:@"https://app.shinianwangluo.com/"];
    [[DomainExamineManager sharedManager]checkShouldExchangeDomain];
    [self setupRTCKit];
}

//检查用户的登录状态
-(BOOL)checkUserLoginStatusOptions:(NSDictionary *)launchOptions{
    [self getAllCurrencyRequest];
    if ([UserInfoManager sharedManager].loginStatus) {
        [[WCDBManager sharedManager]initCurrentUserWCDataBase];
        [WebSocketManager.sharedManager initWebScoket];
        [self fetchUserPrivateParameterRequest];
        [CheckVersionTool checkVersioForceUpdate];
        [UserInfoManager uploadAppLanguagesRequest];
        [self getUserInfoMessage];
        [[WebSocketManager sharedManager] getNIMTokenRequest];
        [[BaseSettingManager sharedManager]resetAppToTabbarViewController];
        [UserInfoManager.sharedManager getAliyunOSSSecurityToken:^{
            
        }];
        [[C2CUserManager shared]getC2COssTokenRequest:^{
            
        }];
        if(launchOptions){
            ///如果是从快捷选项标签启动app，则根据不同标识执行不同操作，然后返回NO，防止调用- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
            UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
            if (shortcutItem) {
                [[HandleOpenUrlManager shareManager]handleShortcutItem:shortcutItem];
                return NO;
            }
            ///其他APP通过openUrl打开APP
            NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
            if(url){
                [HandleOpenUrlManager shareManager].openUrl = url;
                if ([HandleOpenUrlManager shareManager].openUrl) {
                    return [[HandleOpenUrlManager shareManager]handleOpenUrl];
                }else {
                    return NO;
                }
            }
        }else{
            ///获取的相关信息
            [C2CUserManager.shared getC2CAllMessage];
            return YES;
        }
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
    return YES;
}

//通过UIApplicationShortcutItem点击进来的
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    [[HandleOpenUrlManager shareManager]handleShortcutItem:shortcutItem];
}
-(void)creatshortcutItem{
    // 自定义icon，大小为 70*70 px
    UIApplicationShortcutIcon *scanIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"icon_shortcut_scan.png"];
    UIApplicationShortcutItem *scanItem = [[UIApplicationShortcutItem alloc]initWithType:@"com.codingchou.test.scan" localizedTitle:@"chatlist.menu.list.scan".icanlocalized localizedSubtitle:nil icon:scanIcon userInfo:nil];
    
    UIApplicationShortcutIcon *qrcodeIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"icon_shortcut_code.png"];
    UIApplicationShortcutItem *qrcodeItem = [[UIApplicationShortcutItem alloc]initWithType:@"com.codingchou.test.qrcode" localizedTitle:@"AppDelegate.myqrcode".icanlocalized localizedSubtitle:nil icon:qrcodeIcon userInfo:nil];
    [UIApplication sharedApplication].shortcutItems = @[scanItem,qrcodeItem];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
//    --- for reinstall purposes---
//    if  ([OpenInstallSDK handLinkURL:url]){//必写
//        return YES;
//    }
    //证明是点击微信跳转过来的URL 授权登录 wxc03d8a36b9ee76fe://oauth?code=091DbW0w3AqoAW2awl0w3QQzE84DbW0Q&state=123
    if ([url.scheme isEqualToString:KWeiXinAppID]) {
        return [WXApi handleOpenURL:url delegate:[HandleOpenUrlManager shareManager]];
    }else if ([url.host isEqualToString:@"apmqpdispatch"]) {//支付宝
        [AFServiceCenter handleResponseURL:url withCompletion:^(AFServiceResponse *response) {
            
        }];
        return YES;
    }
    [HandleOpenUrlManager shareManager].openUrl=url;
    if ([HandleOpenUrlManager shareManager].openUrl) {
        return [[HandleOpenUrlManager shareManager]handleOpenUrl];
    }else {
        return NO;
    }
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
//    --- for reinstall purposes----
    //判断是否通过OpenInstall Universal Link 唤起App
    //如果使用了Universal link ，此方法必写
//    if ([OpenInstallSDK continueUserActivity:userActivity]){
//        return YES;
//    }
    if ([userActivity.interaction.intent isKindOfClass:[INStartAudioCallIntent class]]) {
        INPerson *person = [[(INStartAudioCallIntent*)userActivity.interaction.intent contacts] firstObject];
        NSString *callID = person.displayName;
        [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
            self.callVC = [[NeCallBaseViewController alloc] initWithOtherMember:callID isCalled:NO type:NERtcCallTypeAudio uuid:[NSUUID UUID]];
            NSString *userID = [callID componentsSeparatedByString:@"_"].lastObject;
            DDLogInfo(@"[NERtcCallKit sharedInstance].authorityType=%@",[NERtcCallKit sharedInstance].authorityType);
            if ([[NERtcCallKit sharedInstance].authorityType isEqualToString:AuthorityType_circle]) {
                [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithCircleUserId:[NERtcCallKit sharedInstance].circleUserId successBlock:^(CircleUserInfo * _Nonnull info) {
                    self.callVC.nickname = info.nickname;
                    self.callVC.avtar = info.avatar;
                    self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:self.callVC animated:YES completion:nil];
                }];
            }else{
                [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userID successBlock:^(UserMessageInfo * _Nonnull info) {
                    self.callVC.nickname = info.remarkName?:info.nickname;
                    self.callVC.avtar = info.headImgUrl;
                    self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    [self presentViewController:self.callVC animated:YES completion:nil];
                }];
            }
        } notDetermined:^{
            NSLog(@"notDetermined");
        } failure:^{
            NSLog(@"Fail");
        }];
    }
    if ([userActivity.interaction.intent isKindOfClass:[INStartVideoCallIntent class]]) {
        INPerson *person = [[(INStartAudioCallIntent*)userActivity.interaction.intent contacts] firstObject];
        NSString *callID = person.displayName;
        [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
            [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.callVC = [[NeCallBaseViewController alloc] initWithOtherMember:callID isCalled:NO type:NERtcCallTypeVideo uuid:[NSUUID UUID]];
                    NSString *userID = [callID componentsSeparatedByString:@"_"].lastObject;
                    DDLogInfo(@"[NERtcCallKit sharedInstance].authorityType=%@",[NERtcCallKit sharedInstance].authorityType);
                    if ([[NERtcCallKit sharedInstance].authorityType isEqualToString:AuthorityType_circle]) {
                        [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithCircleUserId:[NERtcCallKit sharedInstance].circleUserId successBlock:^(CircleUserInfo * _Nonnull info) {
                            self.callVC.nickname = info.nickname;
                            self.callVC.avtar = info.avatar;
                            self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
                            [self presentViewController:self.callVC animated:YES completion:nil];
                        }];
                    }else{
                        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userID successBlock:^(UserMessageInfo * _Nonnull info) {
                            self.callVC.nickname = info.remarkName?:info.nickname;
                            self.callVC.avtar = info.headImgUrl;
                            self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
                            [self presentViewController:self.callVC animated:YES completion:nil];
                        }];
                    }
                });
            } notDetermined:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"notDetermined");
                });
            } failure:^{
                NSLog(@"Fail");
            }];
        } failure:^{
            NSLog(@"Fail");
        }];
    }
    if ([WXApi handleOpenUniversalLink:userActivity delegate:[HandleOpenUrlManager shareManager]]) {
        return [WXApi handleOpenUniversalLink:userActivity delegate:[HandleOpenUrlManager shareManager]];
    }
    
    //其他第三方回调；
    return YES;
}

//注册token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [self applicationAPNS:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
//进入app触发的方法
- (void)applicationDidBecomeActive:(UIApplication*)application{
    [self clearBage];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundTaskIdentifier];
    [WebSocketManager sharedManager].delegate = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNotificationData" object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [WebSocketManager sharedManager].delegate = self;
}

-(void)applicationWillResignActive:(UIApplication *)application{
    if ([UserInfoManager sharedManager].loginStatus) {
        [CheckVersionTool checkVersioForceUpdate];
    }
    [self clearBage];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [UserInfoManager sharedManager].attemptCount = nil;
    [UserInfoManager sharedManager].isPayBlocked = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NERtcEngine.sharedEngine leaveChannel];
}

-(void)clearBage{
    [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
    //清除所有通知
    //清除通知栏内所有通知消息要点在于要先把BadgeNumber 设成跟当前不同的值，然后再设成0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [WebSocketManager.sharedManager setApplicationIconBadgeNumber];
    
}
/** 获取支持的货币 */
-(void)getAllCurrencyRequest{
    GetAllSupportedCurrenciesRequest * request = [GetAllSupportedCurrenciesRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CurrencyInfo class] success:^(NSArray* response) {
        UserInfoManager.sharedManager.allSupportedCurrenciesItems = response;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(void)fetchUserPrivateParameterRequest{
    [[UserInfoManager sharedManager] getPrivateParameterRequest:^(PrivateParameterInfo * _Nonnull) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kGetPriviSuccessNotification object:nil userInfo:nil];
    }];
}
-(void)getUserInfoMessage{
    [[UserInfoManager sharedManager]getMineMessageRequest:^(UserMessageInfo * _Nonnull info) {
        [[WCDBManager sharedManager] insertUserMessageInfo:info];
        [[NSNotificationCenter defaultCenter]postNotificationName:KShowNewTipViewNotification object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateShowNearPeopleNotification object:nil userInfo:nil];
    }];
}
-(void)getPublicStartPagesRequest{
    GetPublicStartPagesRequest*request=[GetPublicStartPagesRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetPublicStartInfo class] contentClass:[GetPublicStartInfo class] success:^(GetPublicStartInfo* response) {
        //获取沙河路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        //获取文件路径
        NSString * pathName = [path stringByAppendingString:@"/PublicStart.data"];
        [[NSKeyedArchiver archivedDataWithRootObject:response requiringSecureCoding:YES error:nil] writeToFile:pathName atomically:YES];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
- (void)setupRTCKit {
    [[NIMSDK sharedSDK] enableConsoleLog];
   
    NERtcCallOptions *option2 = [NERtcCallOptions new];
#if DEBUG
    option2.APNSCerName = @"Certificates.p12";
#else
    option2.APNSCerName = @"Certificates.p12";
#endif
    [[NERtcCallKit sharedInstance] setupAppKey:KNIMKey options:option2];
    // 安全模式需要计算token，如果tokenHandler为nil表示非安全模式，需要联系经销商开通
    // The security mode needs to calculate the token. If the tokenHandler is nil, it means the non-secure mode, you need to contact the dealer to activate
    NERtcCallKit.sharedInstance.tokenHandler = ^(uint64_t uid, void (^complete)(NSString *token, NSError *error)) {
        GetCloudLetterNERTCTokenRequest *request = [GetCloudLetterNERTCTokenRequest request];
        ///user/{uid}/cloudLetterNERTCToken
        request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/user/%lld/cloudLetterNERTCToken",uid];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[CloudLetterToken class] contentClass:[CloudLetterToken class] success:^(CloudLetterToken *response) {
            complete(response.cloudLetterToken,nil);
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            NSError*error2=[[NSError alloc]initWithDomain:NSCocoaErrorDomain code:statusCode userInfo:@{@"error":info.desc}];
            complete(nil,error2);
        }];
    };
}
-(void)initHttpHead{
    NSMutableString*userAgenString=[[NSMutableString alloc]init];
    //软件信息由以下内容构成，以 / 作为分隔符;
    [userAgenString appendString:@"1 Fortune/"];
    [userAgenString appendString:[[NSBundle mainBundle]bundleIdentifier]];
    [userAgenString appendString:@"/"];
    [userAgenString appendString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [userAgenString appendString:@"/"];
    [userAgenString appendString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [userAgenString appendString:@" "];
    //设备信息由以下内容构成，以 / 作为分隔符
    //    [userAgenString appendString: [UIDevice currentDevice].name];
    [userAgenString appendString:@"iphone"];
    [userAgenString appendString:@"/"];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [userAgenString appendString:machineString];
    [userAgenString appendString:@"/"];
    //获取国家代码
    [userAgenString appendString:[[NSLocale currentLocale] countryCode]];
    [userAgenString appendString:@"/"];
    //获取当前系统语言
    NSString *strLang = [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    [userAgenString appendString: strLang];
    [userAgenString appendString:@" "];
    // 获取所有已知的时区名称
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    // 获取指定时区的名称
    NSString *strZoneName = [zone name];
    [userAgenString appendString:strZoneName];
    //系统信息由以下内容构成，以 / 作为分隔符;
    [userAgenString appendString:@" "];
    [userAgenString appendString:@"iOS/"];
    [userAgenString appendString:[[UIDevice currentDevice] systemVersion]];
    [userAgenString appendString:@"/"];
    NSString*deviceid=(NSString*)[KeyChainTool loadKeyChainForKey:KDeviceUDIDKEY];
    if (deviceid&&deviceid.length>0) {
        [userAgenString appendString:deviceid];
    }else{
        deviceid=[[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [KeyChainTool saveDeviceUDIDWithString:deviceid];
        [userAgenString appendString:deviceid];
    }
    [userAgenString appendString:@" "];
#if TARGET_IPHONE_SIMULATOR
    [userAgenString appendString:@"00"];
#else
    [userAgenString appendString:@"10"];
#endif
    [BaseSettingManager sharedManager].userAgent=userAgenString;
    [self getPublicStartPagesRequest];
}

@end
