//
//  VarifyViewController.m
//  ICan
//
//  Created by Kalana Rathnayaka on 15/09/2023.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "VarifyViewController.h"
#import "WXApi.h"
#import "WCDBManager.h"
#import "WCDBManager+ChatSetting.h"
#import "HandleOpenUrlManager.h"
#import "CheckVersionTool.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "KeyChainTool.h"
#import "LoginViewController.h"

@interface VarifyViewController ()<HandleOpenUrlManagerDelegate,UIScrollViewDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *topDescription;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIView *emailOrPhone;
@property (weak, nonatomic) IBOutlet UIImageView *weChat;
@property (weak, nonatomic) IBOutlet UIImageView *apple;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyBtnTopMarginHeight;
@property (weak, nonatomic) IBOutlet UIStackView *sendEmailStackView;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *recoveryBtn;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UIView *getCodeBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleTop;
@end

@implementation VarifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topDescription.text = @"VerifyHeaderTitle".icanlocalized;
    self.titleTop.text = @"Access from new device".icanlocalized;
    [self.recoveryBtn setTitle:@"Confirm".icanlocalized forState:UIControlStateNormal];
    self.emailLabel.text = [NSString stringWithFormat:@"%@",@"GetOTPviaEmail".icanlocalized];
    self.emailTF.placeholder = @"EnterTheVerificationCode".icanlocalized;
    [self.getCodeBtn setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
    self.backBtn.userInteractionEnabled = YES;
    self.weChat.userInteractionEnabled = YES;
    self.apple.userInteractionEnabled = YES;
    self.weChat.layer.cornerRadius = 10.0;
    self.apple.layer.cornerRadius = 10.0;
    self.recoveryBtn.layer.cornerRadius = 10.0;
    self.weChat.layer.masksToBounds = YES;
    self.apple.layer.masksToBounds = YES;
    [self.getCodeBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.codeBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    self.secondLabel.text = [NSString stringWithFormat:@"%@%@",@"Code Send to".icanlocalized,self.info.maskedEmail];
    UITapGestureRecognizer *tapGestureWeChat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatBtnAction:)];
    UITapGestureRecognizer *tapGestureApple = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appleBtnAction:)];
    UITapGestureRecognizer *tapGestureBackbtn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnAction:)];
    [self.apple addGestureRecognizer:tapGestureApple];
    [self.weChat addGestureRecognizer:tapGestureWeChat];
    [self.backBtn addGestureRecognizer:tapGestureBackbtn];
}


- (IBAction)getCodeBtnAction:(id)sender {
    SendVerifyCodeRequest *request = [SendVerifyCodeRequest request];
    request.username = [NSString stringWithFormat:@"%@", self.info.email];
    request.type = @(0);
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"The verification code has been sent, please check it carefully".icanlocalized inView:self.view];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
    [self starTimerForEmail];
}
- (void)backBtnAction:(UITapGestureRecognizer *)gestureRecognizer {
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)weChatBtnAction:(UITapGestureRecognizer *)gestureRecognizer {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    
    //     [WXApi sendReq:req ];
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}
- (void)appleBtnAction:(UITapGestureRecognizer *)gestureRecognizer {
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}
// ASAuthorizationControllerPresentationContextProviding method
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return self.view.window;
}
// ASAuthorizationControllerDelegate method for successful authorization
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        NSDictionary *dic = [NSMutableDictionary dictionary];
        NSString *authCode = [[NSString alloc] initWithData:appleIDCredential.authorizationCode encoding:NSUTF8StringEncoding];
        NSString *identityToken = [[NSString alloc] initWithData:appleIDCredential.identityToken encoding:NSUTF8StringEncoding];
        NSString *email = appleIDCredential.email;
        NSString *userIdentifier = appleIDCredential.user;
        NSPersonNameComponents *fullName = appleIDCredential.fullName;
        NSString *name = fullName.givenName;
        [dic setValue:authCode forKey:@"authCode"];
        [dic setValue:identityToken forKey:@"identityToken"];
        [dic setValue:email forKey:@"email"];
        [dic setValue:userIdentifier forKey:@"userIdentifier"];
        [dic setValue:name forKey:@"name"];
        
        UserThirdPartyAuthorizationRequest *request = [UserThirdPartyAuthorizationRequest request];
        request.type = @(3);
        request.extra = dic;
        request.code = [KeyChainTool loadKeyChainForKey:KDeviceUDIDKEY];
        request.parameters = [request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* response) {
            [self loginSuccessWithLoginInfo:response];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
}
// ASAuthorizationControllerDelegate method for authorization failure
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    // Handle authorization error
    NSLog(@"Sign in with Apple failed with error: %@", error);
}
-(void)managerDidRecvWeiXinAuthResponse:(SendAuthResp *)response{
    if (response.errCode == 0) {
        UserThirdPartyAuthorizationRequest *request = [UserThirdPartyAuthorizationRequest request];
        request.type = @(0);
        request.code = response.code;
        request.parameters = [request mj_JSONString];
        [QMUITipsTool showLoadingWihtMessage:@"WechatAuthorizedLogin".icanlocalized inView:self.view];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* response) {
            [UserInfoManager sharedManager].loginType = @"0";
            [self loginSuccessWithLoginInfo:response];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
}

-(void)loginSuccessWithLoginInfo:(LoginInfo*)info {
    [self.view endEditing:YES];
    [WebSocketManager sharedManager].isManualClose = NO;
    NSInteger time = [[NSDate date]timeIntervalSince1970]*1000;
    [UserInfoManager sharedManager].lastLoginTime = [NSString stringWithFormat:@"%ld",time];
    [UserInfoManager sharedManager].token = info.token;
    [UserInfoManager sharedManager].username = info.username;
    [UserInfoManager sharedManager].nickname = info.nickname;
    [UserInfoManager sharedManager].userId = info.ID;
    [UserInfoManager sharedManager].certification = info.certification;
    [UserInfoManager sharedManager].numberId = info.numberId;
    [UserInfoManager sharedManager].headImgUrl = info.headImgUrl;
    [UserInfoManager sharedManager].cardId = info.cardId;
    [UserInfoManager sharedManager].mobile = info.mobile;
    [UserInfoManager sharedManager].email = info.email;
    [UserInfoManager sharedManager].gender = info.gender;
    [UserInfoManager sharedManager].loginStatus = YES;
    [UserInfoManager sharedManager].isSetPayPwd = info.isSetPayPwd;
    [UserInfoManager sharedManager].openIdType = info.openIdType;
    [UserInfoManager sharedManager].openId = info.openId;
    [UserInfoManager sharedManager].nearbyVisible = info.nearbyVisible;
    [UserInfoManager sharedManager].beFound = info.beFound;
    [UserInfoManager sharedManager].signature = info.signature;
    [UserInfoManager sharedManager].isSetPassword = info.isSetPassword;
    [UserInfoManager sharedManager].quickFriend = info.requireFriendRequest;
    [UserInfoManager sharedManager].vip = @(info.vip);
    [UserInfoManager sharedManager].isNew = info.isNew;
    [UserInfoManager sharedManager].areaNum = info.areaNum;
    [UserInfoManager sharedManager].diamondMemberExpiration = info.diamondMemberExpiration;
    [UserInfoManager sharedManager].seniorMemberExpiration = info.seniorMemberExpiration;
    [UserInfoManager sharedManager].preventDeleteMessage =  info.preventDeleteMessage;
    UserInfoManager.sharedManager.countriesCode = info.countriesCode;
    [IQKeyboardManager sharedManager].enable=NO;
    
    //连接socket
    [[WebSocketManager sharedManager] initWebScoket];
    [[WebSocketManager sharedManager]getNIMTokenRequest];
    [[WCDBManager sharedManager]initCurrentUserWCDataBase];
    [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
    [[WebSocketManager sharedManager] pushDeviceToken];
    [self fetchUserBalance];
    [[UserInfoManager sharedManager] getPrivateParameterRequest:^(PrivateParameterInfo * _Nonnull) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateShowNearPeopleNotification object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kGetPriviSuccessNotification object:nil userInfo:nil];
    }];
    [C2CUserManager.shared getC2CAllMessage];
    [UserInfoManager.sharedManager getMineMessageRequest:^(UserMessageInfo * _Nonnull info) {
        [self getPayHelpDisturbRequest];
        ReportUserLoginRequest *request = [ReportUserLoginRequest request];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
        [UserInfoManager uploadAppLanguagesRequest];
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Successful login", 成功登录) inView:nil];
        [self changeToMainView];
    }];
}
-(void)changeToMainView {
    [[BaseSettingManager sharedManager] resetAppToTabbarViewController];
    [[CheckVersionTool sharedManager]getAnnouncementRequest];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([HandleOpenUrlManager shareManager].openUrl) {
            [[HandleOpenUrlManager shareManager]handleOpenUrl];
            [HandleOpenUrlManager shareManager].openUrl=nil;
        }
        
    });
}
-(void)getPayHelpDisturbRequest{
    GetPayHelperDisturbRequest*request=[GetPayHelperDisturbRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetPayHelperDisturbInfo class] contentClass:[GetPayHelperDisturbInfo class] success:^(GetPayHelperDisturbInfo* response) {
        [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:response.payHelper chatId:PayHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
        [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:response.systemHelper chatId:SystemHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
        [UserInfoManager sharedManager].helperDisturb=response.payHelper;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(void)fetchUserBalance{
    UserBalanceRequest*request=[UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
        [UserInfoManager sharedManager].isEmailBinded=response.isEmailBound;
        [UserInfoManager sharedManager].mustBindEmailPayPswd=response.mustBindEmailPayPswd;
        [UserInfoManager sharedManager].tradePswdSet=response.tradePswdSet;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
- (IBAction)verifyBtnAction {
    if (self.emailTF.text.length <= 0) {
        [QMUITipsTool showOnlyTextWithMessage:@"Enter the verification code".icanlocalized inView:self.view];
        return;
    }else {
        DeviceVerifyRequest *request = [DeviceVerifyRequest request];
        request.accountType = @"Email";
        request.code = self.emailTF.text;
        request.username = self.info.email;
        request.parameters = [request mj_JSONString];
        [QMUITipsTool showLoadingWihtMessage:@"Verifying..".icanlocalized inView:self.view isAutoHidden:NO];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo *dataResponseClass) {
            [self loginSuccessWithLoginInfo:dataResponseClass];
            
        } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
            
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        }];
    }
}

-(void)starTimerForEmail{
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.getCodeBtn setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
                self.getCodeBtn. userInteractionEnabled = YES;
                [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
            });
            
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%.2dS", seconds] forState:UIControlStateNormal];
                [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
