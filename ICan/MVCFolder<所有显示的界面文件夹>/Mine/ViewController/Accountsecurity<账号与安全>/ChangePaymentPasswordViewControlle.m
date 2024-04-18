//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 11/11/2019
 - File name:  FindPaymentPasswordViewController.m
 - Description:
 - Function List:
 */


#import "ChangePaymentPasswordViewControlle.h"
@interface ChangePaymentPasswordViewControlle ()<QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *itemBgView;
@property (weak, nonatomic) IBOutlet UIView *itemBgView1;
@property (weak, nonatomic) IBOutlet UIView *itemBgView2;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *line10pxBgView;

@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *acountTextFiled;
@property (weak, nonatomic) IBOutlet QMUITextField *codeTextField;
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation ChangePaymentPasswordViewControlle
- (IBAction)sureButtonAction:(id)sender {
    NSString*newPassword=self.codeTextField.text;
    NSString*againPassword=self.passwordTextField.text;
    if ([newPassword isEqualToString:againPassword]) {
        if ([newPassword remove].length==0) {
//            "ChangePaymentPasswordViewControlle.password.nonull"="支付密码不能为空";
            [QMUITipsTool showOnlyTextWithMessage:@"ChangePaymentPasswordViewControlle.password.nonull".icanlocalized inView:self.view];
            return;
        }
        SettingUserpPayPasswordRequest*request=[SettingUserpPayPasswordRequest request];
        request.oldPayPassword=self.acountTextFiled.text;
        request.payPassword=self.codeTextField.text;
        request.parameters=[request mj_JSONString];
        [QMUITipsTool showLoadingWihtMessage:nil inView:self.view isAutoHidden:NO];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            [QMUITipsTool showSuccessWithMessage:nil inView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:@"Those password didn't".icanlocalized inView:self.view];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.lineView.backgroundColor = UIColorSeparatorColor;
    self.codeTextField.secureTextEntry=self.acountTextFiled.secureTextEntry=self.passwordTextField.secureTextEntry=YES;
    self.title=@"PaymentManagementViewController.resetPassword".icanlocalized;
//    "ChangePaymentPasswordViewControlle.acountTextFiled"="请输入原密码";
    self.acountTextFiled.placeholder=@"ChangePaymentPasswordViewControlle.acountTextFiled".icanlocalized;
    self.codeTextField.placeholder=NSLocalizedString(@"Please enter the new password", 请输入新密码);;
    self.passwordTextField.placeholder=@"Enter the new password again".icanlocalized;
    self.acountTextFiled.placeholderColor=
    self.passwordTextField.placeholderColor=
    self.codeTextField.placeholderColor=UIColorThemeMainSubTitleColor;
    self.tipLabel.text=@"The password must be 6 numeric characters".icanlocalized;
    self.tipLabel.textColor=UIColorThemeMainSubTitleColor;
    self.sureButton.backgroundColor=UIColorThemeMainColor;
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.mobileLabel.text=NSLocalizedString(@"originalpaymentpassword", 原支付密码);
    
    self.codeLabel.text=NSLocalizedString(@"PaymentPassword", 支付密码);
    
    self.codeLabel.text=@"NewPayPassword".icanlocalized;
    
    self.passwordLabel.text=NSLocalizedString(@"Confirmpaymentpassword", 确认支付密码);
    
    self.mobileLabel.textColor=self.passwordLabel.textColor=self.codeLabel.textColor=UIColorThemeMainTitleColor;
    
    
    [self.sureButton setTitle:@"CommonButton.Confirm".icanlocalized forState:UIControlStateNormal];
    self.acountTextFiled.textColor = UIColorThemeMainTitleColor;
    self.codeTextField.textColor = UIColorThemeMainTitleColor;
    self.passwordTextField.textColor = UIColorThemeMainTitleColor;
    self.acountTextFiled.delegate=self;
    self.codeTextField.delegate=self;
    self.passwordTextField.delegate=self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (checkStr.length>6) {
        return NO;
    }
    return [NSString checkIsPureString:string];
}



@end
