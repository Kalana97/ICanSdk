//
//  ReceiptRecordDetailHeaderView.m
//  ICan
//
//  Created by Limaohuyu666 on 2019/11/12.
//  Copyright © 2019 dzl. All rights reserved.
//

#import "ReceiptRecordDetailHeaderView.h"
@interface ReceiptRecordDetailHeaderView ()

@property (nonatomic,strong)UILabel * tranferTips;
@end

@implementation ReceiptRecordDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
    
}

-(void)setupView{
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.height.equalTo(@35);
        make.top.equalTo(@25);
    }];
    
    [self addSubview:self.namelabel];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.tranferTips];
    [self.tranferTips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.namelabel.mas_bottom).offset(10);
    }];
    
}


-(void)setInfo:(ReceiveFlowsInfo *)info{
    _info=info;
    self.tranferTips.text=[NSString stringWithFormat:@"￥%.2f",[info.money doubleValue]];;
    [self.iconImageView setDZIconImageViewWithUrl:self.info.payUserHeadImgUrl gender:self.info.payUserGender];
    self.namelabel.text=self.info.payUserNickname;
}
-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [DZIconImageView new];
        ViewRadius(_iconImageView, 18);
        [_iconImageView setImage:UIImageMake(BoyDefault)];
    }
    return _iconImageView;
}

-(UILabel *)namelabel{
    if (!_namelabel) {
        _namelabel= [UILabel centerLabelWithTitle:@"" font:16 color:UIColorThemeMainSubTitleColor];
    }
    return _namelabel;
}
-(UILabel *)tranferTips{
    if (!_tranferTips) {
        _tranferTips = [UILabel leftLabelWithTitle:@"" font:14 color:UIColorThemeMainTitleColor];
        
    }
    return _tranferTips;
}



@end
