//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "C2CConfirmReceiptMoneyPopView.h"
#import "C2CAdverFilterCurrencyPopViewCurrencyCell.h"
@interface C2CConfirmReceiptMoneyPopView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel2;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *sureLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end
@implementation C2CConfirmReceiptMoneyPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    
    [self.sureBtn layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
   
    [self.selectBtn setBackgroundImage:UIImageMake(@"c2c_icon_confirm") forState:UIControlStateSelected];
    self.titleLabel.text = @"C2CConfirmReceiptMoneyViewControllerTitle".icanlocalized;
    self.tipsLabel.text = @"C2CConfirmReceiptMoneyPopViewTitle".icanlocalized;
    self.sureLabel.text = @"C2CConfirmReceiptMoneyPopViewTip".icanlocalized;
    [self.sureBtn setTitle:@"Confirm".icanlocalized forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"Cancel".icanlocalized forState:UIControlStateNormal];
//    "C2CConfirmReceiptMoneyPopViewTipsLab1"="1.请勿相信买家提供的付款证明，务必登录收款账户确认款项无误后再放币。";
//    "C2CConfirmReceiptMoneyPopViewTipsLab2"="2.若付款仍在进行中，请等待款项到账后再放币。";
    self.tipsLabel1.text = @"C2CConfirmReceiptMoneyPopViewTipsLab1".icanlocalized;
    self.tipsLabel2.text = @"C2CConfirmReceiptMoneyPopViewTipsLab2".icanlocalized;
    
}
- (IBAction)tap:(id)sender {
    
}
-(IBAction)selectAction{
    self.selectBtn.selected = !self.selectBtn.selected;
    
}
-(IBAction)sureAction{
    if (self.selectBtn.selected) {
        !self.sureBlock?:self.sureBlock();
        [self hiddenView];
    }
}
-(IBAction)cancelAction{
    [self hiddenView];
    !self.cancelBlock?:self.cancelBlock();
}
-(void)tapAction:(UITapGestureRecognizer*)gest{
    [self hiddenView];
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
