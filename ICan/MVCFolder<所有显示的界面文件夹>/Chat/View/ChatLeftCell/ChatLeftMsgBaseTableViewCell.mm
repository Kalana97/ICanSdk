//
//  ChatLeftMsgBaseTableViewCell.m
//  ICan
//
//  Created by dzl on 19/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatLeftMsgBaseTableViewCell.h"
#import "MenuItem.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+CircleUserInfo.h"
@interface ChatLeftMsgBaseTableViewCell()
///最外层垂直排布容器
@property(nonatomic, strong) UIStackView *bodyVerticalStackView;
@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UIView *timeBgView;
@property(nonatomic, strong) UILabel *timeLab;
///最外层水平方向排布容器
@property(nonatomic, strong) UIStackView *bodyHorizontalStackView;
///放置多选的按钮的stackView
@property(nonatomic, strong) UIStackView *multipleHorizontalStackView;
@property(nonatomic, strong) UIView *multiplePlaceholderView;
//@property(nonatomic, strong) UIButton *multipleBtn;
///放置多选的按钮的stackView
@property(nonatomic, strong) UIStackView *iconHorizontalStackView;
@property(nonatomic, strong) UIView *iconLineView1;
@property(nonatomic, strong) UIView *iconLineView2;
///昵称背景
@property(nonatomic, strong) UIView * nameLabelBgView;
///昵称
@property(nonatomic, strong) UILabel * nameLabel;
@property(nonatomic, strong) UILabel * label;
/** 处于多选状态的时候 显示在最顶层的View */
@property(nonatomic,strong)  UIControl *multipleSelectionTapView;
@end
@implementation ChatLeftMsgBaseTableViewCell
-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    _currentChatModel=currentChatModel;
    
    if ([_currentChatModel.chatType isEqualToString:@"userChat"]) {
        
    }else {
        [self.iconHorizontalStackView addArrangedSubview:self.iconImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@35);
        }];
    }
    
    
    _isShowTime = isShowTime;
    self.multipleHorizontalStackView.hidden = !self.multipleSelection;
    self.multipleSelectionTapView.hidden = !self.multipleSelection;
    [self setReplayText];
    self.timeBgView.hidden = !isShowTime;
    NSDate *date = [GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.label.text = [GetTime getTimeWithMessageDate:date];;
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
    if(self.currentChatModel.isSelect == YES){
        self.multipleBtn.selected = YES;
    }else{
        self.multipleBtn.selected = NO;
    }
}
-(void)setReplayText{
    if ([self.currentChatModel.messageType isEqualToString:AtSingleMessageType]||[self.currentChatModel.messageType isEqualToString:AtAllMessageType]||[self.currentChatModel.messageType isEqualToString:TextMessageType]||[self.currentChatModel.messageType isEqualToString:URLMessageType]||[self.currentChatModel.messageType isEqualToString:GamifyMessageType]) {
        self.isReplay = self.currentChatModel.extra.length>0;
    }else{
        self.isReplay=NO;
    }
    ReplyMessageInfo*info=[ReplyMessageInfo mj_objectWithKeyValues:[self.currentChatModel.extra mj_JSONObject]];
    NSString*replyText;
    if ([info.originalMessageType isEqualToString:TextMessageType]||[info.originalMessageType isEqualToString:AtSingleMessageType]||[info.originalMessageType isEqualToString:AtAllMessageType]||[info.originalMessageType isEqualToString:URLMessageType]) {
        TextMessageInfo *textInfo = [TextMessageInfo mj_objectWithKeyValues:info.jsonMessage];
        replyText = textInfo.content;
    }else if([info.originalMessageType isEqualToString:GamifyMessageType]){
        replyText = NSLocalizedString(@"GameTips",[ 图片 ]);
    }else if ([info.originalMessageType isEqualToString:ImageMessageType]){
        replyText=NSLocalizedString(@"ImageTips",[ 图片 ]);
    }else if ([info.originalMessageType isEqualToString:LocationMessageType]){
        replyText=NSLocalizedString(@"LocationTips",[ 位置 ]);
    }else if ([info.originalMessageType isEqualToString:FileMessageType]){
        FileMessageInfo*finfo=[FileMessageInfo mj_objectWithKeyValues:info.jsonMessage];
        replyText=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"FileTips",[ 文件 ]),finfo.fileUrl.lastPathComponent];
    }else if ([info.originalMessageType isEqualToString:VideoMessageType]){
        replyText=NSLocalizedString(@"VideoTips",[ 视频 ]);
    }else if ([info.originalMessageType isEqualToString:UserCardMessageType]){
        replyText=NSLocalizedString(@"ContactCardTips",[ 名片 ]);;
    }else if ([info.originalMessageType isEqualToString:kChat_PostShare]){
        replyText=@"ChatViewController.replyText".icanlocalized;
    }else if ([info.originalMessageType isEqualToString:kChatOtherShareType]){
        replyText=@"Commodity sharing".icanlocalized;
    }
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:info.userId successBlock:^(UserMessageInfo * _Nonnull info) {
        self.replyText = replyText;
        self.replierName = info.nickname;
    }];
}
-(void)setGroupUserNameAndIcon{
    [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:self.currentChatModel.chatID userId:self.currentChatModel.messageFrom successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
        [self.iconImgView setDZIconImageViewWithUrl:memberInfo.headImgUrl gender:memberInfo.gender];
        self.nameLabel.text=[NSString isEmptyString:memberInfo.groupRemark]?memberInfo.nickname:memberInfo.groupRemark;
        UserMessageInfo*info=[[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.currentChatModel.messageFrom];
        if (info.isFriend) {
            self.nameLabel.text=info.remarkName?: info.remarkName?:info.nickname;
        }
        if (!memberInfo) {
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.currentChatModel.messageFrom successBlock:^(UserMessageInfo * _Nonnull info) {
                [self.iconImgView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
                self.nameLabel.text=info.remarkName?: info.remarkName?:info.nickname;
            }];
        }
        
        
    }];
}
///设置用户头像和昵称
-(void)setUserNameAndIcon{
    if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_secret]) {
        [self.iconImgView setDZIconImageViewWithUrl:KSecretHeadImg gender:@"1"];
    }else if([self.currentChatModel.authorityType isEqualToString:AuthorityType_friend]){
        if ([self.currentChatModel.chatID isEqual:@"100"]) {
            [self.iconImgView setDZIconImageViewWithUrl:@"https://oss.icanlk.com/system/head_img/ican/iA.png" gender:@"male"];
        }else {
            [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.currentChatModel.chatID successBlock:^(UserMessageInfo * _Nonnull info) {
                [self.iconImgView setDZIconImageViewWithUrl:info.headImgUrl gender:info.gender];
            }];
        }
    }else if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_circle]){
        [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithCircleUserId:self.currentChatModel.circleUserId successBlock:^(CircleUserInfo * _Nonnull info) {
            [self.iconImgView setCircleIconImageViewWithUrl:info.avatar gender:info.gender];
        }];
    }else if ([self.currentChatModel.authorityType isEqualToString:AuthorityType_c2c]){
        [self.iconImgView setDZIconImageViewWithUrl:self.c2cUserInfo.headImgUrl gender:@"1"];
    }
    
}

-(void)setUpUI{
    [self.contentView addSubview:self.bodyVerticalStackView];
    [self.bodyVerticalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.bodyVerticalStackView addArrangedSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
    }];
    [self.bodyVerticalStackView addArrangedSubview:self.timeBgView];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-20, -10, 100, 20)];
    CGFloat fontSize = 12;
    self.label.font = [UIFont systemFontOfSize:fontSize];
    self.label.textColor = UIColor153Color;
    CGRect labelFrame = self.label.frame;
    labelFrame.size.width = 50;
    self.label.frame = labelFrame;
    self.label.backgroundColor = UIColor.whiteColor;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.layer.cornerRadius = 10;
    self.label.clipsToBounds = YES;
    [self.timeBgView addSubview:self.label];
    [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
    }];
    [self.bodyVerticalStackView addArrangedSubview:self.bodyHorizontalStackView];
    [self.bodyHorizontalStackView addArrangedSubview:self.multipleHorizontalStackView];
    [self.multipleHorizontalStackView addArrangedSubview:self.multiplePlaceholderView];
    [self.multiplePlaceholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
    }];
    [self.multipleHorizontalStackView addArrangedSubview:self.multipleBtn];
    [self.multipleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
    }];
    [self.bodyHorizontalStackView addArrangedSubview:self.iconHorizontalStackView];
    [self.iconHorizontalStackView addArrangedSubview:self.iconLineView1];
    [self.iconLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@5);
    }];
    [self.iconHorizontalStackView addArrangedSubview:self.iconLineView2];
    [self.iconLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@5);
    }];
    UIView *subview1 = [[UIView alloc] init];
    [subview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
    }];
    [self.bodyHorizontalStackView addArrangedSubview:subview1];
    [self.bodyHorizontalStackView addArrangedSubview:self.contentVerticalStackView];
    [self.contentVerticalStackView addArrangedSubview:self.nameLabelBgView];
    [self.nameLabelBgView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self addSubview:self.multipleSelectionTapView];
    [self.multipleSelectionTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    UITapGestureRecognizer*iconTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIconImageView)];
    [self.iconImgView addGestureRecognizer:iconTap];
    UILongPressGestureRecognizer *iconLongGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressIconImageView:)];
    self.iconImgView.userInteractionEnabled=YES;
    [self.iconImgView addGestureRecognizer:iconLongGesture];
    UITapGestureRecognizer*multipleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleSelectionAction)];
    [self.multipleSelectionTapView addGestureRecognizer:multipleTap];
    
}

//点击了头像
-(void)tapIconImageView{
    if (![self.currentChatModel.chatID isEqual:@"100"]) {
        if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didSelectIconViewWithOtherCell:)]) {
            [self.baseOtherMessageCellDelegate didSelectIconViewWithOtherCell:self];
        }
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

- (void)longPress:(UILongPressGestureRecognizer *)longPressGes{
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        if([self.currentChatModel.messageType isEqualToString:ChatCallMessageType] || [self.currentChatModel.messageType isEqualToString:LocationMessageType] || [self.currentChatModel.messageType isEqualToString:SendRoomRedPacketType] || [self.currentChatModel.messageType isEqualToString:SendSingleRedPacketType] || [self.currentChatModel.messageType isEqualToString:UserCardMessageType] || [self.currentChatModel.messageType isEqualToString:kChatOtherShareType]){
            [self.menuView showMessageMenuView:self.contentView convertRectView:self.convertRectView ChatModel:self.currentChatModel showTime:self.isShowTime];
        } else{
            [self.menuView showReactionMenuView:self.contentView convertRectView:self.convertRectView ChatModel:self.currentChatModel showTime:self.isShowTime];
        }
    }
}

-(UIStackView *)bodyVerticalStackView{
    if (!_bodyVerticalStackView) {
        _bodyVerticalStackView = [[UIStackView alloc]init];
        _bodyVerticalStackView.axis = UILayoutConstraintAxisVertical;
        _bodyVerticalStackView.alignment = UIStackViewAlignmentFill;
    }
    return _bodyVerticalStackView;
}
-(UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = UIColor.clearColor;
    }
    return _topLineView;
}
-(UIView *)timeBgView{
    if (!_timeBgView) {
        _timeBgView = [[UIView alloc]init];
        _timeBgView.backgroundColor = UIColor.clearColor;
    }
    return _timeBgView;
}
-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [UILabel centerLabelWithTitle:nil font:12 color:UIColor153Color];
    }
    return _timeLab;
}
-(UIStackView *)bodyHorizontalStackView{
    if (!_bodyHorizontalStackView) {
        _bodyHorizontalStackView = [[UIStackView alloc]init];
        _bodyHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _bodyHorizontalStackView.alignment = UIStackViewAlignmentFill;
    }
    return _bodyHorizontalStackView;
}
-(UIStackView *)multipleHorizontalStackView{
    if (!_multipleHorizontalStackView) {
        _multipleHorizontalStackView = [[UIStackView alloc]init];
        _multipleHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _multipleHorizontalStackView.alignment = UIStackViewAlignmentCenter;
        _multipleHorizontalStackView.hidden = YES;
    }
    return _multipleHorizontalStackView;
}
-(UIView *)multiplePlaceholderView{
    if (!_multiplePlaceholderView) {
        _multiplePlaceholderView = [[UIView alloc]init];
    }
    return _multiplePlaceholderView;
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
-(UIButton *)multipleBtn{
    if (!_multipleBtn) {
        _multipleBtn = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(multipleSelectionAction)];
        [_multipleBtn setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_sel"] forState:UIControlStateSelected];
        [_multipleBtn setBackgroundImage:[UIImage imageNamed:@"icon_selectperson_nor"] forState:UIControlStateNormal];
        
    }
    return _multipleBtn;
}
-(void)multipleSelectionAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateIsSelect" object:self.currentChatModel];
    if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didMultipleSelectMessageWithCell:)]) {
        [self.baseOtherMessageCellDelegate didMultipleSelectMessageWithCell:self];
    }
}
-(UIStackView *)iconHorizontalStackView{
    if (!_iconHorizontalStackView) {
        _iconHorizontalStackView = [[UIStackView alloc]init];
        _iconHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _iconHorizontalStackView.alignment = UIStackViewAlignmentTop;
        _iconHorizontalStackView.spacing = 0;
        
    }
    return _iconHorizontalStackView;
}
-(DZIconImageView *)iconImgView{
    if (!_iconImgView) {
        _iconImgView = [[DZIconImageView alloc]init];
        [_iconImgView layerWithCornerRadius:35/2 borderWidth:0 borderColor:nil];
        _iconImgView.userInteractionEnabled = YES;
    }
    return _iconImgView;
}
-(UIView *)iconLineView1{
    if (!_iconLineView1) {
        _iconLineView1 = [[UIView alloc]init];
    }
    return _iconLineView1;
}
-(UIView *)iconLineView2{
    if (!_iconLineView2) {
        _iconLineView2 = [[UIView alloc]init];
    }
    return _iconLineView2;
}
-(UIStackView *)contentVerticalStackView{
    if (!_contentVerticalStackView) {
        _contentVerticalStackView = [[UIStackView alloc]init];
        _contentVerticalStackView.axis = UILayoutConstraintAxisVertical;
        _contentVerticalStackView.alignment = UIStackViewAlignmentLeading;
    }
    return _contentVerticalStackView;
}
-(UIView *)nameLabelBgView{
    if (!_nameLabelBgView) {
        _nameLabelBgView = [[UIView alloc]init];
    }
    return _nameLabelBgView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel leftLabelWithTitle:@"lida" font:13 color:UIColor153Color];
    }
    return _nameLabel;
}

-(MessageMenuView *)menuView{
    if (!_menuView) {
        _menuView=[[MessageMenuView alloc]init];
        _menuView.messageMenuViewDelegate=self;
    }
    return _menuView;
}
-(void)didClickMesageMenuViewDelegate:(MenuItem *)item{
    if (item.selectMessageType ==SelectMessageTypeCopy||item.selectMessageType==SelectMessageTypeTranslate||item.selectMessageType==SelectMessageTypeAll||item.selectMessageType==SelectMessageTypeTranslateHide) {
        [self clickMessageMunuView:item];
    }else{
        if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didSelectItemArticleWithOtherSelectTypeWith:cell:)]) {
            [self.baseOtherMessageCellDelegate didSelectItemArticleWithOtherSelectTypeWith:(item.selectMessageType) cell:self];
        }
    }
}

-(void)didClickReactMenuItemDelegate:(ReactItem *)item{
    if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didSelectReactItemOfCell:cell:)]) {
        [self.baseOtherMessageCellDelegate didSelectReactItemOfCell:item cell:self];
    }
}
///父类实现
-(void)clickMessageMunuView:(MenuItem *)item{
    
}
-(void)clickMessageCell{
    if (self.baseOtherMessageCellDelegate && [self.baseOtherMessageCellDelegate respondsToSelector:@selector(didSelectMessageWithCell:)]) {
        [self.baseOtherMessageCellDelegate didSelectMessageWithCell:self];
    }
}
@end
