//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferBankViewController.m
- Description:
- Function List:
*/
        

#import "IcanTransferBankViewController.h"
#import "IcanSureTransferViewController.h"
#import "DecimalKeyboard.h"
#import "IcanTransferSelectBankCardViewController.h"
#import "IcanTransferSelectBankHistoryViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface IcanTransferBankViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet QMUITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *cardIdLab;
@property (weak, nonatomic) IBOutlet QMUITextField *cardIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *bankLab;
@property (weak, nonatomic) IBOutlet QMUITextField *bankTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet QMUITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property(nonatomic, strong) NSString *bankTypeId;
@property(nonatomic, copy) NSString *bindId;
@property(nonatomic, strong) UserBalanceInfo *balanceInfo;
@end

@implementation IcanTransferBankViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"Transfertobancard".icanlocalized;
    [RACObserve(self, self.nextBtn.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en = x.boolValue;
        if (en) {
            self.nextBtn.backgroundColor=UIColorThemeMainColor;
            [self.nextBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.nextBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.nextBtn.backgroundColor = UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    self.nextBtn.enabled = NO;
    RAC(self.nextBtn,enabled) = [RACSignal combineLatest:@[
        self.nameTextField.rac_textSignal,
        self.cardIdTextField.rac_textSignal,
        self.bankTextField.rac_textSignal,self.amountTextField.rac_textSignal ]reduce:^(NSString *address, NSString *network,NSString *withdrawMoney,NSString *amount) {
        return @(address.length>0 && network.length>0 && withdrawMoney.length>0 && amount.floatValue>0);
    }];
    [self fetchUserBalance];
    self.nameLab.text = @"Name".icanlocalized;
    self.nameTextField.placeholder = @"PayeeName".icanlocalized;
    self.cardIdLab.text = @"CardNumber".icanlocalized;
    self.cardIdTextField.placeholder = @"Payeessavingscardnumber".icanlocalized;
    self.bankLab.text = @"Bank".icanlocalized;
    self.bankTextField.placeholder = @"Choosebank".icanlocalized;
    if([_bankType isEqualToString:@"ABA"]) {
        self.bankTextField.text = @"ABA";
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
    if([_bankType isEqualToString:@"Bank"]) {
        IcanTransferSelectBankHistoryViewController *vc = [[IcanTransferSelectBankHistoryViewController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.selectBlock = ^(BindingBankCardListInfo * _Nonnull info) {
            self.bindId = info.bindId;
            self.bankTextField.text = info.bankName;
            self.cardIdTextField.text = info.cardNo;
            self.nameTextField.text = info.username;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)selectBankAction {
    if([_bankType isEqualToString:@"Bank"]) {
        IcanTransferSelectBankCardViewController *vc = [[IcanTransferSelectBankCardViewController alloc]init];
        vc.selectBlock = ^(CommonBankCardsInfo * _Nonnull info) {
            self.bankTypeId = info.ID;
            self.bankTextField.text = info.name;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)nextAction {
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.amountTextField.text];
    if ([amount compare:self.balanceInfo.balance] == NSOrderedDescending) {
        [QMUITipsTool showErrorWihtMessage:@"NotEnoughBalance".icanlocalized inView:self.view];
    }else if ([amount compare:self.balanceInfo.withdrawMinAmount] == NSOrderedAscending) {
        [QMUITipsTool showErrorWihtMessage:[NSString stringWithFormat:@"%@ %@",@"TheMinimumWithdrawal".icanlocalized,[self.balanceInfo.withdrawMinAmount calculateByNSRoundDownScale:2].currencyString] inView:self.view];
    } else{
        IcanSureTransferViewController *vc = [[IcanSureTransferViewController alloc]init];\
        vc.bank = _bankType;
        vc.bindingId = self.bindId;
        vc.username = self.nameTextField.text;
        vc.account = self.cardIdTextField.text;
        vc.bankName = self.bankTextField.text;
        vc.amount = self.amountTextField.text;
        vc.availableBalance = self.balanceLab.text;
        vc.bankTypeId = self.bankTypeId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

// Get user balance
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
