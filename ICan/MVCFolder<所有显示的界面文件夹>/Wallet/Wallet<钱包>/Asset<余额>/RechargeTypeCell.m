//
//  RechargeTypeCell.m
//  ICan
//
//  Created by Sathsara on 2023-02-07.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "RechargeTypeCell.h"

@implementation RechargeTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setData:(RechargeChannelInfo *)channelInfo{
    self.rechargeChannelInfoData = channelInfo;
    if([channelInfo.channelName  isEqual: @"USDT"]){
        UIImage *icon_usdt = [UIImage imageNamed:@"icon_usdt"];
        self.logoImg.image =  icon_usdt;
    }else{
        [self.logoImg sd_setImageWithURL:[NSURL URLWithString:channelInfo.logo]];
    }
    self.typeNameLbl.text = channelInfo.channelName;
    UIImage *btnSelectedImage = [UIImage imageNamed:@"icon_circle_select"];
    UIImage *btnUnSelectedImage = [UIImage imageNamed:@"icon_circle_unSelect"];
    if(channelInfo.isSelected == YES){
        [self.selectionBtn setImage:btnSelectedImage forState:UIControlStateNormal];
    }else{
        [self.selectionBtn setImage:btnUnSelectedImage forState:UIControlStateNormal];
    }
}

- (IBAction)didSelectCountry:(id)sender {
    self.selectRechargeInfo(self.rechargeChannelInfoData);
}

@end
