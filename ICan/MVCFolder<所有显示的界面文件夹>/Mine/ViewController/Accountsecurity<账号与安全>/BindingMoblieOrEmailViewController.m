//
//  BindingMoblieOrEmailViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/12/3.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BindingMoblieOrEmailViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "SettingPasswordViewController.h"
#import "SMSCodeButton.h"
#import "SelectMobileCodeViewController.h"
#import "QDNavigationController.h"
@interface BindingMoblieOrEmailViewController ()

@property (weak, nonatomic) IBOutlet UIView *mobilBgView;
@property (weak, nonatomic) IBOutlet UILabel *mobilTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UIControl *mobilCodeBgCon;
@property (weak, nonatomic) IBOutlet UILabel *mobilCodeLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *mobilTextFeild;


@property (weak, nonatomic) IBOutlet QMUITextField *codeTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet SMSCodeButton *codeBtn;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property(nonatomic, copy) NSString *mobileCode;
@property(nonatomic, assign) BOOL isSelfEmailVerified;
@property(nonatomic, copy) NSString *verificationKey;
@end

@implementation BindingMoblieOrEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.mobilBgView.backgroundColor = UIColorViewBgColor;
    self.codeBgView.backgroundColor = UIColorViewBgColor;

    self.lineView.backgroundColor = UIColorSeparatorColor;
    
    self.mobilTitleLabel.textColor = UIColorThemeMainSubTitleColor;
    self.mobilTextFeild.textColor = UIColorThemeMainSubTitleColor;
    self.tipsLabel.textColor = UIColorThemeMainSubTitleColor;
    if (self.bindingType==BindingType_Moblie) {
        self.title=NSLocalizedString(@"BindPhone",绑定手机);
        self.tipsLabel.text=NSLocalizedString(@"The verification code will be sent to your mobile phone. Please pay attention to the SMS.", 验证码会发至你的手机请留意短信);
        self.mobilTitleLabel.text =[@"mine.profile.title.more.mobile" icanlocalized:@"手机号"];
        self.mobilTextFeild.placeholder=@"Please enter the phone number".icanlocalized;
        [self.sureButton setTitle:NSLocalizedString(@"Confirmbinding", 确认绑定) forState:UIControlStateNormal];
    }else{
        self.lineView.hidden=self.mobilCodeBgCon.hidden=YES;
        self.mobilTextFeild.keyboardType = UIKeyboardTypeDefault;
        self.mobilTitleLabel.text = [@"mine.profile.title.more.email" icanlocalized:@"邮箱"];
        if(UserInfoManager.sharedManager.isEmailBinded){
            self.title = @"Change email".icanlocalized;
            self.mobilTextFeild.text = UserInfoManager.sharedManager.email;
            [self.sureButton setTitle:NSLocalizedString(@"Verify", 确认绑定) forState:UIControlStateNormal];
            self.mobilTextFeild.enabled = NO;
        }else{
            self.title = @"Binding Email".icanlocalized;
            self.mobilTextFeild.placeholder = NSLocalizedString(@"Pleaseenteremail", 请输入邮箱);
            [self.sureButton setTitle:NSLocalizedString(@"Confirmbinding", 确认绑定) forState:UIControlStateNormal];
        }
        self.tipsLabel.text=NSLocalizedString(@"The verification code will be sent to your email. Please go to the email to check.", 验证码会发至你的邮箱请前往邮箱查看);
    }
    self.mobileCode = UserInfoManager.sharedManager.areaNum?:@"94";
    self.mobilCodeLabel.text=[NSString stringWithFormat:@"+%@",self.mobileCode];
    self.mobilCodeLabel.textColor = UIColorThemeMainTitleColor;
    self.codeLabel.text=NSLocalizedString(@"code",验证码);
    self.codeLabel.textColor=UIColorThemeMainSubTitleColor;
    self.codeTextFeild.placeholder=@"Enter the verification code".icanlocalized;
    [self.codeBtn layerWithCornerRadius:15 borderWidth:0.7 borderColor:UIColorThemeMainColor];
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self judgeUserHaveSetLoginPassword];
}
- (IBAction)selectMobileCode {
    SelectMobileCodeViewController*vc=[[SelectMobileCodeViewController alloc]init];
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [[AppDelegate shared] presentViewController:nav animated:YES completion:^{
        
    }];
    vc.selectCodeBlock = ^(NSString * _Nonnull mobileCode) {
        self.mobileCode=mobileCode;
        self.mobilCodeLabel.text=[NSString stringWithFormat:@"+%@",mobileCode];
    };
}

- (IBAction)sendCodeAction {
    NSString*mobilText=self.mobilTextFeild.text;
    if (self.bindingType==BindingType_Moblie) {
        if ([NSString checkIsPureString:mobilText]) {
            [self.codeBtn starTimer];
            [self sendCodeRequest:mobilText];
        }else{
            [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Please enter the correct phone number", 请输入正确的手机号) inView:nil];
        }
    }else{
        if ([NSString checkIsEmail:mobilText]) {
            [self.codeBtn starTimer];
            [self sendCodeRequest:mobilText];
        }else{
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:nil];
        }
    }
}
- (IBAction)sureAction {
    if (self.bindingType==BindingType_Moblie) {
        [self fetchBindMoblieRequestWithAcount:self.mobilTextFeild.text code:self.codeTextFeild.text mobileCode:self.mobileCode];
    }else{
        if(UserInfoManager.sharedManager.isEmailBinded){
            if(!self.isSelfEmailVerified){
                [self verifyCurrentEmail:self.codeTextFeild.text];
            }else{
                [self fetchBindEmailRequestWithAcount:self.mobilTextFeild.text code:self.codeTextFeild.text];
            }
        }else{
            [self fetchBindEmailRequestWithAcount:self.mobilTextFeild.text code:self.codeTextFeild.text];
        }
    }
}

-(void)verifyCurrentEmail:(NSString *)code{
    VerifySelfEmail *request = [VerifySelfEmail request];
    request.code = code;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[SelfEmailVerificationKey class] contentClass:[SelfEmailVerificationKey class] success:^(SelfEmailVerificationKey *response) {
        self.isSelfEmailVerified = YES;
        self.verificationKey = response.key;
        self.title = @"Bind new email".icanlocalized;
        self.mobilTextFeild.placeholder = NSLocalizedString(@"Pleaseenteremail", 请输入邮箱);
        self.mobilTextFeild.text = @"";
        self.codeTextFeild.text = @"";
        [self.sureButton setTitle:NSLocalizedString(@"Confirmbinding", 确认绑定) forState:UIControlStateNormal];
        self.mobilTextFeild.enabled = YES;
        [self.codeBtn stopTimer];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)sendCodeRequest:(NSString*)account{
    if (self.bindingType==BindingType_Moblie) {
        if (![NSString checkIsPureString:account]) {
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct mobile phone number".icanlocalized inView:self.view];
            return;
        }
    }else{
        if (![NSString checkIsEmail:account]) {
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
            return;
        }
    }
    SendVerifyCodeRequest*request=[SendVerifyCodeRequest request];
    if (self.bindingType==BindingType_Moblie) {
        request.username=[NSString stringWithFormat:@"%@ %@",self.mobileCode,account];
    }else{
        request.username=account;
    }
    request.type=@(2);
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"Verification code has been sent, please check".icanlocalized inView:nil];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

-(void)fetchBindEmailRequestWithAcount:(NSString *)acount code:(NSString *)code{
    BindingUserEmailRequest * request = [BindingUserEmailRequest request];
    request.email = acount;
    request.code = code;
    request.prevVerifyKey = self.verificationKey;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"BindingSuccess",绑定成功) inView:self.view];
        [UserInfoManager sharedManager].email = acount;
        [[NSNotificationCenter defaultCenter]postNotificationName:kBindingSucessNotification object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}


-(void)fetchBindMoblieRequestWithAcount:(NSString *)acount code:(NSString *)code mobileCode:(NSString*)mobileCode{
    BindingUserMobileRequest * request = [BindingUserMobileRequest request];
    request.mobile = acount;
    request.code = code;
    request.areaNum=mobileCode;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"BindingSuccess",绑定成功) inView:self.view];
        [UserInfoManager sharedManager].mobile = acount;
        [[NSNotificationCenter defaultCenter]postNotificationName:kBindingSucessNotification object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

-(void)judgeUserHaveSetLoginPassword{
    if (![UserInfoManager sharedManager].isSetPassword) {
        [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No password has been set for the current account. Do you want to set the password?", 当前账号未设置过密码是否去设置密码) message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                [self.navigationController pushViewController:[SettingPasswordViewController new] animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
@end
