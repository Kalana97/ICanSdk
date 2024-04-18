//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 11/11/2019
 - File name:  FindPaymentPasswordViewController.m
 - Description:
 - Function List:
 */


#import "ChangeLoginPasswordViewController.h"
#import <ReactiveObjC.h>
@interface ChangeLoginPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
//原密码
@property (weak, nonatomic) IBOutlet QMUITextField *acountTextFiled;
//新密码
@property (weak, nonatomic) IBOutlet QMUITextField *codeTextField;
//再次输入密码
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *passwordBgView;
@property (weak, nonatomic) IBOutlet UIView *nwPasswordBgView;
@property (weak, nonatomic) IBOutlet UIView *suerPasswordBgView;

@end

@implementation ChangeLoginPasswordViewController
- (IBAction)sureButtonAction:(id)sender {
    if (self.acountTextFiled.text.length==0) {
        //请输入原密码
        [QMUITipsTool showErrorWihtMessage:@"PleaseEnterTheCurrentPassword".icanlocalized inView:self.view];
        return;
    }
    
    if (self.codeTextField.text.length<6 ||self.passwordTextField.text.length<6||self.codeTextField.text.length >32 ||self.passwordTextField.text.length>32) {
        [QMUITipsTool showErrorWihtMessage:@"Password must be 6-32 characters".icanlocalized inView:self.view];
        return;
    }
    
    if (![self.codeTextField.text isEqualToString:self.passwordTextField.text]) {
        [QMUITipsTool showErrorWihtMessage:@"The two entered passwords are inconsistent".icanlocalized inView:self.view];
        return;
    }
    
    ChangeLoginPasswordRequest*request=[ChangeLoginPasswordRequest request];
    request.oldPassword=self.acountTextFiled.text;
    request.password=self.codeTextField.text;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Modified success", 成功修改) inView:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.sureButton.backgroundColor=UIColorThemeMainColor;
    self.sureButton.enabled=NO;
    RAC(self.sureButton,enabled)=[RACSignal combineLatest:@[
        self.acountTextFiled.rac_textSignal,
        self.codeTextField.rac_textSignal,
        self.passwordTextField.rac_textSignal ]reduce:^(NSString *oringPassword, NSString *password,NSString *againPassword ) {
        return @((oringPassword.length>0)&&password.length>=6&&againPassword.length>=6&&[password isEqualToString:againPassword]);
    }];
    [RACObserve(self, self.sureButton.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.sureButton.backgroundColor=UIColorThemeMainColor;
        }else{
            self.sureButton.backgroundColor=UIColorMakeWithRGBA(29, 129, 245, 0.5);
        }
    }];
    self.title=NSLocalizedString(@"Change password", 修改密码);
    self.acountTextFiled.placeholder=@"PleaseEnterTheCurrentPassword".icanlocalized;
    self.codeTextField.placeholder=NSLocalizedString(@"Please enter the new password", 请输入新密码);
    self.passwordTextField.placeholder=NSLocalizedString(@"Enter new password again", 再次输入新密码);
    self.acountTextFiled.placeholderColor=
    self.codeTextField.placeholderColor=
    self.passwordTextField.placeholderColor= UIColorThemeMainSubTitleColor;
   
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    //原密码
    self.mobileLabel.text=@"Currentpassword".icanlocalized;
    self.lineView.backgroundColor=UIColorSeparatorColor;
    self.codeLabel.text=@"NewPassword".icanlocalized;
    self.passwordLabel.text=NSLocalizedString(@"Confirm Password", 确认密码);
    self.mobileLabel.textColor=
    self.passwordLabel.textColor=
    self.codeLabel.textColor=UIColorThemeMainTitleColor;
    
    [self.sureButton setTitle:@"CommonButton.Confirm".icanlocalized forState:UIControlStateNormal];
    self.acountTextFiled.textColor = UIColorThemeMainTitleColor;
    self.codeTextField.textColor = UIColorThemeMainTitleColor;
    self.passwordTextField.textColor = UIColorThemeMainTitleColor;
}




@end
