//
//  TimelinesHeaderView.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/4.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesHeaderView.h"
#import "FriendDetailViewController.h"
#import "HJCActionSheet.h"

@interface TimelinesHeaderView ()<HJCActionSheetDelegate>

@property(nonatomic,strong)DZIconImageView * iconImageView;
@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UIView * horizontalLineView;
@property(nonatomic,strong)UIView * verticalLineView1;
@property(nonatomic,strong)UIView * verticalLineView2;


@property(nonatomic,strong)UIView * videoBgView;
@property(nonatomic,strong)UIImageView * videoImageView;
@property(nonatomic,strong)UILabel * videoLabel;

@property(nonatomic,strong)UIView * shareBgView;
@property(nonatomic,strong)UIImageView * shareImageView;
@property(nonatomic,strong)UILabel * shareLabel;


@property(nonatomic,strong)UIView * friendsBgView;
@property(nonatomic,strong)UIImageView * friendsImageView;
@property(nonatomic,strong)UILabel * friendsLabel;
@property(nonatomic, strong) UIStackView * titleHorizontalStack;
@property(nonatomic, strong) UIStackView *typesContainingStack;
@property(nonatomic, strong) UIStackView *verticalStack;
@property(nonatomic, strong) UIButton *publishBtn;
@property(nonatomic, strong) UIView *titleContainer;
@property(nonatomic, strong) UIView *typesContainer;
@property(nonatomic, strong) UIView *lineView1;
@property(nonatomic, strong) UIView *lineView2;
@property(nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@property(nonatomic, strong)  NSArray *sheetItems;
@end

@implementation TimelinesHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.backgroundColor = [UIColor qmui_colorWithHexString:@"#F8F8F8"];
    [self addSubview:self.verticalStack];
    [self.verticalStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@5);
        make.right.equalTo(@-5);
        make.bottom.equalTo(@0);
    }];
    [self.verticalStack addArrangedSubview:self.titleContainer];
    [self.titleContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
    }];
    [self.titleContainer addSubview:self.titleHorizontalStack];
    [self.titleHorizontalStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.titleHorizontalStack addArrangedSubview:self.lineView1];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@2);
    }];
    [self.titleHorizontalStack addArrangedSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@72);
    }];
    [self.titleHorizontalStack addArrangedSubview:self.titleLabel];
    [self.titleHorizontalStack addArrangedSubview:self.publishBtn];
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
    }];
    [self.titleHorizontalStack addArrangedSubview:self.lineView2];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@15);
    }];
    [self.verticalStack addArrangedSubview:self.typesContainer];
    [self.typesContainer addSubview:self.typesContainingStack];
    [self.typesContainingStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.typesContainingStack addArrangedSubview:self.videoBgView];
    [self.videoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(@((ScreenWidth-34)/3));
    }];
    [self.typesContainingStack addArrangedSubview:self.shareBgView];
    [self.shareBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(@((ScreenWidth-34)/3));
    }];
    [self.typesContainingStack addArrangedSubview:self.friendsBgView];
    [self.friendsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.width.equalTo(@((ScreenWidth-34)/3));
    }];
    [self.videoBgView addSubview:self.videoLabel];
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.videoBgView.mas_centerY);
        make.centerX.equalTo(self.videoBgView.mas_centerX).offset(15);
    }];
    [self.videoBgView addSubview:self.videoImageView];
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self.videoBgView.mas_centerY);
        make.right.equalTo(self.videoLabel.mas_left).offset(-5);
    }];
    [self.shareBgView addSubview:self.shareLabel];
    [self.shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareBgView.mas_centerY);
        make.centerX.equalTo(self.shareBgView.mas_centerX).offset(15);
    }];
    [self.shareBgView addSubview:self.shareImageView];
    [self.shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self.shareBgView.mas_centerY);
        make.right.equalTo(self.shareLabel.mas_left).offset(-5);
    }];
    
    [self.friendsBgView addSubview:self.friendsLabel];
    [self.friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.friendsBgView.mas_centerY);
        make.centerX.equalTo(self.friendsBgView.mas_centerX).offset(15);
    }];
    [self.friendsBgView addSubview:self.friendsImageView];
    [self.friendsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22);
        make.centerY.equalTo(self.friendsBgView.mas_centerY);
        make.right.equalTo(self.friendsLabel.mas_left).offset(-5);
        
    }];
}

-(void)showHjcActionSheet{
    NSArray *array =
    @[@"chatView.function.video".icanlocalized,
      @"TimelineView.share".icanlocalized,
      @"friend.detail.listCell.Moments".icanlocalized];
    self.hjcActionSheet = [[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:array];
    [self.hjcActionSheet show];
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        if(self.publishVideoTapHandle){
            self.publishVideoTapHandle();
        }
    }else if(buttonIndex == 2){
        if(self.publishShareTapHandle){
            self.publishShareTapHandle();
        }
    }else if(buttonIndex == 3){
        if(self.publishFriendTapHandle){
            self.publishFriendTapHandle();
        }
    }else{
        return;
    }
}

-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[DZIconImageView alloc]init];
        ViewRadius(_iconImageView, 65/2);
        [_iconImageView setDZIconImageViewWithUrl:[UserInfoManager sharedManager].headImgUrl gender:[UserInfoManager sharedManager].gender];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_iconImageView addGestureRecognizer:tap1];
        
    }
    return _iconImageView;
}

-(void)tapAction{
    FriendDetailViewController * vc = [FriendDetailViewController new];
    vc.userId = [UserInfoManager sharedManager].userId;
    vc.friendDetailType=FriendDetailType_push;
    [[AppDelegate shared] pushViewController:vc animated:YES];
    
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel leftLabelWithTitle: NSLocalizedString(@"Share your mood at the moment?",分享你此刻的心情) font:17 color:UIColor252730Color];
    }
    return _titleLabel;
}

-(UIView *)horizontalLineView{
    if (!_horizontalLineView) {
        _horizontalLineView = [UIView new];
        _horizontalLineView.backgroundColor = UIColorMake(232, 231, 231);
    }
    
    return _horizontalLineView;
}

-(UIView *)verticalLineView1{
    if (!_verticalLineView1) {
        _verticalLineView1 = [UIView new];
        _verticalLineView1.backgroundColor = UIColorMake(232, 231, 231);
    }
    
    return _verticalLineView1;
}

-(UIView *)verticalLineView2{
    if (!_verticalLineView2) {
        _verticalLineView2 = [UIView new];
        _verticalLineView2.backgroundColor = UIColorMake(232, 231, 231);
    }
    
    return _verticalLineView2;
}

-(UIView *)videoBgView{
    if (!_videoBgView) {
        _videoBgView = [UIView new];
        _videoBgView.layer.cornerRadius = 5;
        _videoBgView.backgroundColor = UIColor.whiteColor;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoAction)];
        [_videoBgView addGestureRecognizer:tap];
    }
    
    return _videoBgView;
}

-(void)videoAction{
    if (self.videoTapHandle) {
        self.videoTapHandle();
    }
    
}

-(UIView *)shareBgView{
    if (!_shareBgView) {
        _shareBgView = [UIView new];
        _shareBgView.layer.cornerRadius = 5;
        _shareBgView.backgroundColor = UIColor.whiteColor;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareAction)];
        [_shareBgView addGestureRecognizer:tap];
    }
    
    return _shareBgView;
}

-(void)shareAction{
    if (self.shareTapHandle) {
        self.shareTapHandle();
    }
    
}

-(UIView *)friendsBgView{
    if (!_friendsBgView) {
        _friendsBgView = [UIView new];
        _friendsBgView.layer.cornerRadius = 5;
        _friendsBgView.backgroundColor = UIColor.whiteColor;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(friendAction)];
        [_friendsBgView addGestureRecognizer:tap];
    }
    
    return _friendsBgView;
}

-(void)friendAction{
    if (self.friendTapHandle) {
        self.friendTapHandle();
    }
    
}

-(UILabel *)videoLabel{
    if (!_videoLabel) {
        
        _videoLabel = [UILabel centerLabelWithTitle:@"chatView.function.video".icanlocalized font:16.0 color:UIColor252730Color];
    }
    
    return _videoLabel;
}

-(UILabel *)shareLabel{
    if (!_shareLabel) {
        
        _shareLabel = [UILabel centerLabelWithTitle:@"TimelineView.share".icanlocalized font:16.0 color:UIColor252730Color];
    }
    
    return _shareLabel;
}

-(UILabel *)friendsLabel{
    if (!_friendsLabel) {
//        friend.detail.listCell.Moments 朋友圈
        _friendsLabel = [UILabel centerLabelWithTitle:@"friend.detail.listCell.Moments".icanlocalized font:16.0 color:UIColor252730Color];
    }
    
    return _friendsLabel;
}


-(UIImageView *)videoImageView{
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_timeline_video"]];
        
    }
    
    return _videoImageView;
}

-(UIImageView *)shareImageView{
    if (!_shareImageView) {
        _shareImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_timeline_share"]];
    }
    
    return _shareImageView;
}


-(UIImageView *)friendsImageView{
    if (!_friendsImageView) {
        _friendsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_timeline_timeline"]];
    }
    
    return _friendsImageView;
}

-(UIStackView *)titleHorizontalStack{
    if (!_titleHorizontalStack) {
        _titleHorizontalStack = [[UIStackView alloc]init];
        _titleHorizontalStack.axis = UILayoutConstraintAxisHorizontal;
        _titleHorizontalStack.alignment = UIStackViewAlignmentCenter;
        _titleHorizontalStack.distribution = UIStackViewDistributionFill;
        _titleHorizontalStack.spacing = 10;
        _titleHorizontalStack.layer.cornerRadius = 10;
        _titleHorizontalStack.backgroundColor = UIColor.whiteColor;
        _titleHorizontalStack.userInteractionEnabled = YES;
    }
    return _titleHorizontalStack;
}

-(UIStackView *)typesContainingStack{
    if (!_typesContainingStack) {
        _typesContainingStack = [[UIStackView alloc]init];
        _typesContainingStack.axis = UILayoutConstraintAxisHorizontal;
        _typesContainingStack.alignment = UIStackViewAlignmentCenter;
        _typesContainingStack.spacing = 7;
        _typesContainingStack.userInteractionEnabled = YES;
    }
    return _typesContainingStack;
}

-(UIStackView *)verticalStack{
    if (!_verticalStack) {
        _verticalStack = [[UIStackView alloc]init];
        _verticalStack.axis = UILayoutConstraintAxisVertical;
        _verticalStack.spacing = 9;
        _verticalStack.userInteractionEnabled = YES;
    }
    return _verticalStack;
}

- (UIButton *)publishBtn {
    if (!_publishBtn) {
        UIButton * publishBtn = [[UIButton alloc] init];
        [publishBtn setImage:[UIImage imageNamed:@"icon_timline_nav_add"] forState:UIControlStateNormal];
        [publishBtn addTarget:self action:@selector(publicAction) forControlEvents:UIControlEventTouchUpInside];
        _publishBtn = publishBtn;
    }
    return _publishBtn;
}

-(UIView *)titleContainer{
    if(!_titleContainer){
        _titleContainer = [[UIView alloc]init];
    }
    return _titleContainer;
}

-(UIView *)typesContainer{
    if(!_typesContainer){
        _typesContainer = [[UIView alloc]init];
    }
    return _typesContainer;
}

-(UIView *)lineView1{
    if(!_lineView1){
        _lineView1 = [UIView new];
    }
    return _lineView1;
}

-(UIView *)lineView2{
    if(!_lineView2){
        _lineView2 = [UIView new];
    }
    return _lineView2;
}

-(void)publicAction{
    [self showHjcActionSheet];
}

@end
