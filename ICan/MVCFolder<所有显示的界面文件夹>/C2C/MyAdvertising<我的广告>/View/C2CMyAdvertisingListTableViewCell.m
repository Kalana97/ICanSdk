//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2021
- File name:  C2CMyAdvertisingListTableViewCell.m
- Description:
- Function List:
*/
        

#import "C2CMyAdvertisingListTableViewCell.h"
@interface C2CMyAdvertisingListTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *contentBgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *virtualCurrencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UILabel *legalTenderLabel;

@property (weak, nonatomic) IBOutlet UIView *stateBgView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//交易总额
@property (weak, nonatomic) IBOutlet UILabel *transactionLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionAmountLabel;
//剩余数量
@property (weak, nonatomic) IBOutlet UILabel *surplusTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitAmountLabel;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

///手续费率
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeRateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeRateLabel;
///手续费
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceFeeLabel;
///银行卡
@property (weak, nonatomic) IBOutlet UIStackView *bankCardBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
///支付宝
@property (weak, nonatomic) IBOutlet UIStackView *alipayBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *alipayLabel;
///微信
@property (weak, nonatomic) IBOutlet UIStackView *weixinBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;

@end
@implementation C2CMyAdvertisingListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorBg243Color;
    self.lineView.hidden = YES;
    [self.stateBgView layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    self.useLabel.text = @"C2CMyAdvertisingListTableViewCellUse".icanlocalized;
    self.transactionLabel.text = @"C2CMyAdvertisingListTableViewCellTransactionLabel".icanlocalized;
    self.limitLabel.text = @"C2CMyAdvertisingListTableViewCellLimitLabel".icanlocalized;
    self.stateLabel.text = @"C2CMyAdvertisingListTableViewCellStateLabel".icanlocalized;
    self.bankLabel.text = @"C2CBankCard".icanlocalized;
    self.alipayLabel.text = @"C2CAlipay".icanlocalized;
    self.weixinLabel.text = @"C2CWeChat".icanlocalized;
//    "HandlingFeeRate"="手续费率";
//    "HandlingFee"="手续费";
    self.serviceFeeRateTitleLabel.text = @"HandlingFeeRate".icanlocalized;
    self.serviceFeeTitleLabel.text = @"HandlingFee".icanlocalized;
    self.surplusTitleLabel.text = @"RemainingQuantity".icanlocalized;
    
}
-(void)setAdverInfo:(C2CAdverInfo *)adverInfo{
    _adverInfo = adverInfo;
    if ([adverInfo.transactionType isEqualToString:@"Buy"]) {
        self.titleLabel.text = @"C2CPConfirmOrderViewControllerSaleCurrencyLabel".icanlocalized;
        self.titleLabel.textColor = UIColorThemeMainColor;
    }else{
        self.titleLabel.text = @"C2COptionalSaleViewControllerTitle".icanlocalized;
        self.titleLabel.textColor = UIColorMake(239, 51, 79);
    }
    self.virtualCurrencyLabel.text = adverInfo.virtualCurrency;
    self.legalTenderLabel.text = adverInfo.legalTender;
    //缺少符号
    self.symbolLabel.text = adverInfo.virtualCurrency;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@",[[adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:adverInfo.priceFluctuationIndex.decimalNumber]calculateByNSRoundDownScale:2].currencyString];
    self.limitAmountLabel.text = [NSString stringWithFormat:@"%@ - %@ %@",[adverInfo.min.decimalNumber calculateByNSRoundDownScale:2].currencyString,[adverInfo.max.decimalNumber calculateByNSRoundDownScale:2].currencyString,adverInfo.legalTender];
    self.bankCardBgStackView.hidden = !adverInfo.supportBankTransfer;
    self.alipayBgStackView.hidden = !adverInfo.supportAliPay;
    self.weixinBgStackView.hidden = !adverInfo.supportWechat;
    CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:adverInfo.legalTender];
    self.symbolLabel.text = info.symbol;
    self.openSwitch.on = adverInfo.available;
    self.stateBgView.hidden = adverInfo.available;
    self.transactionAmountLabel.text = [NSString stringWithFormat:@"%@ %@",[adverInfo.count.decimalNumber calculateByNSRoundDownScale:2].currencyString,adverInfo.virtualCurrency];
    
    self.serviceFeeRateLabel.text = [NSString stringWithFormat:@"%@%%",[[adverInfo.handlingFee.decimalNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] calculateByNSRoundDownScale:2].currencyString];
    self.serviceFeeLabel.text = [NSString stringWithFormat:@"%@ %@",[adverInfo.handlingFeeMoney.decimalNumber calculateByNSRoundDownScale:2].currencyString,adverInfo.virtualCurrency];
    ///剩余数量
    self.surplusLabel.text = [NSString stringWithFormat:@"%@ %@",[[adverInfo.count.decimalNumber decimalNumberBySubtracting:adverInfo.finishCount.decimalNumber]calculateByNSRoundDownScale:2].currencyString ,adverInfo.virtualCurrency];
}
-(IBAction)moreButtonAction{
   
}
-(IBAction)switchButtonAction{
    self.adverInfo.available = self.openSwitch.isOn;
    self.stateBgView.hidden = self.adverInfo.available;
    !self.switchBlock?:self.switchBlock(self.openSwitch.isOn);
}

@end
