//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 2/6/2020
- File name:  ChatViewReplyView.m
- Description:
- Function List:
*/
        

#import "ChatViewReplyView.h"

@implementation ChatViewReplyView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=UIColor.clearColor;
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.bottom.equalTo(@0);
        }];
        [self.bgView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@24);
            make.centerY.equalTo(self.bgView.mas_centerY);
            make.right.equalTo(@-15);
        }];
        [self.bgView addSubview:self.leftBoderView];
        [self.leftBoderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.bgView.mas_height);
            make.left.equalTo(self.bgView.mas_left);
            make.width.equalTo(@4);
            make.centerY.equalTo(self.bgView.mas_centerY);
        }];
        [self.bgView addSubview:self.replyTitleLabel];
        [self.replyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@15);
            make.right.equalTo(self.cancelButton.mas_left).offset(-10);
        }];
        
        [self.bgView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.right.equalTo(self.cancelButton.mas_left).offset(-10);
            make.top.equalTo(self.replyTitleLabel.mas_bottom).offset(5);
        }];
    }
    return self;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]init];
        [_bgView layerWithCornerRadius:0 borderWidth:0 borderColor:nil];
        _bgView.layer.borderColor = [UIColor qmui_colorWithHexString:@"#228CE9"].CGColor;
        _bgView.layer.borderWidth = 0.5;
        _bgView.backgroundColor = UIColorMakeHEXCOLOR(0xE6F0FF);
    }
    return _bgView;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[UILabel leftLabelWithTitle:nil font:12.5 color:UIColor153Color];
    }
    return _contentLabel;
}

-(UILabel *)replyTitleLabel {
    if(!_replyTitleLabel) {
        _replyTitleLabel = [[UILabel alloc]init];
        _replyTitleLabel.textColor = UIColorMakeHEXCOLOR(0x266ECF);
        [_replyTitleLabel setFont:[UIFont qmui_systemFontOfSize:15 weight:QMUIFontWeightBold italic:YES]];
    }
    return _replyTitleLabel;
}

-(UIView *)leftBoderView {
    if(!_leftBoderView) {
        _leftBoderView = [[UIView alloc]init];
        _leftBoderView.backgroundColor = UIColorMakeHEXCOLOR(0x266ECF);

    }
    return _leftBoderView;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton=[UIButton dzButtonWithTitle:nil image:@"icon_close_reply" backgroundColor:UIColor.clearColor titleFont:10 titleColor:nil target:self action:@selector(cancelButtonAction)];
    }
    return _cancelButton;
}
-(void)cancelButtonAction{
    self.hidden=YES;
    !self.cancelBlock?:self.cancelBlock();
}
@end
