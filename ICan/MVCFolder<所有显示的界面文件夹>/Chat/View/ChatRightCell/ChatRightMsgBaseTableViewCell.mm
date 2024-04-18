//
//  ChatLeftMsgBaseTableViewCell.m
//  ICan
//
//  Created by dzl on 19/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "ChatRightMsgBaseTableViewCell.h"
#import "MenuItem.h"
#import "ShwoHasReadView.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+GroupMemberInfo.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+CircleUserInfo.h"
static NSString*const KRightReadCollectionIconImageViewCell=@"RightReadCollectionIconImageViewCell";
@interface RightReadCollectionIconImageViewCell:UICollectionViewCell
@property(nonatomic, strong) DZIconImageView *iconImageView;
@property (nonatomic,strong) NSDictionary * dict;
@end

@implementation RightReadCollectionIconImageViewCell
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
@interface ChatRightMsgBaseTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
///放置头像stackView
@property(nonatomic, strong) UIStackView *iconHorizontalStackView;
@property(nonatomic, strong) UIView *iconLineView1;
@property(nonatomic, strong) UIView *reactMarginView;
@property(nonatomic, strong) UIView *iconLineView2;
@property(nonatomic, strong) DZIconImageView *stateImageView;
@property(nonatomic, strong) UILabel *label;
//已读未读
@property(nonatomic, strong) UIStackView *hasReadVerticalStackView;
@property(nonatomic, strong) UIView *hasReadLineView;
///最外层水平方向排布容器
@property(nonatomic, strong) UIStackView *hasReadHorizontalStackView;
@property(nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong) UILabel *hasReadLabel;
/** 处于多选状态的时候 显示在最顶层的View */
@property(nonatomic, strong) UIControl *multipleSelectionTapView;
@property(nonatomic, assign) BOOL isGroup;
@end
@implementation ChatRightMsgBaseTableViewCell

-(void)setcurrentChatModel:(ChatModel *)currentChatModel isShowName:(BOOL)isShowName isGroup:(BOOL)isGroup isShowTime:(BOOL)isShowTime{
    _currentChatModel=currentChatModel;
    _isShowTime = isShowTime;
    _isGroup = isGroup;
    self.multipleHorizontalStackView.hidden = !self.multipleSelection;
    self.multipleSelectionTapView.hidden = !self.multipleSelection;
    [self setReplayText];
    self.timeBgView.hidden = !isShowTime;
    NSDate *date = [GetTime dateConvertFromTimeStamp:currentChatModel.messageTime];
    self.label.text = [GetTime getTimeWithMessageDate:date];
    [self setHasReadUI];
    [self setSendStateUi];
    [self setupReactionUI];
}
-(void)setSendStateUi{
    switch (self.currentChatModel.sendState) {
        case MessageSendTypeFailed:{
            self.failBtn .hidden = NO;
            self.sendActivityView.hidden = YES;
            [self.sendActivityView stopAnimating];
            break;
        }
        case MessageSendTypeSuccess:{
            self.failBtn .hidden = YES;
            self.sendActivityView.hidden = YES;
            [self.sendActivityView stopAnimating];
            break;
        }
        default:{
            self.failBtn .hidden = YES;
            self.sendActivityView.hidden = NO;
            [self.sendActivityView startAnimating];
            break;
        }
    }
}

-(void)setupReactionUI{
    if(self.currentChatModel.reactions.count > 0){
        self.reactMarginView.hidden = NO;
    }else{
        self.reactMarginView.hidden = YES;
    }
}

-(void)setReplayText{
    if ([self.currentChatModel.messageType isEqualToString:AtSingleMessageType]||[self.currentChatModel.messageType isEqualToString:AtAllMessageType]||[self.currentChatModel.messageType isEqualToString:TextMessageType]||[self.currentChatModel.messageType isEqualToString:GamifyMessageType]||[self.currentChatModel.messageType isEqualToString:URLMessageType]) {
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
#pragma mark 设置已读未读的UI界面
-(void)setHasReadUI{
    self.hasReadVerticalStackView.hidden = YES;
    self.stateImageView.hidden = NO;
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
        if(self.currentChatModel.isSelect == YES){
            self.multipleBtn.selected = YES;
        }else{
            self.multipleBtn.selected = NO;
        }
        self.hasReadVerticalStackView.hidden = YES;
        self.stateImageView.hidden = NO;
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
        if(self.currentChatModel.isSelect == YES){
            self.multipleBtn.selected = YES;
        }else{
            self.multipleBtn.selected = NO;
        }
        if (self.currentChatModel.hasReadUserInfoItems.count<2) {
            self.hasReadVerticalStackView.hidden = YES;
            self.stateImageView.hidden = NO;
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
            self.stateImageView.hidden = YES;
            self.hasReadVerticalStackView.hidden = NO;
            [self.collectionView reloadData];
            self.stateImageView.image = [UIImage imageWithColor:UIColor.clearColor];
            if (self.currentChatModel.hasReadUserInfoItems.count>=4) {
                self.hasReadLabel.hidden = NO;
                self.hasReadLabel.text=[NSString stringWithFormat:@"+ %lu",self.currentChatModel.hasReadUserInfoItems.count-3];
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@65);
                    make.height.equalTo(@16);
                }];
            }else{
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(self.currentChatModel.hasReadUserInfoItems.count*21));
                    make.height.equalTo(@16);
                }];
                
                
            }
        }
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
-(void)setUpUI{
    [self.contentView addSubview:self.bodyVerticalStackView];
    [self.bodyVerticalStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.bodyVerticalStackView addArrangedSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
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
    
    [self.bodyHorizontalStackView addArrangedSubview:self.contentVerticalStackView];
    [self.contentVerticalStackView addArrangedSubview:self.bodyContentView];
    [self.bodyContentView addSubview:self.failBtn];
    [self.failBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(@0);
        make.centerY.equalTo(self.bodyContentView.mas_centerY);
    }];
    [self.bodyContentView addSubview:self.sendActivityView];
    [self.sendActivityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(@0);
        make.centerY.equalTo(self.bodyContentView.mas_centerY);
    }];
    [self.bodyHorizontalStackView addArrangedSubview:self.iconHorizontalStackView];
    [self.iconHorizontalStackView addArrangedSubview:self.iconLineView1];
    [self.iconLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
    }];
    [self.iconHorizontalStackView addArrangedSubview:self.iconLineView2];
    [self.iconLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@15);
    }];
    [self.contentVerticalStackView addArrangedSubview:self.reactMarginView];
    [self.contentVerticalStackView addArrangedSubview:self.iconLineView1];
    [self.reactMarginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@20);
    }];
    [self.iconLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@5);
    }];
    [self.contentVerticalStackView addArrangedSubview:self.stateImageView];
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@16);
    }];
    [self.contentVerticalStackView addArrangedSubview:self.hasReadVerticalStackView];
    [self.hasReadVerticalStackView addArrangedSubview:self.hasReadLineView];
    [self.hasReadLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@5);
    }];
    [self.hasReadVerticalStackView addArrangedSubview:self.hasReadHorizontalStackView];
    [self.hasReadHorizontalStackView addArrangedSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@65);
        make.height.equalTo(@16);
    }];
    [self.hasReadHorizontalStackView addArrangedSubview:self.hasReadLabel];
    
    [self addSubview:self.multipleSelectionTapView];
    [self.multipleSelectionTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    UITapGestureRecognizer*iconTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToShowReadUserView)];
    [self.stateImageView addGestureRecognizer:iconTap];
    self.stateImageView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer*multipleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(multipleSelectionAction)];
    [self.multipleSelectionTapView addGestureRecognizer:multipleTap];
    
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
    if (self.msgDelegate && [self.msgDelegate respondsToSelector:@selector(didMultipleSelectMessageWithCell:)]) {
        [self.msgDelegate didMultipleSelectMessageWithCell:self];
    }
}
-(UIStackView *)iconHorizontalStackView{
    if (!_iconHorizontalStackView) {
        _iconHorizontalStackView = [[UIStackView alloc]init];
        _iconHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _iconHorizontalStackView.alignment = UIStackViewAlignmentBottom;
        _iconHorizontalStackView.spacing = 0;
        
    }
    return _iconHorizontalStackView;
}
-(DZIconImageView *)stateImageView{
    if (!_stateImageView) {
        _stateImageView = [[DZIconImageView alloc]init];
        [_stateImageView layerWithCornerRadius:8 borderWidth:0 borderColor:nil];
        _stateImageView.userInteractionEnabled = YES;
    }
    return _stateImageView;
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

-(UIView *)reactMarginView{
    if (!_reactMarginView) {
        _reactMarginView = [[UIView alloc]init];
    }
    return _reactMarginView;
}

-(UIStackView *)contentVerticalStackView{
    if (!_contentVerticalStackView) {
        _contentVerticalStackView = [[UIStackView alloc]init];
        _contentVerticalStackView.axis = UILayoutConstraintAxisVertical;
        _contentVerticalStackView.alignment = UIStackViewAlignmentTrailing;
    }
    return _contentVerticalStackView;
}

-(UIView *)bodyContentView{
    if (!_bodyContentView) {
        _bodyContentView = [[UIView alloc]init];
    }
    return _bodyContentView;
}
-(UIButton *)failBtn{
    if (!_failBtn) {
        _failBtn = [UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:0 titleColor:nil target:self action:@selector(failBtnAction)];
        [_failBtn setBackgroundImage:UIImageMake(@"chat_sendfailure_btn") forState:UIControlStateNormal];
    }
    return _failBtn;
}
-(void)failBtnAction{
    if (self.msgDelegate&&[self.msgDelegate respondsToSelector:@selector(didClickSendFailButtonWithCell:)]) {
        [self.msgDelegate didClickSendFailButtonWithCell:self];
    }
}
-(UIActivityIndicatorView *)sendActivityView{
    if (!_sendActivityView) {
        if (@available(iOS 13.0, *)) {
            _sendActivityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        } else {
            _sendActivityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
    return _sendActivityView;
}
-(UIStackView *)hasReadVerticalStackView{
    if (!_hasReadVerticalStackView) {
        _hasReadVerticalStackView = [[UIStackView alloc]init];
        _hasReadVerticalStackView.axis = UILayoutConstraintAxisVertical;
        _hasReadVerticalStackView.alignment = UIStackViewAlignmentFill;
    }
    return _hasReadVerticalStackView;
}
-(UIView *)hasReadLineView{
    if (!_hasReadLineView) {
        _hasReadLineView = [[UIView alloc]init];
        _hasReadLineView.backgroundColor = UIColor.clearColor;
    }
    return _hasReadLineView;
}
-(UIStackView *)hasReadHorizontalStackView{
    if (!_hasReadHorizontalStackView) {
        _hasReadHorizontalStackView = [[UIStackView alloc]init];
        _hasReadHorizontalStackView.axis = UILayoutConstraintAxisHorizontal;
        _hasReadHorizontalStackView.alignment = UIStackViewAlignmentCenter;
        _hasReadHorizontalStackView.spacing = 5;
    }
    return _hasReadHorizontalStackView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout*lay=[[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _collectionView.dataSource                      = self;
        _collectionView.delegate                        = self;
        _collectionView.showsVerticalScrollIndicator    = NO;
        _collectionView.showsHorizontalScrollIndicator  = YES;
        _collectionView.scrollEnabled                   = YES;
        _collectionView.pagingEnabled=YES;
        _collectionView.backgroundColor                 = [UIColor whiteColor];
        [_collectionView registClassWithClassName:KRightReadCollectionIconImageViewCell];
    }
    return _collectionView;
}
-(UILabel *)hasReadLabel{
    if (!_hasReadLabel) {
        _hasReadLabel = [UILabel centerLabelWithTitle:nil font:12 color:UIColor153Color];
    }
    return _hasReadLabel;
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
        if (self.msgDelegate && [self.msgDelegate respondsToSelector:@selector(didSelectItemArticleWithOtherSelectTypeWith:cell:)]) {
            [self.msgDelegate didSelectItemArticleWithOtherSelectTypeWith:(item.selectMessageType) cell:self];
        }
    }
}
-(void)didClickReactMenuItemDelegate:(ReactItem *)item{
    if (self.msgDelegate && [self.msgDelegate respondsToSelector:@selector(didSelectReactItemOfCell:cell:)]) {
        [self.msgDelegate didSelectReactItemOfCell:item cell:self];
    }
}
///文本子类实现
-(void)clickMessageMunuView:(MenuItem *)item{
    
}
-(void)clickMessageCell{
    if (self.msgDelegate && [self.msgDelegate respondsToSelector:@selector(didSelectMessageWithCell:)]) {
        [self.msgDelegate didSelectMessageWithCell:self];
    }
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentChatModel.hasReadUserInfoItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RightReadCollectionIconImageViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:KRightReadCollectionIconImageViewCell forIndexPath:indexPath];
    if(self.currentChatModel.hasReadUserInfoItems.count > 0){
        NSDictionary *dict = [self.currentChatModel.hasReadUserInfoItems objectAtIndex:indexPath.item];
        cell.dict = dict;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.collectionView convertRect: self.collectionView.bounds toView:window];
    if (self.currentChatModel.hasReadUserInfoItems.count>0) {
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

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(16,16);
}
//设置列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

@end
