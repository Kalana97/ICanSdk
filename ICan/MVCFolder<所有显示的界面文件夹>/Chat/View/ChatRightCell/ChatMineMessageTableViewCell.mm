//
/**
 - Copyright © 2021 dzl. All rights reserved.
 - Author: Created  by DZL on 15/11/2021
 - File name:  ChatTextTestTableViewCell.m
 - Description:
 - Function List:
 */
#import "ChatMineMessageTableViewCell.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+CircleUserInfo.h"
#import "ChatTransferButton.h"
#import "LocationInfoBtn.h"
#import "UserCardButton.h"
#import "RedPacketContentImageView.h"
#import "WebSocketManager+HandleMessage.h"
#import "ShwoHasReadView.h"
#import "WCDBManager+GroupListInfo.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "ReactionBar.h"
static NSString*const KReadCollectionIconImageViewCell=@"ReadCollectionIconImageViewCell";
@interface ReadCollectionIconImageViewCell:UICollectionViewCell
@property(nonatomic, strong) DZIconImageView *iconImageView;
@property (nonatomic,strong) NSDictionary * dict;
@end

@implementation ReadCollectionIconImageViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    return self;
}
-(void)setDict:(NSDictionary *)dict{
    @weakify(self);
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:dict[@"id"] successBlock:^(UserMessageInfo * _Nonnull info) {
        @strongify(self);
        [self.iconImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
    }];
}
-(DZIconImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[DZIconImageView alloc]init];
        [_iconImageView layerWithCornerRadius:7.5 borderWidth:0 borderColor:nil];
    }
    return _iconImageView;
}

@end
@interface ChatMineMessageTableViewCell()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) ChatModel *  currentChatModel;
//时间背景view
@property(nonatomic,weak) IBOutlet UIView * timeLabelBgView;
@property(weak, nonatomic) IBOutlet UIView *timeLineView;
@property(nonatomic,weak) IBOutlet UILabel * timeLabel;
//头像
@property(nonatomic,weak) IBOutlet DZIconImageView * stateImageView;
/** 处于多选状态的时候 显示在最顶层的View */
@property(nonatomic,strong)  UIControl *multipleSelectionTapView;
@property(weak, nonatomic) IBOutlet UIStackView *multipleSelectBgView;
/** 多选的button */
@property(nonatomic,weak) IBOutlet UIButton *multipleSelectButton;
//转账
@property (weak, nonatomic) IBOutlet UIView *transferBgView;
@property (weak, nonatomic) IBOutlet ChatTransferButton *transferButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transferButtonWidth;
@property (weak, nonatomic) IBOutlet UIButton *transferFailBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *transferSendActivityView;
//定位
@property (weak, nonatomic) IBOutlet LocationInfoBtn *locationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationButtonWidth;
@property (weak, nonatomic) IBOutlet UIView *locationBgView;
@property (weak, nonatomic) IBOutlet UIButton *locationFailBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locationSendActivityView;
//名片
@property(weak, nonatomic) IBOutlet UserCardButton *usercardButton;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *usercardButtonWidth;
@property(weak, nonatomic) IBOutlet UIView *usercardBgView;
@property(weak, nonatomic) IBOutlet UIButton *usercardFailBtn;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *usercardSendActivityView;

//红包
@property(weak, nonatomic) IBOutlet UIView *redpacketBgView;
@property(weak, nonatomic) IBOutlet RedPacketContentImageView *redpacketButton;
@property(weak, nonatomic) IBOutlet UIButton *redpacketFailBtn;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *redpacketSendActivityView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *redpacketWidth;
//已读未读
@property(weak, nonatomic) IBOutlet UIStackView *hasReadBgView;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(weak, nonatomic) IBOutlet UILabel *hasReadLabel;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidth;
@property(strong, nonatomic) ReactionBar *reactionBar;
@property(nonatomic, assign) BOOL isShowTime;
@property (weak, nonatomic) IBOutlet UIStackView *mineMsgStack;
@property (weak, nonatomic) IBOutlet UIView *locationBgCover;
@property (weak, nonatomic) IBOutlet UIView *userCardBgCover;
@property (weak, nonatomic) IBOutlet UIView *redPacketBgCover;
@property (weak, nonatomic) IBOutlet UIView *transferBgCover;

@end
@implementation ChatMineMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor =  UIColorThemeMainBgColor;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registClassWithClassName:KReadCollectionIconImageViewCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //给头像添加点击手势
    UITapGestureRecognizer*iconTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToShowReadUserView)];
    [self.stateImageView addGestureRecognizer:iconTap];
    self.stateImageView.userInteractionEnabled=YES;
    ViewRadius(self.stateImageView, 8);
    UITapGestureRecognizer*multipleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleSelectionAction)];
    [self.multipleSelectionTapView addGestureRecognizer:multipleTap];
    [self.multipleSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_sel"] forState:UIControlStateSelected];
    [self.multipleSelectButton setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_nor"] forState:UIControlStateNormal];
    //给转账添加长按事件
    UILongPressGestureRecognizer *transferLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.transferButton addGestureRecognizer:transferLongGesture];
    
    //定位
    UILongPressGestureRecognizer *locationLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.locationButton addGestureRecognizer:locationLongGesture];
    
    //名片
    self.usercardButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UILongPressGestureRecognizer *usercardLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.usercardButton addGestureRecognizer:usercardLongGesture];
    
    //红包
    UILongPressGestureRecognizer *redLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
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
    self.multipleSelectBgView.hidden = self.multipleSelectionTapView.hidden = !multipleSelection;
}
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    self.isShowTime = isShowTime;
    self.isGroup = isGroup;
    _currentChatModel=currentChatModel;
    self.timeLabelBgView.hidden = !isShowTime;
    self.timeLineView.hidden = !isShowTime;
    NSDate*date=[GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.timeLabel.text=[GetTime getTimeWithMessageDate:date];
    [self setHasReadUI];
    self.transferBgCover.hidden = YES;
    self.locationBgCover.hidden = YES;
    self.userCardBgCover.hidden = YES;
    self.redPacketBgCover.hidden = YES;
    NSString * msgType = self.currentChatModel.messageType;
    if ([msgType isEqualToString:TransFerMessageType]){
        [self setTransgerMessageType];
        NSError *jsonError;
        NSString * jsonString = currentChatModel.messageContent;
        NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
        NSString *currencyCodeVal = [json objectForKey:@"currencyCode"];
        if ([currencyCodeVal  isEqual: @"USDT"]){
            [self.transferButton setBackgroundImage:[UIImage imageNamed:@"green_other_green"] forState:UIControlStateNormal];
        }else{
            [self.transferButton setBackgroundImage:[UIImage imageNamed:@"red_other_red"] forState:UIControlStateNormal];
        }
    }else if ([msgType isEqualToString:LocationMessageType]){
        [self setLocationMessageType];
    }else if ([msgType isEqualToString:UserCardMessageType]){
        [self setUsercardMessageType];
    }else if ([msgType isEqualToString:SendSingleRedPacketType]||[msgType isEqualToString:SendRoomRedPacketType]){
        [self setRedpacketMessage];
    }
}
#pragma mark 设置已读未读的UI界面
-(void)setHasReadUI{
    self.hasReadBgView.hidden = YES;
    self.stateImageView.image = [UIImage imageWithColor:UIColor.clearColor];
    if (self.currentChatModel.sendState==1) {
        self.stateImageView.image = [UIImage imageNamed:@"chat_icon_send_success"];
        if ([self.currentChatModel.chatType isEqualToString:UserChat]) {
            //是否开启消息回执
            if (UserInfoManager.sharedManager.readReceipt) {
                [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.currentChatModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                    if (info.readReceipt) {
                        self.stateImageView.image=[UIImage imageNamed:@"chat_icon_send_success"];
                        
                    }
                }];
            }
        }
    }
    if ([self.currentChatModel.chatType isEqualToString:UserChat]) {
        self.hasReadBgView.hidden = YES;
        //如果是视频通话类型的消息 那么不显示已读未读
        if ([self.currentChatModel.messageType isEqualToString:ChatCallMessageType]) {
            self.stateImageView.image = [UIImage imageWithColor:UIColor.clearColor];
        }else{
            if (self.currentChatModel.sendState==1) {
                if (UserInfoManager.sharedManager.readReceipt) {
                    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.currentChatModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                        if (info.readReceipt) {
                            if ([self.currentChatModel.receiptStatus isEqualToString:ReceiptRECEIVE]) {
                                self.stateImageView.image=[UIImage imageNamed:@"chat_icon_other_success_receive"];
                            }else if([self.currentChatModel.receiptStatus isEqualToString:ReceiptREAD]){
                                if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_secret]) {
                                    [self .stateImageView setDZIconImageViewWithUrl:KSecretHeadImg gender:@"1"];
                                }else if([self.currentChatModel.authorityType isEqualToString:AuthorityType_friend]){
                                    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.currentChatModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                                        [self .stateImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
                                    }];
                                }else if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_circle]){
                                    [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithCircleUserId:self.currentChatModel.circleUserId successBlock:^(CircleUserInfo * _Nonnull info) {
                                        [self.stateImageView setCircleIconImageViewWithUrl:info.avatar gender:info.gender];
                                    }];
                                }else if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_c2c]){
                                    [self.stateImageView setCircleIconImageViewWithUrl:self.c2cUserInfo.headImgUrl gender:@"1"];
                                }
                                
                            }
                        }else{
                            self.stateImageView.image = [UIImage imageWithColor:UIColor.clearColor];
                        }
                    }];
                }
                
            }
        }
    }else{
        if (self.currentChatModel.hasReadUserInfoItems.count<2) {
            self.hasReadBgView.hidden = YES;
            if (self.currentChatModel.hasReadUserInfoItems.count==1) {
                NSDictionary*dict=[self.currentChatModel.hasReadUserInfoItems objectAtIndex:0];
                NSString*userId=dict[@"id"];
                if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_secret]) {
                    [self .stateImageView setDZIconImageViewWithUrl:KSecretHeadImg gender:@"1"];
                }else{
                    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userId successBlock:^(UserMessageInfo * _Nonnull info) {
                        [self .stateImageView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
                    }];
                }
                
            }
        }else{
            self.hasReadBgView.hidden = NO;
            [self.collectionView reloadData];
            self.stateImageView.image = [UIImage imageWithColor:UIColor.clearColor];
            if (self.currentChatModel.hasReadUserInfoItems.count>=4) {
                self.hasReadLabel.hidden = NO;
                self.hasReadLabel.text=[NSString stringWithFormat:@"+ %lu",self.currentChatModel.hasReadUserInfoItems.count-3];
                self.collectionViewWidth.constant = 65;
            }else{
                self.collectionViewWidth.constant = self.currentChatModel.hasReadUserInfoItems.count*21;
                
            }
        }
    }
}
#pragma mark 长按手势事件
- (void)longPress:(UILongPressGestureRecognizer *)longPressGes {
    NSString * msgType = self.currentChatModel.messageType;
    UIView * converView ;
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
        [self.menuView showReactionMenuView:self.contentView convertRectView:converView ChatModel:self.currentChatModel showTime:self.isShowTime];
    }
    
}
#pragma mark 点击对应的消息
-(void)didSelectMessage:(id)sender{
    if (self.baseMessageCellDelegate && [self.baseMessageCellDelegate respondsToSelector:@selector(didSelectMessageWithCell:)]) {
        [self.baseMessageCellDelegate didSelectMessageWithCell:self];
    }
}

-(void)setRedpacketMessage{
    self.redpacketWidth.constant = KRedEnvelopeWidth;
    self.redPacketBgCover.hidden = NO;
    self.redpacketButton.chatModel = self.currentChatModel;
    switch (self.currentChatModel.sendState) {
        case MessageSendTypeFailed:{
            self.redpacketFailBtn .hidden = NO;
            self.redpacketSendActivityView.hidden = YES;
            [self.redpacketSendActivityView stopAnimating];
            break;
        }
        case MessageSendTypeSuccess:{
            self.redpacketFailBtn .hidden = YES;
            self.redpacketSendActivityView.hidden = YES;
            [self.redpacketSendActivityView stopAnimating];
            
            break;
        }
        default:{
            self.redpacketFailBtn .hidden = YES;
            self.redpacketSendActivityView.hidden = NO;
            [self.redpacketSendActivityView startAnimating];
            break;
        }
    }
    [self.redpacketBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.right.equalTo(@-10);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@22);
    }];
    [self setReactions:self.currentChatModel];
}

-(void)setReactions:(ChatModel *)model{
    if(model.reactions.count == 0){
        self.reactionBar.hidden = YES;
    }else{
        self.reactionBar.hidden = NO;
        [self.reactionBar setReactions:model];
    }
}

-(void)setUsercardMessageType{
    self.userCardBgCover.hidden = NO;
    self.usercardButtonWidth.constant = KUserVCardButtonWidth;
    self.usercardButton.chatModel = self.currentChatModel;
    switch (self.currentChatModel.sendState) {
        case MessageSendTypeFailed:{
            self.usercardFailBtn .hidden = NO;
            self.usercardSendActivityView.hidden = YES;
            [self.usercardSendActivityView stopAnimating];
            break;
        }
        case MessageSendTypeSuccess:{
            self.usercardFailBtn .hidden = YES;
            self.usercardSendActivityView.hidden = YES;
            [self.usercardSendActivityView stopAnimating];
            
            break;
        }
        default:{
            self.usercardFailBtn .hidden = YES;
            self.usercardSendActivityView.hidden = NO;
            [self.usercardSendActivityView startAnimating];
            break;
        }
    }
    [self.usercardBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.right.equalTo(@-10);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@22);
    }];
    [self setReactions:self.currentChatModel];
}
-(void)setLocationMessageType{
    self.locationButtonWidth.constant = KLocationButtonWidth;
    self.locationBgCover.hidden = NO;
    self.locationButton.chatModel = self.currentChatModel;
    switch (self.currentChatModel.sendState) {
        case MessageSendTypeFailed:{
            self.locationFailBtn .hidden = NO;
            self.locationSendActivityView.hidden = YES;
            [self.locationSendActivityView stopAnimating];
            break;
        }
        case MessageSendTypeSuccess:{
            self.locationFailBtn .hidden = YES;
            self.locationSendActivityView.hidden = YES;
            [self.locationSendActivityView stopAnimating];
            
            break;
        }
        default:{
            self.locationFailBtn .hidden = YES;
            self.locationSendActivityView.hidden = NO;
            [self.locationSendActivityView startAnimating];
            break;
        }
    }
    [self.locationBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.right.equalTo(@-10);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@24);
    }];
    [self setReactions:self.currentChatModel];
}
-(void)setTransgerMessageType{
    self.transferButtonWidth.constant = KRedEnvelopeWidth;
    self.transferBgCover.hidden = NO;
    self.transferButton.chatModel = self.currentChatModel;
    switch (self.currentChatModel.sendState) {
        case MessageSendTypeFailed:{
            self.transferFailBtn .hidden = NO;
            self.transferSendActivityView.hidden = YES;
            [self.transferSendActivityView stopAnimating];
            break;
        }
        case MessageSendTypeSuccess:{
            self.transferFailBtn .hidden = YES;
            self.transferSendActivityView.hidden = YES;
            [self.transferSendActivityView stopAnimating];
            
            break;
        }
        default:{
            self.transferFailBtn .hidden = YES;
            self.transferSendActivityView.hidden = NO;
            [self.transferSendActivityView startAnimating];
            break;
        }
    }
    [self.transferBgView addSubview:self.reactionBar];
    [self.reactionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@28);
        make.right.equalTo(@-10);
        make.width.greaterThanOrEqualTo(@52);
        make.bottom.equalTo(@22);
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
-(void)multipleSelectionAction{
    self.currentChatModel.isSelect=!self.currentChatModel.isSelect;
    self.multipleSelectButton.selected=self.currentChatModel.isSelect;
    if (self.baseMessageCellDelegate && [self.baseMessageCellDelegate respondsToSelector:@selector(didMultipleSelectMessageWithCell:)]) {
        [self.baseMessageCellDelegate didMultipleSelectMessageWithCell:self];
    }
}
-(void)didClickMesageMenuViewDelegate:(MenuItem *)item{
    
    if (self.baseMessageCellDelegate && [self.baseMessageCellDelegate respondsToSelector:@selector(didSelectItemArticleWithSelectType:cell:)]) {
        [self.baseMessageCellDelegate didSelectItemArticleWithSelectType:(item.selectMessageType) cell:self];
    }
    
}

-(void)didClickReactMenuItemDelegate:(ReactItem *)item{
    if (self.baseMessageCellDelegate && [self.baseMessageCellDelegate respondsToSelector:@selector(didSelectReactItemOfCell:cell:)]) {
        [self.baseMessageCellDelegate didSelectReactItemOfCell:item cell:self];
    }
}

-(MessageMenuView *)menuView{
    if (!_menuView) {
        _menuView=[[MessageMenuView alloc]init];
        _menuView.messageMenuViewDelegate=self;
    }
    return _menuView;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentChatModel.hasReadUserInfoItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadCollectionIconImageViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:KReadCollectionIconImageViewCell forIndexPath:indexPath];
    NSDictionary*dict=[self.currentChatModel.hasReadUserInfoItems objectAtIndex:indexPath.item];
    cell.dict=dict;
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.collectionView convertRect: self.collectionView.bounds toView:window];
    if (self.currentChatModel.hasReadUserInfoItems.count>0) {
        if (self.isGroup) {
            GroupListInfo*info=[[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:self.currentChatModel.chatID];
            if (info) {
                ShwoHasReadView*view=[[ShwoHasReadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                view.isGroup=self.isGroup;
                view.groupId=self.currentChatModel.chatID;
                view.convertRect=rect; view.groupHasReadUserItems=self.currentChatModel.hasReadUserInfoItems;
                [view showSurePaymentView];
            }
        }
        
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(16,16);
}
//设置行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(IBAction)failButtonAction{
    if (self.baseMessageCellDelegate&&[self.baseMessageCellDelegate respondsToSelector:@selector(didClickSendFailButtonWithCell:)]) {
        [self.baseMessageCellDelegate didClickSendFailButtonWithCell:self];
    }
}
-(void)goToShowReadUserView{
    if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_friend]) {
        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
        CGRect rect=[self.stateImageView convertRect: self.stateImageView.bounds toView:window];
        if (self.currentChatModel.hasReadUserInfoItems.count>0) {
            if (self.isGroup) {
                GroupListInfo*info=[[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:self.currentChatModel.chatID];
                if (info) {
                    if ([self.currentChatModel.receiptStatus isEqualToString:ReceiptREAD]){
                        ShwoHasReadView*view=[[ShwoHasReadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        view.isGroup=self.isGroup;
                        view.groupId=self.currentChatModel.chatID;
                        view.convertRect=rect;
                        view.groupHasReadUserItems=self.currentChatModel.hasReadUserInfoItems;
                        [view showSurePaymentView];
                    }
                }
            }else{
                if ([self.currentChatModel.chatType isEqualToString:UserChat]) {
                    if ([self.currentChatModel.receiptStatus isEqualToString:ReceiptREAD]) {
                        ShwoHasReadView*view=[[ShwoHasReadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                        view.isGroup=NO;
                        view.convertRect=rect;
                        view.groupHasReadUserItems=self.currentChatModel.hasReadUserInfoItems;
                        [view showSurePaymentView];
                        
                    }
                    
                }
            }
        }
        
    }
}
@end

