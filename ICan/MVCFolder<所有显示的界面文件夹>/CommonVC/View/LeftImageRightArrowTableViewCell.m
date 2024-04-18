//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/10/2019
- File name:  LeftImageRightArrowTableViewCell.m
- Description:
- Function List:
*/
        

#import "LeftImageRightArrowTableViewCell.h"

@implementation LeftImageRightArrowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tintColor=[UIColor redColor];
    self.leftLabel.textColor=UIColor252730Color;
    
}

-(void)setRechargeChannelInfo:(RechargeChannelInfo *)rechargeChannelInfo{
    _rechargeChannelInfo = rechargeChannelInfo;
    self.leftLabel.text = rechargeChannelInfo.channelName;
    [self.leftImageView setImage:[UIImage imageNamed:@"icon_unionPay"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
