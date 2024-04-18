//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 8/5/2021
- File name:  SelectTranspondMoreCollectionViewCell.m
- Description:
- Function List:
*/
        

#import "SelectTranspondMoreCollectionViewCell.h"

@implementation SelectTranspondMoreCollectionViewCell
-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        [_iconImageView layerWithCornerRadius:20 borderWidth:0 borderColor:nil];
        _iconImageView.contentMode=UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    return self;
}

@end
