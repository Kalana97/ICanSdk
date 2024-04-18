
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/9/2021
- File name:  WalletViewHeadView.m
- Description:
- Function List:
*/
        

#import "WalletViewHeadView.h"
#import "ExchangeCurrencyListViewController.h"
#import "C2CWalletBillListViewController.h"
@interface WalletViewHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *banlanceLab;
@property (weak, nonatomic) IBOutlet UIButton *hiddenBanlanceBtn;

@property (weak, nonatomic) IBOutlet UILabel *banlanceMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *banlanceMoneyLabIcon;
@property (weak, nonatomic) IBOutlet UILabel *banlanceMoneyLabCurency;
@property (weak, nonatomic) IBOutlet UIButton *saleListHistoryBtn;



@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdraweBtn;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneListBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastSaleBtn;

@property (weak, nonatomic) IBOutlet UIButton *c2cBtn;
@property (weak, nonatomic) IBOutlet UILabel *c2cLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UIButton *fastBtn;
@property (weak, nonatomic) IBOutlet UILabel *fastLabel;
@property (nonatomic, strong) NSDecimalNumber *totalNumber;
@property (weak, nonatomic) IBOutlet UIControl *convertControl;
@end

@implementation WalletViewHeadView
-(void)awakeFromNib{
    [super awakeFromNib];
    //    "C2CWalletPayment"="支付";
//    "FlashExchange"="闪兑";
    self.payLabel.text = @"ReceiveHead".icanlocalized;
    self.c2cLabel.text = @"Transfer".icanlocalized;
    self.fastLabel.text = @"CurrencyConvert".icanlocalized;
    [self.hiddenBanlanceBtn setBackgroundImage:UIImageMake(@"icon_hide_balance") forState:UIControlStateNormal];
    [self.hiddenBanlanceBtn setBackgroundImage:UIImageMake(@"icon_see_balance") forState:UIControlStateSelected];
    [self.rechargeBtn setTitle:@"Top Up".icanlocalized forState:UIControlStateNormal];
//    [self.rechargeBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
//    [self.rechargeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    
    [self.withdraweBtn setTitle:@"Withdraw".icanlocalized forState:UIControlStateNormal];
    [self.withdraweBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [self.withdraweBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    
    [self.transferBtn setTitle:@"C2CTransfer".icanlocalized forState:UIControlStateNormal];
    [self.transferBtn setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [self.transferBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    
    [self.rechargeBtn layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.withdraweBtn layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.transferBtn layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    
    
    [self.lastSaleBtn setTitleColor:UIColorThemeMainSubTitleColor forState:UIControlStateNormal];
    [self.moneListBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    
    //设置默认值
    self.rechargeBtn.selected = YES;
    self.withdraweBtn.selected = NO;
    self.transferBtn.selected = NO;
    [self.rechargeBtn setBackgroundColor:UIColorThemeMainColor];
    [self.withdraweBtn setBackgroundColor:UIColorBg243Color];
    [self.transferBtn setBackgroundColor:UIColorBg243Color];
    
    [self.moneListBtn setTitle:@"AssetList".icanlocalized forState:UIControlStateNormal];
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.banlanceLab.text = [NSString stringWithFormat:@"%@(CNY)",@"Assetvaluation".icanlocalized];
     }

    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        self.banlanceLab.text = [NSString stringWithFormat:@"%@(CNT)",@"Assetvaluation".icanlocalized];
    }
    self.banlanceLab.textColor = UIColorThemeMainSubTitleColor;
    self.banlanceMoneyLab.textColor = UIColorThemeMainTitleColor;
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.withdraweBtn.hidden = YES;
    }
    if([[UserInfoManager sharedManager].vip integerValue] < 5){
        self.convertControl.hidden = YES;
        self.transferBtn.hidden = YES;
    }
}
-(void)setCurrencyBalanceListItems:(NSArray<C2CBalanceListInfo *> *)currencyBalanceListItems{
    _currencyBalanceListItems = currencyBalanceListItems;
    self.totalNumber = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    for (C2CBalanceListInfo*info in currencyBalanceListItems) {
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            if ([info.code isEqualToString:@"CNY"]) {
                self.totalNumber = [self.totalNumber decimalNumberByAdding:info.money];
            }else{
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"virtualCurrency == [cd] %@ AND supportC2C == YES AND legalTender == [cd] %@ ",info.code,@"CNY"];
                C2CExchangeRateInfo *eInfo = [C2CUserManager.shared.allExchangenRateItems filteredArrayUsingPredicate:predicate].firstObject;
                if (eInfo) {
                    self.totalNumber = [self.totalNumber decimalNumberByAdding:[info.money decimalNumberByMultiplyingBy:eInfo.fixedPrice]];
                }
            }
        }

        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            if ([info.code isEqualToString:@"CNT"]) {
                self.totalNumber = [self.totalNumber decimalNumberByAdding:info.money];
            }else{
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"virtualCurrency == [cd] %@ AND supportC2C == YES AND legalTender == [cd] %@ ",info.code,@"CNT"];
                C2CExchangeRateInfo *eInfo = [C2CUserManager.shared.allExchangenRateItems filteredArrayUsingPredicate:predicate].firstObject;
                if (eInfo) {
                    self.totalNumber = [self.totalNumber decimalNumberByAdding:[info.money decimalNumberByMultiplyingBy:eInfo.fixedPrice]];
                }
            }
        }
     
     }
    __block CurrencyInfo *info;
    //IcanChat
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        info = [C2CUserManager.shared getCurrecyInfoWithCode:@"CNY"];
     }

    //IcanMeta
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        info = [C2CUserManager.shared getCurrecyInfoWithCode:@"CNT"];
    }
    self.banlanceMoneyLab.text =  [NSString stringWithFormat:@"%@",[self.totalNumber calculateByNSRoundDownScale:2].currencyString];
    self.banlanceMoneyLabIcon.text = @"≈";
    self.banlanceMoneyLabCurency.text = info.symbol;
    
}

- (IBAction)hiddenBanlanceAction {
    self.hiddenBanlanceBtn.selected = !self.hiddenBanlanceBtn.selected;
    __block CurrencyInfo *info;
    if (self.hiddenBanlanceBtn.selected) {
        self.banlanceMoneyLab.text = @"*****";
    }else{
        //IcanChat
        if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
            info = [C2CUserManager.shared getCurrecyInfoWithCode:@"CNY"];
         }

        //IcanMeta
        if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
            info = [C2CUserManager.shared getCurrecyInfoWithCode:@"CNT"];
        }
        self.banlanceMoneyLab.text =  [NSString stringWithFormat:@"%@",[self.totalNumber calculateByNSRoundDownScale:2].currencyString];
        self.banlanceMoneyLabIcon.text = @"≈";
        self.banlanceMoneyLabCurency.text = info.symbol;
    }
    
}

- (IBAction)saleListHistoryAction {
    C2CWalletBillListViewController*vc=[[C2CWalletBillListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    [[AppDelegate shared] pushViewController:vc animated:YES];
}

- (IBAction)rechargeAction {
    !self.functionBlock?:self.functionBlock(WalletFunctionTypeRecharge);
    
}
- (IBAction)withdraweAction {
    !self.functionBlock?:self.functionBlock(WalletFunctionTypeWithdraw);
}
- (IBAction)transferAction {
    !self.functionBlock?:self.functionBlock(WalletFunctionTypeTransfer);
}
- (IBAction)c2cAction {
    !self.functionBlock?:self.functionBlock(WalletFunctionTypeC2C);
}
- (IBAction)payAction {
    !self.functionBlock?:self.functionBlock(WalletFunctionTypePay);
}
- (IBAction)fastAction {
    !self.functionBlock?:self.functionBlock(WalletFunctionTypeFast);
}
- (IBAction)moneListAction {
    [self.moneListBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    [self.lastSaleBtn setTitleColor:UIColor153Color forState:UIControlStateNormal];
    !self.functionBlock?:self.functionBlock(WalletFunctionTypeCurrency);
    
}
- (IBAction)lastSaleAction {
    [self.moneListBtn setTitleColor:UIColorThemeMainSubTitleColor forState:UIControlStateNormal];
    [self.lastSaleBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
    !self.functionBlock?:self.functionBlock(WalletFunctionTypeHistory);
}



@end
