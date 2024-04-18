//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/10/2019
- File name:  RightArrowTableViewCell.m
- Description:
- Function List:
*/
        

#import "RightArrowTableViewCell.h"
@interface RightArrowTableViewCell ()

@end
@implementation RightArrowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColorViewBgColor;
    self.titleLabel.textColor=UIColorThemeMainTitleColor;
    self.descriptionLabel.textColor=UIColorThemeMainSubTitleColor;
    [self.redLabel layerWithCornerRadius:4 borderWidth:0 borderColor:nil];
    self.redLabel.backgroundColor=UIColor244RedColor;
   
}


@end
