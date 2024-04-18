//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 1/9/2020
- File name:  ReceiptMoneyCountTableViewCell.m
- Description:
- Function List:
*/
        

#import "ReceiptMoneyCountTableViewCell.h"

@implementation ReceiptMoneyCountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.countMoneyLabel.textColor = UIColorThemeMainTitleColor;
    self.coutTipsLabel.textColor = UIColorThemeMainTitleColor;
    // Initialization code
    self.coutTipsLabel.text=@"Received Total Payment".icanlocalized;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
