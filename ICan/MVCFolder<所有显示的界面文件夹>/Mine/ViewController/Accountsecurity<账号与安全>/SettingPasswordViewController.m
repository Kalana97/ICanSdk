//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 4/12/2019
 - File name:  SettingPasswordViewController.m
 - Description:
 - Function List:
 */


#import "SettingPasswordViewController.h"
@interface SettingPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *passwordLab;
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UILabel *againPasswordLab;
@property (weak, nonatomic) IBOutlet QMUITextField *againPasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation SettingPasswordViewController
- (IBAction)sureBtnAction:(id)sender {
    [self settingPasswordRequest:self.passwordTextField.text againPassword:self.againPasswordTextField.text];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Setloginpassword", 设置登录密码);
    self.view.backgroundColor = UIColorBg243Color;
    
    self.passwordLab.text = NSLocalizedString(@"LoginPasswrod", 密码);
    self.passwordTextField.placeholder = NSLocalizedString(@"EnterPassword", 请输入密码);
    self.againPasswordLab.text = NSLocalizedString(@"Confirm Password", 确认密码);
    self.againPasswordTextField.placeholder = NSLocalizedString(@"RegisterSecondPassword", 请再次输入密码);
    self.tipsLabel.text = @"Password must be 6-32 characters".icanlocalized;
    
    [self.sureBtn setTitle:NSLocalizedString(@"Confirmbinding", 确认绑定) forState:UIControlStateNormal];
    [self.sureBtn layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    
}
-(void)settingPasswordRequest:(NSString*)password againPassword:(NSString*)againPassword{
    if (password.length>32 ||password.length<6) {
        [QMUITipsTool showErrorWihtMessage:@"Password must be 6-32 characters".icanlocalized inView:nil];
        return;
    }
    if ([password isEqualToString:againPassword]) {
        ChangeLoginPasswordRequest*request=[ChangeLoginPasswordRequest request];
        request.password=againPassword;
        request.parameters=[request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
            [UserInfoManager sharedManager].isSetPassword=YES;
            [UserInfoManager sharedManager].isNew=YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:ksetPasswordSuccessNotification object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
    
}
@end
