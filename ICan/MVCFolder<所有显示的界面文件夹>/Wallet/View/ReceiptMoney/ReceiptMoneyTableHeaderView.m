//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 1/9/2020
 - File name:  ReceiptMoneyTableHeaderView.m
 - Description:
 - Function List:
 */


#import "ReceiptMoneyTableHeaderView.h"
#import "ReceiptRecordViewController.h"
@interface ReceiptMoneyTableHeaderView()
@property(nonatomic, strong) UIView *bgContView;

@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIImageView *topTipsImageView;
@property(nonatomic, strong) UILabel *topTipsLabel;
/** 扫一扫，向我付钱呦 */
@property(nonatomic, strong) UILabel *tipsLabel;



@property(nonatomic, strong) UIView *centerLineView;
@property(nonatomic, strong) UIButton *saveImageButton;

@property(nonatomic, strong) UIView *bottomLineView;

@property(nonatomic, strong) UIControl *bottomViewControl;
@property(nonatomic, strong) UIImageView *bottomTipsImgView;
@property(nonatomic, strong) UILabel *bottomTipsLabel;
@property(nonatomic, strong) UIImageView *rightArrowImageView;

@end
@implementation ReceiptMoneyTableHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=UIColor.clearColor;
        [self setUpView];
        
    }
    return self;
}
-(void)updateHasMoney{
    //30
    [self.tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(25);
        make.centerX.equalTo(self.bgContView.mas_centerX);
    }];
    [self.qrCodeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@160);
        make.top.equalTo(self.topView.mas_bottom).offset(100);
        make.centerX.equalTo(self.bgContView.mas_centerX);
    }];
    
    [self.bgContView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@425);
    }];
}

-(void)setUpView{
    [self addSubview:self.bgContView];
    [self.bgContView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@400);
    }];
    [self.bgContView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@50);
    }];
    [self.topView addSubview:self.topTipsImageView];
    [self.topTipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.topView.mas_centerY);
        make.width.height.equalTo(@15);
    }];
    [self.topView addSubview:self.topTipsLabel];
    [self.topTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topTipsImageView.mas_right).offset(5);
        make.centerY.equalTo(self.topTipsImageView.mas_centerY);
    }];
    [self.saveImageButton sizeToFit];
    CGFloat saveWidth=self.saveImageButton.bounds.size.width;
    [self.settingMoneyButton sizeToFit];
    CGFloat setWidth=self.settingMoneyButton.bounds.size.width;
    
    [self.bgContView addSubview:self.tipsLabel];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(50);
        make.centerX.equalTo(self.bgContView.mas_centerX);
    }];
    
    //30+10
    [self.bgContView addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgContView.mas_centerX);
        make.top.equalTo(self.topView.mas_bottom).offset(50);
    }];
    
    [self.bgContView addSubview:self.qrCodeImageView];
    [self.qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@140);
        make.top.equalTo(self.topView.mas_bottom).offset(75);
        make.centerX.equalTo(self.bgContView.mas_centerX);
    }];
    [self.bgContView addSubview:self.centerLineView];
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgContView.mas_centerX);
        make.top.equalTo(self.qrCodeImageView.mas_bottom).offset(20);
        make.height.equalTo(@15);
        make.width.equalTo(@1);
    }];
    [self.bgContView addSubview:self.settingMoneyButton];
    [self.settingMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerLineView.mas_left).offset(-20);
        make.height.equalTo(@15);
        make.width.equalTo(@(setWidth));
        make.centerY.equalTo(self.centerLineView.mas_centerY);
    }];
    [self.bgContView addSubview:self.saveImageButton];
    
    [self.saveImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerLineView.mas_right).offset(20);
        make.height.equalTo(@15);
        make.width.equalTo(@(saveWidth));
        make.centerY.equalTo(self.centerLineView.mas_centerY);
    }];
    [self.bgContView addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@1);
        make.bottom.equalTo(@-50);
    }];
    
    [self.bgContView addSubview:self.bottomViewControl];
    [self.bottomViewControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(@0);
        make.height.equalTo(@50);
    }];
    [self.bottomViewControl addSubview:self.bottomTipsImgView];
    [self.bottomTipsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.bottomViewControl.mas_centerY);
        make.width.height.equalTo(@15);
    }];
    [self.bottomViewControl addSubview:self.bottomTipsLabel];
    [self.bottomTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomTipsImgView.mas_right).offset(5);
        make.centerY.equalTo(self.bottomViewControl.mas_centerY);
    }];
    [self.bottomViewControl addSubview:self.rightArrowImageView];
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.bottomViewControl.mas_centerY);
        make.width.height.equalTo(@13);
        
    }];
    
}
-(UIView *)bgContView{
    if (!_bgContView) {
        _bgContView=[[UIView alloc]init];
        _bgContView.backgroundColor=UIColorViewBgColor;
        [_bgContView layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
    }
    return _bgContView;
}
-(UIView *)topView{
    if (!_topView) {
        _topView=[[UIView alloc]init];
        _topView.backgroundColor=UIColor10PxClearanceBgColor;
        UIBezierPath *addmaskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth-20, 50) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(7,7)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame =CGRectMake(0, 0, ScreenWidth-20, 50);
        maskLayer.path = addmaskPath.CGPath;
        _topView.layer.mask = maskLayer;
    }
    return _topView;
}
-(UIImageView *)topTipsImageView{
    if (!_topTipsImageView) {
        _topTipsImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_wallet_collection_qrode_black")];
    }
    return _topTipsImageView;
}
-(UILabel *)topTipsLabel{
    if (!_topTipsLabel) {
        _topTipsLabel=[UILabel leftLabelWithTitle:@"QRCodeCollection".icanlocalized font:15 color:UIColorThemeMainTitleColor];
    
    }
    return _topTipsLabel;
}

-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[UILabel centerLabelWithTitle:@"Scan to pay".icanlocalized font:12 color:UIColorThemeMainTitleColor];
    }
    return _tipsLabel;
}
-(UIImageView *)qrCodeImageView{
    if (!_qrCodeImageView) {
        _qrCodeImageView=[[UIImageView alloc]init];
    }
    return _qrCodeImageView;
}
-(UIButton *)settingMoneyButton{
    if (!_settingMoneyButton) {
        _settingMoneyButton=[UIButton dzButtonWithTitle:@"Set Amount" image:nil backgroundColor:UIColor.clearColor titleFont:15 titleColor:UIColorThemeMainColor target:self action:@selector(settingMoneyButtonAction)];
        [_settingMoneyButton setTitle:@"Set Amount".icanlocalized forState:UIControlStateNormal];
        
        
    }
    return _settingMoneyButton;
}
-(void)settingMoneyButtonAction{
    if (self.settingMoneyButton.isSelected) {
        [_settingMoneyButton setTitle:@"Set Amount".icanlocalized forState:UIControlStateNormal];
        self.moneyLabel.hidden=YES;
        !self.clearMoneyBlock?:self.clearMoneyBlock();
        [self.qrCodeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@140);
            make.top.equalTo(self.topView.mas_bottom).offset(75);
            make.centerX.equalTo(self.bgContView.mas_centerX);
        }];
        [self.bgContView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.height.equalTo(@400);
        }];
    }else{
        [_settingMoneyButton setTitle:@"Clear Amount".icanlocalized forState:UIControlStateNormal];
        !self.settingMoneyBlock?:self.settingMoneyBlock();
    }
    self.settingMoneyButton.selected=!self.settingMoneyButton.selected;
    [self.settingMoneyButton sizeToFit];
    CGFloat setWidth=self.settingMoneyButton.bounds.size.width;
    [self.settingMoneyButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerLineView.mas_left).offset(-20);
        make.height.equalTo(@15);
        make.width.equalTo(@(setWidth));
        make.centerY.equalTo(self.centerLineView.mas_centerY);
    }];
}
-(UIButton *)saveImageButton{
    if (!_saveImageButton) {
        _saveImageButton=[UIButton dzButtonWithTitle:@"Save Image".icanlocalized image:nil backgroundColor:UIColor.clearColor titleFont:15 titleColor:UIColorThemeMainColor target:self action:@selector(saveImageButtonAction)];
    }
    return _saveImageButton;
}
-(void)saveImageButtonAction{
    if (self.saveQrImageBlock) {
        self.saveQrImageBlock();
    }
    
    
}
-(UIView *)centerLineView{
    if (!_centerLineView) {
        _centerLineView=[[UIView alloc]init];
        _centerLineView.backgroundColor=UIColorSeparatorColor;
    }
    return _centerLineView;
}

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView=[[UIView alloc]init];
        _bottomLineView.backgroundColor=UIColorSeparatorColor;
    }
    return _bottomLineView;
}
-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel=[UILabel centerLabelWithTitle:@"" font:26 color:UIColorThemeMainTitleColor];
    }
    return _moneyLabel;
}
-(UIControl *)bottomViewControl{
    if (!_bottomViewControl) {
        _bottomViewControl=[[UIControl alloc]init];
        _bottomViewControl.backgroundColor=UIColorViewBgColor;
        [_bottomViewControl addTarget:self action:@selector(toBillList) forControlEvents:UIControlEventTouchUpInside];
        UIBezierPath *addmaskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth-20, 50) byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(7,7)];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame =CGRectMake(0, 0, ScreenWidth-20, 50);
        maskLayer.path = addmaskPath.CGPath;
        _bottomViewControl.layer.mask = maskLayer;
    }
    return _bottomViewControl;
}
-(void)toBillList{
    ReceiptRecordViewController*vc=[[ReceiptRecordViewController alloc]init];
    [[AppDelegate shared]pushViewController:vc animated:YES];
}
-(UIImageView *)bottomTipsImgView{
    if (!_bottomTipsImgView) {
        _bottomTipsImgView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_scan_record")];
    }
    return _bottomTipsImgView;
}
-(UILabel *)bottomTipsLabel{
    if (!_bottomTipsLabel) {
        _bottomTipsLabel=[UILabel leftLabelWithTitle:@"Collection records".icanlocalized font:15 color:UIColorThemeMainTitleColor];
    }
    return _bottomTipsLabel;
}
-(UIImageView *)rightArrowImageView{
    if (!_rightArrowImageView) {
        _rightArrowImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_arrow_right")];
    }
    return _rightArrowImageView;
}
@end
