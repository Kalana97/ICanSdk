//
//  QuickLoginViewController.m
//  ICan
//
//  Created by CodeLabs on 2023-11-01.
//  Copyright © 2023 dzl. All rights reserved.
//

#import <AuthenticationServices/AuthenticationServices.h>
#import "QuickLoginViewController.h"
#import "QDNavigationController.h"
#import "WXApi.h"
#import "HandleOpenUrlManager.h"
#import "WCDBManager.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatSetting.h"
#import "CheckVersionTool.h"

@interface QuickLoginViewController ()<UIScrollViewDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (weak, nonatomic) IBOutlet QMUITextField *emailTextField;
@property (weak, nonatomic) IBOutlet QMUITextField *otpTextField;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleHintLabel;
@property (weak, nonatomic) IBOutlet UIButton *otpSendLabel;
@property (weak, nonatomic) IBOutlet UIView *emailBgView;
@property (weak, nonatomic) IBOutlet UIView *otpBtnBgView;
@property (weak, nonatomic) IBOutlet UIView *otpBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger countdown;

@end

@implementation QuickLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.emailBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.otpBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.otpBtnBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    
    self.titleHintLabel.text=@"quickLogin".icanlocalized;
    self.orLabel.text=@"or".icanlocalized;
    self.emailTextField.placeholder=@"Pleaseenteremail".icanlocalized;
    self.otpTextField.placeholder=@"Enter the verification code".icanlocalized;
    [self.otpSendLabel setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"LoginViewController.loginBtn".icanlocalized forState:UIControlStateNormal];
    self.wechatBtn.hidden = [WXApi isWXAppInstalled] ? NO : YES;
    [IQKeyboardManager sharedManager].enable=YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES;
    [self.emailTextField setText:self.email];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return self.view.window;
}

- (IBAction)sendBtnAction {
    if (![NSString checkIsEmail:self.emailTextField.text]) {
        [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
        return;
    }
    self.otpSendLabel.userInteractionEnabled = NO;
    SendVerifyCodeRequest*request=[SendVerifyCodeRequest request];
    request.username= self.emailTextField.text;
    request.type=@(0);
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showLoadingWihtMessage:@"".icanlocalized inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        [self startCountdown];
        [QMUITipsTool showOnlyTextWithMessage:@"The verification code has been sent, please check it carefully".icanlocalized inView:self.view];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [self cancelCountdown];
        self.otpSendLabel. userInteractionEnabled = YES;
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

- (void)startCountdown {
    self.countdown = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
}

- (void)cancelCountdown {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateCountdown {
    if (self.countdown > 0) {
        [self.otpSendLabel setTitle:[NSString stringWithFormat:@"%.2dS", self.countdown] forState:UIControlStateNormal];
        [self.otpSendLabel setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        self.countdown--;
    } else {
        [self.otpSendLabel setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
        self.otpSendLabel. userInteractionEnabled = YES;
        [self.otpSendLabel setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        [self cancelCountdown];
    }
}

- (IBAction)loginBtnAction {
    if (self.emailTextField.text.length <= 0) {
        [QMUITipsTool showOnlyTextWithMessage:@"validation.email".icanlocalized inView:self.view];
        return;
    }
    if (![NSString checkIsEmail:self.emailTextField.text]) {
        [QMUITipsTool showOnlyTextWithMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
        return;
    }
    if (self.otpTextField.text.length <= 0) {
        [QMUITipsTool showOnlyTextWithMessage:@"Enter the verification code".icanlocalized inView:self.view];
        return;
    }
    LoginRequest*request=[LoginRequest request];
    request.username=self.emailTextField.text;
    request.accountType=@(1);
    request.code = self.otpTextField.text;
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showLoadingWihtMessage:@"Login.loading..".icanlocalized inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* dataResponseClass) {
        [UserInfoManager sharedManager].email = self.emailTextField.text;
        [UserInfoManager sharedManager].loginType =@"6";
        [self loginSuccessWithLoginInfo:dataResponseClass];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

- (void)loginSuccessWithLoginInfo:(LoginInfo*)info {
   [self.view endEditing:YES];
   [WebSocketManager sharedManager].isManualClose=NO;
   NSInteger time=[[NSDate date]timeIntervalSince1970]*1000;
   [UserInfoManager sharedManager].lastLoginTime=[NSString stringWithFormat:@"%ld",time];
   [UserInfoManager sharedManager].token=info.token;
   [UserInfoManager sharedManager].username=info.username;
   [UserInfoManager sharedManager].nickname=info.nickname;
   [UserInfoManager sharedManager].userId=info.ID;
   [UserInfoManager sharedManager].certification=info.certification;
   [UserInfoManager sharedManager].numberId=info.numberId;
   [UserInfoManager sharedManager].headImgUrl=info.headImgUrl;
   [UserInfoManager sharedManager].cardId = info.cardId;
   [UserInfoManager sharedManager].mobile = info.mobile;
   [UserInfoManager sharedManager].email = info.email;
   [UserInfoManager sharedManager].areaNum = info.areaNum;
   [UserInfoManager sharedManager].gender = info.gender;
   [UserInfoManager sharedManager].loginStatus=YES;
   [UserInfoManager sharedManager].isSetPayPwd=info.isSetPayPwd;
   [UserInfoManager sharedManager].openIdType=info.openIdType;
   [UserInfoManager sharedManager].openId =info.openId;
   [UserInfoManager sharedManager].nearbyVisible = info.nearbyVisible;
   [UserInfoManager sharedManager].beFound = info.beFound;
   [UserInfoManager sharedManager].signature = info.signature;
   [UserInfoManager sharedManager].isSetPassword=info.isSetPassword;
   [UserInfoManager sharedManager].quickFriend=info.requireFriendRequest;
   [UserInfoManager sharedManager].vip=@(info.vip);
   [UserInfoManager sharedManager].isNew=info.isNew;
   [IQKeyboardManager sharedManager].enable=NO;
   //连接socket
   [[WebSocketManager sharedManager] initWebScoket];
   [[WCDBManager sharedManager]initCurrentUserWCDataBase];
   [[WebSocketManager sharedManager]getNIMTokenRequest];
   [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
   [[WebSocketManager sharedManager] pushDeviceToken];
   [self fetchUserBalance];
   [[UserInfoManager sharedManager] getPrivateParameterRequest:^(PrivateParameterInfo * _Nonnull) {
   }];
   [C2CUserManager.shared getC2cToken:^(C2CTokenInfo *response) {
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [C2CUserManager.shared getC2CCurrentUser:^(C2CUserInfo *info) {
               
           }];
       });
   } failure:^(NetworkErrorInfo *info, NSInteger statusCode) {
       
   }];
   [UserInfoManager.sharedManager getMineMessageRequest:^(UserMessageInfo * _Nonnull info) {
       
   }];
   [self getPayHelpDisturbRequest];
   [UserInfoManager uploadAppLanguagesRequest];
   ReportUserLoginRequest*request=[ReportUserLoginRequest request];
   [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
       
   } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
       
   }];
   [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Successful login", 成功登录) inView:nil];
   [self changeToMainView];
}

- (IBAction)appleSignBtnAction {
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    NSLog(@"Sign in with Apple failed with error: %@", error);
}

- (IBAction)wechatBtnAction {
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}

- (void)fetchUserBalance{
    UserBalanceRequest*request=[UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
        [UserInfoManager sharedManager].isEmailBinded=response.isEmailBound;
        [UserInfoManager sharedManager].mustBindEmailPayPswd=response.mustBindEmailPayPswd;
        [UserInfoManager sharedManager].tradePswdSet=response.tradePswdSet;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

- (void)getPayHelpDisturbRequest{
    GetPayHelperDisturbRequest*request=[GetPayHelperDisturbRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetPayHelperDisturbInfo class] contentClass:[GetPayHelperDisturbInfo class] success:^(GetPayHelperDisturbInfo* response) {
        [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:response.payHelper chatId:PayHelperMessageType chatType:UserChat authorityType:AuthorityType_friend ];
        [UserInfoManager sharedManager].helperDisturb=response.payHelper;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

//获取系统通知的免打扰信息
- (void)getSystemHelpperDisturbRequest{
    GetPayHelperDisturbRequest*request=[GetPayHelperDisturbRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetPayHelperDisturbInfo class] contentClass:[GetPayHelperDisturbInfo class] success:^(GetPayHelperDisturbInfo* response) {
        [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:response.payHelper chatId:PayHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
        [UserInfoManager sharedManager].helperDisturb=response.payHelper;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

- (void)changeToMainView {
    [[BaseSettingManager sharedManager] resetAppToTabbarViewController];
    [[CheckVersionTool sharedManager]getAnnouncementRequest];
}

@end
