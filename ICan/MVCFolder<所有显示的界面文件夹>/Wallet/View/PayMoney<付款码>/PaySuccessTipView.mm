//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 3/9/2020
- File name:  PaySuccessTipView.m
- Description:
- Function List:
*/
        

#import "PaySuccessTipView.h"
#import "WCDBManager+UserMessageInfo.h"
@interface PaySuccessTipView()
@property(nonatomic, strong) DZIconImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;


@end
@implementation PaySuccessTipView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=UIColor.whiteColor;
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@75);
            make.centerX.equalTo(self);
            make.top.equalTo(@50);
        }];
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(15);
            make.left.equalTo(@90);
            make.right.equalTo(@-90);
        }];
        [self addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(20);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}
-(void)setUserId:(NSString *)userId{
    _userId=userId;
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userId successBlock:^(UserMessageInfo * _Nonnull info) {
        [self.iconImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
        self.nameLabel.text=[NSString stringWithFormat:@"向%@成功支付了",info.remarkName?:info.nickname];
    }];
    
}
-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        [_iconImageView layerWithCornerRadius:75/2 borderWidth:0 borderColor:nil];
    }
    return _iconImageView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel centerLabelWithTitle:nil font:16 color:UIColor252730Color];
        _nameLabel.numberOfLines=0;
    }
    return _nameLabel;
}
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel=[UILabel centerLabelWithTitle:nil font:40 color:UIColor252730Color];
        _amountLabel.font=[UIFont boldSystemFontOfSize:40];
    }
    return _amountLabel;
}
@end
