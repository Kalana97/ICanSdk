//
//  BankCardListAddTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BankCardListAddTableViewCell.h"
@interface BankCardListAddTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *addBankCardLabel;

@property (weak, nonatomic) IBOutlet UILabel *addBankCardTipsLabel;

@end

@implementation BankCardListAddTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.backgroundColor = UIColorBg243Color;
    ViewRadius(self.bgView, 8);
    self.addBankCardLabel.textColor = UIColor102Color;
    self.addBankCardTipsLabel.textColor = UIColor153Color;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
