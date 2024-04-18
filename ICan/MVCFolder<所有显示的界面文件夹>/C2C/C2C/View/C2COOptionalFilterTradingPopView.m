//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
 //"C2CAllTitle"="全部";
 //"C2CBankCard"="银行卡";
 //"C2CWeChat"="微信";
 //"C2CAlipay"="支付宝";
*/
#import "C2COOptionalFilterTradingPopView.h"
@interface C2COOptionalFilterTradingPopView()
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *bankCardButton;
@property (weak, nonatomic) IBOutlet UIButton *alipayButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatButton;
@end
@implementation C2COOptionalFilterTradingPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    [self.allButton setTitle:@"C2CAllTitle".icanlocalized forState:UIControlStateNormal];
    [self.bankCardButton setTitle:@"C2CBankCard".icanlocalized forState:UIControlStateNormal];
    [self.alipayButton setTitle:@"C2CAlipay".icanlocalized forState:UIControlStateNormal];
    [self.wechatButton setTitle:@"C2CWeChat".icanlocalized forState:UIControlStateNormal];
    
    [self.allButton setTitleColor:UIColorThemeMainColor forState:UIControlStateSelected];
    [self.allButton setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [self.bankCardButton setTitleColor:UIColorThemeMainColor forState:UIControlStateSelected];
    [self.bankCardButton setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [self.alipayButton setTitleColor:UIColorThemeMainColor forState:UIControlStateSelected];
    [self.alipayButton setTitleColor:UIColor252730Color forState:UIControlStateNormal];
    [self.wechatButton setTitleColor:UIColorThemeMainColor forState:UIControlStateSelected];
    [self.wechatButton setTitleColor:UIColor252730Color forState:UIControlStateNormal];
}
-(void)setPaymentMethodType:(NSString *)paymentMethodType{
    _paymentMethodType = paymentMethodType;
    //Wechat,AliPay,BankTransfer
    if ([self.paymentMethodType isEqualToString:@"C2CBankCard".icanlocalized]) {
        self.allButton.selected = NO;
        self.bankCardButton.selected = YES;
        self.wechatButton.selected = NO;
        self.alipayButton.selected = NO;
    }else if ([self.paymentMethodType isEqualToString:@"C2CAlipay".icanlocalized]) {
        self.allButton.selected = NO;
        self.bankCardButton.selected = NO;
        self.wechatButton.selected = NO;
        self.alipayButton.selected = YES;
    }else if ([self.paymentMethodType isEqualToString:@"C2CWeChat".icanlocalized]) {
        self.allButton.selected = NO;
        self.bankCardButton.selected = NO;
        self.wechatButton.selected = YES;
        self.alipayButton.selected = NO;
    }else{
        self.allButton.selected = YES;
        self.bankCardButton.selected = NO;
        self.wechatButton.selected = NO;
        self.alipayButton.selected = NO;
        
    }
}
-(IBAction)allButtonAction{
    
    self.allButton.selected = YES;
    self.bankCardButton.selected = NO;
    self.wechatButton.selected = NO;
    self.alipayButton.selected = NO;
    [self hiddenView];
    !self.selectBlock?:self.selectBlock(@"C2CAllTitle".icanlocalized);
}
-(IBAction)bankcardButtonAction{
    self.allButton.selected = NO;
    self.bankCardButton.selected = YES;
    self.wechatButton.selected = NO;
    self.alipayButton.selected = NO;
    [self hiddenView];
    !self.selectBlock?:self.selectBlock(@"C2CBankCard".icanlocalized);
}
-(IBAction)alipayButtonAction{
    self.allButton.selected = NO;
    self.bankCardButton.selected = NO;
    self.wechatButton.selected = NO;
    self.alipayButton.selected = YES;
    [self hiddenView];
    !self.selectBlock?:self.selectBlock(@"C2CAlipay".icanlocalized);
}
-(IBAction)wechatButtonAction{
    self.allButton.selected = NO;
    self.bankCardButton.selected = NO;
    self.wechatButton.selected = YES;
    self.alipayButton.selected = NO;
    [self hiddenView];
    !self.selectBlock?:self.selectBlock(@"C2CWeChat".icanlocalized);
}
-(void)hiddenView{
    self.hidden = YES;
    !self.hiddenBlock?:self.hiddenBlock();
    [self removeFromSuperview];
}
-(void)showView{
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
@end
