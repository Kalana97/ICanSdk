//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  SelectReceiveMethodFooterView.m
- Description:
- Function List:
*/
        

#import "SelectReceiveMethodFooterView.h"
@interface SelectReceiveMethodFooterView ()
@property (weak, nonatomic) IBOutlet UIControl *addWeChatBgCon;
@property (weak, nonatomic) IBOutlet UILabel *addWeChatLabel;

@property (weak, nonatomic) IBOutlet UIControl *addBankCardBgCon;
@property (weak, nonatomic) IBOutlet UILabel *addBankCardLabel;
@property (weak, nonatomic) IBOutlet UIControl *addAlipayBgCon;
@property (weak, nonatomic) IBOutlet UILabel *addAlipayLabel;
@end
@implementation SelectReceiveMethodFooterView

-(IBAction)addWeChatAction{
    !self.addWeChatBlock?:self.addWeChatBlock();
}
-(IBAction)addBankCardAction{
    !self.addBankCardBlock?:self.addBankCardBlock();
}
-(IBAction)addAlipayAction{
    !self.addAlipayBlock?:self.addAlipayBlock();
}

@end
