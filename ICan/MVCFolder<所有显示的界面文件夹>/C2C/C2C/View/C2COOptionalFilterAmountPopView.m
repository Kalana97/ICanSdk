//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "C2COOptionalFilterAmountPopView.h"
#import "DZUITextField.h"
@interface C2COOptionalFilterAmountPopView()
@property (weak, nonatomic) IBOutlet DZUITextField *amountTextField;

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
@implementation C2COOptionalFilterAmountPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    [self.resetBtn layerWithCornerRadius:22 borderWidth:1 borderColor:UIColorThemeMainColor];
//    "C2CResetTitle"="Reset";
//    "C2CAddBankCardViewControllerSureButton"="确定";
    self.amountTextField.placeholder = @"C2COptionalSaleViewControllerAmountTextFieldAmount".icanlocalized;
    [self.resetBtn setTitle:@"C2CResetTitle".icanlocalized forState:UIControlStateNormal];
    [self.sureBtn setTitle:@"C2CAddBankCardViewControllerSureButton".icanlocalized forState:UIControlStateNormal];
}
-(void)setAmount:(NSString *)amount{
    
    self.amountTextField.text = amount;
}
- (IBAction)resetBtnAction {
    !self.resetBlock?:self.resetBlock();
    [self hiddenView];
}
- (IBAction)sureAction {
    !self.amountBlock?:self.amountBlock(self.amountTextField.text);
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
