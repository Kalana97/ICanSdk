//
//  UnFriendHeaderTipsView.m
//  CaiHongApp
//
//  Created by young on 10/6/2019.
//  Copyright © 2019 LIMAOHUYU. All rights reserved.
//

#import "UnFriendHeaderTipsView.h"
@interface UnFriendHeaderTipsView ()


@end

@implementation UnFriendHeaderTipsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(void)setUpView{
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.equalTo(@25);
        
    }];
    [self addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    [self addSubview:self.addFriendBtn];
    [self.addFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(self.mas_centerY);
    
    }];
    
}



-(void)addFriendAction{
    !self.addFriendBlock?:self.addFriendBlock();
}

-(DZIconImageView *)imageView{
    if (!_imageView) {
        _imageView=[[DZIconImageView alloc]init];
        ViewRadius(_imageView, 5);
    }
    return _imageView;
}
- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[UILabel leftLabelWithTitle:NSLocalizedString(@"UnFriendTips", 对方还不是你的通讯录) font:15 color:UIColorThemeMainTitleColor];
    }
    return _tipsLabel;
    
}

-(UIButton *)addFriendBtn{
    if (!_addFriendBtn) {
        _addFriendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_addFriendBtn addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
        [_addFriendBtn setTitle:@"加好友".icanlocalized forState:UIControlStateNormal];
        [_addFriendBtn setTitleColor:UIColorThemeMainColor forState:UIControlStateNormal];
        _addFriendBtn.titleLabel.font=[UIFont systemFontOfSize:14];

    }
    return _addFriendBtn;
}





@end
