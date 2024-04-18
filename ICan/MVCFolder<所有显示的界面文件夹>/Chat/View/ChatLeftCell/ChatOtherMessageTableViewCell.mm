
//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 15/11/2021
 - File name:  ChatOtherContentTableViewCell.m
 - Description:
 - Function List:
 */


#import "ChatOtherMessageTableViewCell.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+CircleUserInfo.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "ChatTransferButton.h"
#import "FileMessageBtn.h"
#import "LocationInfoBtn.h"
#import "UserCardButton.h"
#import "RedPacketContentImageView.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import "ReactionBar.h"

@interface ChatOtherMessageTableViewCell()<UITextViewDelegate>
@property(nonatomic,strong) ChatModel *  currentChatModel;
//时间背景view
@property(nonatomic,weak) IBOutlet UIView * timeLabelBgView;
@property(weak, nonatomic) IBOutlet UIView *timeLineView;
@property(nonatomic,weak) IBOutlet UILabel * timeLabel;
//头像
@property(nonatomic,weak) IBOutlet DZIconImageView * iconImageView;
//昵称背景
@property(nonatomic,weak) IBOutlet UIView * nameLabelBgView;
//昵称
@property(nonatomic,weak) IBOutlet UILabel * nameLabel;


/** 处于多选状态的时候 显示在最顶层的View */
@property(nonatomic,strong)  UIControl *multipleSelectionTapView;
/** 多选的button */
@property(weak, nonatomic) IBOutlet UIStackView *multipleStackView;

@property(nonatomic,weak) IBOutlet UIButton *multipleSelectButton;
@property (weak, nonatomic) IBOutlet UIView *mutipleFirstLineView;
//转账
@property (weak, nonatomic) IBOutlet ChatTransferButton *transferButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transferButtonWidth;

//定位
@property (weak, nonatomic) IBOutlet LocationInfoBtn *locationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationButtonWidth;
//名片
@property (weak, nonatomic) IBOutlet UserCardButton *usercardButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usercardButtonWidth;
//红包
@property (weak, nonatomic) IBOutlet RedPacketContentImageView *redpacketButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redpacketWidth;
@property(strong, nonatomic) ReactionBar *reactionBar;
@property (weak, nonatomic) IBOutlet UIView *locationBgCover;
@property (weak, nonatomic) IBOutlet UIView *userCardBgCover;
@property (weak, nonatomic) IBOutlet UIView *redPacketBgCover;
@property (weak, nonatomic) IBOutlet UIView *transferBgCover;
@property(nonatomic, assign) BOOL showTime;
@end
@implementation ChatOtherMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor =  UIColorThemeMainBgColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    

    UITapGestureRecognizer*iconTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIconImageView)];
    [_iconImageView addGestureRecognizer:iconTap];
    UILongPressGestureRecognizer *iconLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressIconImageView:)];
    _iconImageView.userInteractionEnabled=YES;
    [_iconImageView addGestureRecognizer:iconLongGesture];
    ViewRadius(_iconImageView, 35/2);
    UITapGestureRecognizer*multipleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleSelectionAction)];
    [self.multipleSelectionTapView addGestureRecognizer:multipleTap];
    [self.multipleSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_sel"] forState:UIControlStateSelected];
    [self.multipleSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_nor"] forState:UIControlStateNormal];
    //给转账添加长按事件
    UILongPressGestureRecognizer *transferLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.transferButton addGestureRecognizer:transferLongGesture];
    self.transferButtonWidth.constant = KRedEnvelopeWidth;
    
    //定位
    UILongPressGestureRecognizer *locationLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.locationButton addGestureRecognizer:locationLongGesture];
    self.locationButtonWidth.constant = KLocationButtonWidth;
    //名片
    self.usercardButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UILongPressGestureRecognizer *usercardLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.usercardButton addGestureRecognizer:usercardLongGesture];
    self.usercardButtonWidth.constant = KUserVCardButtonWidth;
    
    
    //红包
    UILongPressGestureRecognizer *redLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    self.redpacketWidth.constant = KRedEnvelopeWidth;
    [self.redpacketButton addGestureRecognizer:redLongGesture];
    UITapGestureRecognizer *redTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectMessage:)];
    [self.redpacketButton addGestureRecognizer:redTapGesture];
    
    [self addSubview:self.multipleSelectionTapView];
    [self.multipleSelectionTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.reactionBar = [[ReactionBar alloc] init];
    self.reactionBar.backgroundColor = UIColorMake(243, 243, 243);
}
-(void)setMultipleSelection:(BOOL)multipleSelection{
    _multipleSelection = multipleSelection;
    self.multipleStackView.hidden = self.multipleSelectButton.hidden = self.mutipleFirstLineView.hidden = self.multipleSelectionTapView.hidden = !multipleSelection;
}
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    _currentChatModel=currentChatModel;
    self.showTime = isShowTime;
    self.timeLabelBgView.hidden = !isShowTime;
    self.timeLineView.hidden = !isShowTime;
    NSDate*date=[GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.timeLabel.text=[GetTime getTimeWithMessageDate:date];;
    if (isShowName&&isGroup) {
        self.nameLabelBgView.hidden=NO;
    }else{
        self.nameLabelBgView.hidden=YES;
    }
    if ([currentChatModel.chatType isEqualToString:GroupChat]) {
        [self setGroupUserNameAndIcon];
    }else{
        [self setUserNameAndIcon];
    }
    self.transferBgCover.hidden = YES;
    self.locationBgCover.hidden = YES;
    self.userCardBgCover.hidden = YES;
    self.redPacketBgCover.hidden = YES;
    NSString * msgType = self.currentChatModel.messageType;
    if ([msgType isEqualToString:TransFerMessageType]){
        self.transferBgCover.hidden = NO;
        [self setTransgerMessageType];
        NSError *jsonError;
        NSString *jsonString = currentChatModel.messageContent;
        NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
        NSString *currencyCodeVal = [json objectForKey:@"currencyCode"];
        if ([currencyCodeVal  isEqual: @"USDT"]){
            [self.transferButton setBackgroundImage:[UIImage imageNamed:@"green_other_green"] forState:UIControlStateNormal];
        }else{
            [self.transferButton setBackgroundImage:[UIImage imageNamed:@"red_other_red"] forState:UIControlStateNormal];
        }
    }else if ([msgType isEqualToString:LocationMessageType]){
        self.locationBgCover.hidden = NO;
        [self setLocationMessageType];
    }else if ([msgType isEqualToString:UserCardMessageType]){
        self.userCardBgCover.hidden = NO;
        [self setUsercardMessageType];
    }else if ([msgType isEqualToString:SendSingleRedPacketType]||[msgType isEqualToString:SendRoomRedPacketType]){
        self.redPacketBgCover.hidden = NO;
        [self setRedpacketMessage];
    }
    
}

-(void)setReactions:(ChatModel *)model{
    if(model.reactions.count == 0){
        self.reactionBar.hidden = YES;
    }else{
        self.reactionBar.hidden = NO;
        [self.reactionBar setReactions:model];
    }
}

#pragma 长按手势事件
- (void)longPress:(UILongPressGestureRecognizer *)longPressGes {
    NSString * msgType = self.currentChatModel.messageType;
    UIView * converView;
    if ([msgType isEqualToString:TransFerMessageType]){
        converView = self.transferButton;
    }else if ([msgType isEqualToString:LocationMessageType]){
        converView = self.locationButton;
    }else if ([msgType isEqualToString:UserCardMessageType]){
        converView = self.usercardButton;
    }else if ([msgType isEqualToString:SendSingleRedPacketType]||[msgType isEqualToString:SendRoomRedPacketType]){
        converView = self.redpacketButton;
    }
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        [self.menuView showReactionMenuView:self.contentView  convertRectView:converView ChatModel:self.currentChatModel showTime:self.showTime];
    }
    
}
-(void)didSelectMessage:(id)sender{
    [self isNetworkAvailable];
}

-(void)isNetworkAvailable{
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityRef address;
    address = SCNetworkReachabilityCreateWithName(NULL, "www.apple.com");
    Boolean success = SCNetworkReachabilityGetFlags(address, &flags);
    CFRelease(address);
    bool canReach = success
    && !(flags & kSCNetworkReachabilityFlagsConnectionRequired)
    && (flags & kSCNetworkReachabilityFlagsReachable);
    if (canReach == YES){
        if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didSelectMessageWithCell:)]) {
            [self.baseOtherMessageCellDelegate didSelectMessageWithCell:self];
        }
    }else{
        [UIAlertController alertControllerWithTitle:@"Request time out, please check your network status".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"CommonButton.Confirm".icanlocalized] handler:^(int index) {}];
    }
}

-(void)networkMonitoring{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
    [reachability stopMonitoring];
}

-(void)applicationNetworkStatusChanged:(NSNotification*)userinfo{
    NSInteger status = [[[userinfo userInfo]objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            return;
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
        default:{
            if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didSelectMessageWithCell:)]) {
                [self.baseOtherMessageCellDelegate didSelectMessageWithCell:self];
            }
        }
            return;
    }
}

-(void)setRedpacketMessage{
    self.redpacketButton.chatModel = self.currentChatModel;
    [self.redPacketBgCover addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.equalTo(@12);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@-1);
    }];
    [self setReactions:self.currentChatModel];
}

-(void)setUsercardMessageType{
    self.usercardButton.chatModel = self.currentChatModel;
    [self.userCardBgCover addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.equalTo(@12);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@-1);
    }];
    [self setReactions:self.currentChatModel];
}
-(void)setLocationMessageType{
    self.locationButton.chatModel = self.currentChatModel;
    [self.locationBgCover addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.equalTo(@12);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@-1);
    }];
    [self setReactions:self.currentChatModel];
}

-(void)setTransgerMessageType{
    self.transferButton.chatModel = self.currentChatModel;
    [self.transferBgCover addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.left.equalTo(@12);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@-1);
    }];
    [self setReactions:self.currentChatModel];
}

-(UIControl *)multipleSelectionTapView{
    if (!_multipleSelectionTapView) {
        _multipleSelectionTapView = [[UIControl alloc]init];
        _multipleSelectionTapView.backgroundColor = UIColor.clearColor;
        _multipleSelectionTapView.hidden = YES;
        [_multipleSelectionTapView addTarget:self action:@selector(multipleSelectionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _multipleSelectionTapView;
}
-(void)replayLabelAction{
    if (self.baseOtherMessageCellDelegate&&[self.baseOtherMessageCellDelegate respondsToSelector:@selector(clickReplyActionByCell:)]) {
        [self.baseOtherMessageCellDelegate clickReplyActionByCell:self];
    }
}
//点击了头像
-(void)tapIconImageView{
    if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didSelectIconViewWithOtherCell:)]) {
        [self.baseOtherMessageCellDelegate didSelectIconViewWithOtherCell:self];
    }
    
}
//长按头像
-(void)longPressIconImageView:(UIGestureRecognizer*)longPress{
    if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_friend]) {
        if (longPress.state == UIGestureRecognizerStateBegan) {
            if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(longPressIconViewWithOtherCell:)]) {
                [self.baseOtherMessageCellDelegate longPressIconViewWithOtherCell:self];
            }
        }
    }
    
}
-(void)multipleSelectionAction{
    self.currentChatModel.isSelect=!self.currentChatModel.isSelect;
    self.multipleSelectButton.selected=self.currentChatModel.isSelect;
    if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didMultipleSelectMessageWithCell:)]) {
        [self.baseOtherMessageCellDelegate didMultipleSelectMessageWithCell:self];
    }
}


-(void)didClickMesageMenuViewDelegate:(MenuItem *)item{
    if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didSelectItemArticleWithOtherSelectTypeWith:cell:)]) {
        [self.baseOtherMessageCellDelegate didSelectItemArticleWithOtherSelectTypeWith:(item.selectMessageType) cell:self];
    }
}

-(void)didClickReactMenuItemDelegate:(ReactItem *)item{
    if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didSelectReactItemOfCell:cell:)]) {
        [self.baseOtherMessageCellDelegate didSelectReactItemOfCell:item cell:self];
    }
}

-(void)setGroupUserNameAndIcon{
    [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:self.currentChatModel.chatID userId:self.currentChatModel.messageFrom successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
        [self.iconImageView setDZIconImageViewWithUrl:memberInfo.headImgUrl gender:memberInfo.gender];
        self.nameLabel.text=[NSString isEmptyString:memberInfo.groupRemark]?memberInfo.nickname:memberInfo.groupRemark;
        UserMessageInfo*info=[[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.currentChatModel.messageFrom];
        if (info.isFriend) {
            self.nameLabel.text=info.remarkName?: info.remarkName?:info.nickname;
        }
        if (!memberInfo) {
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.currentChatModel.messageFrom successBlock:^(UserMessageInfo * _Nonnull info) {
                [self.iconImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
                self.nameLabel.text=info.remarkName?: info.remarkName?:info.nickname;
            }];
        }
        
        
    }];
}
///设置用户头像和昵称
-(void)setUserNameAndIcon{
    if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_secret]) {
        [self.iconImageView setDZIconImageViewWithUrl:KSecretHeadImg gender:@"1"];
    }else if([self.currentChatModel.authorityType isEqualToString:AuthorityType_friend]){
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.currentChatModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
            [self.iconImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
        }];
    }else if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_circle]){
        [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithCircleUserId:self.currentChatModel.circleUserId successBlock:^(CircleUserInfo * _Nonnull info) {
            [self.iconImageView setCircleIconImageViewWithUrl:info.avatar gender:info.gender];
        }];
    }else if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_c2c]){
        [self.iconImageView setDZIconImageViewWithUrl:self.c2cUserInfo.headImgUrl gender:@"1"];
    }
    
}

-(MessageMenuView *)menuView{
    if (!_menuView) {
        _menuView=[[MessageMenuView alloc]init];
        _menuView.messageMenuViewDelegate=self;
    }
    return _menuView;
}
@end

