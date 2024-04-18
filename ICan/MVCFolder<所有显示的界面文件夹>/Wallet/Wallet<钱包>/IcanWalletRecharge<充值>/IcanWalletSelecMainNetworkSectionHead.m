
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 23/9/2021
- File name:  WalletViewHeadView.m
- Description:
- Function List:
*/
        

#import "IcanWalletSelecMainNetworkSectionHead.h"

@interface IcanWalletSelecMainNetworkSectionHead ()
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation IcanWalletSelecMainNetworkSectionHead
-(void)awakeFromNib{
    [super awakeFromNib];
//    "MainNetworkViewTips"="请确保您选择的充值主网与您在提币时选择的主网一致，否则可能造成资产丢失。";
    self.tipsLabel.text = @"MainNetworkViewTips".icanlocalized;
   
}
@end
