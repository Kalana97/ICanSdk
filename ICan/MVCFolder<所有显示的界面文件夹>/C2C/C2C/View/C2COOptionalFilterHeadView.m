//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
 "C2COptionalSaleViewControllerPayWayTitleLabel"="交易方式";
 "C2COOptionalFilterHeadViewFilterLabel"="筛选";
*/
        

#import "C2COOptionalFilterHeadView.h"

@interface C2COOptionalFilterHeadView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIControl *amountBgCon;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *amountImgView;

@property (weak, nonatomic) IBOutlet UIControl *tradingBgView;
@property (weak, nonatomic) IBOutlet UILabel *tradingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tradingImgView;

@property (weak, nonatomic) IBOutlet UIControl *filterBgView;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@property (weak, nonatomic) IBOutlet UIControl *selectCurrencyBgView;
@property (weak, nonatomic) IBOutlet UIImageView *filterImgView;
@end
@implementation C2COOptionalFilterHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.amountLabel.text = @"Amount".icanlocalized;
    self.tradingLabel.text = @"C2COptionalSaleViewControllerPayWayTitleLabel".icanlocalized;
    self.filterLabel.text = @"C2COOptionalFilterHeadViewFilterLabel".icanlocalized;
    UITapGestureRecognizer * amountTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(amountAction)];
    [self.amountBgCon addGestureRecognizer:amountTap];
}
-(void)setAmount:(NSString *)amount{
    if (amount) {
        if (amount.remove.length==0) {
            self.amountLabel.text = @"Amount".icanlocalized;
            self.amountLabel.textColor = UIColor252730Color;
        }else{
            self.amountLabel.text = amount.currencyString;
            self.amountLabel.textColor = UIColorThemeMainColor;
        }
    }else{
        self.amountLabel.text = @"Amount".icanlocalized;
        self.amountLabel.textColor = UIColor252730Color;
    }
}
//"C2CAllTitle"="全部";
//"C2CBankCard"="银行卡";
//"C2CWeChat"="微信";
//"C2CAlipay"="支付宝";
-(void)setPaymentMethodType:(NSString *)paymentMethodType{
    _paymentMethodType = paymentMethodType;
    self.tradingLabel.textColor = UIColorThemeMainColor;
    //Wechat,AliPay,BankTransfer
    if ([self.paymentMethodType isEqualToString:@"C2CBankCard".icanlocalized]) {
        self.tradingLabel.text = @"C2CBankCard".icanlocalized;
    }else if ([self.paymentMethodType isEqualToString:@"C2CAlipay".icanlocalized]) {
        self.tradingLabel.text = @"C2CAlipay".icanlocalized;
    }else if ([self.paymentMethodType isEqualToString:@"C2CWeChat".icanlocalized]) {
        self.tradingLabel.text = @"C2CWeChat".icanlocalized;
    }else{
        self.tradingLabel.textColor = UIColor252730Color;
        self.tradingLabel.text = @"C2COptionalSaleViewControllerPayWayTitleLabel".icanlocalized;
    }
}
- (IBAction)amountAction {
    
    !self.tapAmountBlock?:self.tapAmountBlock();
}
- (IBAction)tradingAction {
    !self.tapTradingBlock?:self.tapTradingBlock();
    
}
- (IBAction)filterAction {
    !self.tapFilterBlock?:self.tapFilterBlock();
}
- (IBAction)amountAction:(id)sender {
    !self.tapTradingBlock?:self.tapTradingBlock();
}

- (IBAction)selectCurrencyAction:(id)sender {
    !self.tapCurrencyBlock?:self.tapCurrencyBlock();
}

@end
