//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/11/2021
- File name:  WantToBuyListTableViewCell.m
- Description:
- Function List:
*/
        

#import "WantToBuyListTableViewCell.h"
#import "C2CUserDetailViewController.h"

@interface WantToBuyListTableViewCell()
@property (weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

//单价
@property (weak, nonatomic) IBOutlet UILabel *unitPriceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;

//数量
@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
///限额
@property (weak, nonatomic) IBOutlet UILabel *limitTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UIView *buyBgView;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
///银行卡
@property (weak, nonatomic) IBOutlet UIStackView *bankCardBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
///支付宝
@property (weak, nonatomic) IBOutlet UIStackView *alipayBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *alipayLabel;
///微信
@property (weak, nonatomic) IBOutlet UIStackView *weixinBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
//cash
@property (weak, nonatomic) IBOutlet UIStackView *cashBgStackView;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;

@end
@implementation WantToBuyListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconAction)];
    [self.iconImageView addGestureRecognizer:tap];
//    "C2COptionalSaleViewControllerUnitPriceTitleLabel"="单价";
    //"C2CConfirmReceiptMoneyViewControllerCountTitleLabel"="数量";
    //"C2CMyAdvertisingListTableViewCellLimitLabel"="限额";
    //"WantToBuyListTableViewCellTurnoverLabel"="成交量";
    self.unitPriceTitleLabel.text = @"C2COptionalSaleViewControllerUnitPriceTitleLabel".icanlocalized;
    self.countTitleLabel.text = @"C2CConfirmReceiptMoneyViewControllerCountTitleLabel".icanlocalized;
    self.limitTitleLabel.text = @"C2CMyAdvertisingListTableViewCellLimitLabel".icanlocalized;
    self.bankLabel.text = @"C2CBankCard".icanlocalized;
    self.alipayLabel.text = @"C2CAlipay".icanlocalized;
    self.weixinLabel.text = @"C2CWeChat".icanlocalized;
    self.cashLabel.text = @"Cash".icanlocalized;
}

-(void)setIsOptionBuy:(BOOL)isOptionBuy{
    _isOptionBuy = isOptionBuy;
//    "C2CPublishAdvertFirstStepViewControllerbuyLabel"="购买";
//    "C2CPublishAdvertFirstStepViewControllersaleLabel"="出售";
    if (isOptionBuy) {
        self.buyLabel.text = @"C2CPublishAdvertFirstStepViewControllerbuyLabel".icanlocalized;
       
    }else{
        self.buyBgView.backgroundColor = UIColorMake(239, 51, 79);
        self.buyLabel.text =@"C2CPublishAdvertFirstStepViewControllersaleLabel".icanlocalized;
    }
}
-(void)setAdverInfo:(C2CAdverInfo *)adverInfo{
    _adverInfo = adverInfo;
    if (self.isUserDetail) {
        self.contentView.backgroundColor = UIColorBg243Color;
        self.cellLineView.backgroundColor = UIColorMake(236, 235, 235);
        self.turnoverLabel.hidden = self.volumeTwoLabel.hidden = YES;
        CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:adverInfo.virtualCurrency];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:info.icon]];
        self.nicknameLabel.text =BaseSettingManager.isChinaLanguages?info.nameCn:info.nameEn;
    }else{
        [self.iconImageView setImageWithString:adverInfo.user.headImgUrl placeholder:BoyDefault];
        self.nicknameLabel.text = adverInfo.user.nickname;
    }
    if (adverInfo.userId == C2CUserManager.shared.userId.integerValue) {
        self.buyBgView.hidden = YES;
    }else{
        self.buyBgView.hidden = NO;
    }
    //在首页我要买 我要卖页面显示的是出售
    self.turnoverLabel.text = [NSString stringWithFormat:@"%@%ld",@"WantToBuyListTableViewCellTurnoverLabel".icanlocalized,(long)adverInfo.user.clinchCount];
    if (adverInfo.user.clinchCount==0) {
        self.volumeTwoLabel.text = @"100%";
    }else{
        self.volumeTwoLabel.text = [NSString stringWithFormat:@"%.2f %% ",((adverInfo.user.clinchCount*1.0)/(adverInfo.user.orderCount*1.0))*100];
    }
    self.unitPriceLabel.text = [NSString stringWithFormat:@"%@",[[adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:adverInfo.priceFluctuationIndex.decimalNumber]calculateByNSRoundDownScale:2].currencyString];
    self.countLabel.text = [NSString stringWithFormat:@"%@ %@",[[adverInfo.count.decimalNumber decimalNumberBySubtracting:adverInfo.finishCount.decimalNumber]calculateByNSRoundDownScale:2].currencyString,adverInfo.virtualCurrency];
    self.bankCardBgStackView.hidden = !adverInfo.supportBankTransfer;
    self.alipayBgStackView.hidden = !adverInfo.supportAliPay;
    self.weixinBgStackView.hidden = !adverInfo.supportWechat;
    self.weixinBgStackView.hidden = !adverInfo.supportWechat;
    self.cashBgStackView.hidden = !adverInfo.supportCash;
    
    CurrencyInfo * info =  [C2CUserManager.shared getCurrecyInfoWithCode:adverInfo.legalTender];
    self.symbolLabel.text = info.symbol;
    ///剩余的金额
    NSDecimalNumber * surplusAmount = [[adverInfo.fixedPrice.decimalNumber decimalNumberByMultiplyingBy:adverInfo.priceFluctuationIndex.decimalNumber]decimalNumberByMultiplyingBy:[adverInfo.count.decimalNumber decimalNumberBySubtracting:adverInfo.finishCount.decimalNumber]];
    ///如果剩余金额小于最大限额
    if ([surplusAmount compare:adverInfo.max.decimalNumber]==NSOrderedAscending) {
        self.limitLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",info.symbol,[adverInfo.min.decimalNumber calculateByNSRoundDownScale:2].currencyString,info.symbol,[surplusAmount calculateByNSRoundDownScale:2].currencyString];
    }else{
        self.limitLabel.text = [NSString stringWithFormat:@"%@ %@ - %@ %@",info.symbol,[adverInfo.min.decimalNumber calculateByNSRoundDownScale:2].currencyString,info.symbol,[adverInfo.max.decimalNumber calculateByNSRoundDownScale:2].currencyString];
    }
    
    
}
-(IBAction)iconAction{
    if (!self.isUserDetail) {
        C2CUserDetailViewController * vc = [C2CUserDetailViewController new];
        vc.userId = self.adverInfo.userId;
        [[AppDelegate shared]pushViewController:vc animated:YES];
    }
   
}

@end
