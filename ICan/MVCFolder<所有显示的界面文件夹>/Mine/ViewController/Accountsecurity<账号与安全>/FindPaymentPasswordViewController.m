//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 11/11/2019
 - File name:  FindPaymentPasswordViewController.m
 - Description:
 - Function List:
 */


#import "FindPaymentPasswordViewController.h"
#import "SMSCodeButton.h"
#import "QDNavigationController.h"
#import "SelectMobileCodeViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
@interface FindPaymentPasswordViewController ()<QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *itemBgView;
@property (weak, nonatomic) IBOutlet UIView *itemBgView1;
@property (weak, nonatomic) IBOutlet UIView *itemBgView2;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *acountTextFiled;
@property (weak, nonatomic) IBOutlet QMUITextField *codeTextField;
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet SMSCodeButton *codeButton;
@property (weak, nonatomic) IBOutlet UILabel *emailRegisterLabel;
//切换电话区号
@property (weak, nonatomic) IBOutlet UIButton *counttycodeButton;
@property(nonatomic, assign) BOOL isMobileRegister;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countryButtonWidth;


@end

@implementation FindPaymentPasswordViewController



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"PaymentManagementViewController.forgotPassword".icanlocalized;
    self.view.backgroundColor = UIColorBg243Color;
    self.acountTextFiled.enabled=NO;
    self.codeTextField.placeholder=NSLocalizedString(@"EnterTheVerificationCode", @"请输入验证码");
    [self.codeButton layerWithCornerRadius:15 borderWidth:0.7 borderColor:UIColorThemeMainColor];
//    "PaymentManagementViewController.passwordTextField"="输入新支付密码";
    self.passwordTextField.placeholder=@"PaymentManagementViewController.passwordTextField".icanlocalized;
    self.acountTextFiled.placeholderColor=
    self.passwordTextField.placeholderColor=
    self.codeTextField.placeholderColor=UIColorThemeMainSubTitleColor;
    self.sureButton.backgroundColor=UIColorThemeMainColor;
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.mobileLabel.textColor=self.passwordLabel.textColor=self.codeLabel.textColor=UIColorThemeMainTitleColor;
    self.codeLabel.text=NSLocalizedString(@"code", 验证码);
    self.lineView.backgroundColor=UIColorSeparatorColor;
    
    if (UserInfoManager.sharedManager.email.length>0&&UserInfoManager.sharedManager.mobile.length>0) {
        self.emailRegisterLabel.text=NSLocalizedString(@"Useemailtoretrieve", 使用邮箱找回);
        self.acountTextFiled.placeholder=@"Please enter the phone number".icanlocalized;
        self.isMobileRegister=YES;
        self.acountTextFiled.text=UserInfoManager.sharedManager.mobile;
        if (UserInfoManager.sharedManager.areaNum) {
            self.countryButtonWidth.constant=60;
            [self.counttycodeButton setTitle:[NSString stringWithFormat:@"+%@",UserInfoManager.sharedManager.areaNum] forState:UIControlStateNormal];
        }else{
            self.countryButtonWidth.constant=0;
        }
       
    }else if (UserInfoManager.sharedManager.email.length>0){
        self.emailRegisterLabel.hidden=YES;
        self.countryButtonWidth.constant=0;
        self.acountTextFiled.placeholder=NSLocalizedString(@"Pleaseenteremail", 请输入邮箱);
        self.isMobileRegister=NO;
        self.acountTextFiled.text=UserInfoManager.sharedManager.email;
    }else if (UserInfoManager.sharedManager.mobile.length>0){
        self.acountTextFiled.placeholder=@"Please enter the phone number".icanlocalized;
        self.countryButtonWidth.constant=60;
        self.emailRegisterLabel.hidden=YES;
        self.isMobileRegister=YES;
        self.acountTextFiled.text=UserInfoManager.sharedManager.mobile;
        if (UserInfoManager.sharedManager.areaNum) {
            self.countryButtonWidth.constant=60;
            [self.counttycodeButton setTitle:[NSString stringWithFormat:@"+%@",UserInfoManager.sharedManager.areaNum] forState:UIControlStateNormal];
        }else{
            self.countryButtonWidth.constant=0;
        }
    }
    
    self.passwordLabel.text=NSLocalizedString(@"NewPassword", 新密码);
    self.acountTextFiled.textColor = UIColorThemeMainTitleColor;
    self.codeTextField.textColor = UIColorThemeMainTitleColor;
    self.passwordTextField.textColor = UIColorThemeMainTitleColor;
    [self.sureButton setTitle:@"CommonButton.Confirm".icanlocalized forState:UIControlStateNormal];
    [self.counttycodeButton setTitleColor:UIColorThemeMainTitleColor forState:UIControlStateNormal];
    NSString*mobileCode;
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *carrier_country_code = carrier.isoCountryCode;
    //国家简写
    if (carrier_country_code == nil) {
        carrier_country_code = @"";
        
    }
    NSArray*array=[[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Mobile" ofType:@"plist"]];
    for (NSDictionary*dict in array) {
        NSString*code=[dict objectForKey:@"countrycode"];
        if ([code isEqualToString:carrier_country_code]) {
            mobileCode=[dict objectForKey:@"mobilecode"];
            break;
        }
    }
    
    self.counttycodeButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.emailRegisterLabel.textColor=UIColorThemeMainColor;
    UITapGestureRecognizer*tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(emailRegisterLabelAction)];
    [self.emailRegisterLabel addGestureRecognizer:tap2];
    self.emailRegisterLabel.userInteractionEnabled=YES;
    self.passwordTextField.delegate=self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length == 0) {
        return YES;
    }
    //第一个参数，被替换字符串的range，第二个参数，即将键入或者粘贴的string，返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (checkStr.length>6) {
        return NO;
    }
    return [NSString checkIsPureString:string];
}


-(void)emailRegisterLabelAction{
    self.isMobileRegister=!self.isMobileRegister;
    if (self.isMobileRegister) {
        self.emailRegisterLabel.text=NSLocalizedString(@"Useemailtoretrieve", 使用邮箱找回);
        self.acountTextFiled.placeholder=@"Please enter the phone number".icanlocalized;
        self.acountTextFiled.text=UserInfoManager.sharedManager.mobile;
    }else{
        self.emailRegisterLabel.text=NSLocalizedString(@"Usemobilephonetoretrieve", 使用手机找回);
        self.acountTextFiled.placeholder=NSLocalizedString(@"Pleaseenteremail", 请输入邮箱);
        self.acountTextFiled.text=UserInfoManager.sharedManager.email;
    }
    
    if (self.isMobileRegister) {
        self.countryButtonWidth.constant=60;
    }else{
        self.countryButtonWidth.constant=0;
    }
}
- (IBAction)countryCodeButtonAction:(id)sender {
    SelectMobileCodeViewController*vc=[[SelectMobileCodeViewController alloc]init];
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    vc.selectCodeBlock = ^(NSString * _Nonnull mobileCode) {
        [self.counttycodeButton setTitle:[NSString stringWithFormat:@"+%@",mobileCode] forState:UIControlStateNormal];
    };
    
}

- (IBAction)sureButtonAction:(id)sender {
    FindUserpPayPasswordRequest*request=[FindUserpPayPasswordRequest request];
    request.username=self.acountTextFiled.text;
    request.payPassword=self.passwordTextField.text;
    request.code=self.codeTextField.text;
    request.parameters=[request mj_JSONString];
    
    [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:nil inView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
- (IBAction)codeButtonAction:(id)sender {
    [self checkCanSendCode];
}
-(void)checkCanSendCode{
    if (self.isMobileRegister) {
        if ([NSString checkIsPureString:self.acountTextFiled.text]) {
            [self.codeButton starTimer];
            [self sendSMSCode];
        }else{
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct mobile phone number".icanlocalized inView:self.view];
        }
    }else{
        if ([NSString checkIsEmail:self.acountTextFiled.text]) {
            [self.codeButton starTimer];
            [self sendSMSCode];
        }else{
            [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
        }
    }
    
}
-(void)sendSMSCode{
    SendVerifyCodeRequest*request=[SendVerifyCodeRequest request];
    request.type=@(0);
    if ([NSString checkIsEmail:self.acountTextFiled.text]) {
        request.username= self.acountTextFiled.text;
    }else{
        request.username=[NSString stringWithFormat:@"%@ %@",self.counttycodeButton.titleLabel.text,self.acountTextFiled.text];
//        request.username=[NSString stringWithFormat:@"%@ %@",@"94",@"766731670"];
    }//94 766731670
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id  _Nonnull response) {
        [QMUITipsTool showOnlyTextWithMessage:@"The verification code has been sent, please check it carefully".icanlocalized inView:self.view];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

@end
