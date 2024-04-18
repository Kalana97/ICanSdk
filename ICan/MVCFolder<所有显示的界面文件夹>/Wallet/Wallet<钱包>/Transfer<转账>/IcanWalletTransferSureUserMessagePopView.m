//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/1/2022
- File name:  IcanWalletTransferSureUserMessagePopView.m
- Description:
- Function List:
*/
        

#import "IcanWalletTransferSureUserMessagePopView.h"
@interface IcanWalletTransferSureUserMessagePopView ()

@property(nonatomic, weak) IBOutlet UILabel *receiveTitleLabel;
@property(nonatomic, weak) IBOutlet UILabel *nicknameTitleLabel;

@property(nonatomic, weak) IBOutlet UILabel *paywayLabel;
@property(nonatomic, weak) IBOutlet UILabel *paywayDetailLabel;

@property(nonatomic, weak) IBOutlet UILabel *currencyLabel;

@property(nonatomic, weak) IBOutlet UIButton *sureBtn;
@end
@implementation IcanWalletTransferSureUserMessagePopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
//    "C2CTransferPopViewReceive"="收款人";
//    "C2CTransferPopViewNickname"="昵称";
//    "C2CTransferPopViewPayWay"="支付方式";
//    "C2CTransferPopViewWalletPay"="钱包支付";
//    "C2CTransferPopViewSure"="确定";
    self.receiveTitleLabel.text = @"C2CTransferPopViewReceive".icanlocalized;
    self.nicknameTitleLabel.text = @"C2CTransferPopViewNickname".icanlocalized;
    self.paywayLabel.text = @"C2CTransferPopViewPayWay".icanlocalized;
    self.paywayDetailLabel.text = @"C2CTransferPopViewWalletPay".icanlocalized;
    self.currencyLabel.text = @"C2CAddNewAddressCurrency".icanlocalized;
    [self.sureBtn setTitle:@"C2CTransferPopViewSure".icanlocalized forState:UIControlStateNormal];

}

-(IBAction)sureAction{
    [self hiddenView];
    !self.sureBlock?:self.sureBlock();
}
-(void)hiddenView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColor.clearColor;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
-(void)showView{
    
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.2);
        [self layoutIfNeeded];
    }];
}
@end
