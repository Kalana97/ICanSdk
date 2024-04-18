//
/**
 - Copyright © 2020 limao01. All rights reserved.
 - Author: Created  by DZL on 26/11/2020
 - File name:  RegisterViewController.m
 - Description:
 - Function List:
 */


#import <AuthenticationServices/AuthenticationServices.h>
#import "RegisterViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "CommonWebViewController.h"
#import "SelectMobileCodeViewController.h"
#import "QDNavigationController.h"
#import "WCDBManager.h"
#import "WCDBManager+ChatList.h"
#import "CheckVersionTool.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WXApi.h"

@interface RegisterViewController ()<UIScrollViewDelegate,QMUITextFieldDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property (weak, nonatomic) IBOutlet UIView *emailBgView;
@property (weak, nonatomic) IBOutlet UIView *verificationView;
@property (weak, nonatomic) IBOutlet QMUITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIButton *emailLoginBtn;

/**
 密码
 */
@property (weak, nonatomic) IBOutlet UIView *passwordBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIView *againPasswordBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *againPasswordTextField;
/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UIView *getCodeBgView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

/**
 协议
 */
@property (weak, nonatomic) IBOutlet UILabel *protecolLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;



@property(nonatomic, copy) NSString *mobileCode;
@property(nonatomic, strong) NSDictionary *openDataDict;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;

@property (weak, nonatomic) IBOutlet UIView *guiderBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *guiderTextField;
@property (weak, nonatomic) IBOutlet UIImageView *flagView;
@property (weak, nonatomic) IBOutlet UIView *countryBgView;
@property (weak, nonatomic) IBOutlet UIView *usernameBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UILabel *seperatorHintLabel;
@property (weak, nonatomic) IBOutlet UIControl *emailTabBgView;
@property (weak, nonatomic) IBOutlet UIControl *usernameTabBgView;
@property (weak, nonatomic) IBOutlet UILabel *emailTabLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameTabLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseCountryLabel;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (nonatomic, assign) BOOL isTabUsername;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger countdown;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorViewBgColor;
    
    self.title = @"Register Account".icanlocalized;
    self.emailTextField.placeholder=@"Pleaseenteremail".icanlocalized;
    self.usernameTextField.placeholder=@"validation.username.hint".icanlocalized;
    self.passwordTextField.placeholder = @"Please enter password".icanlocalized;
    self.emailTabLabel.text = @"registration.email".icanlocalized;
    self.usernameTabLabel.text = @"registration.username".icanlocalized;
    self.chooseCountryLabel.text = @"ShowSelectAddressView.titleLabel".icanlocalized;
    self.againPasswordTextField.placeholder = @"Please enter the password again".icanlocalized;
    [self.getCodeBtn setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
    self.codeTextField.placeholder = @"Enter the verification code".icanlocalized;
    self.guiderTextField.placeholder = @"PleaseEnterGuiderID".icanlocalized;
    self.seperatorHintLabel.text = @"or".icanlocalized;
    [self.registerBtn setTitle:@"Register".icanlocalized forState:UIControlStateNormal];
    [self.emailLoginBtn setTitle:@"Register to Email".icanlocalized forState:UIControlStateNormal];
    [self.emailLoginBtn setTitle:@"Register to Phone".icanlocalized forState:UIControlStateSelected];
    
    NSString *s1 = @"Agree".icanlocalized;
    NSString *s2 = @"ServiceAgreement".icanlocalized;
    NSString *s3 = @"And".icanlocalized;
    NSString *s4 = @"PrivacyAgreement".icanlocalized;
    NSString *string5 = [NSString stringWithFormat:@"%@%@%@%@",s1,s2,s3,s4];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:string5];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(0, string.length)];
    NSRange rang = [string5 rangeOfString:s2];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(rang.location, s2.length)];
    NSRange rang2 = [string5 rangeOfString:s4];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(rang2.location, s4.length)];
    self.protecolLabel.attributedText = string;
    [self.protecolLabel yb_addAttributeTapActionWithStrings:@[s2,s4] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        [self lookRegistrationAgreement:string];
    }];
    
    [self.registerBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.emailBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.passwordBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.usernameBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.againPasswordBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.getCodeBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.codeBgView layerWithCornerRadius:15 borderWidth:0 borderColor:0];
    [self.guiderBgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.countryBgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.flagView setImageWithString:self.selectCountryInfo.flagUrl placeholder:nil];
    self.flagView.layer.borderWidth = 1.0;
    self.flagView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.selectBtn setSelected:YES];
    [self.selectBtn setBackgroundImage:UIImageMake(@"wallet_recharge_way_select") forState:UIControlStateSelected];
    [self.selectBtn setBackgroundImage:UIImageMake(@"icon_selectperson_nor") forState:UIControlStateNormal];
    [self.emailLoginBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    [self.emailLoginBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateSelected];
    self.countryLab.text = BaseSettingManager.isChinaLanguages?self.selectCountryInfo.nameCn:self.selectCountryInfo.nameEn;
    self.wechatBtn.hidden = [WXApi isWXAppInstalled] ? NO : YES;
    
    [self setupEmailTab];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.guiderTextField) {
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (checkStr.length > 6) {
            return NO;
        }
        return [NSString checkIsPureString:string];
    }
    return YES;
}

- (IBAction)endEditing {
    [self.view endEditing:YES];
}

- (IBAction)selectCountryAction {
    SelectMobileCodeViewController *vc = [[SelectMobileCodeViewController alloc]init];
    QDNavigationController *nav = [[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^ {
        
    }];
    vc.selectAreaBlock = ^(AllCountryInfo * _Nonnull info) {
        self.mobileCode = info.phoneCode;
        self.selectCountryInfo = info;
        self.countryLab.text = BaseSettingManager.isChinaLanguages?info.nameCn:info.nameEn;
        [self.flagView setImageWithString:info.flagUrl placeholder:nil];
        self.guiderBgView.hidden = NO;
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        self.emailTextField.placeholder = @"Please Enter Your Email Account".icanlocalized;
        self.verificationView.hidden = NO;
    };
}

- (IBAction)emailTabAction {
    self.usernameTabLabel.textColor = UIColorGrayLighten;
    self.emailTabLabel.textColor = UIColorThemeMainColor;
    //    [UIView transitionWithView: self.emailTabBgView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    [self setupEmailTab];
    //    } completion:NULL];
}

- (IBAction)usernameTabAction {
    self.emailTabLabel.textColor = UIColorGrayLighten;
    self.usernameTabLabel.textColor = UIColorThemeMainColor;
    //    [UIView transitionWithView: self.usernameTabBgView duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    [self setupUsernameTab];
    //    } completion:NULL];
}

- (void)setupEmailTab {
    self.usernameTextField.text = nil;
    self.passwordTextField.text = nil;
    self.againPasswordTextField.text = nil;
    //setup view
    self.isTabUsername = NO;
    self.emailBgView.hidden = NO;
    self.verificationView.hidden = NO;
    self.usernameBgView.hidden = YES;
    self.passwordBgView.hidden = YES;
    self.againPasswordBgView.hidden = YES;
    [self.usernameTextField resignFirstResponder];
}

- (void)setupUsernameTab {
    self.emailTextField.text = nil;
    self.codeTextField.text = nil;
    //setup view
    self.isTabUsername = YES;
    self.usernameBgView.hidden = NO;
    self.passwordBgView.hidden = NO;
    self.againPasswordBgView.hidden = NO;
    self.emailBgView.hidden = YES;
    self.verificationView.hidden = YES;
    [self.emailTextField resignFirstResponder];
}

- (IBAction)selectBtnAction {
    self.selectBtn.selected =! self.selectBtn.selected;
}

- (IBAction)registerAction {
    if (!self.isTabUsername) {
        if (self.emailTextField.text.length <= 0) {
            [QMUITipsTool showOnlyTextWithMessage:@"validation.email".icanlocalized inView:self.view];
            return;
        }
        if (![NSString checkIsEmail:self.emailTextField.text]) {
            [QMUITipsTool showOnlyTextWithMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
            return;
        }
        if (self.codeTextField.text.length <= 0) {
            [QMUITipsTool showOnlyTextWithMessage:@"Enter the verification code".icanlocalized inView:self.view];
            return;
        }
    } else {
        if (self.usernameTextField.text.length <= 0) {
            [QMUITipsTool showOnlyTextWithMessage:@"validation.username".icanlocalized inView:self.view];
            return;
        }
        if (![NSString checkUsername:self.usernameTextField.text]) {
            [QMUITipsTool showOnlyTextWithMessage:@"validation.username.pattern".icanlocalized inView:self.view];
            return;
        }
        if (self.passwordTextField.text.length <= 0) {
            [QMUITipsTool showOnlyTextWithMessage:@"Please enter password".icanlocalized inView:self.view];
            return;
        }
        if (self.passwordTextField.text.length > 32 || self.passwordTextField.text.length < 6) {
            [QMUITipsTool showOnlyTextWithMessage:@"Password must be 6-32 characters".icanlocalized inView:nil];
            return;
        }
        if (![self.againPasswordTextField.text isEqualToString:self.passwordTextField.text]) {
            [QMUITipsTool showOnlyTextWithMessage:@"Those password didn't".icanlocalized inView:self.view];
            return;
        }
    }
    if (!self.selectBtn.selected) {
        [QMUITipsTool showOnlyTextWithMessage:@"Please agree the Service agreement and Privacy agreement".icanlocalized inView:nil];
        return;
    }
    RegisterRequest *request = [RegisterRequest request];
    request.username = self.isTabUsername ? self.usernameTextField.text : self.emailTextField.text;
    request.countriesCode = self.selectCountryInfo.code;
    request.areaNum = self.mobileCode;
    if (self.isTabUsername) {
        request.accountType = @(3);
        request.password = self.passwordTextField.text;
    }else{
        request.accountType = @(1);
        request.code = self.codeTextField.text;
    }
    if (self.guiderTextField.text.length > 0) {
        request.guiderNumberId = self.guiderTextField.text;
    }
    if (self.openDataDict) {
        request.extra = self.openDataDict;
    }
    request.parameters = [request mj_JSONString];
    [QMUITipsTool showLoadingWihtMessage:@"Registering.loading".icanlocalized inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo *response) {
        [QMUITipsTool showSuccessWithMessage:@"Successful registration".icanlocalized inView:self.view];
        [UserInfoManager sharedManager].loginType = self.isTabUsername ? @"7" : @"6";
        [UserInfoManager sharedManager].username = self.usernameTextField.text;
        [UserInfoManager sharedManager].email = self.emailTextField.text;
        [UserInfoManager sharedManager].loginPassword = self.passwordTextField.text;
        [self loginSuccessWithLoginInfo:response];
    } failure:^(NSError *_Nonnull error, NetworkErrorInfo *_Nonnull info, NSInteger statusCode) {
        if ([info.code isEqualToString:@"user.already.exists"]) {
            [QMUITipsTool showErrorWihtMessage:self.isTabUsername ? @"validation.username.exists".icanlocalized : @"validation.email.exists".icanlocalized  inView:self.view];
        } else {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }
    }];
}

/**
 登录成功之后 的操作
 */
- (void)loginSuccessWithLoginInfo:(LoginInfo*)info {
    //    报告用户登录
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

- (IBAction)getCodeAction:(id)sender {
    if (![NSString checkIsEmail:self.emailTextField.text]) {
        [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
        return;
    }
    SendVerifyCodeRequest*request=[SendVerifyCodeRequest request];
    
    if ([NSString checkIsEmail:self.emailTextField.text]) {
        request.username= self.emailTextField.text;
        
    }else{
        request.username=[NSString stringWithFormat:@"%@ %@",self.mobileCode,self.emailTextField.text];
    }
    request.type=@(1);
    request.parameters=[request mj_JSONObject];
    [QMUITipsTool showLoadingWihtMessage:@"".icanlocalized inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        [self startCountdown];
        [QMUITipsTool showOnlyTextWithMessage:@"The verification code has been sent, please check it carefully".icanlocalized inView:self.view];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [self cancelCountdown];
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

//- (void)starTimer{
//    __block NSInteger time = 59; //倒计时时间
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(time <= 0){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置按钮的样式
//                [self.getCodeBtn setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
//                self.getCodeBtn. userInteractionEnabled = YES;
//                [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
//            });
//            
//        }else{
//            int seconds = time % 60;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //设置按钮显示读秒效果
//                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%.2dS", seconds] forState:UIControlStateNormal];
//                [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
//                self.getCodeBtn.userInteractionEnabled = NO;
//            });
//            time--;
//        }
//    });
//    dispatch_resume(_timer);
//}

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
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%.2dS", self.countdown] forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        self.countdown--;
    } else {
        [self.getCodeBtn setTitle:@"Send Code".icanlocalized forState:UIControlStateNormal];
        self.getCodeBtn. userInteractionEnabled = YES;
        [self.getCodeBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        [self cancelCountdown];
    }
}

- (void)lookRegistrationAgreement:(NSString*)title{
    CommonWebViewController*web = [[CommonWebViewController alloc]init];
    NSDictionary*dict = [BaseSettingManager getCurrentAgreementWithTitle:title];
    web.title     = dict[@"title"];
    web.urlString = dict[@"url"];
    web.isPresent=YES;
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:web];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        
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

- (IBAction)wechatBtnAction {
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
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

@end
