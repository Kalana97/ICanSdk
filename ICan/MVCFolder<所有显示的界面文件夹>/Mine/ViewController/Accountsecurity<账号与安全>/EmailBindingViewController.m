//
//  EmailBindingViewController.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-09-22.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "EmailBindingViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "SettingPasswordViewController.h"
#import "SMSCodeButton.h"
#import "SelectMobileCodeViewController.h"
#import "QDNavigationController.h"
#import "SettingPaymentPasswordViewController.h"

@interface EmailBindingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailTitleLbl;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *getCodeTitleLbl;
@property (weak, nonatomic) IBOutlet SMSCodeButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *subTipLbl;
@end

@implementation EmailBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"Binding Email".icanlocalized;
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithTitle:@"skip".icanlocalized style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    [customButton setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorThemeMainColor} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = customButton;
    self.tipsLabel.text = @"Enter your email and get a verification code by sending through the system for bind the email.".icanlocalized;
    self.subTipLbl.text = NSLocalizedString(@"The verification code will be sent to your email. Please go to the email to check.", 验证码会发至你的邮箱请前往邮箱查看);
    self.emailTextField.keyboardType = UIKeyboardTypeDefault;
    self.emailTextField.layer.cornerRadius = 15;
    self.codeTextFeild.layer.cornerRadius = 15;
    self.emailTitleLbl.text = [@"Email address" icanlocalized:@"邮箱"];
    self.emailTextField.placeholder = NSLocalizedString(@"Pleaseenteremail", 请输入邮箱);
    self.codeTextFeild.placeholder = @"Enter the verification code".icanlocalized;
    [self.codeBtn layerWithCornerRadius:25/2 borderWidth:0 borderColor:UIColorThemeMainColor];
    self.codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.sureButton setTitle:@"C2CContinue".icanlocalized forState:UIControlStateNormal];
    self.getCodeTitleLbl.text = @"Verification code".icanlocalized;
    [self.sureButton layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
}

-(void)fetchBindEmailRequestWithAcount:(NSString *)acount code:(NSString *)code{
    BindingUserEmailRequest * request = [BindingUserEmailRequest request];
    request.email = acount;
    request.code = code;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"BindingSuccess",绑定成功) inView:self.view];
        [UserInfoManager sharedManager].email = acount;
        [[NSNotificationCenter defaultCenter]postNotificationName:kBindingSucessNotification object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
        [UserInfoManager sharedManager].isEmailBinded = YES;
        [UserInfoManager sharedManager].mustBindEmailPayPswd = NO;
        [self dismissViewControllerAnimated:YES completion:^{
            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
            vc.isFromBinding = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];

    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(void)rightButtonAction{
    SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
    vc.isFromBinding = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)sureAction:(id)sender {
    [self fetchBindEmailRequestWithAcount:self.emailTextField.text code:self.codeTextFeild.text];
}

- (IBAction)getCode:(id)sender {
    NSString *emailTxt=self.emailTextField.text;
    if ([NSString checkIsEmail:emailTxt]) {
        [self.codeBtn starTimer];
        [self sendCodeRequest:emailTxt];
    }else{
        [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:nil];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)sendCodeRequest:(NSString*)account{
    if (![NSString checkIsEmail:account]) {
        [QMUITipsTool showErrorWihtMessage:@"Please enter the correct email format".icanlocalized inView:self.view];
        return;
    }
    SendVerifyCodeRequest*request=[SendVerifyCodeRequest request];
    request.username=account;
    request.type=@(2);
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"Verification code has been sent, please check".icanlocalized inView:nil];

    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}

@end
