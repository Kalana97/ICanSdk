//
//  BankCardRechargeTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/25.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BankCardRechargeTableViewCell.h"

@implementation BankCardRechargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cardNumberLabel.textColor = UIColor102Color;

}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (isSelected) {
        self.cardNumberLabel.textColor = UIColor102Color;
        self.rightImageView.hidden = NO;
        
    }else{
        self.cardNumberLabel.textColor = UIColor153Color;
        self.rightImageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
