//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 17/1/2022
- File name:  IcanWalletReceiveSettingMoneyViewController.m
- Description:
- Function List:
*/
        

#import "IcanWalletReceiveSettingMoneyViewController.h"
#import "IcanWalletSelectVirtualViewController.h"
#import "DecimalKeyboard.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "DZUITextField.h"
@interface IcanWalletReceiveSettingMoneyViewController ()<UIScrollViewDelegate>
@property(nonatomic, weak) IBOutlet UILabel *titleLabel;
@property(nonatomic, weak) IBOutlet UILabel *currencyLabel;
@property(nonatomic, weak) IBOutlet UIImageView *currencyImgView;
@property(nonatomic, weak) IBOutlet QMUITextField *currencyTextField;
@property(nonatomic, weak) IBOutlet UILabel *amountLabel;
@property(nonatomic, weak) IBOutlet DZUITextField *amountTextField;

@property(nonatomic, weak) IBOutlet UILabel *remarkLabel;
@property(nonatomic, weak) IBOutlet QMUITextField *remarkTextField;

@property(nonatomic, weak) IBOutlet UIButton *sureBtn;
@property(nonatomic, strong) CurrencyInfo *selectCurrencyInfo;
@end

@implementation IcanWalletReceiveSettingMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.balanceInfo) {
        self.selectCurrencyInfo = [C2CUserManager.shared getCurrecyInfoWithCode:self.balanceInfo.code];
        if (!self.selectCurrencyInfo) {
            self.selectCurrencyInfo = [[CurrencyInfo alloc]init];
            self.selectCurrencyInfo.code = self.balanceInfo.code;
            
        }
    }else{
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"type contains [cd] %@ ",@"VirtualCurrency"];
        self.selectCurrencyInfo =  [C2CUserManager.shared.allSupportedCurrencyItems filteredArrayUsingPredicate:predicate].firstObject;
    }
    //    "C2CReceiveSettingRemark"="备注（选填）"
    //    "C2CReceiveSettingAddRemark"="添加收款理由";
    self.titleLabel.text = @"C2CReceiveSettingMoney".icanlocalized;
    self.currencyLabel.text = @"C2CAddNewAddressCurrency".icanlocalized;
    self.amountLabel.text = @"Amount".icanlocalized;
    self.remarkLabel.text = @"C2CReceiveSettingRemark".icanlocalized;
    self.amountTextField.placeholder = @"PleaseEnterAmount".icanlocalized;
    self.remarkTextField.placeholder = @"C2CReceiveSettingAddRemark".icanlocalized;
    [self.sureBtn setTitle:@"Sure".icanlocalized forState:UIControlStateNormal];
    self.currencyTextField.text = self.selectCurrencyInfo.code;
    [self.currencyImgView setImageWithString:self.selectCurrencyInfo.icon placeholder:@"icon_c2c_currency_default"];
    DecimalKeyboard *decimalKeyboard = [[DecimalKeyboard alloc] initWithFrame:CGRectZero];
    [decimalKeyboard setTargetTextField:self.amountTextField];
    decimalKeyboard.translatesAutoresizingMaskIntoConstraints = NO;
    self.amountTextField.inputView = decimalKeyboard;
    [RACObserve(self, self.sureBtn.enabled) subscribeNext:^(NSNumber*  _Nullable x) {
        BOOL en=x.boolValue;
        if (en) {
            self.sureBtn.backgroundColor=UIColorThemeMainColor;
            [self.sureBtn setTitleColor:UIColorWhite forState:UIControlStateNormal];
        }else{
            [self.sureBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
            self.sureBtn.backgroundColor = UIColorMakeHEXCOLOR(0xe6e6e7);
        }
    }];
    self.sureBtn.enabled = NO;
    RAC(self.sureBtn,enabled)=[RACSignal combineLatest:@[
        self.currencyTextField.rac_textSignal,
        self.amountTextField.rac_textSignal]reduce:^(NSString *currency, NSString *amount ) {
        return @(amount.length>0&&currency.length>0);
    }];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(IBAction)sureAction{
    !self.sureBlock?:self.sureBlock(self.selectCurrencyInfo,self.amountTextField.text,self.remarkTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)selectCurrencyAction{
    IcanWalletSelectVirtualViewController * vc = [[IcanWalletSelectVirtualViewController alloc]init];
    vc.type = IcanWalletSelectVirtualTypeSettingMoney;
    vc.selectBlock = ^(CurrencyInfo * _Nonnull info) {
        self.selectCurrencyInfo = info;
        self.currencyTextField.text = info.code;
        [self.currencyImgView setImageWithString:info.icon placeholder:@"icon_c2c_currency_default"];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
@end
