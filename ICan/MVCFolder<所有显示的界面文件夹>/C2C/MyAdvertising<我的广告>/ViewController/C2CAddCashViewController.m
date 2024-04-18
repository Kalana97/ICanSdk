//
//  C2CAddCashViewController.m
//  ICan
//
//  Created by Sathsara on 2022-11-16.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "C2CAddCashViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface C2CAddCashViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameTitleLbl;
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *mobileNoTitleLbl;
@property (weak, nonatomic) IBOutlet QMUITextField *mobileNoTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLbl;
@property (weak, nonatomic) IBOutlet QMUITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *paymentRemarkLbl;
@property (weak, nonatomic) IBOutlet QMUITextField *paymentRemarkTextField;
@property (weak, nonatomic) IBOutlet UILabel *reminderTxtLbl;
@end

@implementation C2CAddCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cash";
    [self setData];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)setData{
    self.nameTitleLbl.text = @"Name".icanlocalized;
    self.mobileNoTitleLbl.text = @"MobileNumber".icanlocalized;
    self.mobileNoTextField.placeholder = @"C2CMobilePlac".icanlocalized;
    self.addressTitleLbl.text = @"Address".icanlocalized;
    self.addressTextField.placeholder = @"please_enter_address".icanlocalized;
    self.paymentRemarkLbl.text = @"C2CAddBankCardViewControllerRemarkLabel".icanlocalized;
    self.paymentRemarkTextField.placeholder = @"C2CAddBankCardViewControllerRemarkTextField".icanlocalized;
    self.reminderTxtLbl.text = @"C2CAddBankCardViewControllerTipsLabel".icanlocalized;
    [self.sureBtn setTitle:@"C2CAddBankCardViewControllerSureButton".icanlocalized forState:UIControlStateNormal];
    self.sureBtn.enabled = NO;
    RAC(self.sureBtn,enabled)=[RACSignal combineLatest:@[
        self.nameTextField.rac_textSignal,
        self.mobileNoTextField.rac_textSignal,self.addressTextField.rac_textSignal]reduce:^(NSString *name, NSString *account,NSString *bankName ) {
        return @(name.length>0&&account.length>0&&bankName.length>0);
    }];
    RACSignal * signal =  RACObserve(self, self.sureBtn.enabled);
    [signal subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.sureBtn.backgroundColor=UIColorThemeMainColor;
            [self.sureBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.sureBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.sureBtn.backgroundColor=UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    self.nameTextField.text = UserInfoManager.sharedManager.realname;
}

- (IBAction)sureBtnAction:(id)sender {
    C2CAddPaymentMethodRequest * request = [C2CAddPaymentMethodRequest request];
    request.name = self.nameTextField.text;
    request.mobile = self.mobileNoTextField.text ;
    if (self.addressTextField.text) {
        request.address = self.addressTextField.text;
    }
    if (self.paymentRemarkTextField.text) {
        request.remark = self.paymentRemarkTextField.text;
    }
    request.paymentMethodType = @"Cash";
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
