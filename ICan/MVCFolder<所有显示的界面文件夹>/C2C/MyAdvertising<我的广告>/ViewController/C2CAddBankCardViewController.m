//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 22/11/2021
 - File name:  C2CAddBankCardViewController.m
 - Description:
 - Function List:
 */


#import "C2CAddBankCardViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface C2CAddBankCardViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UILabel *depositBankLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *depositBankTextField;

@property (weak, nonatomic) IBOutlet UILabel *branchBankLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *branchBankTextField;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet QMUITextField *remarkTextField;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@end

@implementation C2CAddBankCardViewController
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"C2CAddBankCardViewControllerTitle".icanlocalized;
    self.nameLabel.text = @"C2CAddBankCardViewControllerNameLabel".icanlocalized;
    self.nameTextField.placeholder = @"C2CAddBankCardViewControllerNameTextField".icanlocalized;
    self.accountLabel.text = @"C2CAddBankCardViewControllerAccountLabel".icanlocalized;
    self.accountTextField.placeholder = @"C2CAddBankCardViewControllerAccountTextField".icanlocalized;
     
    self.depositBankLabel.text = @"C2CAddBankCardViewControllerDepositBankLabel".icanlocalized;
    self.depositBankTextField.placeholder = @"C2CAddBankCardViewControllerDepositBankTextField".icanlocalized;
    
    self.branchBankLabel.text = @"C2CAddBankCardViewControllerBranchBankLabel".icanlocalized;
    self.branchBankTextField.placeholder = @"C2CAddBankCardViewControllerBranchBankTextField".icanlocalized;
    self.remarkLabel.text = @"C2CAddBankCardViewControllerRemarkLabel".icanlocalized;
    self.remarkTextField.placeholder = @"C2CAddBankCardViewControllerRemarkTextField".icanlocalized;
    self.tipsLabel.text = @"C2CAddBankCardViewControllerTipsLabel".icanlocalized;
    [self.sureButton setTitle:@"C2CAddBankCardViewControllerSureButton".icanlocalized forState:UIControlStateNormal];
    self.sureButton.enabled = NO;
    RAC(self.sureButton,enabled)=[RACSignal combineLatest:@[
        self.nameTextField.rac_textSignal,
        self.accountTextField.rac_textSignal,self.depositBankTextField.rac_textSignal]reduce:^(NSString *name, NSString *account,NSString *bankName ) {
        return @(name.length>0&&account.length>0&&bankName.length>0);
    }];
    RACSignal * signal =  RACObserve(self, self.sureButton.enabled);
    [signal subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.sureButton.backgroundColor=UIColorThemeMainColor;
            [self.sureButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.sureButton setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.sureButton.backgroundColor=UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    self.nameTextField.text = UserInfoManager.sharedManager.realname;
    
}
-(IBAction)sureButtonAction{
    C2CAddPaymentMethodRequest * request = [C2CAddPaymentMethodRequest request];
    request.name = self.nameTextField.text;
    request.account = self.accountTextField.text ;
    if (self.branchBankTextField.text) {
        request.branch = self.branchBankTextField.text;
    }
    if (self.depositBankTextField.text) {
        request.bankName = self.depositBankTextField.text;
    }
    if (self.remarkTextField.text) {
        request.remark = self.remarkTextField.text;
    }
    request.paymentMethodType = @"BankTransfer";
    request.parameters = [request mj_JSONObject];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"AddSuccess".icanlocalized inView:nil];
        !self.addSuccessBlock?:self.addSuccessBlock();
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
    
}


@end
