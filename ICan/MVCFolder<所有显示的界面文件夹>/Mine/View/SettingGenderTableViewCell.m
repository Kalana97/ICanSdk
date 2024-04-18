//
//  SettingGenderTableViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/10/22.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "SettingGenderTableViewCell.h"

@implementation SettingGenderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.genderLabel.textColor = UIColor252730Color;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
