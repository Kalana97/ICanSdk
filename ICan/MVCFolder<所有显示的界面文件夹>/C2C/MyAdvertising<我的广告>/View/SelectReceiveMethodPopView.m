//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodPopView.m
- Description:
- Function List:
*/
        

#import "SelectReceiveMethodPopView.h"
@interface SelectReceiveMethodPopView()

@end
@implementation SelectReceiveMethodPopView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenView)];
    [self addGestureRecognizer:tap];
    UITapGestureRecognizer * wechatap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addWeChatAction)];
    [self.addWeChatBgCon addGestureRecognizer:wechatap];
    UITapGestureRecognizer * banktap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBankCardAction)];
    [self.addBankCardBgCon addGestureRecognizer:banktap];
    UITapGestureRecognizer * aliptap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAlipayAction)];
    [self.addAlipayBgCon addGestureRecognizer:aliptap];
    UITapGestureRecognizer * cashTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addCashAction)];
    [self.addCashBgCon addGestureRecognizer:cashTap];
    self.addBankCardLabel.text = @"AddBankCard".icanlocalized;
    self.addWeChatLabel.text = @"C2CAddWeChatOrAlipayViewControllerWechat".icanlocalized;
    self.addAlipayLabel.text = @"Add Alipay".icanlocalized;
    self.addCashLabel.text = @"Cash".icanlocalized;
}
-(IBAction)addWeChatAction{
    !self.addWeChatBlock?:self.addWeChatBlock();
    [self hiddenView];
}
-(IBAction)addBankCardAction{
    !self.addBankCardBlock?:self.addBankCardBlock();
    [self hiddenView];
}
-(IBAction)addAlipayAction{
    !self.addAlipayBlock?:self.addAlipayBlock();
    [self hiddenView];
}

-(IBAction)addCashAction{
    !self.addCashBlock?:self.addCashBlock();
    [self hiddenView];
}

-(void)hiddenView{
    self.hidden = YES;
    [self removeFromSuperview];
}
-(void)showView{
    self.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
@end
