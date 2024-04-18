//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferBankViewController.m
- Description:
- Function List:
*/
        

#import "IcanTransferAlipayViewController.h"
#import "IcanSureTransferViewController.h"
#import "DecimalKeyboard.h"
#import "IcanTransferSelectAlipayHistoryViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface IcanTransferAlipayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *cardIdLab;
@property (weak, nonatomic) IBOutlet QMUITextField *cardIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet QMUITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, strong) UserBalanceInfo *balanceInfo;
@property (nonatomic, copy) NSString *bindId;
@end

@implementation IcanTransferAlipayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TransferToAlipay".icanlocalized;
    [RACObserve(self, self.nextBtn.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en = x.boolValue;
        if (en) {
            self.nextBtn.backgroundColor = UIColorThemeMainColor;
            [self.nextBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.nextBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.nextBtn.backgroundColor = UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    self.nextBtn.enabled = NO;
    RAC(self.nextBtn,enabled) = [RACSignal combineLatest:@[
        self.nameTextField.rac_textSignal,
        self.cardIdTextField.rac_textSignal,self.amountTextField.rac_textSignal ]reduce:^(NSString *address,NSString *withdrawMoney,NSString *amount) {
        return @(address.length>0 && withdrawMoney.length>0 && amount.floatValue>0);
    }];
    [self fetchUserBalance];
    self.nameLab.text = @"Name".icanlocalized;
    self.nameTextField.placeholder = @"PayeeName".icanlocalized;
    self.cardIdLab.text = @"Account".icanlocalized;
    if([_bankType isEqualToString:@"Alipay"]) {
        self.title = @"TransferToAlipay".icanlocalized;
        self.cardIdTextField.placeholder = @"PayeeAlipayAccount".icanlocalized;
    }else if([_bankType isEqualToString:@"Huione"]) {
        self.title = @"TransferToHuione".icanlocalized;
        self.cardIdTextField.placeholder = @"PayeeHuioneAccount".icanlocalized;
    }else if ([_bankType isEqualToString:@"ABA"]) {
        self.title = @"TransferToABA".icanlocalized;
        self.cardIdTextField.placeholder = @"PayeeABAAccount".icanlocalized;
    }
    self.amountLab.text = @"Amount".icanlocalized;
    self.amountTextField.placeholder = @"PleaseEnterAmount".icanlocalized;
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.amountTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField.inputView = decimalKeyboard;
    [self.nextBtn setTitle:@"NextStep".icanlocalized forState:UIControlStateNormal];
}

- (IBAction)selectTransferHistoryAction {
    IcanTransferSelectAlipayHistoryViewController *vc = [[IcanTransferSelectAlipayHistoryViewController alloc]init];
    vc.selectBlock = ^(BindingAliPayListInfo * _Nonnull info) {
        self.bindId = info.bindId;
        self.nameTextField.text = info.username;
        self.cardIdTextField.text = info.account;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)nextAction {
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.amountTextField.text];
    if ([amount compare:self.balanceInfo.balance] == NSOrderedDescending) {
        [QMUITipsTool showErrorWihtMessage:@"NotEnoughBalance".icanlocalized inView:self.view];
    }else if([amount compare:self.balanceInfo.withdrawMinAmount] == NSOrderedAscending) {
        [QMUITipsTool showErrorWihtMessage:[NSString stringWithFormat:@"%@ %@",@"TheMinimumWithdrawal",[self.balanceInfo.withdrawMinAmount calculateByNSRoundDownScale:2].currencyString] inView:self.view];
    }else {
        IcanSureTransferViewController *vc = [[IcanSureTransferViewController alloc]init];
        vc.bank = _bankType;
        vc.bindingId = self.bindId;
        vc.username = self.nameTextField.text;
        vc.account = self.cardIdTextField.text;
        vc.amount = self.amountTextField.text;
        vc.bankName = _bankType;
        vc.availableBalance = self.balanceLab.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/// Get user balance
- (void)fetchUserBalance {
    UserBalanceRequest *request = [UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo *response) {
        self.balanceInfo = response;
        self.balanceLab.text = [NSString stringWithFormat:@"%@ ￥%.2f",@"AvailableBalance".icanlocalized,response.balance.doubleValue];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

@end
