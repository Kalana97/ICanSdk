//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/11/2019
- File name:  PaymentManagementViewController.m
- Description:
- Function List:
*/
        

#import "PaymentManagementViewController.h"
#import "FindPaymentPasswordViewController.h"
#import "ChangePaymentPasswordViewControlle.h"
#import "SettingPaymentPasswordViewController.h"
#import "BindingMoblieOrEmailViewController.h"
#import "EmailBindingViewController.h"
@interface PaymentManagementViewController ()
@property (weak, nonatomic) IBOutlet UIControl *resetPasswordBgView;
@property (weak, nonatomic) IBOutlet UILabel *resetPasswordLab;
@property (weak, nonatomic) IBOutlet UIControl *forgetPasswordBgView;
@property (weak, nonatomic) IBOutlet UILabel *forgetPasswordLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation PaymentManagementViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Payment Management", 支付管理);
    self.view.backgroundColor = UIColorBg243Color;
    self.lineView.backgroundColor = UIColorSeparatorColor;
    self.resetPasswordLab.text =@"PaymentManagementViewController.resetPassword".icanlocalized;
    self.resetPasswordLab.textColor =UIColorThemeMainTitleColor;
    self.forgetPasswordLab.text = @"PaymentManagementViewController.forgotPassword".icanlocalized;
    self.forgetPasswordLab.textColor =UIColorThemeMainTitleColor;

}
- (IBAction)resetPasswordAction {
    if ([UserInfoManager sharedManager].tradePswdSet) {
        [self.navigationController pushViewController:[ChangePaymentPasswordViewControlle new] animated:YES];
    }else{
        if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (IBAction)forgetPasswordAction {
    if (UserInfoManager.sharedManager.email.length>0||UserInfoManager.sharedManager.mobile.length>0) {
        [self.navigationController pushViewController:[FindPaymentPasswordViewController new] animated:YES];
    }else{
        [UIAlertController alertControllerWithTitle:@"You have not bound your mobile phone or email, please bind your mobile phone/email to retrieve your password".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                BindingMoblieOrEmailViewController * vc = [BindingMoblieOrEmailViewController new];
                vc.bindingType=BindingType_Moblie;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
      
    }
}

@end
