//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 31/12/2019
 - File name:  GroupDetailNavBarView.m
 - Description:
 - Function List:
 */


#import "GroupDetailNavBarView.h"
@interface GroupDetailNavBarView()



@end

@implementation GroupDetailNavBarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.backgroundColor= UIColorThemeMainBgColor;
    }
    return self;
}
-(void)setUpView{
    [self addSubview:self.leftArrowButton];
    [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@17);
        make.height.equalTo(@17);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-13.5);
    }];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftArrowButton.mas_right).offset(10);
        make.top.equalTo(self.leftArrowButton.mas_top);
        make.right.equalTo(@-37);
    }];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=UIColorBg243Color;
    }
    return _lineView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel centerLabelWithTitle:nil font:17 color:UIColorThemeMainTileColor];
        _nameLabel.font=[UIFont boldSystemFontOfSize:17];
        _nameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.whiteColor target:self action:@selector(buttonAction)];
        //icon_nav_return
        [_leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_return") forState:UIControlStateNormal];
        _leftArrowButton.tag=0;
    }
    return _leftArrowButton;
}
-(void)buttonAction{
    if (self.buttonBlock) {
        self.buttonBlock();
    }
}
@end
