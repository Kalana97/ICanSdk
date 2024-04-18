//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 21/12/2020
 - File name:  LoginViewController1.m
 - Description:
 - Function List:
 */

#import <AuthenticationServices/AuthenticationServices.h>
#import "LoginViewController.h"
#import "QDNavigationController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "QuickLoginViewController.h"
#import "SelectMobileCodeViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import <AlipaySDK/AFServiceCenter.h>
#import <AlipaySDK/AFServiceResponse.h>
#import "WXApi.h"
#import "BaseRequest.h"
#import "BaseResponse.h"
#import "HandleOpenUrlManager.h"
#import "WCDBManager.h"
#import "WCDBManager+ChatList.h"
#import "KeyChainTool.h"
#import "SMSCodeButton.h"
#import "QDNavigationController.h"
#import "CheckVersionTool.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
//#import "OpenInstallSDK.h"--- for reinstall purposes
#import "CommonWebViewController.h"
#import "AdvertisingView.h"
#import "AuthorizationLoginViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "C2COssWrapper.h"
#import "UIDevice+Orientation.h"
#import "RegisterViewController.h"
#import "VarifyViewController.h"

@interface LoginViewController ()<HandleOpenUrlManagerDelegate,UIScrollViewDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 账号背景框*/
@property (weak, nonatomic) IBOutlet UIView *accountBgView;
/** 区号label*/
@property (weak, nonatomic) IBOutlet UILabel *areaCodeLabel;
@property (nonatomic,strong) NSMutableArray<AllCountryInfo*> * countryItems;
/**账号输入框*/
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UIControl *areaCodeCon;
@property (weak, nonatomic) IBOutlet UIView *areaCodeJianGeView;
@property (nonatomic, strong) UIImage *showPasswordImage;
@property (nonatomic, strong) UIImage *hidePasswordImage;
/**密码输入框*/
@property (weak, nonatomic) IBOutlet UIView *passwordBgView;
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTextField;
/**显示或隐藏输入框文字*/
@property (weak, nonatomic) IBOutlet UIButton *showOrHiddenBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *quickBtn;
/**ID邮箱登录*/
@property (weak, nonatomic) IBOutlet UIButton *IDOrEmailLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIView *loginWithCredLine;
@property (weak, nonatomic) IBOutlet UIButton *loginWithCredBtn;
@property (weak, nonatomic) IBOutlet UIView *loginWithMobileLine;
@property(nonatomic, copy) NSString *mobileCode;
/**
 当前选择的登录方式
 账户类型：0、电话；1：email   2:id
 */
@property(nonatomic, assign) NSInteger accountType;
/**微信*/
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *signInWithAppleBtn;
@property (weak, nonatomic) IBOutlet UIButton *quickButton;
@end

@implementation LoginViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIDevice interfaceOrientation:UIInterfaceOrientationPortrait];
    [HandleOpenUrlManager shareManager].delegate=self;
    
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        if (BaseSettingManager.isChinaLanguages) {
            self.titleLabel.text = @"易信";
        }else{
            self.titleLabel.text = @"iCan Chat";
        }
    }
    
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        if (BaseSettingManager.isChinaLanguages) {
            self.titleLabel.text = @"我行";
        }else{
            self.titleLabel.text = @"iCan";
        }
    }
    
    self.accountLabel.text=@"Account".icanlocalized;
    self.passwordLabel.text=@"Password".icanlocalized;
    self.passwordTextField.placeholder=@"Please enter password".icanlocalized;
    self.orLabel.text=@"or".icanlocalized;
    [self.quickBtn setTitle:@"otpLogin".icanlocalized forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"LoginViewController.loginBtn".icanlocalized forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"Register".icanlocalized forState:UIControlStateNormal];
    [self.forgetBtn setTitle:@"Forgot Password".icanlocalized forState:UIControlStateNormal];
    [self.loginWithCredBtn setTitle:@"LoginwithCredentials".icanlocalized forState:UIControlStateNormal];
    [self.accountBgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.passwordBgView layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.loginBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    [self.registerBtn layerWithCornerRadius:15 borderWidth:1 borderColor:UIColor252730Color];
    [IQKeyboardManager sharedManager].enable=YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES;
    NSString*s2=@"ServiceAgreement".icanlocalized;
    NSString*s3=@"And".icanlocalized;
    NSString*s4=@"PrivacyAgreement".icanlocalized;
    NSString*string5=[NSString stringWithFormat:@"%@%@%@",s2,s3,s4];
    NSMutableAttributedString*string=[[NSMutableAttributedString alloc]initWithString:string5];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColor153Color range:NSMakeRange(0, string.length)];
    NSRange rang =[string5 rangeOfString:s2];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(rang.location, s2.length)];
    NSRange rang2 =[string5 rangeOfString:s4];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorThemeMainColor range:NSMakeRange(rang2.location, s4.length)];
    self.protocolLabel.attributedText=string;
    [self.protocolLabel yb_addAttributeTapActionWithStrings:@[s2,s4] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        [self lookRegistrationAgreement:string];
    }];
    [self.IDOrEmailLoginBtn setTitle:@"Login with Mobile".icanlocalized forState:UIControlStateSelected];
//    [self.IDOrEmailLoginBtn setTitle:@"Account ID/Mailbox".icanlocalized forState:UIControlStateNormal];
    /**
     loginType  0 微信 1支付宝  2 游客  3手机登录  4 游客登录 5ID登陆 6邮箱登陆
     accountType 账户类型：0、电话；1：email   2:id
     */
    /**
     默认为0
     */
    self.accountType = 0;
    NSString*loginType=[UserInfoManager sharedManager].loginType;
    //手机登录
    if ([loginType isEqualToString:@"3"]) {
        //        "LoginViewController.accountTextField.placeholder.loginType3"="请输入手机号码";
        self.accountTextField.placeholder=@"LoginViewController.accountTextField.placeholder.loginType3".icanlocalized;
        self.accountType=0;
        self.areaCodeCon.hidden=self.areaCodeJianGeView.hidden=NO;
        self.accountTextField.keyboardType=UIKeyboardTypeNumberPad;
        self.accountTextField.text=UserInfoManager.sharedManager.mobile;
        self.passwordTextField.text=UserInfoManager.sharedManager.loginPassword;
        self.loginWithMobileLine.hidden = NO;
        self.loginWithCredLine.hidden = YES;
        [self.IDOrEmailLoginBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        [self.loginWithCredBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.quickBtn setHidden:YES];
    }else if([loginType isEqualToString:@"6"]) {//邮箱登录
        self.accountTextField.keyboardType=UIKeyboardTypeEmailAddress;
        self.IDOrEmailLoginBtn.selected=YES;
        self.accountTextField.placeholder=@"Please enter ID/email account".icanlocalized;
        self.areaCodeCon.hidden=self.areaCodeJianGeView.hidden=YES;
        self.accountType=1;
        self.accountTextField.text=UserInfoManager.sharedManager.email;
        self.passwordTextField.text=UserInfoManager.sharedManager.loginPassword;
    }else if([loginType isEqualToString:@"5"]){
        self.accountTextField.keyboardType=UIKeyboardTypeNumberPad;
        self.IDOrEmailLoginBtn.selected=YES;
        self.accountTextField.placeholder=@"Please enter ID/email account".icanlocalized;
        self.areaCodeCon.hidden=self.areaCodeJianGeView.hidden=YES;
        self.accountType=2;
        self.accountTextField.text=UserInfoManager.sharedManager.numberId;
        self.passwordTextField.text=UserInfoManager.sharedManager.loginPassword;
    }else if([loginType isEqualToString:@"7"]){
        self.accountTextField.keyboardType=UIKeyboardTypeDefault;
        self.IDOrEmailLoginBtn.selected=YES;
        self.accountTextField.placeholder=@"Please enter ID/email account".icanlocalized;
        self.areaCodeCon.hidden=self.areaCodeJianGeView.hidden=YES;
        self.accountType=3;
        self.accountTextField.text=UserInfoManager.sharedManager.username;
        self.passwordTextField.text=UserInfoManager.sharedManager.loginPassword;
    }else{
        self.accountTextField.keyboardType=UIKeyboardTypeEmailAddress;
        self.accountType=1;
        self.accountTextField.placeholder=@"Please enter ID/email account".icanlocalized;
        self.areaCodeCon.hidden=self.areaCodeJianGeView.hidden=YES;
    }
    if (!UserInfoManager.sharedManager.hasShowAdver) {
        //获取沙河路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        //获取文件路径
        NSString * pathName = [path stringByAppendingString:@"/PublicStart.data"];
        GetPublicStartInfo*info= [NSKeyedUnarchiver unarchiveObjectWithFile:pathName];
        if (info.imgUrl) {
            if (info.endTime) {
                NSInteger currentTime=[[NSDate date]timeIntervalSince1970]*1000;
                if (info.startTime<currentTime<info.endTime) {
                    AdvertisingView*view=[[AdvertisingView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    view.startInfo=info;
                    UserInfoManager.sharedManager.hasShowAdver=YES;
                    [[UIApplication sharedApplication].delegate.window addSubview:view];
                    
                }
            }else{
                AdvertisingView*view=[[AdvertisingView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                view.startInfo=info;
                UserInfoManager.sharedManager.hasShowAdver=YES;
                [[UIApplication sharedApplication].delegate.window addSubview:view];
            }
            
        }
    }
    self.weixinButton.hidden = [WXApi isWXAppInstalled] ? NO : YES;
    [ self getAllCountryRequest];
    self.showPasswordImage = [UIImage imageNamed:@"icon_login_hidePassWord"];
    self.hidePasswordImage = [UIImage imageNamed:@"icon_login_showPassWord"];
    [self.showOrHiddenBtn setBackgroundImage:self.showPasswordImage forState:UIControlStateNormal];
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
//        [QMUITipsTool showLoadingWihtMessage:@"Apple SignIN authorized login".icanlocalized inView:self.view];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* response) {
//            [UserInfoManager sharedManager].loginType = @"1";
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
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.showOtherLoginTips) {
        if ([[self.tips componentsSeparatedByString:@","].lastObject isEqualToString:Notice_BanMessageType]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController*alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@%@",@"Your account logged in at".icanlocalized,[self.tips componentsSeparatedByString:@","].firstObject,@"Disabled".icanlocalized] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction*sureAction=[UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            });
        }else  if ([[self.tips componentsSeparatedByString:@"^$"].lastObject isEqualToString:Notice_FreezeType]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController*alert=[UIAlertController alertControllerWithTitle:[self.tips componentsSeparatedByString:@"^$"].firstObject message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction*sureAction=[UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            });
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController*alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%@%@",@"Your account logged in at".icanlocalized,self.tips,@"on another device. If you didn’t intend to log in to your account from other device, please protect your account by changing your login password ASAP".icanlocalized] message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction*sureAction=[UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sureAction];
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            });
        }
        
    }
}
- (IBAction)signInWithAppleButtonTapped:(id)sender {
//    ASAuthorizationAppleIDButton *appleSignInButton = [[ASAuthorizationAppleIDButton alloc] initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleWhite];
//    appleSignInButton.center = self.view.center;
//    [self.view addSubview:appleSignInButton];
//
//    [appleSignInButton addTarget:self action:@selector(handleAppleSignIn) forControlEvents:UIControlEventTouchUpInside];
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}
- (void)handleAppleSignIn {
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    
    ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    controller.delegate = self;
    controller.presentationContextProvider = self;
    [controller performRequests];
}

- (IBAction)endEditing:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)showOrHiddenPasswordAction {
    self.showOrHiddenBtn.selected=!self.showOrHiddenBtn.selected;
    if (self.showOrHiddenBtn.selected) {
        self.passwordTextField.secureTextEntry = NO;
        [self.showOrHiddenBtn setBackgroundImage:self.hidePasswordImage forState:UIControlStateNormal];
    }else{
        [self.showOrHiddenBtn setBackgroundImage:self.showPasswordImage forState:UIControlStateNormal];
        self.passwordTextField.secureTextEntry = YES;
    }
}
//忘记密码
- (IBAction)forgetBtnAction {
    ForgetPasswordViewController*vc=[[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)quickBtnAction {
    QuickLoginViewController*vc=[[QuickLoginViewController alloc]init];
    if ([NSString checkIsEmail:self.accountTextField.text]) {
        vc.email = self.accountTextField.text;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
//ID登录邮箱登录
- (IBAction)emailLoginAction {
    self.accountTextField.text=@"";
    self.passwordTextField.text=@"";
    [self.accountTextField resignFirstResponder];
    self.accountTextField.placeholder=@"LoginViewController.accountTextField.placeholder.loginType3".icanlocalized;
    self.accountType=0;
    self.areaCodeCon.hidden=self.areaCodeJianGeView.hidden=NO;
    self.accountTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.loginWithMobileLine.hidden = NO;
    self.loginWithCredLine.hidden = YES;
    [self.IDOrEmailLoginBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    [self.loginWithCredBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.accountTextField becomeFirstResponder];
    [self.quickBtn setHidden:YES];
}
- (IBAction)phoneLoginAction {
    self.accountTextField.text=@"";
    self.passwordTextField.text=@"";
    [self.accountTextField resignFirstResponder];
    self.accountTextField.keyboardType=UIKeyboardTypeEmailAddress;
    self.accountType=1;
    self.accountTextField.placeholder=@"Please enter ID/email account".icanlocalized;
    self.areaCodeCon.hidden=self.areaCodeJianGeView.hidden=YES;
    self.loginWithMobileLine.hidden = YES;
    self.loginWithCredLine.hidden = NO;
    [self.loginWithCredBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    [self.IDOrEmailLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.accountTextField becomeFirstResponder];
    [self.quickBtn setHidden:NO];
}
- (IBAction)quickLoginAction {
    QuickLoginViewController*vc=[[QuickLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)weixinLoginAction {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"123";
    //第三方向微信终端发送一个SendAuthReq消息结构
    
    //     [WXApi sendReq:req ];
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}
-(void)managerDidRecvWeiXinAuthResponse:(SendAuthResp *)response{
    if (response.errCode==0) {
        UserThirdPartyAuthorizationRequest*request=[UserThirdPartyAuthorizationRequest request];
        request.type=@(0);
        request.code=response.code;
        request.parameters=[request mj_JSONString];
        [QMUITipsTool showLoadingWihtMessage:@"WechatAuthorizedLogin".icanlocalized inView:self.view];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* response) {
            [UserInfoManager sharedManager].loginType = @"0";
            [self loginSuccessWithLoginInfo:response];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
}
- (IBAction)zhifubaoLoginAction:(id)sender {
    NSString *url = @"https://authweb.alipay.com/auth?auth_type=PURE_OAUTH_SDK&app_id=2019090266798748&scope=auth_user&state=XXXXXXX";  //登陆授权或别的需要跳转到支付宝完成操作的Url
    NSDictionary *params = @{kAFServiceOptionBizParams: @{
        @"url": url },
                             kAFServiceOptionCallbackScheme: @"alipay2019090266798748"};
    [AFServiceCenter callService:AFServiceAuth withParams:params andCompletion:^(AFServiceResponse *response) {
        [[HandleOpenUrlManager shareManager]managerDidRecvAlipayAuthResponse:response];
    }];
}
/**
 支付宝授权成功回调
 
 @param response AFServiceResponse
 */
-(void)managerDidRecvAlipayAuthResponse:(AFServiceResponse *)response{
    UserThirdPartyAuthorizationRequest*request=[UserThirdPartyAuthorizationRequest request];
    request.type=@(1);
    request.code=response.result[@"auth_code"];
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showLoadingWihtMessage:@"Alipay authorized login".icanlocalized inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* response) {
        [UserInfoManager sharedManager].loginType = @"1";
        [self loginSuccessWithLoginInfo:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
- (IBAction)youkeLogin {
    UserThirdPartyAuthorizationRequest*request=[UserThirdPartyAuthorizationRequest request];
    request.type=@(2);
    request.code=[KeyChainTool loadKeyChainForKey:KDeviceUDIDKEY];
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showLoadingWihtMessage:@"Login.loading..".icanlocalized inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* response) {
        [UserInfoManager sharedManager].loginType = @"4";
        [self loginSuccessWithLoginInfo:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

//登录按钮
- (IBAction)loginBtnAction {
    if ([NSString isEmptyString:self.accountTextField.text]) {
        [QMUITipsTool showErrorWihtMessage:@"Please input the correct mobile number or email".icanlocalized inView:nil];
        return;
    }
    if (![NSString checkIsPureString:self.accountTextField.text]&&![NSString checkIsEmail:self.accountTextField.text]&&![NSString checkUsername:self.accountTextField.text]) {
        [QMUITipsTool showErrorWihtMessage:@"Please input the correct mobile number or email".icanlocalized inView:nil];
        return;
    }
    if (![NSString checkIsEmail:self.accountTextField.text]){
        if ([NSString isEmptyString:self.passwordTextField.text]) {
            [QMUITipsTool showErrorWihtMessage:@"ThePasswordCannotBeEmpty".icanlocalized inView:nil];
            return;
        }
        if (self.passwordTextField.text.length>32 ||self.passwordTextField.text.length<6) {
            [QMUITipsTool showErrorWihtMessage:@"Password must be 6-32 characters".icanlocalized inView:nil];
            return;
        }
    }
    LoginRequest*request=[LoginRequest request];
    NSString*username=self.accountTextField.text;
    request.username=username;
    request.password=self.passwordTextField.text;
    //    accountType账户类型：0、电话；1：email   2:id
    if (self.accountType==0) {
        request.areaNum = self.mobileCode;
    }else{
        if ([username containsString:@"@"]) {
            self.accountType=1;
        } else if ([NSString checkNumber:self.accountTextField.text]){
            self.accountType=2;
        } else {
            self.accountType=3;
        }
    }
    request.accountType=@(self.accountType);
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showLoadingWihtMessage:@"" inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* dataResponseClass) {
        /**
         0 微信 1支付宝  2 游客  3手机登录  4 游客登录 5ID登陆 6邮箱登陆
         accountType账户类型：0、电话；1：email   2:id
         */
        if (self.accountType ==0) {
            [UserInfoManager sharedManager].mobile = self.accountTextField.text;
            [UserInfoManager sharedManager].loginType =@"3";
            [UserInfoManager sharedManager].areaNum = self.mobileCode;
        }else if (self.accountType ==1){
            [UserInfoManager sharedManager].email = self.accountTextField.text;
            [UserInfoManager sharedManager].loginType =@"6";
        }else if (self.accountType == 3) {
            [UserInfoManager sharedManager].loginType = @"7";
        } else {
            [UserInfoManager sharedManager].loginType = @"5";
        }
        
        [UserInfoManager sharedManager].loginPassword = self.passwordTextField.text;
        if(dataResponseClass.isNewDeviceLogin) {
            VarifyViewController *vc = [[VarifyViewController alloc]init];
            vc.info = dataResponseClass;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self loginSuccessWithLoginInfo:dataResponseClass];
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        if ([info.code isEqualToString:@"email.password.not.set"]) {
            [QMUITips hideAllTipsInView:self.view];
            QuickLoginViewController*vc=[[QuickLoginViewController alloc]init];
            if ([NSString checkIsEmail:self.accountTextField.text]) {
                vc.email = self.accountTextField.text;
            }
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        }
    }];
    
}
//注册
- (IBAction)registerAction:(id)sender {
    //先选择手机区号
    RegisterViewController *vc=[[RegisterViewController alloc]init];
    vc.selectCountryInfo = self.autoSelectedCountryInfo;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)logincountryCodeButtonAction {
    
    SelectMobileCodeViewController*vc=[[SelectMobileCodeViewController alloc]init];
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
    __weak __typeof(self)weakSelf = self;
    vc.selectCodeBlock = ^(NSString * _Nonnull mobileCode) {
        self.mobileCode=mobileCode;
        weakSelf.areaCodeLabel.text=[NSString stringWithFormat:@"+%@",mobileCode];
    };
    
}

-(void)lookRegistrationAgreement:(NSString*)title{
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
/**
 登录成功之后 的操作
 */
-(void)loginSuccessWithLoginInfo:(LoginInfo*)info {
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
    [UserInfoManager sharedManager].areaNum=info.areaNum;
    [UserInfoManager sharedManager].diamondMemberExpiration = info.diamondMemberExpiration;
    [UserInfoManager sharedManager].seniorMemberExpiration = info.seniorMemberExpiration;
    [UserInfoManager sharedManager].preventDeleteMessage =  info.preventDeleteMessage;
    UserInfoManager.sharedManager.countriesCode = info.countriesCode;
    UserInfoManager.sharedManager.countryCode = info.countriesCode;
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
        ReportUserLoginRequest*request=[ReportUserLoginRequest request];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
        [UserInfoManager uploadAppLanguagesRequest];
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Successful login", 成功登录) inView:nil];
        [self changeToMainView];
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
-(void)getPayHelpDisturbRequest{
    GetPayHelperDisturbRequest*request=[GetPayHelperDisturbRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetPayHelperDisturbInfo class] contentClass:[GetPayHelperDisturbInfo class] success:^(GetPayHelperDisturbInfo* response) {
        [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:response.payHelper chatId:PayHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
        [[WCDBManager sharedManager]updateChatSettingIsNoDisturbing:response.systemHelper chatId:SystemHelperMessageType chatType:UserChat authorityType:AuthorityType_friend];
        [UserInfoManager sharedManager].helperDisturb=response.payHelper;
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
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

-(void)getAllCountryRequest{
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    GetAllCountriesRequest *request = [GetAllCountriesRequest request];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[AllCountryInfo class] success:^(NSArray *response) {
            [self.countryItems addObjectsFromArray:response];
            for (AllCountryInfo *countryData in self.countryItems) {
                if (countryCode == countryData.code){
                    self.areaCodeLabel.text = [NSString stringWithFormat:@"+%@",countryData.phoneCode];
                    self.autoSelectedCountryInfo = countryData;
                    self.mobileCode = countryData.phoneCode;
                }
            }
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        }];
}

-(NSMutableArray *)countryItems{
    if (!_countryItems) {
        _countryItems=[NSMutableArray array];
    }
    return _countryItems;
}

@end
