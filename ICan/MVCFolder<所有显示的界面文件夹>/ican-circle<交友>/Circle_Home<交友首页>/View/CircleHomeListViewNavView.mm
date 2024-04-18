//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 20/5/2021
- File name:  CircleHomeListViewNavView.m
- Description:
- Function List:
*/
        

#import "CircleHomeListViewNavView.h"
#import "CircleMineViewController.h"
#import "CircleLikeOrDislikeListViewController.h"
#import "CircleEditMydDataViewController.h"
#import "CircleChatListViewController.h"
#import "WCDBManager+ChatList.h"
#import "CircleFllowOrBeFllowPageViewController.h"
@interface CircleHomeListViewNavView()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *leftArrowButton;
@property(nonatomic, strong) DZIconImageView *likeImageView;
@property(nonatomic, strong) UIControl *iconTapCon;
@property(nonatomic, strong) UIControl *fllowTapCon;
@property(nonatomic, strong) DZIconImageView *iconImageView;
@property(nonatomic, strong) UIControl *chatListTapCon;
@property(nonatomic, strong) UIImageView *chatListImageView;
@property(nonatomic, strong) UILabel *secretUnredLabel;

@end
@implementation CircleHomeListViewNavView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCircleUnreadCount) name:KChatListRefreshNotification object:nil];
        //监听清除交友消息 刷新未读数量
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCircleUnreadCount) name:kCleanCircleMessageNotificatiaon object:nil];
        [self getCircleUnreadCount];
    }
    return self;
}

-(UILabel *)secretUnredLabel{
    if (!_secretUnredLabel) {
        _secretUnredLabel=[UILabel centerLabelWithTitle:nil font:10 color:UIColor.whiteColor];
        _secretUnredLabel.backgroundColor=UIColor244RedColor;
        [_secretUnredLabel layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
        _secretUnredLabel.hidden=YES;
    }
    return _secretUnredLabel;
}
-(void)getCircleUnreadCount{
    NSInteger secretUnreadCount= [[WCDBManager sharedManager]fetchAllCircleUnReadNumberCount].integerValue;
    if (secretUnreadCount==0) {
        self.secretUnredLabel.hidden=YES;
    }else{
        self.secretUnredLabel.hidden=NO;
        if (secretUnreadCount > 9&&secretUnreadCount<=99) {
            [self.secretUnredLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@20);
                make.width.equalTo(@20);
                make.top.equalTo(self.chatListImageView.mas_top).offset(-7);
                make.left.equalTo(self.chatListImageView.mas_right).offset(-9);
            }];
            self.secretUnredLabel.text = [NSString stringWithFormat:@"%ld",(long)secretUnreadCount];
        }else if (secretUnreadCount > 99) {
            self.secretUnredLabel.text = @"··";
            [self.secretUnredLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@20);
                make.width.equalTo(@20);
                make.top.equalTo(self.chatListImageView.mas_top).offset(-7);
                make.left.equalTo(self.chatListImageView.mas_right).offset(-9);
            }];
            
        } else {
            [self.secretUnredLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@18);
                make.width.equalTo(@18);
                make.top.equalTo(self.chatListImageView.mas_top).offset(-7);
                make.left.equalTo(self.chatListImageView.mas_right).offset(-9);
            }];
            self.secretUnredLabel.text = [NSString stringWithFormat:@"%ld",(long)secretUnreadCount];
        }
    }
}
-(void)setUpView{
    self.backgroundColor=[UIColor whiteColor];
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
        make.width.height.equalTo(@25);
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
    }];
    [self addSubview:self.iconTapCon];
    [self.iconTapCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@45);
        make.height.equalTo(@44);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.centerX.equalTo(self.iconImageView.mas_centerX);
    }];
    [self addSubview:self.likeImageView];
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.right.equalTo(self.iconImageView.mas_left).offset(-17);
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
    }];
    [self addSubview:self.fllowTapCon];
    [self.fllowTapCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@45);
        make.centerX.equalTo(self.likeImageView.mas_centerX);
        make.height.equalTo(@44);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
    }];
    
    [self addSubview:self.chatListImageView];
    [self.chatListImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@22);
        make.height.equalTo(@20);
        make.right.equalTo(self.likeImageView.mas_left).offset(-15);
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
    }];
    [self addSubview:self.chatListTapCon];
    [self.chatListTapCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@45);
        make.centerX.equalTo(self.chatListImageView.mas_centerX);
        make.height.equalTo(@44);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
    }];
    [self addSubview:self.secretUnredLabel];
    [self.secretUnredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@7);
        make.top.equalTo(self.chatListImageView.mas_top);
        make.left.equalTo(self.chatListImageView.mas_right);
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateIcon) name:kUpdateCircleUserMessageNotificatiaon object:nil];
    [self updateIcon];
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel centerLabelWithTitle:@"CircleHomeListViewController.title".icanlocalized font:17 color:UIColor252730Color];
        _titleLabel.font=[UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}
-(UIControl *)fllowTapCon{
    if (!_fllowTapCon) {
        _fllowTapCon=[[UIControl alloc]init];
        _fllowTapCon.backgroundColor=UIColor.clearColor;
        [_fllowTapCon addTarget:self action:@selector(likeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fllowTapCon;
}
-(UIControl *)iconTapCon{
    if (!_iconTapCon) {
        _iconTapCon=[[UIControl alloc]init];
        _iconTapCon.backgroundColor=UIColor.clearColor;
        [_iconTapCon addTarget:self action:@selector(iconImageViewTap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconTapCon;
}
-(DZIconImageView *)likeImageView{
    if (!_likeImageView) {
        _likeImageView=[[DZIconImageView alloc]initWithImage:UIImageMake(@"icon_follow")];
        [_likeImageView addTap];
        @weakify(self);
        _likeImageView.tapBlock = ^{
            @strongify(self);
            [self likeButtonAction];
        };
        
    }
    return _likeImageView;
}
-(void)likeButtonAction{
    CircleFllowOrBeFllowPageViewController*vc=[[CircleFllowOrBeFllowPageViewController alloc]initWithCircleListType:CircleListType_ILike];
    [[AppDelegate shared]pushViewController:vc animated:YES];
    
}
-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.whiteColor titleFont:0 titleColor:UIColor.whiteColor target:self action:@selector(buttonAction)];
        [_leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_back_black") forState:UIControlStateNormal];
    }
    return _leftArrowButton;
}
-(void)buttonAction{
    [[AppDelegate shared].curNav popViewControllerAnimated:YES];
}
-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        [_iconImageView layerWithCornerRadius:11 borderWidth:0 borderColor:nil];
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconImageViewTap)];
        [_iconImageView addGestureRecognizer:tap];
        _iconImageView.userInteractionEnabled=YES;
      
        
    }
    return _iconImageView;
}
-(void)updateIcon{
    if (CircleUserInfoManager.shared.checkAvatar.length>0) {
        [self.iconImageView setCircleIconImageViewWithUrl:CircleUserInfoManager.shared.checkAvatar gender:CircleUserInfoManager.shared.gender];
    }else{
        [self.iconImageView setCircleIconImageViewWithUrl:CircleUserInfoManager.shared.avatar gender:CircleUserInfoManager.shared.gender];
    }
  
}
-(void)iconImageViewTap{
    CircleMineViewController*vc=[[CircleMineViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [[AppDelegate shared] pushViewController:vc animated:YES];
}
-(UIControl *)chatListTapCon{
    if (!_chatListTapCon) {
        _chatListTapCon=[[UIControl alloc]init];
        _chatListTapCon.backgroundColor=UIColor.clearColor;
        [_chatListTapCon addTarget:self action:@selector(goToCircleChatList) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatListTapCon;
}
-(UIImageView *)chatListImageView{
    if (!_chatListImageView) {
        _chatListImageView=[[UIImageView alloc]initWithImage:UIImageMake(@"icon_chat_1")];
    }
    return _chatListImageView;
}
-(void)goToCircleChatList{
    [[AppDelegate shared]pushViewController:[CircleChatListViewController new] animated:YES];
}
@end
