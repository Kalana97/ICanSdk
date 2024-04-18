//
/**
 - Copyright © 2019 EasyPay. All rights reserved.
 - AUthor: Created  by DZL on 2019/9/4
 - System_Version_MACOS: 10.14
 - EasyPay
 - File name:  HandleOpenUrlManager.m
 - Description:
 - Function List:
 - History:
 */


#import "HandleOpenUrlManager.h"
#import <AlipaySDK/AFServiceCenter.h>
#import "AuthorizationLoginViewController.h"
#import "ShareExtensionChaltListViewController.h"
#import "QDNavigationController.h"
#import "PayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "QRCodeController.h"
#import "QRCodeView.h"
#import "TranspondTableViewController.h"
#import "SurePayMessageViewController.h"
#import "QrScanResultAddRoomController.h"
#import "FriendDetailViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "PayStatusViewController.h"
#import "IcanThirdPayViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "WalletTopupViewController.h"
#import "CertificationViewController.h"
@interface HandleOpenUrlManager()
@property(nonatomic, strong) C2CPreparePayOrderDetailInfo *detailInfo;

@end
@implementation HandleOpenUrlManager
IMPLEMENT_SINGLETON(HandleOpenUrlManager, shareManager);
-(void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(managerDidRecvWeiXinAuthResponse:)]) {
            [self.delegate managerDidRecvWeiXinAuthResponse:(SendAuthResp *)resp];
        }
    }
}
/**
 支付宝授权登录结果

 @param response AFServiceResponse
 */
- (void)managerDidRecvAlipayAuthResponse:(AFServiceResponse *)response{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(managerDidRecvAlipayAuthResponse:)]) {
        [self.delegate managerDidRecvAlipayAuthResponse:response];
    }
}
-(NSDictionary *) parameterWithURL:(NSURL *) url {
    if (url) {
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        //传入url创建url组件类
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
        //回调遍历所有参数，添加入字典
        [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.value) {
                [parm setObject:obj.value forKey:obj.name];
            }

        }];
        return parm;
    }
    return @{};
}
-(BOOL)handleOpenUrl{
    [NSThread sleepForTimeInterval: 1];
    DDLogInfo(@"self.openUrl=%@",self.openUrl.absoluteString);
    if ([UserInfoManager sharedManager].loginStatus) {
        //支付宝支付
        if ([self.openUrl.host isEqualToString:@"safepay"]){
            [[AlipaySDK defaultService] processOrderWithPaymentResult:self.openUrl standbyCallback:^(NSDictionary *resultDic) {
                [QMUITipsTool showOnlyTextWithMessage:resultDic[@"memo"] inView:nil];

            }];
        }else if ([self.openUrl.scheme isEqualToString:@"icanapp"]){///这个是最新的我行URLscheme(已经不用了 重新改用icanchat 作为国际版)
            [self doC2CPay];
        } else if ([self.openUrl.scheme isEqualToString:@"icanchat"]||[self.openUrl.scheme isEqualToString:@"icancn"]){
            NSDictionary*dict=[self parameterWithURL:self.openUrl];
            if (dict.allKeys.count>0) {
                NSString*type=[dict objectForKey:@"type"];
                if (type.length>0) {
                    if ([type isEqualToString:@"service"]) {//客服
                        NSString*idd=[dict objectForKey:@"id"];;
                        [self pushChatViewWithId:idd];
                    }else if([type isEqualToString:@"pay"]){//我行支付
                        //调起我行支付
                        //icanchat://icanchat:8888/splashActivity?type=pay&payId=payId&amount=amount&typeTitleStr=typeTitleStr

                        [self doIcanPay];
                    }else if ([type isEqualToString:@"group"]){
                        //                    icanchat://icanchat:8888/splashActivity?type=group&group_id=group_id
                        NSString*groupId=[dict objectForKey:@"group_id"];
                        [self getGroupListInfoByGroupId:groupId];
                        //                    icanchat://icanchat:8888/splashActivity?type=user&user_id=user_id
                    }else if ([type isEqualToString:@"user"]){
                        NSString*userId=[dict objectForKey:@"user_id"];
                        FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
                        vc.friendDetailType=FriendDetailType_push;
                        vc.userId=userId;
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                        //icanchat://icanchat:8888/splashActivity?type=user&user_id=user_id
                    }else if ([type isEqualToString:@"authorization"]) {//授权登录
                        //@"icanchat://authorization?type=authorization&access_token=%@&fromScheme=icanmall"
                        [self doAuthorizationLogin];
                    }else if ([type isEqualToString:@"chat_othershare"]){///商城的商品分享
                        //                    /@"icanchat://chat_othershare?type=chat_othershare&content=%@&fromScheme=icanmall"
                        NSString*openString = [NSString decodeUrlString:self.openUrl.absoluteString];
                        NSInteger startIndex=[openString rangeOfString: @"chat_othershare&content="].location+@"chat_othershare&content=".length;
                        NSString*content = [openString substringFromIndex:startIndex];
                        NSInteger endIndex = [content rangeOfString: @"&fromScheme=icanmall"].location;
                        NSString*goods = [content substringToIndex:endIndex];
                        [self doChatOthershare:goods];

                        //                    icanchat://fromShareExtension?type=appshare
                    }else if ([type isEqualToString:@"appshare"]){
                        //这个是APP的截图或者从相册里面分享出来
                        ShareExtensionChaltListViewController*share=[[ShareExtensionChaltListViewController alloc]init];
                        QDNavigationController*navc=[[QDNavigationController alloc]initWithRootViewController:share];
                        navc.modalPresentationStyle=UIModalPresentationFullScreen;
                        [[AppDelegate shared]presentViewController:navc animated:YES completion:nil];
                    }
                }else{
                    NSString*newUrlHost = self.openUrl.host;
                    if ([newUrlHost isEqualToString:@"service"]) {
                        ///icanchat://icanpay?id=%@&appid=%@
                        NSString*userId=[dict objectForKey:@"id"];;
                        [self pushChatViewWithId:userId];
                    }else if ([newUrlHost isEqualToString:@"authorization"]) {///商城登录
                        ///icanchat://icanpay?access_token=%@&appid=%@
                        [self doAuthorizationLogin];
                    }else if ([newUrlHost isEqualToString:@"icanpay"]) {///我行支付
                        ///  ///icanchat://icanpay?transactionId=%@&appid=%@
                        [self doIcanPay];
                    }else if ([newUrlHost isEqualToString:@"c2cpay"]) {///c2c支付
                        ///icanchat://c2cpay?transactionId=%@&appid=%@
                        [self doC2CPay];
                    }else if ([newUrlHost isEqualToString:@"chat_othershare"]) {///商品分享
//                    icanchat://chat_othershare?content=%@&appid=%@
                        NSString*openString = [NSString decodeUrlString:self.openUrl.absoluteString];
                        NSInteger startIndex=[openString rangeOfString: @"chat_othershare?content="].location+@"chat_othershare?content=".length;
                        NSString*content = [openString substringFromIndex:startIndex];
                        NSInteger endIndex = [content rangeOfString: @"&appid="].location;
                        NSString*goods = [content substringToIndex:endIndex];
                        [self doChatOthershare:goods];
                    }

                }

            }
        }
        return YES;
    }
    return YES;
}
///商品分享
-(void)doChatOthershare:(NSString*)goods{
    ChatOtherUrlInfo*info = [ChatOtherUrlInfo mj_objectWithKeyValues:goods];
    TranspondTableViewController*vc = [[TranspondTableViewController alloc]init];
    vc.transpondType=TranspondType_OtherApp;
    vc.pushChatViewBlock = ^(ChatModel * _Nonnull toModel, NSArray * _Nonnull messageItems) {
        for (UIViewController*vc in [AppDelegate shared].curNav.viewControllers) {
            if ([vc isKindOfClass:NSClassFromString(@"ChatViewController")]) {
                return;
            }
        }
        UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:toModel.chatID,kchatType:toModel.chatType,kauthorityType:AuthorityType_friend}];
        [[AppDelegate shared] pushViewController:vc animated:YES];
    };

    vc.chatOtherUrlInfo=info;
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [[AppDelegate shared] presentViewController:nav animated:YES completion:nil];
}
///c2c支付  ///@"icanchat://c2cpay?transactionId=%@&appid=%@"
-(void)doC2CPay{
    NSString*host = self.openUrl.host;
    if ([host isEqualToString:@"pay"]||[host isEqualToString:@"c2cpay"]) {///c2c订单支付

        UIViewController * topVc = AppDelegate.shared.topViewController;
        if ([topVc isKindOfClass:[IcanThirdPayViewController class]]) {
            [topVc dismissViewControllerAnimated:NO completion:^{
                [self getC2CPayOrderDetailRequest];
            }];
        }else{
            [self getC2CPayOrderDetailRequest];
        }

    }
}

/// 授权登录商城
-(void)doAuthorizationLogin{
    NSDictionary*dict = [self parameterWithURL:self.openUrl];
    AuthorizationLoginViewController*vc=[[AuthorizationLoginViewController alloc]init];
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    vc.parameters = dict;
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [[AppDelegate shared]presentViewController:nav animated:YES completion:^{

    }];
}
-(void)pushChatViewWithId:(NSString*)userId{
    if (![userId isEqualToString:[UserInfoManager sharedManager].userId]) {
        UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:userId,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
        [[AppDelegate shared] pushViewController:vc animated:YES];
    }

}
///我行支付
-(void)doIcanPay{
    NSDictionary*dict = [self parameterWithURL:self.openUrl];
    ///旧的SDK调起
    NSString * payId = [dict objectForKey:@"payId"];
    NSString * transactionId = [dict objectForKey:@"transactionId"];
    NSString * appid = [dict objectForKey:@"appid"];
    NSString * from = [dict objectForKey:@"fromScheme"];
    NSString * icanPayId = payId.length>0?payId:transactionId;
    if (icanPayId.length==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"支付ID不能为空" inView:nil];
        return;
    }
    [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
    GetPreparePayOrderDetailRequest*request=[GetPreparePayOrderDetailRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/preparePayOrder/%@",payId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[PreparePayOrderDetailInfo class] contentClass:[PreparePayOrderDetailInfo class] success:^(PreparePayOrderDetailInfo* dresponse) {
        [QMUITips hideAllTips];
        SurePayMessageViewController*vc=[[SurePayMessageViewController alloc]init];
        vc.detailInfo=dresponse;
        @weakify(vc);
        vc.payBlock = ^{
            UserBalanceRequest *request = [UserBalanceRequest request];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo *response) {
                if(dresponse.amount.doubleValue <= response.balance.doubleValue){
                    [[PayManager sharedManager] payShowPayViewWithAmount:[NSString stringWithFormat:@"%.2f",dresponse.amount.doubleValue] showViewController:[AppDelegate shared].curNav typeTitleStr:dresponse.name SurePaymentViewType:SurePaymentView_Normal successBlock:^(NSString * _Nonnull password) {
                        PayPreparePayOrderRequest *request = [PayPreparePayOrderRequest request];
                        request.pathUrlString = [NSString stringWithFormat:@"%@/preparePayOrder/%@",request.baseUrlString,icanPayId];
                        request.password = password;
                        request.parameters = [request mj_JSONString];
                        [QMUITipsTool showLoadingWihtMessage:@"Paying".icanlocalized inView:nil];
                        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                            @strongify(vc);
                            [UserInfoManager sharedManager].attemptCount = nil;
                            [UserInfoManager sharedManager].isPayBlocked = NO;
                            [QMUITips hideAllTips];
                            [vc dismissViewControllerAnimated:NO completion:^{
                                PayStatusViewController *statusVC = [PayStatusViewController new];
                                statusVC.detailInfo = dresponse;
                                statusVC.status = 1;
                                statusVC.backUrl = [NSString stringWithFormat:@"%@://icanpay?errCode=1",from.length > 0 ? from:appid];
                                [[AppDelegate shared]pushViewController:statusVC animated:YES];
                            }];
                        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                            if ([info.code isEqual:@"pay.password.error"]){
                                if(info.extra.isBlocked){
                                    [UserInfoManager sharedManager].isPayBlocked = YES;
                                    [UserInfoManager sharedManager].unblockTime = [NSString getUnblockTime:info.extra.blockedTimeMillis];
                                    [self doIcanPay];
                                }else if(info.extra.remainingCount != 0) {
                                    [UserInfoManager sharedManager].attemptCount = [NSString stringWithFormat:@"%ld", (long)info.extra.remainingCount];
                                    [self doIcanPay];
                                }else{
                                    [UserInfoManager sharedManager].attemptCount = nil;
                                    @strongify(vc);
                                    [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
                                }
                            } else {
                                @strongify(vc);
                                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
                                if (![info.code isEqualToString:@"pay.password.error"]) {
                                    [vc dismissViewControllerAnimated:NO completion:^{
                                        PayStatusViewController *statusVC = [PayStatusViewController new];
                                        statusVC.detailInfo = dresponse;
                                        statusVC.status = 0;
                                        statusVC.backUrl =[NSString stringWithFormat:@"%@://icanpay?errCode=1&&errStr=%@",from.length > 0 ? from:appid,[info.desc netUrlEncoded]];
                                        [[AppDelegate shared]pushViewController:statusVC animated:YES];
                                    }];
                                }
                            }
                        }];
                    }cancelBlock:^{
                    }];
                }else{
                    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
                        WalletTopupViewController *WalletTopupVc = [WalletTopupViewController new];
                        [[AppDelegate shared] pushViewController:WalletTopupVc animated:YES];
                    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authing"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"RealnameAuthingTip".icanlocalized
                                                                                       message:@""
                                                                                preferredStyle:UIAlertControllerStyleAlert]; // 1
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                               style:UIAlertActionStyleCancel
                                                                             handler:^(UIAlertAction *action) {
                                                                                 // Handle cancel button tap action here
                                                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                                             }];

                        [alert addAction:cancelAction]; // 5
                        [[AppDelegate shared] presentViewController:alert animated:YES completion:nil];
                    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"NotAuth"]) {
                        CertificationViewController *VerifiedVc = [[CertificationViewController alloc]init];
                        [[AppDelegate shared] pushViewController:VerifiedVc animated:YES];
                    }
                }
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
            }];
        };
        QDNavigationController *nvc = [[QDNavigationController alloc]initWithRootViewController:vc];
        [[AppDelegate shared]presentViewController:nvc animated:YES completion:nil];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}
-(void)handleShortcutItem:(UIApplicationShortcutItem *)shortcutItem{
    NSString*type=shortcutItem.type;
    if (!UserInfoManager.sharedManager.loginStatus) {
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
        return;
    }
    if([type isEqualToString:@"com.codingchou.test.pay"]){


    } else if([type isEqualToString:@"com.codingchou.test.scan"]){//扫一扫
        [self gotoScanVc];

    } else if([type isEqualToString:@"com.codingchou.test.qrcode"]){//我的二维码
        QRCodeView*view = [[NSBundle mainBundle]loadNibNamed:@"QRCodeView" owner:self options:nil].firstObject;
        view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        view.qrCodeViewTyep=QRCodeViewTyep_user;
        [view showQRCodeView];

    } else if([type isEqualToString:@"com.codingchou.test.redpacket"]){
        NSLog(@"快捷方式 -- 红包");

    }

}
-(void)gotoScanVc {

    QRCodeController *friendsVC = [[QRCodeController alloc]init];
    [[AppDelegate shared] pushViewController:friendsVC animated:YES];


}
-(void)getGroupListInfoByGroupId:(NSString*)groupId{
    GetGroupDetailRequest * request =[GetGroupDetailRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/group/%@",request.baseUrlString,groupId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GroupListInfo class] contentClass:[GroupListInfo class] success:^(GroupListInfo * response) {
        [self goToGroupDetailOrQrRoomWith:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {

    }];
}
-(void)goToGroupDetailOrQrRoomWith:(GroupListInfo*)listInfo{
    if (listInfo.isInGroup) {
        UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:listInfo.groupId,kchatType:GroupChat,kauthorityType:AuthorityType_friend}];
        [[AppDelegate shared] pushViewController:vc animated:YES];
    }else{
        QrScanResultAddRoomController * vc = [QrScanResultAddRoomController new];
        vc.groupDetailInfo = listInfo;
        vc.fromAddFriend=YES;
        [[AppDelegate shared] pushViewController:vc animated:YES];
    }

}
///获取c2c支付订单详情
-(void)getC2CPayOrderDetailRequest{
    GetC2CPreparePayOrderDetailRequest * request = [GetC2CPreparePayOrderDetailRequest request];
    NSDictionary*dict = [self parameterWithURL:self.openUrl];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/preparePayOrder/%@",dict[@"transactionId"]];
    [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CPreparePayOrderDetailInfo class] contentClass:[C2CPreparePayOrderDetailInfo class] success:^(C2CPreparePayOrderDetailInfo*   response) {
        self.detailInfo = response;
        @weakify(self);
        //等待所有网络请求完成
        RACSignal*signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self fetchUserBalance:subscriber];
            return nil;
        }];
        RACSignal*signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self getCurrencyRequest:subscriber];
            return nil;
        }];
        RACSignal*signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            @strongify(self);
            [self getC2CAllExchangeList:subscriber];
            return nil;
        }];
        [self rac_liftSelector:@selector(reloadComplationDataA:dataB:dataC:) withSignalsFromArray:@[signalA,signalB,signalC]];


    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        if (statusCode == 403) {
            [C2CUserManager.shared getC2cToken:^(C2CTokenInfo * _Nonnull response) {
                [self getC2CPayOrderDetailRequest];
            } failure:^(NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {

            }];
        }else{
            [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
        }

    }];

}
///获取我行余额
-(void)fetchUserBalance:(id<RACSubscriber>)singnal{
    UserBalanceRequest*request=[UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
        [singnal sendNext:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}
/** 获取资产列表 */
-(void)getCurrencyRequest:(id<RACSubscriber>)singnal{
    [C2CUserManager.shared getC2CBalanceRequest:^(NSArray * _Nonnull response) {
        [singnal sendNext:response];
    } failure:^(NetworkErrorInfo * _Nonnull info) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}
/** 获取汇率列表 */
-(void)getC2CAllExchangeList:(id<RACSubscriber>)singnal{
    [[C2CUserManager shared]getC2CAllExchangeListRequest:^(NSArray <C2CExchangeRateInfo*>* response) {
        [singnal sendNext:response];
    } failure:^(NetworkErrorInfo * _Nonnull info) {

    }];
}
-(void)reloadComplationDataA:(UserBalanceInfo*)dataA dataB:(NSArray*)dataB dataC:(NSArray<C2CExchangeRateInfo*>*)dataC{
    [QMUITips hideAllTips];
    IcanThirdPayViewController * vc = [[IcanThirdPayViewController alloc]init];
    vc.balanceInfo = dataA;
    vc.assetItems = dataB;
    vc.prepareDetailInfo = self.detailInfo;
    NSDictionary*dict = [self parameterWithURL:self.openUrl];
    vc.appId = dict[@"appid"];
    vc.allExchangeRateItems = dataC;
    [[AppDelegate shared]presentViewController:vc animated:YES completion:nil];

}

@end
