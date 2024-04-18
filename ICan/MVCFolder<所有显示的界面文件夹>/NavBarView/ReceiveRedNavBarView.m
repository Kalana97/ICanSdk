//
//  ReceiveRedNavBarView.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/4/2.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "ReceiveRedNavBarView.h"
@interface ReceiveRedNavBarView()
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) UIButton *leftButton;
@end

@implementation ReceiveRedNavBarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.backgroundColor = UIColorMake(243, 85, 68);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(@0);
        make.height.equalTo(@44);
    }];
    
    [self addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.width.equalTo(@20);
    }];
    
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.width.equalTo(@20);
    }];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel leftLabelWithTitle:nil font:19 color:UIColorMake(255, 217, 177)];
    }
    return _titleLabel;
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton dzButtonWithTitle:nil image:@"icon_red_more" backgroundColor:nil titleFont:0 titleColor:nil target:self action:@selector(rightButtonAction)];
    }
    return _rightButton;
}

-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton=[UIButton dzButtonWithTitle:nil image:@"icon_nav_back_big_white" backgroundColor:nil titleFont:0 titleColor:nil target:self action:@selector(leftButtonAction)];
    }
    return _leftButton;
}

-(void)leftButtonAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navBarLeftReturnAction)]) {
        [self.delegate navBarLeftReturnAction];
    }
    
}

-(void)rightButtonAction{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navBarRightMoreAction)]) {
        [self.delegate navBarRightMoreAction];
    }
    
}


@end
