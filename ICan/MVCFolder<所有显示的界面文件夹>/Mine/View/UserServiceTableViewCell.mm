//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 9/1/2020
- File name:  UserServiceTableViewCell.m
- Description:
- Function List:
*/
        

#import "UserServiceTableViewCell.h"

@implementation UserServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.nameLabel.textColor=UIColorThemeMainTitleColor;
    [self.iconImageView layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)setServicesInfo:(ServicesInfo *)servicesInfo{
    self.nameLabel.text=servicesInfo.nickname;
    [self.iconImageView setImageWithString:servicesInfo.headImgUrl placeholder:BoyDefault];
}

@end
