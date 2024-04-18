//
//  WebSocketManager.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/6/12.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "WebSocketManager.h"
#import "STOMPMacro.h"
//WCDB
#import <WCDB/WCDB.h>
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WebSocketManager+HandleMessage.h"
#import "VoicePlayerTool.h"
#import <CoreLocation/CoreLocation.h>
#import "DomainExamineManager.h"
#import "ResendMessageManager.h"
#import "LoginViewController.h"
#import "QDNavigationController.h"
#import <CoreLocation/CoreLocation.h>
#import "NERtcCallKit.h"

static NSInteger  clientCount = 0;
@implementation ReceiptInfo
-(NSString *)description{
    return [self mj_JSONString];
}
@end

@interface WebSocketManager ()<STOMPClientDelegate,CLLocationManagerDelegate>

///定位管理者
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
/** 是否开启网络监测 */
@property(nonatomic, assign) BOOL shouStartNetworkNotification;
/** 连接地址 */
@property(nonatomic, copy) NSURL *webSocketUrl;
//当前的地图中心点
@property (nonatomic) CLLocationCoordinate2D currentCenterCLLocationCoordinate2D;
@end
@implementation WebSocketManager

+ (instancetype)sharedManager {
    static WebSocketManager *api;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[WebSocketManager alloc] init];
        [api networkMonitoring];
        api.hasNewWork=YES;
        [[NSNotificationCenter defaultCenter]addObserver:api selector:@selector(tokenFailer) name:KTokenFailureNotification object:nil];
        if (UserInfoManager.sharedManager.loginStatus) {
            [api fetchFriendList];
        }
    });
    
    return api;
}
-(NSURL *)webSocketUrl{
    NSString *tokenStr = [UserInfoManager sharedManager].token;
    NSString *urlStr;
    urlStr = SOCKET_URL;
    return [NSURL URLWithString:urlStr];
}
/// token失效的通知
-(void)tokenFailer{
    self.isManualClose=YES;
    [self closeWebSocket];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Yourloginisinvalidpleaseloginagain", 您的登录已失效请重新登录) message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Sure", UIAlertController.sure.title) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [[WebSocketManager sharedManager]userManualLogout];
        LoginViewController*vc=[[LoginViewController alloc]init];
        QDNavigationController*loginVc=[[QDNavigationController alloc]initWithRootViewController:vc];
        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
        [UIApplication sharedApplication].delegate.window.rootViewController=loginVc;
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
/**
 监测是否需要重新连接
 */
-(void)checkShouldStartReconnectToWebSocket{
    if (!self.isManualClose&&self.hasNewWork) {
        [self initWebScoket];
    }
}
//如果是没有网络的话 需要关闭SRWebsocket 并且设置为nil 因为不设置的话 会存在连个socket
- (void)initWebScoket {
    if ([UserInfoManager sharedManager].loginStatus) {
        self.client.delegate = nil;
        self.client = nil;
        self.client = [[STOMPClient alloc] initWithURL:self.webSocketUrl webSocketHeaders:@{@"Token":[UserInfoManager sharedManager].token} useHeartbeat:YES];
        self.client.delegate = self;
        [self.client connectWithHeaders:nil];
        self.connectStatus=SocketConnectStatus_Connecting;
        [[NSNotificationCenter defaultCenter]postNotificationName:KConnectSocketStartNotification object:nil];
    }
}

- (void)closeWebSocket {
    clientCount=0;
    [self.client disconnect];
    
    self.client=nil;
}
/**
 在连接成功之后开始订阅
 */
-(void)subscribeAfterConnetSuccess{
    ///订阅单聊消息
    [self.client subscribeTo:RecivePersonMessage messageHandler:^(STOMPMessage *message) {
        [self didReceiveMessage:message.body];
        
    }];
    ///发送单聊消息之后，收到消息是否发送成功的回调
    [self.client subscribeTo:@"/user/topic/send2user" messageHandler:^(STOMPMessage *message) {
        DDLogInfo(@"/user/topic/send2user = %@",[AESEncryptor decryptAESWithString:message.body]);
        [self didReceiveReceiptInfo:[AESEncryptor decryptAESWithString:message.body]];
    }];
    ///发送群消息之后，收到消息是否发送成功的回调
    [self.client subscribeTo:@"/user/topic/send2group" messageHandler:^(STOMPMessage *message) {
        DDLogInfo(@"/user/topic/send2groupbody = %@",[AESEncryptor decryptAESWithString:message.body]);
        [self didReceiveReceiptInfo:[AESEncryptor decryptAESWithString:message.body]];
    }];
    
    
}
#pragma mark  STOMPClientDelegate
-(void)webSocketConnectWithStompFrame:(STOMPFrame *)stompFrame Error:(NSError *)error{
    clientCount++;
    self.connectStatus=SocketConnectStatus_UnConnected;
    DDLogInfo(@"webSocketConnectWithStompFrame连接失败=%@",error);
}

//连接失败=Error Domain=NSPOSIXErrorDomain Code=61 "Connection refused" UserInfo={_kCFStreamErrorCodeKey=61, _kCFStreamErrorDomainKey=1}
//连接失败=Error Domain=NSPOSIXErrorDomain Code=61 "Connection refused" UserInfo={_kCFStreamErrorCodeKey=61, _kCFStreamErrorDomainKey=1}
//这里可以监测 如果是Connection refused 可以往丁丁群发送通知
-(void)websocketDidDisconnectJFRWebSocket:(SRWebSocket *)webSocket error:(NSError *)error{
    DDLogInfo(@"连接失败=%@",error);
    DDLogInfo(@"error=%@",error.userInfo);
    DDLogInfo(@"error=%ld",error.code);
    self.connectStatus = SocketConnectStatus_UnConnected;
    self.subscribeArray = [NSMutableArray array];
    clientCount++;
    if (error) {
        //        error.userInfo objectForKey:(nonnull NSErrorUserInfoKey)
        NSNumber*code=[error.userInfo objectForKey:@"HTTPResponseStatusCode"];
        DDLogInfo(@"code=%@",code);
        if ([code intValue] == 403) {
            [[NSNotificationCenter defaultCenter]postNotificationName:KTokenFailureNotification object:nil];
            [[UserInfoManager sharedManager]setLoginStatus:NO];
            NSLog(@"%d",[UserInfoManager sharedManager].loginStatus);
            [[WebSocketManager sharedManager]userManualLogout];
            [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
        }else if ([code intValue] == 1011){
            [[UserInfoManager sharedManager]setLoginStatus:NO];
            NSLog(@"%d",[UserInfoManager sharedManager].loginStatus);
            [[WebSocketManager sharedManager]userManualLogout];
            [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
        }else if (error.code==61){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkShouldStartReconnectToWebSocket];
            });
        } else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self checkShouldStartReconnectToWebSocket];
            });
        }
    }  else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkShouldStartReconnectToWebSocket];
        });
    }
}

- (void)webSocketDidConnect:(STOMPFrame *)stompFrame {
    clientCount = 0;
    self.shouStartNetworkNotification = NO;
    [self getCurrentLocation];
    DDLogInfo(@"成功连接");
    [[NSNotificationCenter defaultCenter]postNotificationName:KConnectSocketSuccessNotification object:nil];
    if ([stompFrame.command isEqualToString:@"CONNECTED"]) {
        self.subscribeArray = [NSMutableArray array];
        //连接成功之后获取群列表取出groupID,然后一一订阅相应消息通道 - After the connection is successful, get the group list, take out the groupID, and then subscribe to the corresponding message channel one by one
        [self getGroupList];
        [self getOfflineRequest];
        [self subscribeAfterConnetSuccess];
        [self fetchCurretnLoacationAndJudeIsNeedUpdateLocation];
        self.connectStatus = SocketConnectStatus_Connected;
        [[ResendMessageManager sharedManager]startResendMessage];
    }
}

///  订阅某个群消息
/// @param groupId 群ID
-(void)subscriptionGroupWihtGroupId:(NSString*)groupId{
    NSString *subscribeString = [NSString stringWithFormat:@"/topic/group_%@", groupId];
    STOMPSubscription*sub= [self.client subscribeTo:subscribeString messageHandler:^(STOMPMessage *message) {
        [self didReceiveMessage:message.body];
    }];
    [self.subscribeArray addObject:sub];
}
/// 取消订阅某个群
/// @param groupId 群ID
-(void)unsubscribeGroupWithGroupId:(NSString *)groupId{
    for (STOMPSubscription*sub in self.subscribeArray) {
        DDLogInfo(@"sub=%@",sub.subscriptionAddress);
        if ([sub.subscriptionAddress containsString:groupId]) {
            //取消订阅
            [sub unsubscribe];
            //订阅数组需要移除
            [self.subscribeArray removeObject:sub];
            break;
        }
    }
}


#pragma mark -- 把消息模型存到数据库消息列表里 (在消息页展示)
-(void)saveMessageWithChatModel:(ChatModel *)chatModel {
    //计算消息的高度和宽度
    [[WCDBManager sharedManager]cacheMessageWithChatModel:chatModel isNeedSend:NO];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveMessage:) ]) {
        [self.delegate webSocketManagerDidReceiveMessage:chatModel];
    }
}
#pragma mark -- 和好友或者群聊发送完消息后的回执(服务器成功收到之后给发送方发送的回执)
-(void)didReceiveReceiptInfo:(NSString *)msg {
    NSDictionary *dicStr = [msg mj_JSONObject];
    ReceiptInfo*receiptInfo=[ReceiptInfo mj_objectWithKeyValues:dicStr];
    [[WCDBManager sharedManager]updateChatModelIsSuccessSendWithMessageId:receiptInfo.msgId];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(webSocketManagerDidReceiveReceiptInfo:)]) {
        [self.delegate webSocketManagerDidReceiveReceiptInfo:receiptInfo];
    }
}
/**
 开启网络监听
 */
-(void)networkMonitoring{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
}
//网络监听
-(void)applicationNetworkStatusChanged:(NSNotification*)userinfo{
    NSInteger status = [[[userinfo userInfo]objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:{
            self.shouStartNetworkNotification=YES;
            self.hasNewWork=NO;
            self.connectStatus=SocketConnectStatus_NoNet;
            [[NSNotificationCenter defaultCenter]postNotificationName:KAFNetworkReachabilityStatusNotReachable object:nil];
        }
            return;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
        default:{
            self.hasNewWork=YES;
            //每次APP启动都会调用一次这个回调
            if (self.shouStartNetworkNotification) {
                [self checkShouldStartReconnectToWebSocket];
            }
            
        }
            return;
    }
}
//获取好友列表
-(void)fetchFriendList{
    GetFriendsListRequest * request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray<UserMessageInfo*>* response) {
        [[WCDBManager sharedManager]insertUserMessageInfoWithArray:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {        
    }];
}
#pragma mark -- 获取群聊列表
-(void)getGroupList {
    GetGroupListRequest*request=[GetGroupListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupListInfo class] success:^(NSArray<GroupListInfo*>* response) {
        [[WCDBManager sharedManager]deleteAllGroupList];
        for (GroupListInfo*info in response) {
            [self subscriptionGroupWihtGroupId:info.groupId];
        }
        [[WCDBManager sharedManager]insertOrUpdateGroupListInfoWithArray:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
/// 获取离线消息
-(void)getOfflineRequest{
    GetMessageOfflineRequest*request=[GetMessageOfflineRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[MessageOfflineInfo class] contentClass:[MessageOfflineInfo class] success:^(MessageOfflineInfo* response) {
        [self handleMessageOffline:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
-(void)pushDeviceToken{
    BindingUserDeviceTokenRequesr*request=[BindingUserDeviceTokenRequesr request];
    request.token=[UserInfoManager sharedManager].deviceToken;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(void)getNIMTokenRequest{
    UserGetNIMTokenRequest*request=[UserGetNIMTokenRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/user/%@/cloudLetterToken",[UserInfoManager sharedManager].userId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetRongYunTokenInfo class] contentClass:[GetRongYunTokenInfo class] success:^(GetRongYunTokenInfo* response) {
        if (response) {
            [self connetNIMWithToken:response.token];
        }else{
            [UserInfoManager sharedManager].cloudLetterVoice=
            [UserInfoManager sharedManager].cloudLetterVideo=NO;
        }
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
-(void)connetNIMWithToken:(NSString*)token{
    NSString*account;
#if DEBUG
    account=[NSString stringWithFormat:@"t_%@",[UserInfoManager sharedManager].userId];
#else
    
    account=[NSString stringWithFormat:@"p_%@",[UserInfoManager sharedManager].userId];
#endif
    [[NERtcCallKit sharedInstance]login:account token:token completion:^(NSError * _Nullable error) {
        if (error) {
            DDLogError(@"登录云信失败=%@",error.debugDescription);
        }else{
            DDLogInfo(@"登录云信成功");
        }
    }];
}

/**
 设置消息的未读数量
 */
-(void)setApplicationIconBadgeNumber{
    if ([UserInfoManager sharedManager].loginStatus) {
        NSInteger UnReadMsgNumber =[[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
        NSInteger UnReadFriendSubscriptionAmount = [[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:UnReadMsgNumber+UnReadFriendSubscriptionAmount];
        [[NIMSDK sharedSDK].apnsManager registerBadgeCountHandler:^NSUInteger{
            return UnReadMsgNumber+UnReadFriendSubscriptionAmount;
        }];
        SetApplicationIconBadgeNumberRequest*request=[SetApplicationIconBadgeNumberRequest request];
        request.pathUrlString=[request.baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/user/unReadNumber/%ld",UnReadMsgNumber+UnReadFriendSubscriptionAmount]];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
    }
    
    
}

// Upload user location
- (void)fetchCurretnLoacationAndJudeIsNeedUpdateLocation {
    if ([UserInfoManager sharedManager].nearbyVisible) {
        UploadUserLocationRequest *request = [UploadUserLocationRequest request];
        request.longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
        request.latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
        request.parameters = [request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        }];
    }
}

- (void)getCurrentLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([locations firstObject]) {
        [self.locationManager stopUpdatingLocation];
        self.currentLocation = [locations firstObject];
    }
}

/**
 用户手动退出登录 或者是被顶号 或者禁用 或者冻结
 */
-(void)userManualLogout{
    [UserInfoManager sharedManager].loginStatus=NO;
    [WebSocketManager sharedManager].isManualClose=YES;
    [[UserInfoManager sharedManager]removeObjectWithKey:kmallToken];
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        
    }];
    [self closeWebSocket];
    [[NERtcCallKit sharedInstance] logout:^(NSError * _Nullable error) {
        
    }];
    
}
-(NSMutableArray<NSString *> *)cacheMessageIds{
    if (!_cacheMessageIds) {
        _cacheMessageIds=[NSMutableArray array];
    }
    return _cacheMessageIds;
}


@end
