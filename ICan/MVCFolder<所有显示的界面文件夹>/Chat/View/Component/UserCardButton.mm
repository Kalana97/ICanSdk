//
//  RecommendUserInfoCardTableViewCell.m
//  OneChatAPP
//
//  Created by mac on 2017/11/8.
//  Copyright © 2017年 DW. All rights reserved.
//

#import "UserCardButton.h"
#import "UIImage+colorImage.h"
#import "WCDBManager+UserMessageInfo.h"
#import "FriendDetailViewController.h"
#import "ChatModel.h"
@interface UserCardButton ()

// 头像
@property (nonatomic, strong) DZIconImageView *iconImageView;

@property (nonatomic, strong) UILabel *nickNameLb;

@property (nonatomic, strong) UILabel *userIdLb;

@property (nonatomic, strong) UILabel *desLabel;

@property(nonatomic,strong) UIView *lineView;

@property(nonatomic,strong) UILabel *timeLabelDown;


@end

@implementation UserCardButton
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=UIColorBg243Color;
    [self layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
    [self initUI];
    [self addTarget:self action:@selector(toFriendDetail) forControlEvents:UIControlEventTouchUpInside];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor=UIColorBg243Color;
        [self layerWithCornerRadius:5 borderWidth:0 borderColor:nil];
        [self initUI];
        [self addTarget:self action:@selector(toFriendDetail) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


-(void)setChatModel:(ChatModel *)chatModel{
    _chatModel=chatModel;
    UserCardMessageInfo*info=[UserCardMessageInfo mj_objectWithKeyValues:chatModel.messageContent];
    self.nickNameLb.text = info.nickname;
    self.userIdLb.text=[NSString stringWithFormat:@"ID：%@",info.username];
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:info.userId successBlock:^(UserMessageInfo * _Nonnull messageInfo) {
        [self.iconImageView setDZIconImageViewWithUrl:messageInfo.headImgUrl gender:messageInfo.gender];
    }];
    NSDate*date=[GetTime dateConvertFromTimeStamp:self.chatModel.messageTime];
    self.timeLabelDown.text = [GetTime getTime:date];
    [self addSubview:self.timeLabelDown];
    [self.timeLabelDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@73);
        make.right.equalTo(@-8);
    }];
    
}
-(void)toFriendDetail{
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    FriendDetailViewController *friendDetailVC = [[FriendDetailViewController alloc]init];
    UserCardMessageInfo * info = [UserCardMessageInfo mj_objectWithKeyValues:self.chatModel.messageContent];
    friendDetailVC.userId = info.userId;
    friendDetailVC.friendDetailType=FriendDetailType_push;
    [[AppDelegate shared] pushViewController:friendDetailVC animated:YES];
}

- (void)initUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nickNameLb];
    [self addSubview:self.userIdLb];
    [self addSubview:self.desLabel];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.height.width.equalTo(@45);
    }];
    [self.nickNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.height.equalTo(@20);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(@-10);
    }];
    [self.userIdLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nickNameLb.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.height.equalTo(@20);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@1);
    }];
    
    
    [self addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@65);
        make.height.equalTo(@25);
    }];
    
}
-(UILabel *)nickNameLb{
    if (!_nickNameLb) {
        _nickNameLb = [UILabel leftLabelWithTitle:@"" font:15 color:UIColor252730Color];
    }
    return _nickNameLb;
}

-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        [_iconImageView layerWithCornerRadius:45/2 borderWidth:0 borderColor:nil];
    }
    return _iconImageView;
}
-(UILabel *)userIdLb{
    if (!_userIdLb) {
        _userIdLb=[UILabel leftLabelWithTitle:@"" font:12 color:UIColor102Color];
    }
    return _userIdLb;
}
-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel=[UILabel leftLabelWithTitle:nil font:10 color:UIColor153Color];
        _desLabel.text = @"chatView.function.contactCard".icanlocalized;
        
    }
    return _desLabel;
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorMake(230, 230, 230);
    }
    
    return _lineView;
}
-(UILabel *)timeLabelDown{
    if (!_timeLabelDown) {
        _timeLabelDown = [UILabel leftLabelWithTitle:nil font:10 color:UIColor.darkGrayColor];
    }
    return _timeLabelDown;
}
@end
