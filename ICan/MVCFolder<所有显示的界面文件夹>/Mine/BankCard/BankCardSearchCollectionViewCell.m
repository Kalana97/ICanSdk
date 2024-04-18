//
//  BankCardSearchCollectionViewCell.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/13.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "BankCardSearchCollectionViewCell.h"

@interface BankCardSearchCollectionViewCell()
@property (nonatomic,strong)UIView *bgView;


@end

@implementation BankCardSearchCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setiupView];
    }
    return self;
}

-(void)setiupView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.bgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    
}


-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = UIColorBg243Color;
        _bgView.layer.cornerRadius = 5.0;
    }
    return _bgView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel centerLabelWithTitle:@"" font:14 color:UIColor153Color];
    }
    return _nameLabel;
}



@end
