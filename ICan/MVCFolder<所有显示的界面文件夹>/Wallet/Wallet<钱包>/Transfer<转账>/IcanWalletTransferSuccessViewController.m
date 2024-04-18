//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 19/1/2022
- File name:  IcanWalletTransferSuccessViewController.m
- Description:
- Function List:
*/
        

#import "IcanWalletTransferSuccessViewController.h"
#import "UIViewController+Extension.h"
@interface IcanWalletTransferSuccessViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;

@property (weak, nonatomic) IBOutlet UILabel *payStateLab;

@property (weak, nonatomic) IBOutlet UILabel *toLab;


@property (weak, nonatomic) IBOutlet UILabel *payTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *payTypeDetailLab;

@property (weak, nonatomic) IBOutlet UILabel *currencyLab;



@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@end

@implementation IcanWalletTransferSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.payStateLab.text = @"C2CTransferSuccessViewPaySuccess".icanlocalized;
    self.currencyLab.text = @"C2CAddNewAddressCurrency".icanlocalized;
    self.payTypeDetailLab.text = @"C2CTransferSuccessViewAssest".icanlocalized;
    self.toLab.text = @"C2CTransferSuccessViewToAccount".icanlocalized;
    self.payTypeLab.text = @"C2CTransferPopViewPayWay".icanlocalized;
    [self.doneBtn setTitle:@"C2CTransferPopViewSure".icanlocalized forState:UIControlStateNormal];
    
    self.navHeight.constant = StatusBarAndNavigationBarHeight;
    self.toIdLab.text =self.toIdLabText;
    self.amountLabel.text = self.amountLabelText;
    self.toNicknameLab.text = self.toNicknameText;
    self.currencyDetailLab.text = self.currencyDetailLabText;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeVcWithArray:@[@"IcanWalletTransferInputMoneyViewController",@"IcanWalletTransferInputUserTableViewController",@"QRCodeController",@"IcanWalletPayQrCodeInputMoneyViewController"]];
}
- (IBAction)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneAction {
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}

@end
