//
//  BusinessNavBarView.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-15.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessNavBarView.h"
#import "BussinessInfoManager.h"
#import "BusinessMineViewController.h"

@interface BusinessNavBarView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftArrowButton;
@property (nonatomic, strong) DZIconImageView *iconImageView;
@end

@implementation BusinessNavBarView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftArrowButton];
    [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@17);
        make.height.equalTo(@17);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-13.5);
    }];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
        make.centerX.equalTo(self);
    }];
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateIcon) name:kUpdateBusinessIconNotificatiaon object:nil];
    [self updateIcon];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel centerLabelWithTitle:@"Business Profile".icanlocalized font:17 color:UIColor252730Color];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}

-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.whiteColor titleFont:0 titleColor:UIColor.whiteColor target:self action:@selector(buttonAction)];
        [_leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_back_black") forState:UIControlStateNormal];
    }
    return _leftArrowButton;
}

-(void)buttonAction{
    [[AppDelegate shared].curNav popViewControllerAnimated:YES];
}

-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[DZIconImageView alloc]init];
        [_iconImageView layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconImageViewTap)];
        [_iconImageView addGestureRecognizer:tap];
        _iconImageView.userInteractionEnabled = YES;
    }
    return _iconImageView;
}

-(void)updateIcon{
    if (BussinessInfoManager.shared.checkAvatar.length > 0) {
        [self.iconImageView setCircleIconImageViewWithUrl:BussinessInfoManager.shared.checkAvatar gender:@""];
    }else{
        [self.iconImageView setCircleIconImageViewWithUrl:BussinessInfoManager.shared.avatar gender:@""];
    }
}

-(void)iconImageViewTap{
    if(!BussinessInfoManager.shared.enable){
        [UIAlertController alertControllerWithTitle:@"Your business account has been restricted.Please contact the administrator.".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        }];
        return;
    }
    if(BussinessInfoManager.shared.deleted){
        [UIAlertController alertControllerWithTitle:@"Your account has been removed.Please contact the administrator.".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        }];
        return;
    }    
    BusinessMineViewController *vc = [[BusinessMineViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [[AppDelegate shared] pushViewController:vc animated:YES];
}
@end
