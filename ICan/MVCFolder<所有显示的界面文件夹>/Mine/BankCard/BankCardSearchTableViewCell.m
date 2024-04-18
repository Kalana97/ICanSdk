//
//  BankCardSearchTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/13.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BankCardSearchTableViewCell.h"
@interface BankCardSearchTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation BankCardSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.nameLabel.textColor = UIColorThemeMainTitleColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 
}

-(void)setCommonBankCardsInfo:(CommonBankCardsInfo *)commonBankCardsInfo{
    _commonBankCardsInfo = commonBankCardsInfo;
    self.nameLabel.text = commonBankCardsInfo.name;
}

@end
