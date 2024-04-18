//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 31/3/2020
- File name:  SendRedEnvelopeNavView.m
- Description:
- Function List:
*/
        

#import "SendRedEnvelopeNavView.h"
@interface SendRedEnvelopeNavView()
//@property(nonatomic, strong) UIButton *cancleButton;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *moreButton;
@property(nonatomic, strong) UILabel *cancleLabel;
@end
@implementation SendRedEnvelopeNavView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = UIColorViewBgColor;
        //64 88
        [self addSubview:self.cancleLabel];
        [self.cancleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@20);
            make.height.equalTo(@44);
        }];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.left.equalTo(@20);
            make.height.equalTo(@44);
            make.centerX.equalTo(self.mas_centerX);
        }];
        [self addSubview:self.moreButton];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.right.equalTo(@-20);
            make.height.equalTo(@44);
//            make.width.equalTo(@80);
            
        }];
    }
    return self;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        //Send Red Packet 
        _titleLabel=[UILabel centerLabelWithTitle:NSLocalizedString(@"SendRedPacket", 发红包) font:19 color:UIColorThemeMainTitleColor];
    }
    return _titleLabel;
}
-(UILabel *)cancleLabel{
    if (!_cancleLabel) {
        _cancleLabel=[UILabel leftLabelWithTitle:@"UIAlertController.cancel.title".icanlocalized font:16 color:UIColorThemeMainTitleColor];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
        _cancleLabel.userInteractionEnabled=YES;
        [_cancleLabel addGestureRecognizer:tap];
    }
    return _cancleLabel;
}
-(void)cancelAction{
    !self.buttonBlock?:self.buttonBlock(100);
}

-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton=[UIButton dzButtonWithTitle:@"" image:@"icon_nav_more_black" backgroundColor:UIColor.clearColor titleFont:16 titleColor:UIColorThemeMainTitleColor target:self action:@selector(buttonAction:)];
        _moreButton.tag=101;
        [_moreButton sizeToFit];
        [_moreButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _moreButton;
}
-(void)buttonAction:(UIButton*)button{
    !self.buttonBlock?:self.buttonBlock(button.tag);
}
@end
