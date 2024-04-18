
#import "NewFriendsTableViewCell.h"

#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
@interface NewFriendsTableViewCell ()
@property (nonatomic,strong)  DZIconImageView *headerImageView;
@property (nonatomic,strong)  UILabel *nameLab;
@property (nonatomic,strong)  UILabel *friendInfoLab;
@property (nonatomic,strong)  UILabel *resultLab;
@property (nonatomic,strong)  UIButton *refuseBtn;
@property (nonatomic,strong)  UIButton *agreeBtn;


@end
@implementation NewFriendsTableViewCell
-(void)setUpUI {
    [super setUpUI];
    self.contentView.backgroundColor = UIColorViewBgColor;
    [self addSubview:self.headerImageView];
    [self addSubview:self.friendInfoLab];
    [self addSubview:self.nameLab];
    [self addSubview:self.refuseBtn];
    [self addSubview:self.agreeBtn];
    [self addSubview:self.resultLab];
    self.resultLab.hidden = YES;
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@15);
        make.width.height.equalTo(@60);
    }];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(20);
        make.top.equalTo(@15);
        make.right.equalTo(@-20);
    }];
    [self.friendInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(7);
        make.right.equalTo(@(-10));
        make.height.equalTo(@15);
        make.left.equalTo(self.headerImageView.mas_right).offset(20);
    }];
    //110
    
    [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.width.equalTo(@((ScreenWidth-110)/2.0-30));
        make.bottom.equalTo(@-10);
        make.height.equalTo(@30);
    }];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.refuseBtn.mas_left).offset(-10);
        make.width.equalTo(@((ScreenWidth-110)/2.0+30));
        make.bottom.equalTo(@-10);
        make.height.equalTo(@30);
        
    }];
    [self.resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.refuseBtn.mas_left).offset(-10);
        make.width.equalTo(@((ScreenWidth-110)/2.0+30));
        make.bottom.equalTo(@-10);
        make.height.equalTo(@30);
    }];
    
}
-(void)refuseBtnClick {
    if (self.refuseSucessBlock) {
        self.refuseSucessBlock();
    }
}

-(void)agreeBtnClick {
    if (self.friendSubscriptionInfo.isCanClick) {
        return;
    }
    self.friendSubscriptionInfo.isCanClick=YES;
    if (self.agreeSucessBlock) {
        self.agreeSucessBlock();
    }
}

-(void)setFriendSubscriptionInfo:(FriendSubscriptionInfo *)friendSubscriptionInfo{
    _friendSubscriptionInfo = friendSubscriptionInfo;
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:friendSubscriptionInfo.sender successBlock:^(UserMessageInfo * _Nonnull info) {
        friendSubscriptionInfo.showName=info.nickname;
        self.nameLab.text=info.nickname;
        if(info.nickname != nil || friendSubscriptionInfo.sender != nil){
            [[WCDBManager sharedManager]updateFriendSubscriptionShowName:info.nickname withSender:friendSubscriptionInfo.sender];
        }
        [self.headerImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
    }];
  
    self.friendInfoLab.text=friendSubscriptionInfo.message;
    if (friendSubscriptionInfo.subscriptionType == 0) {
        self.resultLab.hidden = NO;
        self.refuseBtn.hidden = YES;
        self.agreeBtn.hidden = YES;
        self.friendInfoLab.text =  NSLocalizedString(@"RefuseTips", 你已拒绝添加对方为好友);
        [self.resultLab setText:@"Rejected".icanlocalized];
    } else if (friendSubscriptionInfo.subscriptionType == 1){
        self.resultLab.hidden = NO;
        self.refuseBtn.hidden = YES;
        self.agreeBtn.hidden = YES;
        [self.resultLab setText:NSLocalizedString(@"Accepted", 公认)];
        self.friendInfoLab.text = NSLocalizedString(@"AgreeTips", 你已同意添加对方为好友) ;
    } else if (friendSubscriptionInfo.subscriptionType == 2) {
        self.resultLab.hidden = YES;
        self.resultLab.hidden = YES;
        self.refuseBtn.hidden = NO;
        self.agreeBtn.hidden = NO;
    }
}
-(DZIconImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView=[[DZIconImageView alloc]init];
        [_headerImageView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    }
    return _headerImageView;
}
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab=[UILabel leftLabelWithTitle:@"" font:16 color:UIColorThemeMainTitleColor];
        
    }
    return _nameLab;
}
-(UIButton *)refuseBtn{
    if (!_refuseBtn) {
        _refuseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_refuseBtn setTitle:NSLocalizedString(@"Reject", 拒绝) forState:UIControlStateNormal];
        _refuseBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _refuseBtn.backgroundColor=UIColor10PxClearanceBgColor;
        [_refuseBtn setTitleColor:UIColorThemeMainTitleColor forState:UIControlStateNormal];
        [_refuseBtn addTarget:self action:@selector(refuseBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_refuseBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
    }
    return _refuseBtn;
}
-(UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn setTitle:NSLocalizedString(@"Accept", 接受) forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        _agreeBtn.backgroundColor= UIColorThemeMainColor;
        [_agreeBtn setTitleColor:UIColorViewBgColor forState:UIControlStateNormal];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_agreeBtn layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
        
    }
    return _agreeBtn;
}
-(UILabel *)resultLab{
    if (!_resultLab) {
        _resultLab=[UILabel centerLabelWithTitle:@"" font:12 color:UIColorThemeMainSubTitleColor];
        _resultLab.backgroundColor=UIColor10PxClearanceBgColor;
        [_resultLab layerWithCornerRadius:15 borderWidth:0 borderColor:nil];
        
    }
    return _resultLab;
}

-(UILabel *)friendInfoLab{
    if (!_friendInfoLab) {
        _friendInfoLab = [UILabel leftLabelWithTitle:NSLocalizedString(@"AddFriendTips", 对方请求加你为好友) font:13 color:UIColorThemeMainSubTitleColor];
    }
    return _friendInfoLab;
}
@end
