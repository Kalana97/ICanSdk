//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/11/2019
- File name:  FindPaymentPasswordViewController.m
- Description:
- Function List:
*/
        

#import "SettingPaymentPasswordViewController.h"
@interface SettingPaymentPasswordViewController ()<QMUITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *codeTextField;
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@end

@implementation SettingPaymentPasswordViewController
- (IBAction)sureButtonAction:(id)sender {
    if (self.codeTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        [QMUITipsTool showErrorWihtMessage:@"PleaseEnterTheCurrentPassword".icanlocalized inView:self.view];
        return;
    }
    if (self.codeTextField.text.length < 6 || self.passwordTextField.text.length < 6 || self.codeTextField.text.length > 32 || self.passwordTextField.text.length > 32) {
        [QMUITipsTool showErrorWihtMessage:@"Password must be 6-32 characters".icanlocalized inView:self.view];
        return;
    }
    if (![self.codeTextField.text isEqualToString:self.passwordTextField.text]) {
        [QMUITipsTool showErrorWihtMessage:@"The two entered passwords are inconsistent".icanlocalized inView:self.view];
        return;
    }
    SettingUserpPayPasswordRequest*request=[SettingUserpPayPasswordRequest request];
    request.payPassword=self.codeTextField.text;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [UserInfoManager sharedManager].tradePswdSet=1;
        [UserInfoManager sharedManager].isSetPayPwd=YES;
        if(self.isFromBinding){
            NSArray *viewControllers = [self.navigationController viewControllers];
            [self.navigationController popToViewController:viewControllers[viewControllers.count - 3] animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
- (IBAction)cancelAction {
    if(self.isFromBinding){
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:viewControllers[viewControllers.count - 3] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navView.hidden = NO;
    self.title=NSLocalizedString(@"Setting payment password", 设置支付密码);
    self.codeTextField.placeholderColor=UIColor153Color;
    self.passwordTextField.placeholderColor=UIColor153Color;
    self.codeTextField.placeholder=NSLocalizedString(@"Please enter the  payment password", 请输入支付密码);
    self.passwordTextField.placeholder=NSLocalizedString(@"Enter  payment password again", 再次输入支付密码);
    self.codeTextField.textColor =UIColor252730Color;
    self.passwordTextField.textColor =UIColor252730Color;
    self.sureButton.backgroundColor=UIColorThemeMainColor;
    [self.sureButton layerWithCornerRadius:22 borderWidth:0 borderColor:nil];
    self.lineView.backgroundColor=UIColor153Color;
    self.codeLabel.text=NSLocalizedString(@"PaymentPassword", 支付密码);
    self.passwordLabel.text=NSLocalizedString(@"Confirmpaymentpassword", 确认支付密码);

    self.passwordLabel.textColor=self.codeLabel.textColor=UIColor252730Color;
   
    self.lineView.backgroundColor=UIColorSeparatorColor;
    self.codeLabel.text=NSLocalizedString(@"PaymentPassword",支付密码);
    self.passwordLabel.text=NSLocalizedString(@"Confirmpaymentpassword", 确认支付密码);

    self.view.backgroundColor = UIColor.whiteColor;
    [self.sureButton setTitle:@"CommonButton.Confirm".icanlocalized forState:UIControlStateNormal];
    self.passwordTextField.delegate=self;
    self.codeTextField.delegate=self;
}

-(void)customBackAction{
    if(self.isFromBinding){
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:viewControllers[viewControllers.count - 3] animated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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



@end
