//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 11/11/2019
 - File name:  AccountSecurityViewController.m
 - Description:
 - Function List:
 */


#import "AccountSecurityViewController.h"
#import "PaymentManagementViewController.h"
#import "SettingPaymentPasswordViewController.h"
#import "ChangeLoginPasswordViewController.h"
#import "BindingMoblieOrEmailViewController.h"
#import "HandleOpenUrlManager.h"
#import <AlipaySDK/AFServiceCenter.h>
#import <AlipaySDK/AFServiceResponse.h>
#import "WXApi.h"
#import "CertificationViewController.h"
#import "EmailBindingViewController.h"
@interface AccountSecurityViewController ()<HandleOpenUrlManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *IDDetailLab;
//实名认证
@property (weak, nonatomic) IBOutlet UILabel *crtificationLab;
@property (weak, nonatomic) IBOutlet UILabel *crtificationDetailLab;

@property (weak, nonatomic) IBOutlet UIControl *realNameBgCon;
@property (weak, nonatomic) IBOutlet UILabel *realNameLab;
@property (weak, nonatomic) IBOutlet UILabel *realNameDetailLab;
@property (weak, nonatomic) IBOutlet UIImageView *realNameArrowImgViwe;

@property (weak, nonatomic) IBOutlet UIControl *mobileBgCon;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet UILabel *mobileLDetailLab;

@property (weak, nonatomic) IBOutlet UIControl *emailBgCon;
@property (weak, nonatomic) IBOutlet UILabel *emailLab;
@property (weak, nonatomic) IBOutlet UILabel *emailLDetailLab;


@property (weak, nonatomic) IBOutlet UIControl *wxBgCon;
@property (weak, nonatomic) IBOutlet UILabel *wxLab;
@property (weak, nonatomic) IBOutlet UILabel *wxDetailLab;
@property (weak, nonatomic) IBOutlet UIImageView *wxArrowImgViwe;


@property (weak, nonatomic) IBOutlet UIControl *passwordBgCon;
@property (weak, nonatomic) IBOutlet UILabel *passwordLab;



@property (weak, nonatomic) IBOutlet UIControl *passwordManagerBgCon;
@property (weak, nonatomic) IBOutlet UILabel *passwordManagerLab;


@property (weak, nonatomic) IBOutlet UILabel *tipsLab;

@property (weak, nonatomic) IBOutlet UIControl *deleteAccountBgCon;
@property (weak, nonatomic) IBOutlet UILabel *deleteAccountLab;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation AccountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.alwaysBounceVertical = YES;
    self.view.backgroundColor = UIColorBg243Color;
    [HandleOpenUrlManager shareManager].delegate=self;
    self.title=NSLocalizedString(@"mine.setting.cell.title.accountSecurity", 账号与安全);
    [self setData];
    self.crtificationLab.text = @"CertificationViewControllerTitle".icanlocalized;
    self.realNameLab.text = NSLocalizedString(@"mine.profile.title.more.realName",真实姓名);
    self.mobileLab.text = [@"mine.profile.title.more.mobile" icanlocalized:@"手机号"];
    self.emailLab.text = [@"mine.profile.title.more.email" icanlocalized:@"邮箱"];
    self.wxLab.text = NSLocalizedString(@"mine.profile.title.more.weChat",微信);
    self.passwordLab.text = NSLocalizedString(@"Password",密码);
    self.passwordManagerLab.text = NSLocalizedString(@"Payment Management",支付管理);
    self.deleteAccountLab.text=@"AccountSecurityViewController.deleteAccount".icanlocalized;
    self.tipsLab.text=@"AccountSecurityViewController.accountsecurity".icanlocalized;
    self.IDDetailLab.text = [UserInfoManager sharedManager].numberId;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setData) name:KUpdateUserMessageNotification object:nil];
    
}
-(void)setData{
    NSString * name;
    if (UserInfoManager.sharedManager.lastName&&UserInfoManager.sharedManager.firstName) {
         name = UserInfoManager.sharedManager.realname;
        if (name) {
            for (int i =0; i<name.length-1; i++) {
                name=[name stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
            self.realNameArrowImgViwe.hidden = YES;
        }
    }else{
        name=[@"tip.notSet" icanlocalized:@"未设置"];
        self.realNameArrowImgViwe.hidden = NO;
    }
    
    self.realNameDetailLab.text = name;
    if ([UserInfoManager sharedManager].mobile) {
        if (UserInfoManager.sharedManager.areaNum.length>0) {
            self.mobileLDetailLab.text = [NSString stringWithFormat:@"+%@ %@",UserInfoManager.sharedManager.areaNum,UserInfoManager.sharedManager.mobile];
        }else{
            self.mobileLDetailLab.text = UserInfoManager.sharedManager.mobile;
        }
    }else{
        self.mobileLDetailLab.text = [@"tip.notSet" icanlocalized:@"未设置"];
    }
    self.emailLDetailLab.text =UserInfoManager.sharedManager.email?:[@"tip.notSet" icanlocalized:@"未设置"];
    if ([[UserInfoManager sharedManager].openIdType isEqualToString:@"WeChat"]) {
        self.wxDetailLab.text = @"Bound".icanlocalized;
        
        self.wxArrowImgViwe.hidden = YES;
    }else{
        self.wxDetailLab.text = [@"tip.Unbound" icanlocalized:@"未绑定"];
    }
    //游客登录并且没有绑定手机号码邮箱
    if ([[UserInfoManager sharedManager].loginType isEqualToString:@"4"]&& ![UserInfoManager sharedManager].email && ![UserInfoManager sharedManager].mobile){
        self.passwordBgCon.hidden = YES;
    }else{
        self.passwordBgCon.hidden = NO;
    }
    /** 认证状态,可用值:NotAuth,Authing,Authed */
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        self.crtificationDetailLab.text = @"Authed".icanlocalized;
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authing"]) {
        self.crtificationDetailLab.text = @"Authing".icanlocalized;
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"NotAuth"]) {
        self.crtificationDetailLab.text = @"NotAuth".icanlocalized;
    }
}
- (IBAction)crtificationAction {
    /** 认证状态,可用值:NotAuth,Authing,Authed */
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authing"]) {
        [QMUITipsTool showOnlyTextWithMessage:@"RealnameAuthingTip".icanlocalized inView:self.view];
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"NotAuth"]) {
        CertificationViewController *vc =[[CertificationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
       
    }
    
   
}

- (IBAction)realNameAction {
    if (![UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        CertificationViewController *vc =[[CertificationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)mobileAction {
    BindingMoblieOrEmailViewController * vc = [BindingMoblieOrEmailViewController new];
    vc.bindingType=BindingType_Moblie;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)emailAction {
    BindingMoblieOrEmailViewController * vc = [BindingMoblieOrEmailViewController new];
    vc.bindingType=BindingType_Email;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)wxAction {
    if (![[UserInfoManager sharedManager].openIdType isEqualToString:@"WeChat"]) {
        [self sendweixinAuthRequest];
    }
}
- (IBAction)aliAction {
    if (![[UserInfoManager sharedManager].openIdType isEqualToString:@"AliPay"]){
        [self sendaAipayAuthRequest];
    }
}
- (IBAction)passwordAction {
    [self.navigationController pushViewController:[ChangeLoginPasswordViewController new] animated:YES];
}
- (IBAction)passwordManagerAction {
    [self gototradePswdSetVc];
}
- (IBAction)deleteAccoutnAction {
    [self alertUserdestroy];
}
- (void)alertUserdestroy {
    
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle: @"AccountSecurityViewController.sureDeleteAccountTips".icanlocalized message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*action1=[UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction*action2=[UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"AccountSecurityViewController.sureDeleteAccount".icanlocalized message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*action1=[UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction*action2=[UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self userdestroyRequest];
        }];
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
    }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
}


-(void)gototradePswdSetVc{
    if ([UserInfoManager sharedManager].openPay) {
        if ([UserInfoManager sharedManager].tradePswdSet) {
            PaymentManagementViewController*vc=[[PaymentManagementViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else{
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
    }
    
}
/**
 ldz
 支付宝授权登录
 简单的授权登录文档：https://docs.open.alipay.com/218/sxc60m/
 */
-(void)sendaAipayAuthRequest{
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
    BindThirdPartyRequest*request=[BindThirdPartyRequest request];
    request.type=@(1);
    request.code=response.result[@"auth_code"];;
    request.parameters=[request mj_JSONString];
    [QMUITipsTool showLoadingWihtMessage:@"" inView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* response) {
        [UserInfoManager sharedManager].openIdType = @"AliPay";
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
/**
 微信授权
 */
-(void)sendweixinAuthRequest{
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
        BindThirdPartyRequest*request=[BindThirdPartyRequest request];
        request.type=@(0);
        request.code=response.code;
        request.parameters=[request mj_JSONString];
        [QMUITipsTool showLoadingWihtMessage:@"WechatAuthorizedLogin".icanlocalized inView:self.view];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[LoginInfo class] contentClass:[LoginInfo class] success:^(LoginInfo* response) {
            [UserInfoManager sharedManager].openIdType = @"WeChat";
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
}
//用户注销账号
-(void)userdestroyRequest{
    UserDestroyRequest*request=[UserDestroyRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [UserInfoManager sharedManager].loginStatus=NO;
        [UserInfoManager sharedManager].token=nil;
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

@end
