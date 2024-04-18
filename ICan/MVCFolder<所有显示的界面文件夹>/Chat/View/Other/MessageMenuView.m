//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 26/10/2020
 - File name:  MessageMenuView.m
 - Description:
 - Function List:
 */


#import "MessageMenuView.h"
#import "MessageMenuCollectionViewCell.h"
#import "MessageMenuTitleCollectionViewCell.h"
#import "MenuItem.h"
#import "ChatModel.h"
#import "ReactCollectionViewCell.h"
#import "ReactItem.h"
@interface MessageMenuView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIView *lineView;
@property(nonatomic, strong) UICollectionView *reactsCollectionView;
/** 复制 */
@property(nonatomic, strong) MenuItem *duplicateMenuItem;
/** 收藏 */
@property(nonatomic, strong) MenuItem *collectMenuItem;
/** 全选 */
@property(nonatomic, strong) MenuItem *allChoseMenuItem;
/** 转发 */
@property(nonatomic, strong) MenuItem *transpondMenuItem;
@property(nonatomic, strong) MenuItem *hideMenuItem;
/** 删除 */
@property(nonatomic, strong) MenuItem *deleteMenuItem;
/** 撤回 */
@property(nonatomic, strong) MenuItem *recallMenuItem;
/** 多选 */
@property(nonatomic, strong) MenuItem *multipleMenuItem;
/** 回复 */
@property(nonatomic, strong) MenuItem *replyMenuItem;
/** 听筒播放 */
@property(nonatomic, strong) MenuItem *receiverMenuItem;
/** 语音转文字 */
@property(nonatomic, strong) MenuItem *voiceToTextItem;
/** 添加快捷消息 */
@property(nonatomic, strong) MenuItem *addQuickMsgItem;
@property(nonatomic, strong) MenuItem *translateMenuItem;
@property(nonatomic, strong) MenuItem *originTextMenuItem;
@property(nonatomic, strong) MenuItem *addPinMsgItem;
@property(nonatomic, strong) MenuItem *addUnpinMsgItem;
@property(nonatomic, strong) ReactItem *heartReactedItem;
@property(nonatomic, strong) ReactItem *thumnbsUpReactedItem;
@property(nonatomic, strong) ReactItem *hahaReactedItem;
@property(nonatomic, strong) ReactItem *thumbsDownReactedItem;
@property(nonatomic, strong) ReactItem *wowReactedItem;
@property(nonatomic, strong) ReactItem *angryReactedItem;
@property(nonatomic, strong) ReactItem *heartNotReactItem;
@property(nonatomic, strong) ReactItem *thumnbsUpNotReactItem;
@property(nonatomic, strong) ReactItem *hahaNotReactItem;
@property(nonatomic, strong) ReactItem *thumbsDownNotReactItem;
@property(nonatomic, strong) ReactItem *wowNotReactItem;
@property(nonatomic, strong) ReactItem *angryNotReactItem;
@property(nonatomic, strong) UIView *menuView;
@property(nonatomic, strong) UIView *reactMenuView;
@property(nonatomic, strong) UIStackView *chatMessageMenuStackView;
/**
 是否是timeliness
 */
@property(nonatomic, assign) BOOL isTimeline;
@end
@implementation MessageMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@-20);
            make.height.equalTo(@0.5);
            make.centerY.equalTo(self.mas_centerY);
        }];
        self.backgroundColor=UIColorMakeHEXCOLOR(0X4c4c4c);
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = UIColorMakeHEXCOLOR(0X4c4c4c);
        [_collectionView layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
        [_collectionView registNibWithNibName:kMessageMenuCollectionViewCell];
        [_collectionView registNibWithNibName:kMessageMenuTitleCollectionViewCell];
    }
    return _collectionView;
}

-(UICollectionView *)reactsCollectionView{
    if (_reactsCollectionView == nil) {
        UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
        lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _reactsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:lay];
        _reactsCollectionView.dataSource = self;
        _reactsCollectionView.delegate = self;
        _reactsCollectionView.showsVerticalScrollIndicator = NO;
        _reactsCollectionView.showsHorizontalScrollIndicator = NO;
        _reactsCollectionView.scrollEnabled = YES;
        _reactsCollectionView.backgroundColor = UIColor.clearColor;
        [_reactsCollectionView registNibWithNibName:@"ReactCollectionViewCell"];

    }
    return _reactsCollectionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor=UIColorMakeHEXCOLOR(0x606060);
    }
    return _lineView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.reactsCollectionView){
        return self.reactMenuItems.count;
    }
    return self.menuItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.reactsCollectionView) {
        ReactCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReactCollectionViewCell" forIndexPath:indexPath];
        cell.reactItem = self.reactMenuItems[indexPath.item];
        return cell;
    }
    if (self.type == MessageMenuViewTypeTimelineComment) {
        MessageMenuTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMessageMenuTitleCollectionViewCell forIndexPath:indexPath];
        cell.menuItem = self.menuItems[indexPath.item];
        return cell;
    }
    MessageMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMessageMenuCollectionViewCell forIndexPath:indexPath];
    cell.menuItem = self.menuItems[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.reactsCollectionView){
        ReactItem *item = [self.reactMenuItems objectAtIndex:indexPath.item];
        if (self.messageMenuViewDelegate&&[self.messageMenuViewDelegate respondsToSelector:@selector(didClickMesageMenuViewDelegate: )]) {
            [self.messageMenuViewDelegate didClickReactMenuItemDelegate:item];
        }
    }else{
        MenuItem *item = [self.menuItems objectAtIndex:indexPath.item];
        [self hiddenMessageMenuView];
        if (item.selectMessageType == SelectMessageTypeReceiver) {
            [BaseSettingManager sharedManager].speaker =! [BaseSettingManager sharedManager].speaker;
        }
        if (self.messageMenuViewDelegate&&[self.messageMenuViewDelegate respondsToSelector:@selector(didClickMesageMenuViewDelegate: )]) {
            [self.messageMenuViewDelegate didClickMesageMenuViewDelegate:item];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
//设置大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if( collectionView == self.reactsCollectionView){
        return CGSizeMake((320-20)/6.0,50);
    }else{
        switch (self.type) {
            case MessageMenuViewTypeChatMessage:
                return CGSizeMake((320-25)/5.0,70);
                break;
            case MessageMenuViewTypeTimelineComment:
                return CGSizeMake((320-25)/5.0,30);
                break;
            case MessageMenuViewTypeTimelineContent:
                return CGSizeMake((320-25)/5.0,60);
                break;
            default:
                break;
        }
    }
    return CGSizeMake((320-25)/5.0,70);
}

//设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(collectionView == self.reactsCollectionView){
        return 0;
    }
    return 0;
}

//设置列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(collectionView == self.reactsCollectionView){
        return 0;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(collectionView == self.reactsCollectionView){
        return UIEdgeInsetsMake(0, 5, 0, 5);
    }
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)showTimelineCommentMenuView:(UIView*)originView convertRectView:(UIView*)convertRectView isMine:(BOOL)isMine showTranslate:(BOOL)showTranslate isShowOrigin:(BOOL)isShowOrigin {
    self.type = MessageMenuViewTypeTimelineComment;
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    self.isTimeline = YES;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:self.copyMenuItem];
    if (isMine) {
        [array addObject:self.deleteMenuItem];
    }
    if (showTranslate) {
        [array addObject:self.translateMenuItem];
    }
    if (isShowOrigin) {
        [array addObject:self.originTextMenuItem];
    }
    self.menuItems = array;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect convertRect = [originView convertRect:convertRectView.frame toView:window];
    //计算高度
    CGFloat height = 30;
    [UserInfoManager sharedManager].messageMenuView = self;
    self.lineView.hidden = YES;
    CGFloat width = self.menuItems.count>4?320:self.menuItems.count*70;
    //    width=140;
    [self.collectionView reloadData];
    [window addSubview:self];
    if (convertRect.origin.y-height>NavBarHeight+20) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.centerX.equalTo(convertRectView.mas_centerX);
            make.height.equalTo(@(height));
            make.bottom.equalTo(@(-(ScreenHeight- convertRect.origin.y+10)));
        }];
    }else{
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.centerX.equalTo(convertRectView.mas_centerX);
            make.height.equalTo(@(height));
            make.top.equalTo(@(convertRect.origin.y+convertRect.size.height+10));
        }];
    }
}

- (void)showTimelineMenuView:(UIView*)originView convertRectView:(UIView*)convertRectView {
    self.type = MessageMenuViewTypeTimelineContent;
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    self.isTimeline = YES;
    self.menuItems = @[self.copyMenuItem];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect convertRect = [originView convertRect:convertRectView.frame toView:window];
    //计算高度
    CGFloat height = 60;
    [UserInfoManager sharedManager].messageMenuView = self;
    self.lineView.hidden = YES;
    CGFloat width = 60;
    [self.collectionView reloadData];
    [window addSubview:self];
    if (convertRect.origin.y-height>NavBarHeight+20) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.centerX.equalTo(convertRectView.mas_centerX);
            make.height.equalTo(@(height));
            make.bottom.equalTo(@(-(ScreenHeight- convertRect.origin.y+10)));
        }];
    }else{
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
            make.centerX.equalTo(convertRectView.mas_centerX);
            make.height.equalTo(@(height));
            make.top.equalTo(@(convertRect.origin.y+convertRect.size.height+10));
        }];
    }
}

- (void)showMessageMenuView:(UIView*)originView convertRectView:(UIView*)convertRectView  ChatModel:(ChatModel*)chatModel showTime:(BOOL)isShowTime {
    long maxTime = 0;
    if([chatModel.chatType isEqualToString:UserChat]) {
        maxTime = 259200;
    }else if ([chatModel.chatType isEqualToString:GroupChat]) {
        maxTime = 180;
    }
    self.isTimeline = NO;
    self.type = MessageMenuViewTypeChatMessage;
    self.needReactionMenu = NO;
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    NSString *msgType = chatModel.messageType;
    NSMutableArray *items = [NSMutableArray array];
    if ([msgType isEqualToString:TextMessageType]||[msgType isEqualToString:URLMessageType]||[msgType isEqualToString:AtAllMessageType]||[msgType isEqualToString:AtSingleMessageType]){
        if([chatModel.chatID isEqual:@"100"]) {
            [items addObject:self.copyMenuItem];
            [items addObject:self.transpondMenuItem];
            if (chatModel.translateStatus != 1) {
                [items addObject:self.translateMenuItem];
            }
            if (chatModel.translateStatus == 1) {
                [items addObject:self.hideMenuItem];
            }
            if (!chatModel.isSelectAll) {
                [items addObject:self.allChoseMenuItem];
            }
            [items addObject:self.addQuickMsgItem];
            [items addObject:self.deleteMenuItem];
        }else {
            if ([chatModel.chatMode isEqualToString:ChatModeOtherChat]) {
                [items addObject:self.copyMenuItem];
                [items addObject:self.transpondMenuItem];
                [items addObject:self.collectMenuItem];
                if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
                    [items addObject:self.recallMenuItem];
                }
                [items addObject:self.replyMenuItem];
                if (chatModel.translateStatus != 1) {
                    [items addObject:self.translateMenuItem];
                }
                if (chatModel.translateStatus == 1) {
                    [items addObject:self.hideMenuItem];
                }
                [items addObject:self.multipleMenuItem];
                if (!chatModel.isSelectAll) {
                    [items addObject:self.allChoseMenuItem];
                }
                [items addObject:self.addQuickMsgItem];
            }else {
                [items addObject:self.copyMenuItem];
                [items addObject:self.transpondMenuItem];
                [items addObject:self.collectMenuItem];
                if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
                    [items addObject:self.recallMenuItem];
                }
                [items addObject:self.deleteMenuItem];
                [items addObject:self.replyMenuItem];
                if (chatModel.translateStatus != 1) {
                    [items addObject:self.translateMenuItem];
                }
                if (chatModel.translateStatus == 1) {
                    [items addObject:self.hideMenuItem];
                }
                [items addObject:self.multipleMenuItem];
                if (!chatModel.isSelectAll) {
                    [items addObject:self.allChoseMenuItem];
                }
                [items addObject:self.addQuickMsgItem];
            }
        }
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:LocationMessageType]) {
        [items addObject:self.deleteMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.multipleMenuItem];
        [items addObject:self.replyMenuItem];
    }else if ([msgType isEqualToString:AIMessageType]||[msgType isEqualToString:AIMessageQuestionType]){
        [items addObject:self.copyMenuItem];
        [items addObject:self.transpondMenuItem];
        if (chatModel.translateStatus != 1) {
            [items addObject:self.translateMenuItem];
        }
        if (chatModel.translateStatus == 1) {
            [items addObject:self.hideMenuItem];
        }
        if (!chatModel.isSelectAll) {
            [items addObject:self.allChoseMenuItem];
        }
        [items addObject:self.addQuickMsgItem];
        [items addObject:self.deleteMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:ImageMessageType]) {
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:FileMessageType]) {
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:VideoMessageType]){
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:UserCardMessageType]){
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:kChatOtherShareType]) {
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:kChat_PostShare]) {
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:ChatCallMessageType]){
        [items addObject:self.deleteMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:VoiceMessageType]) {
        if ([BaseSettingManager sharedManager].speaker) {
            self.receiverMenuItem.img = @"icon_right_receiver";
            self.receiverMenuItem.title = @"Turn off Speaker".icanlocalized;
        }else{
            self.receiverMenuItem.img = @"icon_right_speaker";
            self.receiverMenuItem.title = @"Turn on Speaker".icanlocalized;
        }
        [items addObject:self.receiverMenuItem];
        [items addObject:self.deleteMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:SendSingleRedPacketType]||[msgType isEqualToString:SendRoomRedPacketType]||[msgType isEqualToString:TransFerMessageType]){
        [items addObject:self.deleteMenuItem];
        [items addObject:self.multipleMenuItem];
        [items removeObject:self.addPinMsgItem];
        [items removeObject:self.addUnpinMsgItem];
    }
    if ([chatModel.authorityType isEqualToString:AuthorityType_secret]) {
        //密聊没有收藏和转发
        [items removeObject:self.transpondMenuItem];
        [items removeObject:self.collectMenuItem];
        [items removeObject:self.addPinMsgItem];
        [items removeObject:self.addUnpinMsgItem];
    }else  if ([chatModel.authorityType isEqualToString:AuthorityType_circle]) {
        //交友没有收藏和转发
        [items removeObject:self.transpondMenuItem];
        [items removeObject:self.collectMenuItem];
        [items removeObject:self.addPinMsgItem];
        [items removeObject:self.addUnpinMsgItem];
    }else if ([chatModel.authorityType isEqualToString:AuthorityType_c2c]){
        //复制  删除  引用  翻译 撤回
        //交友没有收藏和转发和多选
        [items removeObject:self.transpondMenuItem];
        [items removeObject:self.collectMenuItem];
        [items removeObject:self.multipleMenuItem];
        [items removeObject:self.addPinMsgItem];
        [items removeObject:self.addUnpinMsgItem];
    }

    self.menuItems = items;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect convertRect = [originView convertRect:convertRectView.frame toView:window];
    //计算高度 弹框的高度
    CGFloat height = self.menuItems.count>5?140:70;
    [UserInfoManager sharedManager].messageMenuView = self;
    self.lineView.hidden = self.menuItems.count<6;
    CGFloat width = self.menuItems.count>4?320:self.menuItems.count*70;
    [self.collectionView reloadData];
    CGFloat margin = isShowTime?44:20;
    [window addSubview:self];
    if (convertRect.size.width>width) {
        //弹框显示在上面
        if (convertRect.origin.y+margin-height>NavBarHeight+20) {
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.centerX.equalTo(convertRectView.mas_centerX);
                make.height.equalTo(@(height));
                make.bottom.equalTo(@(-(ScreenHeight- convertRect.origin.y-margin+10)));
            }];
        }else{
            [self mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
                make.centerX.equalTo(convertRectView.mas_centerX);
                make.height.equalTo(@(height));
                make.top.equalTo(@(convertRect.origin.y+convertRect.size.height+margin+10));
            }];
        }
    }else{
        if (chatModel.isOutGoing) {
            if (convertRect.origin.y-margin-height>NavBarHeight+20) {
                [self mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(width));
                    make.height.equalTo(@(height));
                    make.bottom.equalTo(@(-(ScreenHeight- convertRect.origin.y-margin+10)));
                    make.right.equalTo(@-10);
                }];
            }else{
                [self mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(width));
                    make.right.equalTo(@-10);
                    make.height.equalTo(@(height));
                    make.top.equalTo(@((ScreenHeight)/2));
                }];
            }
        }else{
            if (convertRect.origin.y-margin-height>NavBarHeight+20) {
                [self mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(width));
                    make.left.equalTo(@10);
                    make.height.equalTo(@(height));
                    make.bottom.equalTo(@(-(ScreenHeight- convertRect.origin.y-margin+10)));
                }];
            }else{
                [self mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(width));
                    make.left.equalTo(@10);
                    make.height.equalTo(@(height));
                    make.top.equalTo(@((ScreenHeight)/2));
                }];
            }
        }
    }
}

- (void)showReactionMenuView:(UIView*)originView convertRectView:(UIView*)convertRectView  ChatModel:(ChatModel*)chatModel showTime:(BOOL)isShowTime {
    long maxTime = 0;
    if([chatModel.chatType isEqualToString:UserChat]) {
        maxTime = 259200;
    }else if ([chatModel.chatType isEqualToString:GroupChat]) {
        maxTime = 180;
    }
    self.isTimeline = NO;
    self.type = MessageMenuViewTypeChatMessage;
    self.needReactionMenu = YES;
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    NSString *msgType = chatModel.messageType;
    NSMutableArray *items = [NSMutableArray array];
    if ([msgType isEqualToString:TextMessageType]||[msgType isEqualToString:URLMessageType]||[msgType isEqualToString:AtAllMessageType]||[msgType isEqualToString:AtSingleMessageType]){
        if([chatModel.chatID isEqual:@"100"]) {
            [items addObject:self.copyMenuItem];
            [items addObject:self.transpondMenuItem];
            if (chatModel.translateStatus != 1) {
                [items addObject:self.translateMenuItem];
            }
            if (chatModel.translateStatus == 1) {
                [items addObject:self.hideMenuItem];
            }
            if (!chatModel.isSelectAll) {
                [items addObject:self.allChoseMenuItem];
            }
            [items addObject:self.addQuickMsgItem];
            [items addObject:self.deleteMenuItem];
        }else {
            if ([chatModel.chatMode isEqualToString:ChatModeOtherChat]) {
                [items addObject:self.copyMenuItem];
                [items addObject:self.transpondMenuItem];
                [items addObject:self.collectMenuItem];
                if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
                    [items addObject:self.recallMenuItem];
                }
                [items addObject:self.replyMenuItem];
                if (chatModel.translateStatus != 1) {
                    [items addObject:self.translateMenuItem];
                }
                if (chatModel.translateStatus == 1) {
                    [items addObject:self.hideMenuItem];
                }
                [items addObject:self.multipleMenuItem];
                if (!chatModel.isSelectAll) {
                    [items addObject:self.allChoseMenuItem];
                }
                [items addObject:self.addQuickMsgItem];
            }else {
                [items addObject:self.copyMenuItem];
                [items addObject:self.transpondMenuItem];
                [items addObject:self.collectMenuItem];
                if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
                    [items addObject:self.recallMenuItem];
                }
                [items addObject:self.deleteMenuItem];
                [items addObject:self.replyMenuItem];
                if (chatModel.translateStatus != 1) {
                    [items addObject:self.translateMenuItem];
                }
                if (chatModel.translateStatus == 1) {
                    [items addObject:self.hideMenuItem];
                }
                [items addObject:self.multipleMenuItem];
                if (!chatModel.isSelectAll) {
                    [items addObject:self.allChoseMenuItem];
                }
                [items addObject:self.addQuickMsgItem];
            }
        }
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:LocationMessageType]) {
        [items addObject:self.deleteMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.multipleMenuItem];
        [items addObject:self.replyMenuItem];
    }else if ([msgType isEqualToString:AIMessageType]||[msgType isEqualToString:AIMessageQuestionType]){
        [items addObject:self.copyMenuItem];
        [items addObject:self.transpondMenuItem];
        if (chatModel.translateStatus != 1) {
            [items addObject:self.translateMenuItem];
        }
        if (chatModel.translateStatus == 1) {
            [items addObject:self.hideMenuItem];
        }
        if (!chatModel.isSelectAll) {
            [items addObject:self.allChoseMenuItem];
        }
        [items addObject:self.addQuickMsgItem];
        [items addObject:self.deleteMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:ImageMessageType]) {
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:FileMessageType]) {
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:VideoMessageType]){
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:UserCardMessageType]){
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:kChatOtherShareType]) {
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:kChat_PostShare]) {
        [items addObject:self.transpondMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.deleteMenuItem];
        [items addObject:self.replyMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:ChatCallMessageType]){
        [items addObject:self.deleteMenuItem];
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:VoiceMessageType]) {
        if ([BaseSettingManager sharedManager].speaker) {
            self.receiverMenuItem.img = @"icon_right_receiver";
            self.receiverMenuItem.title = @"Turn off Speaker".icanlocalized;
        }else{
            self.receiverMenuItem.img = @"icon_right_speaker";
            self.receiverMenuItem.title = @"Turn on Speaker".icanlocalized;
        }
        [items addObject:self.receiverMenuItem];
        [items addObject:self.deleteMenuItem];
        [items addObject:self.collectMenuItem];
        if ([GetTime messageCanWithdrawWithTime:chatModel.messageTime maxTime:maxTime] && chatModel.sendState == 1 && chatModel.isOutGoing) {
            [items addObject:self.recallMenuItem];
        }
        [items addObject:self.multipleMenuItem];
        if(chatModel.isPin == YES) {
            [items removeObject:self.addPinMsgItem];
            [items addObject:self.addUnpinMsgItem];
        }else if(chatModel.isPin == NO) {
            [items addObject:self.addPinMsgItem];
            [items removeObject:self.addUnpinMsgItem];
        }
    }else if ([msgType isEqualToString:SendSingleRedPacketType]||[msgType isEqualToString:SendRoomRedPacketType]||[msgType isEqualToString:TransFerMessageType]){
        [items addObject:self.deleteMenuItem];
        [items addObject:self.multipleMenuItem];
        [items removeObject:self.addPinMsgItem];
        [items removeObject:self.addUnpinMsgItem];
    }
    if ([chatModel.authorityType isEqualToString:AuthorityType_secret]) {
        //密聊没有收藏和转发
        [items removeObject:self.transpondMenuItem];
        [items removeObject:self.collectMenuItem];
        [items removeObject:self.addPinMsgItem];
        [items removeObject:self.addUnpinMsgItem];
    }else  if ([chatModel.authorityType isEqualToString:AuthorityType_circle]) {
        //交友没有收藏和转发
        [items removeObject:self.transpondMenuItem];
        [items removeObject:self.collectMenuItem];
        [items removeObject:self.addPinMsgItem];
        [items removeObject:self.addUnpinMsgItem];
    }else if ([chatModel.authorityType isEqualToString:AuthorityType_c2c]){
        //复制  删除  引用  翻译 撤回
        //交友没有收藏和转发和多选
        [items removeObject:self.transpondMenuItem];
        [items removeObject:self.collectMenuItem];
        [items removeObject:self.multipleMenuItem];
        [items removeObject:self.addPinMsgItem];
        [items removeObject:self.addUnpinMsgItem];
    }
    self.menuItems = items;
    NSMutableArray *reactItems = [NSMutableArray array];
    if([chatModel.selfReaction isEqualToString:@"❤️"]){
        [reactItems addObject:self.heartReactedItem];
        [reactItems addObject:self.thumnbsUpNotReactItem];
        [reactItems addObject:self.thumbsDownNotReactItem];
        [reactItems addObject:self.hahaNotReactItem];
        [reactItems addObject:self.wowNotReactItem];
        [reactItems addObject:self.angryNotReactItem];
    }else if ([chatModel.selfReaction isEqualToString:@"👍"]){
        [reactItems addObject:self.heartNotReactItem];
        [reactItems addObject:self.thumnbsUpReactedItem];
        [reactItems addObject:self.thumbsDownNotReactItem];
        [reactItems addObject:self.hahaNotReactItem];
        [reactItems addObject:self.wowNotReactItem];
        [reactItems addObject:self.angryNotReactItem];
    }else if ([chatModel.selfReaction isEqualToString:@"👎"]){
        [reactItems addObject:self.heartNotReactItem];
        [reactItems addObject:self.thumnbsUpNotReactItem];
        [reactItems addObject:self.thumbsDownReactedItem];
        [reactItems addObject:self.hahaNotReactItem];
        [reactItems addObject:self.wowNotReactItem];
        [reactItems addObject:self.angryNotReactItem];
    }else if ([chatModel.selfReaction isEqualToString:@"😂"]){
        [reactItems addObject:self.heartNotReactItem];
        [reactItems addObject:self.thumnbsUpNotReactItem];
        [reactItems addObject:self.thumbsDownNotReactItem];
        [reactItems addObject:self.hahaReactedItem];
        [reactItems addObject:self.wowNotReactItem];
        [reactItems addObject:self.angryNotReactItem];
    }else if ([chatModel.selfReaction isEqualToString:@"😯"]){
        [reactItems addObject:self.heartNotReactItem];
        [reactItems addObject:self.thumnbsUpNotReactItem];
        [reactItems addObject:self.thumbsDownNotReactItem];
        [reactItems addObject:self.hahaNotReactItem];
        [reactItems addObject:self.wowReactedItem];
        [reactItems addObject:self.angryNotReactItem];
    }else if ([chatModel.selfReaction isEqualToString:@"😡"]){
        [reactItems addObject:self.heartNotReactItem];
        [reactItems addObject:self.thumnbsUpNotReactItem];
        [reactItems addObject:self.thumbsDownNotReactItem];
        [reactItems addObject:self.hahaNotReactItem];
        [reactItems addObject:self.wowNotReactItem];
        [reactItems addObject:self.angryReactedItem];
    }else{
        [reactItems addObject:self.heartNotReactItem];
        [reactItems addObject:self.thumnbsUpNotReactItem];
        [reactItems addObject:self.thumbsDownNotReactItem];
        [reactItems addObject:self.hahaNotReactItem];
        [reactItems addObject:self.wowNotReactItem];
        [reactItems addObject:self.angryNotReactItem];
    }
    self.reactMenuItems = reactItems;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect convertRect = [originView convertRect:convertRectView.frame toView:window];
    //计算高度 弹框的高度
    CGFloat menuHeight = self.menuItems.count>5?140:70;
    [UserInfoManager sharedManager].messageMenuView = self;
    self.lineView.hidden = self.menuItems.count<6;
    CGFloat menuWidth = self.menuItems.count>4?320:self.menuItems.count*70;
    [self.collectionView reloadData];
    CGFloat menuMargin = isShowTime?44:20;

    CGFloat reactionHeight = 60;
//    [UserInfoManager sharedManager].messageMenuView = self;
    CGFloat reactionWidth = 308;
    [self.reactsCollectionView reloadData];
    CGFloat reactionMargin = isShowTime?44:20;
    self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, menuWidth, menuHeight)];
    self.reactMenuView = [[UIView alloc]init];
    [self.menuView layerWithCornerRadius:7 borderWidth:0 borderColor:nil];
    [self.menuView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.menuView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@0.5);
        make.centerY.equalTo(self.menuView.mas_centerY);
    }];
    self.menuView.backgroundColor=UIColorMakeHEXCOLOR(0X4c4c4c);
    [self.reactMenuView layerWithCornerRadius:30 borderWidth:0 borderColor:nil];
    [self.reactMenuView addSubview:self.reactsCollectionView];
    [self.reactsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.reactMenuView.backgroundColor = UIColorMakeHEXCOLOR(0X4c4c4c);
    [window addSubview:self.reactMenuView];
    [window addSubview:self.menuView];
    if (chatModel.isOutGoing) {
        if (convertRect.origin.y-reactionMargin-reactionHeight>NavBarHeight+20) {
            [self.reactMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(reactionWidth));
                make.height.equalTo(@(reactionHeight));
                make.top.equalTo(@((convertRect.origin.y-50)));
                make.right.equalTo(@-10);
            }];
        }else{
            if(convertRect.origin.y < 0){
                [self.reactMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(reactionWidth));
                    make.right.equalTo(@-10);
                    make.height.equalTo(@(reactionHeight));
                    make.top.equalTo(@(NavBarHeight + 20));
                }];
            }else{
                [self.reactMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(reactionWidth));
                    make.right.equalTo(@-10);
                    make.height.equalTo(@(reactionHeight));
                    make.top.equalTo(@((convertRect.origin.y + 50)));
                }];
            }
        }
    }else{
        if (convertRect.origin.y-reactionMargin-reactionHeight>NavBarHeight+20) {
            [self.reactMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(reactionWidth));
                make.left.equalTo(@10);
                make.height.equalTo(@(reactionHeight));
                make.top.equalTo(@((convertRect.origin.y-50)));
            }];
        }else{
            if(convertRect.origin.y < 0){
                [self.reactMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(reactionWidth));
                    make.left.equalTo(@10);
                    make.height.equalTo(@(reactionHeight));
                    make.top.equalTo(@(NavBarHeight + 20));
                }];
            }else{
                [self.reactMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(reactionWidth));
                    make.left.equalTo(@10);
                    make.height.equalTo(@(reactionHeight));
                    make.top.equalTo(@((convertRect.origin.y + 60)));
                }];
            }
        }
    }
    if(([chatModel.messageType isEqualToString:SendSingleRedPacketType]||[chatModel.messageType isEqualToString:SendRoomRedPacketType])){
        if (chatModel.isOutGoing) {
            [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(menuWidth));
                make.right.equalTo(@-10);
                make.height.equalTo(@(menuHeight));
                make.top.equalTo(self.reactMenuView.mas_bottom).offset(60);
            }];
        }else{
            [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(menuWidth));
                make.left.equalTo(@10);
                make.height.equalTo(@(menuHeight));
                make.top.equalTo(self.reactMenuView.mas_bottom).offset(60);
            }];
        }
    }else{
        if (chatModel.isOutGoing) {
            if (convertRect.origin.y-menuMargin-menuHeight>NavBarHeight+20) {
                if(ScreenHeight - convertRect.origin.y < menuHeight + menuMargin + 50){
                    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@(menuWidth));
                        make.right.equalTo(@-10);
                        make.height.equalTo(@(menuHeight));
                        make.bottom.equalTo(self.reactMenuView.mas_top).offset(-40);
                    }];
                }else {
                    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@(menuWidth));
                        make.height.equalTo(@(menuHeight));
                        make.top.equalTo(self.reactMenuView.mas_bottom).offset(menuMargin+30);
                        make.right.equalTo(@-10);
                    }];
                }
            }else{
                [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(menuWidth));
                    make.right.equalTo(@-10);
                    make.height.equalTo(@(menuHeight));
                    make.top.equalTo(self.reactMenuView.mas_bottom).offset(menuMargin+35);
                }];
            }
        }else{
            if (convertRect.origin.y-menuMargin-menuHeight>NavBarHeight+20) {
                if(ScreenHeight - convertRect.origin.y < menuHeight + menuMargin + 50){
                    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@(menuWidth));
                        make.left.equalTo(@10);
                        make.height.equalTo(@(menuHeight));
                        make.bottom.equalTo(self.reactMenuView.mas_top).offset(-40);
                    }];
                }else {
                    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@(menuWidth));
                        make.height.equalTo(@(menuHeight));
                        make.top.equalTo(self.reactMenuView.mas_bottom).offset(menuMargin+30);
                        make.left.equalTo(@10);
                    }];
                }
            }else{
                [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(menuWidth));
                    make.left.equalTo(@10);
                    make.height.equalTo(@(menuHeight));
                    make.top.equalTo(self.reactMenuView.mas_bottom).offset(menuMargin+45);
                }];
            }
        }
    }

}

- (void)hiddenMessageMenuView {
    if(self.needReactionMenu){
        [self.reactMenuView removeFromSuperview];
        [self.menuView removeFromSuperview];
        [self removeFromSuperview];
    }else{
        [self removeFromSuperview];
    }

}

- (MenuItem *)collectMenuItem {
    if (!_collectMenuItem) {
        _collectMenuItem = [MenuItem menuItemWithTitle:NSLocalizedString(@"collect", 收藏) img:@"icon_right_collect" selectMessageType:SelectMessageTypeCollection];
    }
    return _collectMenuItem;
}

- (MenuItem *)duplicateMenuItem {
    if (!_duplicateMenuItem) {
        _duplicateMenuItem = [MenuItem menuItemWithTitle:NSLocalizedString(@"Copy", 复制) img:@"icon_right_copy" selectMessageType:SelectMessageTypeCopy];
    }
    return _duplicateMenuItem;
}

- (MenuItem *)translateMenuItem {
    if (!_translateMenuItem) {
        _translateMenuItem = [MenuItem menuItemWithTitle:NSLocalizedString(@"translate", 翻译) img:@"icon_right_translate" selectMessageType:SelectMessageTypeTranslate];
    }
    return _translateMenuItem;
}

- (MenuItem *)originTextMenuItem {
    if (!_originTextMenuItem) {
        _originTextMenuItem = [MenuItem menuItemWithTitle:@"原文".icanlocalized img:@"icon_right_translate" selectMessageType:SelectMessageTypeOriginText];
    }
    return _originTextMenuItem;
}

- (MenuItem *)transpondMenuItem {
    if (!_transpondMenuItem) {
        _transpondMenuItem = [MenuItem menuItemWithTitle:NSLocalizedString(@"AddToFavorites", 转发) img:@"icon_right_forward" selectMessageType:SelectMessageTypeForward];
    }
    return _transpondMenuItem;
}

- (MenuItem *)hideMenuItem {
    if (!_hideMenuItem) {
        _hideMenuItem = [MenuItem menuItemWithTitle:NSLocalizedString(@"Hide Translation".icanlocalized, 转发) img:@"hide_translation" selectMessageType:SelectMessageTypeTranslateHide];
    }
    return _hideMenuItem;
}

- (MenuItem *)deleteMenuItem {
    if (!_deleteMenuItem) {
        _deleteMenuItem = [MenuItem menuItemWithTitle:[@"timeline.post.operation.delete" icanlocalized:@"删除"] img:@"icon_right_delect" selectMessageType:SelectMessageTypeDelete];
    }
    return _deleteMenuItem;
}

- (MenuItem *)recallMenuItem {
    if (!_recallMenuItem) {
        _recallMenuItem = [MenuItem menuItemWithTitle:NSLocalizedString(@"Recall", 撤回) img:@"icon_right_withdraw" selectMessageType:SelectMessageTypeWithdraw];
    }
    return _recallMenuItem;
}

- (MenuItem *)copyMenuItem {
    if (!_copyMenuItem) {
        _copyMenuItem = [MenuItem menuItemWithTitle:NSLocalizedString(@"Copy", 复制) img:@"icon_right_copy" selectMessageType:SelectMessageTypeCopy];
    }
    return _copyMenuItem;
}

- (MenuItem *)multipleMenuItem {
    if (!_multipleMenuItem) {
        _multipleMenuItem = [MenuItem menuItemWithTitle:NSLocalizedString(@"Multiple", 多选) img:@"icon_right_choice" selectMessageType:SelectMessageTypeMore];
    }
    return _multipleMenuItem;
}

- (MenuItem *)replyMenuItem {
    if (!_replyMenuItem) {
        _replyMenuItem = [MenuItem menuItemWithTitle:@"MessageMenuView.Reply".icanlocalized img:@"icon_right_quote" selectMessageType:SelectMessageTypeReply];
    }
    return _replyMenuItem;
}

- (MenuItem *)allChoseMenuItem {
    if (!_allChoseMenuItem) {
        _allChoseMenuItem = [MenuItem menuItemWithTitle:@"select all".icanlocalized img:@"icon_right_all" selectMessageType:SelectMessageTypeAll];
    }
    return _allChoseMenuItem;
}

- (MenuItem *)receiverMenuItem {
    if (!_receiverMenuItem) {
        //扬声器播放Turn On Speaker
        //听筒播放Turn Of Speaker icon_right_receiver
        _receiverMenuItem = [MenuItem menuItemWithTitle:@"Turn off Speaker" img:@"icon_right_receiver" selectMessageType:SelectMessageTypeReceiver];
    }
    return _receiverMenuItem;
}

- (MenuItem *)voiceToTextItem {
    if (!_voiceToTextItem) {
        _voiceToTextItem = [MenuItem menuItemWithTitle:@"语音转文字" img:@"" selectMessageType:SelectMessageTypeVoiceToText];
    }
    return _voiceToTextItem;
}

- (MenuItem *)addQuickMsgItem {
    if (!_addQuickMsgItem) {
        _addQuickMsgItem = [MenuItem menuItemWithTitle:@"QuickMessage".icanlocalized img:@"icon_add_quick" selectMessageType:SelectMessageTypeQuickMessage];
    }
    return _addQuickMsgItem;
}

- (MenuItem *)addPinMsgItem {
    if (!_addPinMsgItem) {
        _addPinMsgItem = [MenuItem menuItemWithTitle:@"Pin".icanlocalized img:@"pin_icon" selectMessageType:SelectMessageTypePinMessage];
    }
    return _addPinMsgItem;
}

- (MenuItem *)addUnpinMsgItem {
    if (!_addUnpinMsgItem) {
        _addUnpinMsgItem = [MenuItem menuItemWithTitle:@"Unpin".icanlocalized img:@"unpin_icon" selectMessageType:SelectMessageTypeUnpinMessage];
    }
    return _addUnpinMsgItem;
}

- (ReactItem *)heartReactedItem {
    if (!_heartReactedItem) {
        _heartReactedItem = [ReactItem menuWithReactItem:@"❤️" reactImg:@"icon_not_reacted_heart" bgColor:UIColorMakeHEXCOLOR(0x757575)];
    }
    return _heartReactedItem;
}

- (ReactItem *)thumnbsUpReactedItem {
    if (!_thumnbsUpReactedItem) {
        _thumnbsUpReactedItem = [ReactItem menuWithReactItem:@"👍" reactImg:@"icon_not_reacted_thumbsup" bgColor:UIColorMakeHEXCOLOR(0x757575)];
    }
    return _thumnbsUpReactedItem;
}

- (ReactItem *)thumbsDownReactedItem {
    if (!_thumbsDownReactedItem) {
        _thumbsDownReactedItem = [ReactItem menuWithReactItem:@"👎" reactImg:@"icon_not_reacted_thumbsdown"bgColor:UIColorMakeHEXCOLOR(0x757575)];
    }
    return _thumbsDownReactedItem;
}

- (ReactItem *)wowReactedItem {
    if (!_wowReactedItem) {
        _wowReactedItem = [ReactItem menuWithReactItem:@"😯" reactImg:@"icon_not_reacted_wow" bgColor:UIColorMakeHEXCOLOR(0x757575)];
    }
    return _wowReactedItem;
}

- (ReactItem *)angryReactedItem {
    if (!_angryReactedItem) {
        _angryReactedItem = [ReactItem menuWithReactItem:@"😡" reactImg:@"icon_not_reacted_angry" bgColor:UIColorMakeHEXCOLOR(0x757575)];
    }
    return _angryReactedItem;
}

- (ReactItem *)hahaReactedItem {
    if (!_hahaReactedItem) {
        _hahaReactedItem = [ReactItem menuWithReactItem:@"😂" reactImg:@"icon_not_reacted_haha" bgColor:UIColorMakeHEXCOLOR(0x757575)];
    }
    return _hahaReactedItem;
}

- (ReactItem *)heartNotReactItem {
    if (!_heartNotReactItem) {
        _heartNotReactItem = [ReactItem menuWithReactItem:@"❤️" reactImg:@"icon_not_reacted_heart" bgColor:UIColorMakeHEXCOLOR(0X4c4c4c)];
    }
    return _heartNotReactItem;
}

- (ReactItem *)thumnbsUpNotReactItem {
    if (!_thumnbsUpNotReactItem) {
        _thumnbsUpNotReactItem = [ReactItem menuWithReactItem:@"👍" reactImg:@"icon_not_reacted_thumbsup" bgColor:UIColorMakeHEXCOLOR(0X4c4c4c)];
    }
    return _thumnbsUpNotReactItem;
}

- (ReactItem *)thumbsDownNotReactItem {
    if (!_thumbsDownNotReactItem) {
        _thumbsDownNotReactItem = [ReactItem menuWithReactItem:@"👎" reactImg:@"icon_not_reacted_thumbsdown" bgColor:UIColorMakeHEXCOLOR(0X4c4c4c)];
    }
    return _thumbsDownNotReactItem;
}

- (ReactItem *)wowNotReactItem {
    if (!_wowNotReactItem) {
        _wowNotReactItem = [ReactItem menuWithReactItem:@"😯" reactImg:@"icon_not_reacted_wow" bgColor:UIColorMakeHEXCOLOR(0X4c4c4c)];
    }
    return _wowNotReactItem;
}

- (ReactItem *)angryNotReactItem {
    if (!_angryNotReactItem) {
        _angryNotReactItem = [ReactItem menuWithReactItem:@"😡" reactImg:@"icon_not_reacted_angry" bgColor:UIColorMakeHEXCOLOR(0X4c4c4c)];
    }
    return _angryNotReactItem;
}

- (ReactItem *)hahaNotReactItem {
    if (!_hahaNotReactItem) {
        _hahaNotReactItem = [ReactItem menuWithReactItem:@"😂" reactImg:@"icon_not_reacted_haha" bgColor:UIColorMakeHEXCOLOR(0X4c4c4c)];
    }
    return _hahaNotReactItem;
}

-(UIStackView *)chatMessageMenuStackView{
    if (!_chatMessageMenuStackView) {
        _chatMessageMenuStackView = [[UIStackView alloc]init];
        _chatMessageMenuStackView.axis = UILayoutConstraintAxisVertical;
        _chatMessageMenuStackView.alignment = UIStackViewAlignmentFill;
        _chatMessageMenuStackView.distribution = UIStackViewDistributionFill;
    }
    return _chatMessageMenuStackView;
}

@end

