//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 24/9/2020
- File name:  FriendListFirstHeaderView.m
- Description:
- Function List:
*/
        

#import "FriendListFirstHeaderView.h"

@implementation FriendListFirstHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor= UIColorThemeMainBgColor;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.height.equalTo(@20);
        }];
    }
    return self;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel= [UILabel centerLabelWithTitle:@"" font:12 color:UIColor153Color];
        _titleLabel.frame = CGRectMake(10, 10, 20, 20);
        _titleLabel.backgroundColor=UIColorBg243Color;
       
        ViewRadius(_titleLabel, 10);
    }
    return _titleLabel;
}
@end
