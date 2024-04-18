//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 14/4/2020
 - File name:  VersionAlertView.m
 - Description:
 - Function List:
 */


#import "VersionAlertView.h"
@interface VersionAlertView()
/** 关闭 */
@property (strong, nonatomic) UIButton * closeButton;
/** 背景imageView*/
@property (strong, nonatomic)  UIImageView *backGroundImgView;
/** 更新内容label */
@property(nonatomic, strong) UILabel *contentLabel;
/** 升级button */
@property(nonatomic, strong) UIButton *upgradeButton;
/** 版本号 */
@property(nonatomic, strong) UILabel *versionLabel;
@end
@implementation VersionAlertView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        self.backgroundColor=UIColorMakeWithRGBA(0, 0, 0, 0.5);
    }
    return self;
}

-(void)setVersionsInfo:(VersionsInfo *)versionsInfo{
    if (versionsInfo.forced == YES){
        self.versionLabel.text = @"Update required".icanlocalized;
        self.contentLabel.text= @"An update required to continue.".icanlocalized;
        self.closeButton.hidden = YES;
    }else{
        self.versionLabel.text = @"Update Available".icanlocalized;
        self.contentLabel.text= @"A newer version of the app is now available".icanlocalized;
        self.closeButton.hidden = NO;
    }
    [self.upgradeButton setTitle:@"Update button alert".icanlocalized forState:UIControlStateNormal];
}

-(void)setUpView{
    [self addSubview:self.backGroundImgView];
    [self.backGroundImgView addSubview:self.versionLabel];
    [self.backGroundImgView addSubview:self.contentLabel];
    [self.backGroundImgView addSubview:self.upgradeButton];
    [self addSubview:self.closeButton];
    
    [self.backGroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@450);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@180);
        make.left.equalTo(@60);
        
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@210);
        make.left.equalTo(@60);
        make.right.equalTo(@-60);
        
    }];
   
    [self.upgradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@75);
        make.right.equalTo(@-75);
        make.height.equalTo(@45);
        make.bottom.equalTo(@-75);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.top.equalTo(self.backGroundImgView.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
    }];
}
-(UIButton *)upgradeButton{
    if (!_upgradeButton) {
        _upgradeButton=[UIButton functionButtonWithTitle:@"立刻升级" image:nil backgroundColor:UIColorThemeMainColor titleFont:15 target:self action:@selector(upgradeButtonAction)];
        _upgradeButton.tag=102;
        [_upgradeButton layerWithCornerRadius:22.5 borderWidth:0 borderColor:nil];

    }
    return _upgradeButton;
}
-(void)upgradeButtonAction{
    if([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/ican-%E6%88%91%E8%A1%8C/id1466628262"]];
    }else {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://apps.apple.com/lk/app/icanchat/id1620128121"]];
    }
}

-(UIImageView *)backGroundImgView{
    if (!_backGroundImgView) {
        _backGroundImgView=[[UIImageView alloc]init];
        _backGroundImgView.image=[UIImage imageNamed:@"icon_update_bg"];
        _backGroundImgView.userInteractionEnabled=YES;
    }
    return _backGroundImgView;
}
-(UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [_closeButton addTarget:self action:@selector(hiddenVersionAlertView) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setBackgroundImage:[[UIImage imageNamed:@"icon_close_circle_white"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:UIControlStateNormal];
        
    }
    return _closeButton;
}
-(UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel=[UILabel leftLabelWithTitle:@"系统版本更新" font:16 color:UIColor252730Color];
//        19 132 255 蓝色字体
    }
    return _versionLabel;
}
-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[UILabel leftLabelWithTitle:@"更新内容" font:16 color:UIColor102Color];
        _contentLabel.numberOfLines=5;
    }
    return _contentLabel;
}
- (void)showVersionAlertView {
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
}
-(void)hiddenVersionAlertView{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"showAnnouncementsViewNotication" object:nil userInfo:nil];
    [self removeFromSuperview];
}
@end
