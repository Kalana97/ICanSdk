
#import "ChatViewController.h"
#import "ChatUtil.h"
#import "ChatAlbumModel.h"
#import "OSSWrapper.h"
#import "RSAEncryptor.h"
#import "VoicePlayerTool.h"
#import "ChatViewHandleTool.h"
#import "ChatMoreTagItem.h"
#import "XMChatMoreView.h"
#import "WebSocketManager+HandleMessage.h"
#import "QRCodeController.h"
#import "UIButton+HYQUIButton.h"
#import "UIView+HYQEx.h"
#import "UIImage+photoPicker.h"

#import "QDNavigationController.h"
#import "AudioPlayerManager.h"
#import "MJRefresh.h"
#import "WCDBManager+ChatModel.h"

#import "ChatWithdrawTableViewCell.h"
#import "ChatNoticeTableViewCell.h"
#import "ChatMineMessageTableViewCell.h"
#import "ChatRedPacketTipsTableViewCell.h"
#import "ChatOtherMessageTableViewCell.h"

#import "YBImageBrowerTool.h"
#import "GroupDetailViewController.h"
#import "ChatDetailViewController.h"
#import "SelectUserCardViewController.h"
#import "SettingPaymentPasswordViewController.h"
#import "GroupApplyDetailViewController.h"

#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatSetting.h"
#import "ChatSetting.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+GroupListInfo.h"
#import "WCDBManager+CircleUserInfo.h"
#import "ChatListModel.h"

#import "UnFriendHeaderTipsView.h"
#import "UIImagePickerHelper.h"
#import "HJCActionSheet.h"
#import "ChatFunctionView.h"

#import "FriendDetailViewController.h"
#import "TranspondTableViewController.h"
#import "SelectAtUserTableViewController.h"
#import "PrivacyPermissionsTool.h"
#import "ChatViewNavBarView.h"
#import "TransferViewController.h"
#import "MJRefreshGifHeader.h"
#import "WCDBManager+ChatList.h"
#import "MultipleSelectionShowView.h"
#import "SaveViewManager.h"

#import "SendSingleRedTableViewController.h"
#import "SendMultipleRedPacketViewController.h"
#import "SendVipRedPacketViewController.h"
#import "RedPacketReceiveDetailViewController.h"
#import "ShowReplyTextViewController.h"
#import "TimelinesDetailViewController.h"
#import "NeCallBaseViewController.h"
#import "CircleUserDetailViewController.h"
#import "JudgeMessageTypeManager.h"
#import "UIViewController+Extension.h"
#import "UIImage+Compression.h"

#import "ChatViewConnectTipsView.h"
#import "HXPhotoPicker.h"
#import "NERtcCallKit.h"
#import "ChatViewReplyView.h"
#import "FastMessageView.h"
#import "GoTopActionView.h"
#import "GroupApplyInfo.h"

#import "ChatLeftMsgBaseTableViewCell.h"
#import "ChatLeftTxtMsgTableViewCell.h"
#import "ChatLeftUrlMsgTableViewCell.h"
#import "ChatLeftImgMsgTableViewCell.h"
#import "ChatLeftVoiceTableViewCell.h"
#import "ChatLeftVideoTableViewCell.h"
#import "ChatLeftFileTableViewCell.h"
#import "ChatLeftNimCallTableViewCell.h"
#import "ChatLeftTimelineTableViewCell.h"
#import "ChatLeftGoodsTableViewCell.h"

#import "ChatRightTxtMsgTableViewCell.h"
#import "ChatRightUrlMsgTableViewCell.h"
#import "ChatRightImgMsgTableViewCell.h"
#import "ChatRightVoiceTableViewCell.h"
#import "ChatRightVideoTableViewCell.h"
#import "ChatRightFileTableViewCell.h"
#import "ChatRightNimCallTableViewCell.h"
#import "ChatRightTimelineTableViewCell.h"
#import "ChatRightGoodsTableViewCell.h"

#import "SelectMKMapLocationViewController.h"
#import "GoBottomActionView.h"
#import <WBGLinkPreview/WBGLinkPreview.h>
#import "TFHpple.h"
#import "ChatRightAnimationView.h"
#import "ChatLeftAnimationView.h"
#import "TranslatorViewMenue.h"
#import "JKPickerView.h"
#import "PinMenueBar.h"
#import "MsgContentModel.h"
#import "PinMessageTableViewController.h"
#import "ReactItem.h"
#import "EmailBindingViewController.h"
#ifdef ICANTYPE
#import "iCan_我行-Swift.h"
#else
#import "ICanCN-Swift.h"
#endif
@interface ChatViewController ()<WebSocketManagerDelegate,DZAudioPlayerManagerDelegate,HJCActionSheetDelegate,ChatFunctionViewDelegate,ChatViewHandleToolDelegate,
UIGestureRecognizerDelegate,QMUINavigationControllerTransitionDelegate,OtherMessageCellDelegate,BaseMineMessageCelllDelegate,ChatLeftMsgCellDelegate,ChatRightMsgCellDelegate,TranslatorViewMenueDelegate,PinMenueBarDelegate>
///消息数据源
@property(nonatomic, strong) NSMutableArray<ChatModel*> *messageItems;

@property(nonatomic, strong) NSMutableArray<ChatModel*> *inQ;
@property (nonatomic,strong) NSMutableArray <LanguageInfo*> *languageItems;
@property(nonatomic, strong) NSMutableArray<ChatModel*> *visibleMessageItems;
/** 当前需要上传的图片model */
@property(nonatomic,strong) NSArray<ChatModel*> *needUploadImageItems;
/**当前表格是否正在滑动*/
@property(nonatomic, assign) BOOL isScrollViewScroll;
/**安全区域*/
@property(nonatomic, assign) CGFloat defaultHeight;
/** 当前插叙的页数 */
@property(nonatomic ,assign) NSInteger current;
/** 当前点击的某一行cell的model */
@property(nonatomic ,strong) ChatModel * currentTapChatModel;

@property(nonatomic,strong)  ChatModel * currentPlayingVoiceModel;
/** 当前正在播放的视频的model */
@property(nonatomic,strong)  ChatModel * currentPlayVideoModel;
/** 当前正在被回复的model */
@property(nonatomic, strong)  ChatModel *replyModel;

@property(nonatomic ,strong) ChatModel * newmessageModel;

@property(strong,nonatomic)  UserMessageInfo * userMessageInfo;
@property(strong,nonatomic)  UserMessageInfo * currentUserMessageInfo;
@property(nonatomic,strong)  HJCActionSheet * hjcActionSheet;
/** 当前选中的删除的消息的位置 */
@property(nonatomic,strong)  NSIndexPath * deleteIndexPath;

@property(nonatomic, strong)  ChatFunctionView  *chatFunctionView;
@property(nonatomic, strong)  TranslatorViewMenue  *translatorViewMenue;
@property(nonatomic, strong)  PinMenueBar  *pinMenueBar;
@property(nonatomic, strong)  ChatSetting * chatSetting;

@property(nonatomic, strong)  YBImageBrowerTool *ybImageBrowerTool;


@property(nonatomic, strong) GroupListInfo *groupDetailInfo;

@property(nonatomic, strong) ChatListModel *chatListModel;
/** 当前是否是多选状态 */
@property(nonatomic, assign) BOOL multipleSelection;
@property(nonatomic, assign) BOOL isTranslationEnabled;
@property(nonatomic, assign) NSInteger goBottomBtnStatus;

@property(nonatomic, assign) NSInteger goBottomBtnTapCount;

/**
 需要删除的消息ID
 */
@property(nonatomic, strong) NSMutableArray *needDeleteMessageIds;
/**
 导航栏
 */
@property(nonatomic, strong) ChatViewNavBarView *chatViewNavBarView;
/**
 多选消息的View
 */
@property(nonatomic, strong) MultipleSelectionShowView *multipleShowView;
/** 不是好友的提示框 */
@property(strong, nonatomic) UnFriendHeaderTipsView *  unFriendHeaderTipsView;
/** 显示的回复的内容 */
@property(nonatomic, strong) ChatViewReplyView *replyView;
/** 快捷消息 */
@property(nonatomic, strong) FastMessageView *fastMessageView;
/** 网络连接提示的View */
@property(nonatomic, strong) ChatViewConnectTipsView *connectTipsView;

@property(nonatomic, strong) HXPhotoManager *manager;
/**
 是否高亮显示 搜索界面进来
 */
@property(nonatomic, assign) BOOL shouldHightShow;
@property(nonatomic, assign) BOOL isreplyActive;
@property(nonatomic, assign) NSInteger currentPinArrayIndex;
/**
 当前高亮是第几行
 */
@property(nonatomic, assign) NSInteger currentHightRow;
@property(nonatomic, strong) CircleUserInfo *circleUserInfo;
@property(nonatomic, strong) GetCircleDislikeMeInfo *circleDislikeMeInfo;
@property(nonatomic, strong) NSArray *quickMessageItems;
@property(nonatomic, strong) C2CUserInfo *c2cUserInfo;
/** 点击未读消息去到tableView顶部 */
@property(nonatomic, strong) GoTopActionView * actionView;

@property(nonatomic, strong) GoBottomActionView * bottomActionView;
/** 上一条消息的发送时间 */
@property(nonatomic, assign) NSInteger messageSendTime;
@property(nonatomic, strong) NSString* thirdMsg;
@property(nonatomic, assign) float lastContentOffsetY;
@property(nonatomic, assign) BOOL dicePresed;
@property(nonatomic, assign) BOOL scrolledAfterNew;
@property(nonatomic, strong) MsgContentModel *msgContentModel;
@property(nonatomic, strong) ChatModel *pinChatModel;
@property(nonatomic, strong) ChatModel *selectedPinChatModel;
@property(nonatomic, strong) ChatModel *reactChatModel;
@property(nonatomic, strong) NSMutableArray<ChatModel*>* pinMessages;
@end

@implementation ChatViewController

//及时查看这里是否释放
-(void)dealloc{
    WebSocketManager.sharedManager.currentChatID = @"";
    [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
    DDLogInfo(@"ChatViewController%s",__func__);
}

-(void)checkChatOtherChatMode{
    if([self.config.chatMode isEqualToString:ChatModeOtherChat]){
        [self.chatFunctionView hideAllBtn];
    }
}

-(void)savedraftMessage{
    if (self.chatFunctionView.messageTextView.editable) {
        [[WCDBManager sharedManager]saveDraftMessage:self.chatFunctionView.messageTextView.text.length>0?self.chatFunctionView.messageTextView.text:@"" chatModel:self.config];
    }
}


- (void)initChatFuntionAlignment {
    
    [self.chatFunctionView.fastButton setHidden: NO];
    [self.chatFunctionView.sendButton setHidden: YES];
    [self.chatFunctionView.voicedButton setHidden: NO];
    [self.chatFunctionView.faceButton setHidden: YES];
    self.chatFunctionView.textViewBgViewRightMargin = 55;
}

- (void)updateReplayPanal {
    if(self.isreplyActive) {
        if(self.isTranslationEnabled) {
            [self.translatorViewMenue mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(@0);
                make.height.equalTo(@60);
                make.bottom.equalTo(self.chatFunctionView.mas_top);
            }];
            [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.translatorViewMenue.mas_top).offset(-1);
            }];
        }else {
            [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.chatFunctionView.mas_top).offset(1);
            }];
        }
    }else {
        [self.translatorViewMenue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@60);
            make.bottom.equalTo(self.chatFunctionView.mas_top);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *subviews = self.tableView.backgroundView.subviews;
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    if(![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper10"] && ![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper9"] && ![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper8"] && ![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper7"] && ![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper6"] && ![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper5"] && ![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper4"] && ![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper3"] && ![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper2"] && ![UserInfoManager.sharedManager.wallpaperName isEqual:@"chatwallpaper1"]){
        UserInfoManager.sharedManager.wallpaperName = @"chatwallpaper10";
    }
    UIImage *backgroundImage = [UIImage imageNamed:UserInfoManager.sharedManager.wallpaperName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.tableView.backgroundView insertSubview:imageView atIndex:0];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 9, 0);
    [self addArrayData];
    [self checkChatOtherChatMode];
    [self initChatFuntionAlignment];
    self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:self.config];
    [self setLastPinMessage];
    self.pinMessages = [self getPinMessage:self.config.chatID];
    self.isreplyActive = NO;
    if (self.chatSetting.translateLanguage != nil && ![self.chatSetting.translateLanguageCode isEqual: @"None"] && ![self.chatSetting.translateLanguage isEqual: @""] && self.chatSetting.translateLanguageCode != nil){
        NSLog(@"Translation On");
        self.isTranslationEnabled = YES;
        [self.chatFunctionView updateTranslateOnstatus:YES];
        [self updateFrame];
        self.scrolledAfterNew = NO;
        self.translatorViewMenue.languageNameLabel.text = [ChatViewHandleTool getLanguageByLanguageCode:self.chatSetting.translateLanguageCode];
        [self.translatorViewMenue showTranslateView ];
        if(self.pinMessages.count > 0) {
            self.pinMenueBar.messagesArray = self.pinMessages;
            self.pinMenueBar.hidden = NO;
            self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-self.translatorViewMenue.size.height-50);
        }else {
            self.pinMenueBar.hidden = YES;
            self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-self.translatorViewMenue.size.height);
        }
        [self scrollTableViewToBottom:YES needScroll:YES];
    }else{
        NSLog(@"Translation n/a");
        self.isTranslationEnabled = NO;
        [self updateFrame];
        [self.chatFunctionView updateTranslateOnstatus:NO];
        self.translatorViewMenue.languageNameLabel.text = @"N/A";
        [self.translatorViewMenue hideTranslateView ];
        if(self.pinMessages.count > 0) {
            self.pinMenueBar.hidden = NO;
            self.pinMenueBar.messagesArray = self.pinMessages;
            self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-50);
        }else {
            self.pinMenueBar.hidden = YES;
            self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight);
        }
        [self scrollTableViewToBottom:YES needScroll:YES];
    }
    [self removeVcWithArray:@[@"ChatSearchResultViewController",@"QRCodeController",@"QrScanResultAddRoomController"]];
    self.chatFunctionView.leftBgView.hidden=NO;
    [self.chatFunctionView addNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(userDidTakeScreenshot)       name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    [WebSocketManager sharedManager].delegate = self;
    //重置未读消息数量为0
    [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:self.config];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDataWithMessageObject:) name:@"postObject" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:@"refreshNotificationData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(multipleBtnAction:) name:@"updateIsSelect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterDelete:) name:@"refreshAfterDelete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTranslationTextLoading) name:@"translationStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPinMenuBarHidden) name:@"setPinMenuBarHidden" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:@"refresh" object:nil];
    [self.tableView reloadData];

}

- (void) changeTranslationTextLoading {
    self.translatorViewMenue.translatedTextLabel.text = @"Translating".icanlocalized;
    // Create the animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 1.0;
    animation.fromValue = @1.0;
    animation.toValue = @0.0;
    animation.repeatCount = 1;
    // Add the animation to the UILabel's layer
    [self.translatorViewMenue.translatedTextLabel.layer addAnimation:animation forKey:@"opacity"];
}

- (NSMutableArray<ChatModel*>*)getPinMessage:(NSString*)chatId {
    if ([self.config.authorityType isEqualToString:AuthorityType_secret]) {
        return nil;
    }else {
        NSMutableArray<ChatModel*>* pinMessage = [[WCDBManager sharedManager]getPinMessageWithChatModel:chatId];
        return pinMessage;
    }
}

- (void) multipleBtnAction:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"updateIsSelect"]){
        ChatModel*model=[[ChatModel alloc]init];
        model = notification.object;
        model.isSelect=!model.isSelect;
    }
    [self.tableView reloadData];
}

- (void) refreshAfterDelete:(NSNotification *) notification {
    [self.messageItems removeAllObjects];
    [self.tableView reloadData];
}

- (void) refreshTableView:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"refresh"]){
        [self.tableView reloadData];
    }
}

- (void) receiveDataWithMessageObject:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"postObject"]){
        ChatModel*model=[[ChatModel alloc]init];
        model = notification.object;
        if ([model.chatID isEqualToString:self.config.chatID]&&[model.authorityType isEqualToString:self.config.authorityType]) {
            if ([model.authorityType isEqualToString:self.config.authorityType]) {
                //                [self.messageItems addObject:model];
                [self.inQ addObject:model];
                
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                NSMutableArray *arr2 = [[NSMutableArray alloc]init];
                NSString *scrollStatus = [[NSString alloc]init];
                ChatModel *visibleMsgs;
                for (NSIndexPath *indexVisible in self.tableView.indexPathsForVisibleRows) {
                    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexVisible];
                    BOOL isVisible = CGRectContainsRect(self.tableView.bounds, cellRect);
                    if (isVisible) {
                        //                     last = indexVisible.row;
                        [arr addObject:indexVisible];
                        [arr1 addObject:[NSNumber numberWithInteger:indexVisible.row]];
                        visibleMsgs = [self.messageItems objectAtIndex:indexVisible.row];
                        [arr2 addObject:visibleMsgs.messageID];
                    }
                }
                
                if(self.messageItems.count > 3) {
                    for (NSString *idx in arr2) {
                        if (idx ==  self.thirdMsg) {
                            scrollStatus = @"jump";
                        }
                    }
                }
                
                if ([scrollStatus isEqualToString:@"jump"]) {
                    //do the jump
                    if(![model.messageType isEqualToString:@"Pin_Message"]) {
                        [self.messageItems addObject:model];
                    }
                    [self.inQ removeAllObjects];
                    [self scrollTableViewToBottom:YES needScroll:YES];
                }else {
                    //show the icon to go down
                    if ((self.goBottomBtnStatus == 0 && self.goBottomBtnTapCount == 0) || (self.goBottomBtnStatus == 1)){
                        [self callIcon];
                        self.goBottomBtnStatus = 0;
                    }
                    NSLog(@"Go down buttonnnnnnn");
                }
            }
            [self.tableView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                [self scrollTableViewToBottom:YES needScroll:YES];
            });
        }
    }
    //NSLog(@"My arrayAddedwith: %@", self.messageItems[self.messageItems.count-4].messageID);
    if(self.messageItems.count > 3) {
        self.thirdMsg = self.messageItems[self.messageItems.count-4].messageID;
    }
}

- (void) refreshTable:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"refreshNotificationData"]){
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if (state == UIApplicationStateActive){
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    [self.chatFunctionView removeNotification];
    if ([self.config.chatType isEqualToString:UserChat]) {
        [[WCDBManager sharedManager]updateIsService:self.userMessageInfo.cs userId:self.userMessageInfo.userId];
    }else{
        [[WCDBManager sharedManager]updateNoShowAt:self.config];
    }
    [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:self.config];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goBottomBtnStatus = 0;
    self.view.backgroundColor= UIColorViewBgColor;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:self.config];
    WebSocketManager.sharedManager.currentChatID=self.config.chatID;
    if ([self.config.authorityType isEqualToString:AuthorityType_circle]) {
        [self setUserInfoData];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeOnlineChange:) name:kNotice_OnlineChangeNotification object:nil];
        if (CircleUserInfoManager.shared.enable) {
            [self checkUserIsOnLineRequest];
            [self getCircleUserInfoRequest];
            [self getCircleDislikeMeRequest];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveSingleRedPacketGrabNotification:) name:kReceiveSingleRedPacketGrabNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNiMMessage:) name:@"showNiMMessageNotification" object:nil];
        }else{
            [UIAlertController alertControllerWithTitle:@"CircleUserEnable".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        
    }else if ([self.config.authorityType isEqualToString:AuthorityType_c2c]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeOnlineChange:) name:kNotice_OnlineChangeNotification object:nil];
        WebSocketManager.sharedManager.currentChatID = self.config.c2cOrderId;
        [self checkUserIsOnLineRequest];
        [self getC2CUserInfoRequest];
    }else if([self.config.authorityType isEqualToString:AuthorityType_secret]){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeOnlineChange:) name:kNotice_OnlineChangeNotification object:nil];
        [self checkUserIsOnLineRequest];
        [self getFriendDetailRequest];
        [self setUserInfoData];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendNotification:) name:kDeleteFriendNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendNotification:) name:kAgreeFriendNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNiMMessage:) name:@"showNiMMessageNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(blockUserNotification:) name:kNoticeBlockUsersNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewReloadata) name:kUserMessageChangeNotificatiaon object:nil];
    }else if([self.config.authorityType isEqualToString:AuthorityType_friend]){
        if ([self.config.chatType isEqualToString:UserChat]) {
            [self setUserInfoData];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeOnlineChange:) name:kNotice_OnlineChangeNotification object:nil];
            [self checkUserIsOnLineRequest];
            [self getFriendDetailRequest];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendNotification:) name:kDeleteFriendNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFriendNotification:) name:kAgreeFriendNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveSingleRedPacketGrabNotification:) name:kReceiveSingleRedPacketGrabNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showNiMMessage:) name:@"showNiMMessageNotification" object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(blockUserNotification:) name:kNoticeBlockUsersNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewReloadata) name:kUserMessageChangeNotificatiaon object:nil];
        }
    }
    [ChatViewHandleTool shareManager].delegete=self;
    if (hashEqual(self.config.chatType, GroupChat)) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroupDetailByNotification:) name:kUpdateGroupMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getGroupDetailByNotification:) name:KGetGroupDetailNotification object:nil];
        [self getGroupDetail];
        self.groupDetailInfo=[[WCDBManager sharedManager]fetchOneGroupListInfoWithGroupId:self.config.chatID];
        [self.chatViewNavBarView updateUiWithGroupInfo:self.groupDetailInfo];
        
    }
    
    self.chatListModel=[[WCDBManager sharedManager]fetchOneChatListModelWithChatModel:self.config];
    [self removeVcWithArray:@[@"QRCodeController",@"QrScanResultAddRoomController",@"FriendDetailViewController"]];
    [AudioPlayerManager shareDZAudioPlayerManager].delegate=self;
    if (self.shouldStartLoad) {
        self.shouldHightShow = YES;
        [self loadHistoryMessage];
    }else{
        [self loadMoreMessageFitst:YES];
        if (self.messageItems.count > 0) {
            NSInteger row = self.messageItems.count-1;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        [self scrollTableViewToBottom:YES needScroll:YES];
    }
    [self getAllQuickMessageRequest];
    [self setUpUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeMessageNotification:) name:kNotice_RemoveChatNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareExtensionNotification:) name:kShareExtensionNotification object:nil];
    //监听连接状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noNetWorkNotification) name:KAFNetworkReachabilityStatusNotReachable object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connenctSuccessNotification) name:KConnectSocketSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectSocketStartNotification) name:KConnectSocketStartNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAllQuickMessageRequest) name:KChangeQuickMessageNotification object:nil];
    //后台进前台通知 UIApplicationDidBecomeActiveNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    //后台进前台通知 UIApplicationDidBecomeActiveNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transpondSuccess:) name:KTranspondSuccessNotification object:nil];
    self.dicePresed = false;
    UserInfoManager.sharedManager.chatID = self.config.chatID;
}

- (void)setUserInfoData {
    if([self.config.chatID isEqual:@"100"]) {
        self.chatViewNavBarView.nameLabel.text = [NSString stringWithFormat: @"%@", @"iCanAi"];
            [self.chatViewNavBarView hideCallItems];
            [self.chatFunctionView ajustUIforAIChat];
        [self.chatViewNavBarView.iconImageView setDZIconImageViewWithUrl:@"https://oss.icanlk.com/system/head_img/ican/iA.png" gender:@"male"];
    }else {
        self.userMessageInfo = [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.config.chatID];
        self.chatViewNavBarView.nameLabel.text = self.userMessageInfo.remarkName?:self.userMessageInfo.nickname;
        if([self.config.chatMode isEqualToString:ChatModeOtherChat]) {
            [ self.chatViewNavBarView disableCallItems];
        }
        [self.chatViewNavBarView.iconImageView setDZIconImageViewWithUrl:self.userMessageInfo.headImgUrl gender:self.userMessageInfo.gender];
    }
}


-(void)initTableView{
    [super initTableView];
    self.defaultHeight=isIPhoneX?37+57:57;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=UIColorViewBgColor;
    MJRefreshGifHeader *headerView = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreMessageFitst:)];
    NSMutableArray*imageItems=[NSMutableArray array];
    for (NSUInteger i = 1; i<=12; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd", i]];
        [imageItems addObject:image];
    }
    
    headerView.lastUpdatedTimeLabel.hidden = YES;
    headerView.stateLabel.hidden = YES;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 13.0, *)) {
        self.tableView.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
    self.tableView.mj_header = headerView;
    [self.tableView registNibWithNibName:kChatOtherMessageTableViewCell];
    [self.tableView registNibWithNibName:kChatMineMessageTableViewCell];
    [self.tableView registClassWithClassName:kChatWithdrawTableViewCell];
    [self.tableView registNibWithNibName:KChatNoticeTableViewCell];
    [self.tableView registNibWithNibName:kChatRedPacketTipsTableViewCell];
    
    [self.tableView registClassWithClassName:kChatLeftMsgBaseTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftTxtMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftUrlMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftGamifyMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftImgMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftVoiceTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftVideoTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftFileTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftNimCallTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftTimelineTableViewCell];
    [self.tableView registClassWithClassName:kChatLeftGoodsTableViewCell];
    
    [self.tableView registClassWithClassName:kChatRightMsgBaseTableViewCell];
    [self.tableView registClassWithClassName:kChatRightTxtMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatRightUrlMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatRightGamifyMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatRightImgMsgTableViewCell];
    [self.tableView registClassWithClassName:kChatRightVoiceTableViewCell];
    [self.tableView registClassWithClassName:kChatRightVideoTableViewCell];
    [self.tableView registClassWithClassName:kChatRightFileTableViewCell];
    [self.tableView registClassWithClassName:kChatRightNimCallTableViewCell];
    [self.tableView registClassWithClassName:kChatRightTimelineTableViewCell];
    [self.tableView registClassWithClassName:kChatRightGoodsTableViewCell];
    
}

- (void)setUpUI {
    [self.view addSubview:self.chatFunctionView];
    [self.view addSubview:self.translatorViewMenue];
    [self.translatorViewMenue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.chatFunctionView.mas_top).offset(5);
    }];
    [self.view addSubview:self.replyView];
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@60);
        make.bottom.equalTo(self.chatFunctionView.mas_top);
    }];
    [self.view addSubview:self.fastMessageView];
    [self.fastMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@150);
        make.bottom.equalTo(self.chatFunctionView.mas_top);
    }];
    [self.view addSubview:self.chatViewNavBarView];
    if (![self.config.authorityType isEqualToString:AuthorityType_secret]) {
        [self.view addSubview:self.pinMenueBar];
        [self.pinMenueBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@50);
            make.top.equalTo(self.chatViewNavBarView.mas_bottom).offset(0);
        }];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.connectTipsView];
    [self.connectTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.chatViewNavBarView.mas_bottom).offset(0);
        make.height.equalTo(@30);
    }];
}

-(void)tableViewReloadata{
    self.userMessageInfo=[[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.config.chatID];
    [self updateIsFriend];
    [self.tableView reloadData];
}
-(void)didBecomeActive{
    for (ChatModel*chatModel in self.messageItems) {
        [self sendHasReadMessageReceipt:chatModel];
    }
}
-(void)didEnterBackground{
    [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:self.config];
    [[WebSocketManager sharedManager]setApplicationIconBadgeNumber];
}

-(void)noNetWorkNotification{
    self.connectTipsView.hidden=NO;
    [self.connectTipsView noNet];
}

- (void)connenctSuccessNotification {
    self.connectTipsView.hidden = YES;
    [self checkUserIsOnLineRequest];
}

-(void)connectSocketStartNotification{
    self.connectTipsView.hidden=NO;
    [self.connectTipsView loginStart];
}

#pragma mark - 接收通知
-(void)blockUserNotification:(NSNotification*)notifi{
    BlockUserMessageInfo*info=notifi.object;
    if ([info.who isEqualToString:self.config.chatID]) {
        [self getFriendDetailRequest];
    }
}
-(void)updateFriendNotification:(NSNotification*)notifi{
    NSString*friendId=notifi.object;
    if ([friendId isEqualToString:self.config.chatID]) {
        [self getFriendDetailRequest];
    }
    
}
-(void)getGroupDetailByNotification:(NSNotification*)notifi{
    NSString*groupId=(NSString*)notifi.object;
    if ([groupId isEqualToString:self.config.chatID]) {
        [self getGroupDetail];
    }
}

/// 收到Notice_RemoveChatType 类型的消息通知
/// @param notifi 通知对象
- (void)removeMessageNotification:(NSNotification*)notifi {
    BaseMessageInfo *messageInfo = notifi.object;
    RemoveChatMsgInfo *info = [RemoveChatMsgInfo mj_objectWithKeyValues:[NSString decodeUrlString: messageInfo.msgContent]];
    /**
     群部分GroupPart,人部分 UserPart,群全部GroupAll,人全部UserAll, 全部消息All
     */
    if ([info.type isEqualToString:@"GroupAll"]) {
        if ([messageInfo.groupId isEqualToString:self.config.chatID]) {
            [self.messageItems removeAllObjects];
            self.current = 0;
            [self loadMoreMessageFitst:NO];
            [self.tableView reloadData];
            [self scrollTableViewToBottom:YES needScroll:NO];
        }
    }else if([info.type isEqualToString:@"GroupPart"]) {
        [self.messageItems removeAllObjects];
        self.current = 0;
        [self loadMoreMessageFitst:NO];
        [self.tableView reloadData];
        [self scrollTableViewToBottom:YES needScroll:NO];
    }else if([info.type isEqualToString:@"UserAll"] && [UserInfoManager.sharedManager.userId isEqualToString:messageInfo.fromId]){
        [[WCDBManager sharedManager]deleteAllChatModelWith:self.config];
        [[WCDBManager sharedManager]deleteResourceWihtChatId:self.userId];
        [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:self.config];
        [self.messageItems removeAllObjects];
        [self.tableView reloadData];
        [self scrollTableViewToBottom:YES needScroll:NO];
    }else{
        //判断当前聊天的会话是否和收到的删除消息的会话一致 - Determine whether the current chat session is consistent with the received delete message session
        ///同步消息 - Synchronization message
        NSString *chatId;
        if ([messageInfo.platform isEqualToString:@"System"]) {
            chatId = messageInfo.fromId;
        }else{
            chatId = messageInfo.fromId;
        }
        if ([chatId isEqualToString:self.config.chatID]) {
            if (info.messageIds) {
                for (NSString *messageId in info.messageIds) {
                    for (ChatModel *model in self.messageItems) {
                        if ([model.messageID isEqualToString:messageId]) {
                            model.showMessage = @"TheOtherPartyDeletesAMessage".icanlocalized;
                            model.messageType = Notice_RemoveChatType;
                            break;
                        }
                    }
                }
            }else{
                [self.messageItems removeAllObjects];
                self.current=0;
                [self loadMoreMessageFitst:NO];
            }
            [self.tableView reloadData];
            [self scrollTableViewToBottom:YES needScroll:NO];
        }else{
            if (info.messageIds) {
                for (NSString *messageId in info.messageIds) {
                    for (ChatModel *model in self.messageItems) {
                        if ([model.messageID isEqualToString:messageId]) {
                            [self.messageItems removeObject:model];
                            [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
                            [self deleteMoreMessageRequestWithMessageIds:@[model.messageID] deleteAll:NO];
                        }
                    }
                }
            }
            [self.tableView reloadData];
            [self scrollTableViewToBottom:YES needScroll:NO];
        }
    }
    self.pinMessages = [self getPinMessage:self.config.chatID];
    if(self.pinMessages.count == 0) {
        self.pinMenueBar.hidden = YES;
        [self updateFrame];
    }else {
        [self setLastPinMessage];
    }
}

-(void)showNiMMessage:(NSNotification*)noti{
    ChatModel*model=(ChatModel*)noti.object;
    [self.messageItems addObject:model];
    [self.tableView reloadData];
    [self scrollTableViewToBottom:YES needScroll:YES];
}
-(void)receiveSingleRedPacketGrabNotification:(NSNotification*)notifi{
    ChatModel*modle=notifi.object;
    for (ChatModel*cmodel in self.messageItems) {
        if ([cmodel.redId isEqualToString:modle.redId]) {
            cmodel.redPacketState=modle.redPacketState;
            break;
        }
    }
}
-(void)shareExtensionNotification:(NSNotification*)notifi{
    ChatModel*model=(ChatModel*)notifi.object;
    [self.messageItems addObject:model];
    [self.tableView reloadData];
    [self scrollTableViewToBottom:YES needScroll:YES];
}
-(void)tapAction{
    [self.view endEditing:YES];
    [self.chatFunctionView hiddenAllView];
    if (UserInfoManager.sharedManager.messageMenuView) {
        [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    }
    self.fastMessageView.hidden = YES;
    self.scrolledAfterNew = NO;
}


//手势是否继续传递
//1、手势响应是大哥，点击事件响应链是小弟。单击手势优先于UIView的事件响应。大部分冲突，都是因为优先级没有搞清楚。
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch{
    if ([[touch.view.superview class] isSubclassOfClass:[UICollectionViewCell class]]) {
        return NO;
    }
    return YES;
}

/// 收到用户状态修改的通知
/// @param notifi notifi description
-(void)noticeOnlineChange:(NSNotification*)notifi{
    Notice_OnlineChangeInfo*info=(Notice_OnlineChangeInfo*)notifi.object;
    if ([info.userId isEqualToString:self.config.chatID]) {
        [self checkUserIsOnLineRequest];
    }
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}

- (void)navigationController:(nonnull QMUINavigationController *)navigationController poppingByInteractiveGestureRecognizer:(nullable UIScreenEdgePanGestureRecognizer *)gestureRecognizer viewControllerWillDisappear:(nullable UIViewController *)viewControllerWillDisappear viewControllerWillAppear:(nullable UIViewController *)viewControllerWillAppear{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (!self.chatFunctionView.isShowLeftBgView) {
                self.chatFunctionView.leftBgView.hidden=YES;
            }
            
            [self.chatFunctionView removeNotification];
            
            break;
            
        default:
            break;
    }
    
}

/// 监听到用户点击了截取屏幕的操作
-(void)userDidTakeScreenshot{
    ChatSetting*setting = [[WCDBManager sharedManager]fetchChatSettingWith:self.config];
    //如果对方开启了截屏通知
    if (setting.towardsisOpenTaskScreenNotice) {
        ChatModel*chatModel=[ChatUtil initScreenNotice:self.config];
        NoticeScreencastInfo*info=[[NoticeScreencastInfo alloc]init];
        info.operatore=[UserInfoManager sharedManager].userId;
        info.screencastMode=Notice_ScreencastTypeNOTICE;
        chatModel.messageContent=[info mj_JSONString];
        if (BaseSettingManager.isChinaLanguages) {
            chatModel.showMessage=[NSString stringWithFormat:@"%@%@",@"You".icanlocalized,NSLocalizedString(@"Took a screenshot during the chat", 在聊天中截屏了)];
        }else{
            chatModel.showMessage=[NSString stringWithFormat:@"%@ %@",@"You".icanlocalized,NSLocalizedString(@"Took a screenshot during the chat", 在聊天中截屏了)];
        }
        
        [self sendAndSaveMessageWithChatModel:chatModel];
    }
}
-(void)layoutTableView{
    
}
-(void)updateIsFriend{
    if([self.config.chatID isEqual:@"100"]) {
        [self.chatViewNavBarView hideCallItems];
        [self.chatFunctionView ajustUIforAIChat];
    }else if ([self.config.chatMode isEqualToString:ChatModeOtherChat]){
        [self.chatViewNavBarView disableCallItems];
    }else {
        [self.chatViewNavBarView updateUIWith:self.userMessageInfo authorityType:self.config.authorityType];
        //配置底部的按钮能否点击
        [self.chatFunctionView configcanSendMessageWith:self.userMessageInfo draftMessage:self.chatListModel.draftMessage];
        //好友 但是已经被拉入黑名单
        if(self.userMessageInfo.beBlock) {
            [self showUnFriendTipsView];
        }else {
            self.pinMessages = [self getPinMessage:self.config.chatID];
            //是好友
            if(self.userMessageInfo.isFriend) {
                [self.unFriendHeaderTipsView removeFromSuperview];
                if(self.pinMessages.count > 0) {
                    self.pinMenueBar.hidden = NO;
                    self.pinMenueBar.messagesArray = self.pinMessages;
                    self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-50);
                }else {
                    self.pinMenueBar.hidden = YES;
                    self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight);
                }
            }else {
                //自己是不是我行客服
                BOOL myIsService = UserInfoManager.sharedManager.cs;
                //自己是不是第三方客服
                BOOL myIsThirdService = UserInfoManager.sharedManager.thirdPartySystemAppId.length>0&&myIsService;
                //对方是不是我行客服
                BOOL otherIsService = self.userMessageInfo.cs;
                //对方是不是第三方客服
                BOOL otherIsThirdService = self.userMessageInfo.thirdPartySystemAppId.length>0&&otherIsService;
                if(myIsService||myIsThirdService||otherIsService||otherIsThirdService) {
                    [self.unFriendHeaderTipsView removeFromSuperview];
                    if(self.pinMessages.count > 0) {
                        self.pinMenueBar.hidden = NO;
                        self.pinMenueBar.messagesArray = self.pinMessages;
                        self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-50);
                    }else {
                        self.pinMenueBar.hidden = YES;
                        self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight);
                    }
                }else {
                    if(![self.config.chatID isEqual:@"100"]) {
                        [self showUnFriendTipsView];
                    }
                }
            }
        }
    }
    [self scrollTableViewToBottom:YES needScroll:YES];
}
-(void)showUnFriendTipsView{
    NSString*tips;
    if ([self.config.authorityType isEqualToString:AuthorityType_friend]) {
        if (self.userMessageInfo.beBlock) {
            tips=@"You have been blocked by the user".icanlocalized;
        }else{
            tips=NSLocalizedString(@"UnFriendTips", 对方还不是你的通讯录);
        }
    }else if ([self.config.authorityType isEqualToString:AuthorityType_circle]){
        if (self.circleUserInfo.deleted) {
            tips=@"CircleHomeListViewController.deletedtips".icanlocalized;
        }else if (self.circleDislikeMeInfo.dislikeMe) {
            //"TheOtherPartyIsNotInterestedinYou"="对方对你不感兴趣，你无法给对方发送消息";
            tips=@"TheOtherPartyIsNotInterestedinYou".icanlocalized;
        }
    }
    self.pinMessages = [self getPinMessage:self.config.chatID];
    [self.view addSubview:self.unFriendHeaderTipsView];
    [self.unFriendHeaderTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.right.equalTo(@0);
        if(self.pinMessages.count > 0) {
            make.top.equalTo(@(NavBarHeight+50));
        }else {
            make.top.equalTo(@(NavBarHeight));
        }
    }];
    [self.unFriendHeaderTipsView.imageView setDZIconImageViewWithUrl:self.userMessageInfo.headImgUrl gender:self.userMessageInfo.gender];
    if(self.pinMessages.count > 0) {
        self.pinMenueBar.hidden = NO;
        self.pinMenueBar.messagesArray = self.pinMessages;
        self.tableView.frame = CGRectMake(0, NavBarHeight+90, ScreenWidth, ScreenHeight-NavBarHeight-90-self.defaultHeight);
    }else {
        self.pinMenueBar.hidden = YES;
        self.tableView.frame = CGRectMake(0, NavBarHeight+40, ScreenWidth, ScreenHeight-NavBarHeight-40-self.defaultHeight);
    }
    self.unFriendHeaderTipsView.addFriendBtn.hidden = YES;
    self.unFriendHeaderTipsView.tipsLabel.text = tips;
}

-(void)loadHistoryMessage{
    self.needDeleteMessageIds=[NSMutableArray array];
    NSArray<ChatModel*>*array=[[WCDBManager sharedManager]fetchHistoryMessageWihtChatId:self.config.chatID messageTime:self.config.messageTime chatType:self.config.chatType];
    //别问我为什么要遍历再每次都插入到第0个位置 因为数据库查出来之后 按照时间大的在前面 但是显示的时候需要时间大的在tableview的后面
    for (ChatModel*model in array) {
        [self checkIsShouldDeleteMessageWithChatModel:model];
    }
    [self deleteMoreMessageRequestWithMessageIds:self.needDeleteMessageIds deleteAll:NO];
    [self.tableView reloadData];
    for (int i=0; i<self.messageItems.count; i++) {
        ChatModel*model=[self.messageItems objectAtIndex:i];
        if ([model.messageID isEqualToString:self.config.messageID]) {
            self.currentHightRow=i;
            break;
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.currentHightRow>2) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentHightRow-2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }else{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentHightRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
    });
}
-(void)loadMoreMessageFitst:(BOOL)first{
    self.actionView.hidden = YES;
    self.goBottomBtnStatus = 0;
    self.goBottomBtnTapCount = 0;
    self.current++;
    [self loadMessageFitst:first];
    
}
#pragma mark - 拉取数据库消息
- (void)loadMessageFitst:(BOOL)first {
    self.needDeleteMessageIds=[NSMutableArray array];
    NSInteger index = 0;
    NSArray<ChatModel*>*array;
    if (first) {
        /*
         1.如果是首次进入界面,获取所有的未读消息数量,判断是否存在若干未读消息
         2.如果超过10条未读消息，那么显示未读消息数量，并且点击跳转到相对应的位置
         */
        NSInteger unReadCount = self.chatListModel.unReadMessageCount;
        if (unReadCount>10) {
            index = unReadCount-1;
            NSDictionary * dict = [[WCDBManager sharedManager]fetchAllUnReadMessageWihtChatModel:self.config];
            array = dict[@"msgs"];
            self.actionView.hidden = NO;
            if (array.count > 3) {
                NSLog(@"My arrayA: %@", array[2].messageID);
                self.thirdMsg = array[2].messageID;
            }
            
        }else{
            index = self.messageItems.count-1;
            array = [[WCDBManager sharedManager]fetchChatModelMessageWihtConfigModel:self.config offset:self.messageItems.count];
            if (array.count > 3) {
                NSLog(@"My arrayA: %@", array[2].messageID);
                self.thirdMsg = array[2].messageID;
            }
            
            
        }
    }else{
        index = self.messageItems.count-1;
        array = [[WCDBManager sharedManager]fetchChatModelMessageWihtConfigModel:self.config offset:self.messageItems.count];
        if (array.count > 3) {
            NSLog(@"My arrayA: %@", array[2].messageID);
            self.thirdMsg = array[2].messageID;
        }
    }
    
    //当拿出来的数据不足一页 那么就去掉头部
    if (array.count<10) {
        [self noMoreMessage];
    }
    for (ChatModel*model in array) {
        [self checkIsShouldDeleteMessageWithChatModel:model];
    }
    [self deleteMoreMessageRequestWithMessageIds:self.needDeleteMessageIds deleteAll:NO];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height)];
    if (!first&&self.current!=1) {
        //跳转到某个位置
        NSInteger row=self.messageItems.count-1-index;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    [self.tableView endHeaderRefreshing];
    
}
//
///// 拉取消息的时候判断是否先删除消息
///// @param model model description
-(void)checkIsShouldDeleteMessageWithChatModel:(ChatModel*)model{
    UserConfigurationInfo * userConfigurationInfo = [BaseSettingManager sharedManager].userConfigurationInfo;
    NSInteger deleteMessageWholeTime=[userConfigurationInfo.deleteMessageWholeTime integerValue];
    NSInteger currentTime = [[NSDate date]timeIntervalSince1970];
    NSInteger messagetime = [model.messageTime integerValue]/1000;
    NSInteger detoryTime  = [model.destoryTime integerValue];
    if (UserInfoManager.sharedManager.seniorValid||UserInfoManager.sharedManager.diamondValid) {
        if (UserInfoManager.sharedManager.preventDeleteMessage) {
            if ([userConfigurationInfo.deleteMessageWholeTime isEqualToString:@"0"]) {
                if (model.hasRead) {
                    [self.messageItems insertObject:model atIndex:0];
                }else{
                    [self sendHasReadMessageReceipt:model];
                    [self.messageItems insertObject:model atIndex:0];
                }
            }else{
                if (model.hasRead) {
                    if (currentTime-messagetime>deleteMessageWholeTime) {
                        [self.needDeleteMessageIds addObject:model.messageID];
                        [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
                    }else{
                        [self.messageItems insertObject:model atIndex:0];
                    }
                }else{
                    [self sendHasReadMessageReceipt:model];
                    [self.messageItems insertObject:model atIndex:0];
                }
            }
        }else{
            //本地缓存的是13位的时间戳 如果阅后即焚是关闭的
            if ([model.destoryTime isEqualToString:@"0"]) {
                //如果全局的消息删除时间不是关闭的
                if (![userConfigurationInfo.deleteMessageWholeTime isEqualToString:@"0"]) {
                    if (model.hasRead) {
                        if (currentTime-messagetime>deleteMessageWholeTime) {
                            [self.needDeleteMessageIds addObject:model.messageID];
                            [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
                        }else{
                            [self.messageItems insertObject:model atIndex:0];
                        }
                    }else{
                        [self sendHasReadMessageReceipt:model];
                        [self.messageItems insertObject:model atIndex:0];
                    }
                    
                }else{
                    [self sendHasReadMessageReceipt:model];
                    [self.messageItems insertObject:model atIndex:0];
                }
            }else if ([model.destoryTime isEqualToString:@"35"]){//如果阅后即焚是立即焚毁
                if (model.hasRead) {
                    //由于要做消息同步 所以即使是删除自己的消息 也需要通过接口去删除
                    [self.needDeleteMessageIds addObject:model.messageID];
                    [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
                }else{
                    [self sendHasReadMessageReceipt:model];
                    [self.messageItems insertObject:model atIndex:0];
                }
                
            }else{
                if (model.hasRead) {
                    if (currentTime-messagetime>detoryTime) {
                        [self.needDeleteMessageIds addObject:model.messageID];
                        [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
                    }else{
                        [self.messageItems insertObject:model atIndex:0];
                    }
                    
                }else{
                    [self sendHasReadMessageReceipt:model];
                    [self.messageItems insertObject:model atIndex:0];
                }
            }
            
        }
    }else{
        //本地缓存的是13位的时间戳 如果阅后即焚是关闭的
        if ([model.destoryTime isEqualToString:@"0"]) {
            //如果全局的消息删除时间不是关闭的
            if (![userConfigurationInfo.deleteMessageWholeTime isEqualToString:@"0"]) {
                if (model.hasRead) {
                    if (currentTime-messagetime>deleteMessageWholeTime) {
                        [self.needDeleteMessageIds addObject:model.messageID];
                        [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
                    }else{
                        [self.messageItems insertObject:model atIndex:0];
                    }
                }else{
                    [self sendHasReadMessageReceipt:model];
                    [self.messageItems insertObject:model atIndex:0];
                }
                
            }else{
                [self sendHasReadMessageReceipt:model];
                [self.messageItems insertObject:model atIndex:0];
            }
        }else if ([model.destoryTime isEqualToString:@"35"]){//如果阅后即焚是立即焚毁
            if (model.hasRead) {
                //由于要做消息同步 所以即使是删除自己的消息 也需要通过接口去删除
                [self.needDeleteMessageIds addObject:model.messageID];
                [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
            }else{
                [self sendHasReadMessageReceipt:model];
                [self.messageItems insertObject:model atIndex:0];
            }
            
        }else{
            if (model.hasRead) {
                if (currentTime-messagetime>detoryTime) {
                    [self.needDeleteMessageIds addObject:model.messageID];
                    [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
                }else{
                    [self.messageItems insertObject:model atIndex:0];
                }
                
            }else{
                [self sendHasReadMessageReceipt:model];
                [self.messageItems insertObject:model atIndex:0];
            }
        }
    }
    
}
//发送已读回执
-(void)sendHasReadMessageReceipt:(ChatModel*)model{
    //自己开启发送消息回执 对方也开始接受已读回执
    if ([model.chatType isEqualToString:GroupChat]){
        if (UserInfoManager.sharedManager.readReceipt) {
            [JudgeMessageTypeManager checkShouldSendHasReadMessageReceipt:model];
        }
    }else{
        if (UserInfoManager.sharedManager.readReceipt&&self.userMessageInfo.readReceipt) {
            [JudgeMessageTypeManager checkShouldSendHasReadMessageReceipt:model];
        }
    }
}

-(void)noMoreMessage{
    [self.tableView.mj_header endRefreshing];
    self.tableView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.tableView.mj_header removeFromSuperview];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messageItems.count;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取聊天信息
    ChatModel *chatModel = self.messageItems[indexPath.row];
    NSString*messageType=chatModel.messageType;
    if ([messageType containsString:WithdrawMessageType]) {
        return 40;
    }
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel *chatModel = self.messageItems[indexPath.row];
    NSString*messageType = chatModel.messageType;
    BOOL isGroup = [self.config.chatType isEqualToString:GroupChat];
    BOOL isShowNickname = self.chatSetting.isShowNickName;
    BOOL isShowTime = NO;
    if (self.messageItems.count == 1) {
        isShowTime = YES;
    }else {
        if (indexPath.row == 0) {
            isShowTime = YES;
        }else{
            ChatModel *previousModel = [self.messageItems objectAtIndex:indexPath.row - 1];
            if (([chatModel.messageTime integerValue] - [previousModel.messageTime integerValue]) / 1000 > 43200) {
                isShowTime = YES;
            }else {
                NSDate *prevStamp = [GetTime dateConvertFromTimeStamp:previousModel.messageTime];
                NSDate *crntStamp = [GetTime dateConvertFromTimeStamp:chatModel.messageTime];
                NSString *prevDate = [GetTime getTimeWithMessageDate:prevStamp];
                NSString *crntDate = [GetTime getTimeWithMessageDate:crntStamp];
                if (![prevDate isEqual:crntDate]) {
                    isShowTime = YES;
                }
                
            }
        }
        
    }
    if([messageType isEqualToString:AIMessageType]) {
        ChatLeftMsgBaseTableViewCell *leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftMsgBaseTableViewCell];
        leftBaseCell.backgroundColor = [UIColor clearColor];
        leftBaseCell.contentView.backgroundColor = [UIColor clearColor];
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftTxtMsgTableViewCell];
        ChatLeftTxtMsgTableViewCell *txtCell = (ChatLeftTxtMsgTableViewCell*)leftBaseCell;
        txtCell.backgroundColor = [UIColor clearColor];
        txtCell.contentView.backgroundColor = [UIColor clearColor];
        if(chatModel.layoutHeight > 40.00) {
            txtCell.timeLableFlag = YES;
        }else {
            txtCell.timeLableFlag = NO;
        }
        txtCell.longpressStatus = YES ;
        txtCell.searchText = self.searchText;
        txtCell.shouldHightShow = self.shouldHightShow;
        leftBaseCell.c2cUserInfo = self.c2cUserInfo;
        leftBaseCell.multipleSelection = self.multipleSelection;
        leftBaseCell.baseOtherMessageCellDelegate = self;
        leftBaseCell.c2cUserInfo = self.c2cUserInfo;
        [leftBaseCell setcurrentChatModel:chatModel isShowName:isShowNickname isGroup:isGroup isShowTime:isShowTime];
        return leftBaseCell;
    }
    if([messageType isEqualToString:AIMessageQuestionType]) {
        ChatRightMsgBaseTableViewCell *rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightMsgBaseTableViewCell];
        rightBaseCell.backgroundColor = [UIColor clearColor];
        rightBaseCell.contentView.backgroundColor = [UIColor clearColor];
        rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightTxtMsgTableViewCell];
        ChatRightTxtMsgTableViewCell *txtCell = (ChatRightTxtMsgTableViewCell*)rightBaseCell;
        txtCell.backgroundColor = [UIColor clearColor];
        txtCell.contentView.backgroundColor = [UIColor clearColor];
        if(chatModel.layoutHeight > 40.00) {
            txtCell.timeLableFlag = YES;
        }else {
            txtCell.timeLableFlag = NO;
        }
        txtCell.searchText = self.searchText;
        txtCell.shouldHightShow = self.shouldHightShow;
        rightBaseCell.c2cUserInfo = self.c2cUserInfo;
        rightBaseCell.multipleSelection = self.multipleSelection;
        rightBaseCell.msgDelegate = self;
        rightBaseCell.c2cUserInfo = self.c2cUserInfo;
        [rightBaseCell setcurrentChatModel:chatModel isShowName:isShowNickname isGroup:isGroup isShowTime:isShowTime];
        return rightBaseCell;
    }
    if ([messageType isEqualToString:Notice_AddGroupMessageType]||[messageType isEqualToString:Notice_AddFriendMessageType]||[messageType isEqualToString:Notice_SubjectMessageType]||[messageType isEqualToString:Notice_QuitGroupMessageType]||[messageType isEqualToString:Notice_DeleteFriendMessageType]||[messageType isEqualToString:Notice_DestroyTimeType]||[messageType isEqualToString:Notice_ScreencastType]||[messageType isEqualToString:Notice_RemoveChatType]||[messageType isEqualToString:Add_friend_successType]||[messageType isEqualToString:Notice_TransferGroupOwnerType]||[messageType isEqualToString:Notice_GroupRoleUpdateType]||[messageType isEqualToString:kNotice_JoinGroupReviewUpdate]||[messageType isEqualToString:C2COrderMessageType]){
        ChatNoticeTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:KChatNoticeTableViewCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell setcurrentChatModel:chatModel];
        return cell;
    }
    if ([messageType isEqualToString:GrabSingleRedPacketType]||[messageType isEqualToString:GrabRoomRedPacketTypeType]||[messageType isEqualToString:Notice_JoinGroupApplyType]) {
        ChatRedPacketTipsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kChatRedPacketTipsTableViewCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        [cell setcurrentChatModel:chatModel isShowSegmentationTime:NO];
        @weakify(self);
        cell.tapBlock = ^(ChatModel * _Nonnull model) {
            @strongify(self);
            if ([model.messageType isEqualToString:Notice_JoinGroupApplyType]) {
                if (model.isShowOpenRedView) {
                    GroupApplyInfo*applyInfo=[GroupApplyInfo mj_objectWithKeyValues:[NSString decodeUrlString: chatModel.messageContent]];
                    applyInfo.messageId = chatModel.messageID;
                    GroupApplyDetailViewController * vc = [[GroupApplyDetailViewController alloc]init];
                    vc.info = applyInfo;
                    vc.agreeBlock = ^(GroupApplyInfo * _Nonnull groupApplyInfo) {
                        //这里更新需要显示的文字 以及cell的高度和宽度
                        [[WCDBManager sharedManager]updateChatModelGroupApplyWithMessageId:groupApplyInfo.messageId];
                        if(chatModel != nil) {
                            [[WCDBManager sharedManager]updateChatModelGroupApplyWith:chatModel];
                        }
                        [self.tableView reloadData];
                        [self updateFrame];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                [self getRedPackeDetailRequestWithRedId:model.redId];
            }
            
        };
        return cell;
        [self scrollTableViewToBottom:YES needScroll:NO];
    }
    if ([messageType containsString:WithdrawMessageType]){
        ChatWithdrawTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kChatWithdrawTableViewCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.chatModel=chatModel;
        @weakify(self);
        cell.tapBlock = ^{
            @strongify(self);
            self.chatFunctionView.messageTextView.text=[self.chatFunctionView.messageTextView.text stringByAppendingString:chatModel.showMessage];
        };
        return cell;
    }
    if (chatModel.isOutGoing) {
        if ([messageType isEqualToString:TransFerMessageType]||[messageType isEqualToString:SendSingleRedPacketType]||[messageType isEqualToString:SendRoomRedPacketType]||[messageType isEqualToString:LocationMessageType]||[messageType isEqualToString:UserCardMessageType]){
            ChatMineMessageTableViewCell*mineCell = [tableView dequeueReusableCellWithIdentifier:kChatMineMessageTableViewCell];
            mineCell.backgroundColor = [UIColor clearColor];
            mineCell.contentView.backgroundColor = [UIColor clearColor];
            mineCell.searchText=self.searchText;
            mineCell.shouldHightShow=self.shouldHightShow;
            mineCell.baseMessageCellDelegate=self;
            mineCell.multipleSelection=self.multipleSelection;
            mineCell.fileContainerView=self;
            mineCell.c2cUserInfo = self.c2cUserInfo;
            [mineCell setcurrentChatModel:chatModel isShowName:isShowNickname isGroup:isGroup isShowTime:isShowTime];
            return mineCell;
        }
        ChatRightMsgBaseTableViewCell *rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightMsgBaseTableViewCell];
        rightBaseCell.backgroundColor = [UIColor clearColor];
        rightBaseCell.contentView.backgroundColor = [UIColor clearColor];
        rightBaseCell.multipleBtn.selected = chatModel.isSelect;
        if ([messageType isEqualToString:TextMessageType]||[messageType isEqualToString:AtSingleMessageType]||[messageType isEqualToString:AtAllMessageType]) {
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightTxtMsgTableViewCell];
            ChatRightTxtMsgTableViewCell *txtCell = (ChatRightTxtMsgTableViewCell *)rightBaseCell;
            txtCell.backgroundColor = [UIColor clearColor];
            txtCell.contentView.backgroundColor = [UIColor clearColor];
            txtCell.longpressStatus = YES;
            if(chatModel.layoutHeight > 40.00) {
                txtCell.timeLableFlag = YES;
            }else {
                txtCell.timeLableFlag = NO;
            }
            txtCell.searchText = self.searchText;
            txtCell.shouldHightShow = self.shouldHightShow;
        }else if([messageType isEqualToString:GamifyMessageType]){
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightGamifyMsgTableViewCell];
            ChatRightAnimationView *txtCell = (ChatRightAnimationView*)rightBaseCell;
            txtCell.backgroundColor = [UIColor clearColor];
            txtCell.contentView.backgroundColor = [UIColor clearColor];
            txtCell.imgName = chatModel.showMessage;
            if(chatModel.gamificationStatus == 0){
                txtCell.isAnimated = YES;
            } else{
                txtCell.isAnimated = NO;
            }
        }else if ([messageType isEqualToString:URLMessageType]) {
            NSDataDetector *rightDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
            NSArray *rightMatches = [rightDetector matchesInString:chatModel.showMessage options:0 range:NSMakeRange(0, [chatModel.showMessage length])];
            NSURL *url = [rightMatches[0] valueForKeyPath:@"_url"];
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightUrlMsgTableViewCell];
            ChatRightUrlMsgTableViewCell *txtCell = (ChatRightUrlMsgTableViewCell*)rightBaseCell;
            txtCell.backgroundColor = [UIColor clearColor];
            txtCell.contentView.backgroundColor = [UIColor clearColor];
            txtCell.longpressStatus = YES;
            if((chatModel.layoutHeight > 56.00) && !((chatModel.thumbnailTitleofTextUrl == nil) || (chatModel.thumbnailImageurlofTextUrl == nil) || [chatModel.thumbnailTitleofTextUrl isEqualToString: @"Undefined"] || [chatModel.thumbnailImageurlofTextUrl isEqualToString: @"Undefined"] || [chatModel.thumbnailTitleofTextUrl isEqualToString:@""] || [chatModel.thumbnailImageurlofTextUrl isEqualToString:@""])) {
                txtCell.seeMoreBtnFlag = YES;
            }
            else{
                txtCell.seeMoreBtnFlag = NO;
            }
            txtCell.searchText = self.searchText;
            txtCell.shouldHightShow = self.shouldHightShow;
            @weakify(self);
            txtCell.resetBlock = ^{
                @strongify(self);
                UIStoryboard *board;
                board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
                WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
                View.isChat = YES;
                View.chatUrlString = url.absoluteString;
                View.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:View animated:YES];
                [[self navigationController] setNavigationBarHidden:NO animated:YES];
            };
        }else if ([messageType isEqualToString:ImageMessageType]) {
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightImgMsgTableViewCell];
            ChatRightImgMsgTableViewCell *txtCell = (ChatRightImgMsgTableViewCell *)rightBaseCell;
            txtCell.longpressStatus = YES;
        }else if ([messageType isEqualToString:VoiceMessageType]) {
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightVoiceTableViewCell];
            ChatRightVoiceTableViewCell *txtCell = (ChatRightVoiceTableViewCell *)rightBaseCell;
            txtCell.longpressStatus = YES;
        }else if ([messageType isEqualToString:VideoMessageType]) {
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightVideoTableViewCell];
            
        }else if ([messageType isEqualToString:FileMessageType]) {
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightFileTableViewCell];
            ChatRightFileTableViewCell* txtCell = (ChatRightFileTableViewCell*)rightBaseCell;
            txtCell.backgroundColor = [UIColor clearColor];
            txtCell.contentView.backgroundColor = [UIColor clearColor];
            txtCell.fileContainerView= self;
            txtCell.longpressStatus = YES;
        }else if ([messageType isEqualToString:ChatCallMessageType]) {
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightNimCallTableViewCell];
        }else if ([messageType isEqualToString:kChat_PostShare]){
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightTimelineTableViewCell];
            ChatRightTimelineTableViewCell *txtCell = (ChatRightTimelineTableViewCell *)rightBaseCell;
            txtCell.longpressStatus = YES;
        }else if ([messageType isEqualToString:kChatOtherShareType]){
            rightBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatRightGoodsTableViewCell];
            ChatRightGoodsTableViewCell *txtCell = (ChatRightGoodsTableViewCell *)rightBaseCell;
            txtCell.longpressStatus = YES;
        }
        rightBaseCell.c2cUserInfo = self.c2cUserInfo;
        rightBaseCell.multipleSelection = self.multipleSelection;
        rightBaseCell.msgDelegate = self;
        rightBaseCell.c2cUserInfo = self.c2cUserInfo;
        [rightBaseCell setcurrentChatModel:chatModel isShowName:isShowNickname isGroup:isGroup isShowTime:isShowTime];
        return rightBaseCell;
        
    }
    if ([messageType isEqualToString:TransFerMessageType]||[messageType isEqualToString:SendSingleRedPacketType]||[messageType isEqualToString:SendRoomRedPacketType]||[messageType isEqualToString:LocationMessageType]||[messageType isEqualToString:UserCardMessageType]){
        ChatOtherMessageTableViewCell*mineCell = [tableView dequeueReusableCellWithIdentifier:kChatOtherMessageTableViewCell];
        mineCell.backgroundColor = [UIColor clearColor];
        mineCell.contentView.backgroundColor = [UIColor clearColor];
        mineCell.baseOtherMessageCellDelegate=self;
        mineCell.multipleSelection=self.multipleSelection;
        mineCell.c2cUserInfo = self.c2cUserInfo;
        [mineCell setcurrentChatModel:chatModel isShowName:isShowNickname isGroup:isGroup isShowTime:isShowTime];
        return mineCell;
    }
    ChatLeftMsgBaseTableViewCell *leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftMsgBaseTableViewCell];
    leftBaseCell.backgroundColor = [UIColor clearColor];
    leftBaseCell.contentView.backgroundColor = [UIColor clearColor];
    leftBaseCell.multipleBtn.selected = chatModel.isSelect;
    if ([messageType isEqualToString:TextMessageType]||[messageType isEqualToString:AtSingleMessageType]||[messageType isEqualToString:AtAllMessageType]) {
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftTxtMsgTableViewCell];
        ChatLeftTxtMsgTableViewCell *txtCell = (ChatLeftTxtMsgTableViewCell *)leftBaseCell;
        txtCell.longpressStatus = YES;
        txtCell.backgroundColor = [UIColor clearColor];
        txtCell.contentView.backgroundColor = [UIColor clearColor];
        if(chatModel.layoutHeight > 40.00) {
            txtCell.timeLableFlag = YES;
        }else {
            txtCell.timeLableFlag = NO;
        }
    
        
        txtCell.searchText = self.searchText;
        txtCell.shouldHightShow = self.shouldHightShow;
    }else if ([messageType isEqualToString:GamifyMessageType]){
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftGamifyMsgTableViewCell];
        ChatLeftAnimationView *txtCell = (ChatLeftAnimationView *)leftBaseCell;
        txtCell.backgroundColor = [UIColor clearColor];
        txtCell.contentView.backgroundColor = [UIColor clearColor];
        txtCell.imgName =  chatModel.showMessage;
        if(chatModel.gamificationStatus == 0){
            txtCell.isAnimated = YES;
        } else{
            txtCell.isAnimated = NO;
        }
    }else if([messageType isEqualToString:URLMessageType]){
        NSDataDetector *rightDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray *rightMatches = [rightDetector matchesInString:chatModel.showMessage options:0 range:NSMakeRange(0, [chatModel.showMessage length])];
        NSURL *url;
        if(rightMatches.count > 0){
            url = [rightMatches[0] valueForKeyPath:@"_url"];
        }
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftUrlMsgTableViewCell];
        ChatLeftUrlMsgTableViewCell *txtCell = (ChatLeftUrlMsgTableViewCell*)leftBaseCell;
        txtCell.backgroundColor = [UIColor clearColor];
        txtCell.contentView.backgroundColor = [UIColor clearColor];
        txtCell.longpressStatus = YES;
        if((chatModel.layoutHeight > 56.00) && !((chatModel.thumbnailTitleofTextUrl == nil) || (chatModel.thumbnailImageurlofTextUrl == nil) || [chatModel.thumbnailTitleofTextUrl isEqualToString: @"Undefined"] || [chatModel.thumbnailImageurlofTextUrl isEqualToString: @"Undefined"] || [chatModel.thumbnailTitleofTextUrl isEqualToString:@""] || [chatModel.thumbnailImageurlofTextUrl isEqualToString:@""])) {
            txtCell.seeMoreBtnFlag = YES;
        }
        else{
            txtCell.seeMoreBtnFlag = NO;
        }
        txtCell.searchText = self.searchText;
        txtCell.shouldHightShow = self.shouldHightShow;
        @weakify(self);
        txtCell.resetBlock = ^{
            @strongify(self);
            UIStoryboard *board;
            board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
            WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
            View.isChat = YES;
            View.chatUrlString = url.absoluteString;
            View.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:View animated:YES];
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
        };
    }else if ([messageType isEqualToString:ImageMessageType]){
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftImgMsgTableViewCell];
        ChatLeftImgMsgTableViewCell *txtCell = (ChatLeftImgMsgTableViewCell *)leftBaseCell;
        txtCell.longpressStatus = YES;
    }else if ([messageType isEqualToString:VoiceMessageType]){
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftVoiceTableViewCell];
        ChatLeftVoiceTableViewCell *txtCell = (ChatLeftVoiceTableViewCell *)leftBaseCell;
        txtCell.longpressStatus = YES;
    }else if ([messageType isEqualToString:VideoMessageType]){
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftVideoTableViewCell];
    }else if ([messageType isEqualToString:FileMessageType]){
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftFileTableViewCell];
        ChatLeftFileTableViewCell* txtCell = (ChatLeftFileTableViewCell*)leftBaseCell;
        txtCell.backgroundColor = [UIColor clearColor];
        txtCell.contentView.backgroundColor = [UIColor clearColor];
        txtCell.fileContainerView= self;
        txtCell.longpressStatus = YES;
    }else if ([messageType isEqualToString:ChatCallMessageType]){
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftNimCallTableViewCell];
    }else if ([messageType isEqualToString:kChat_PostShare]){
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftTimelineTableViewCell];
        ChatLeftTimelineTableViewCell *txtCell = (ChatLeftTimelineTableViewCell*)leftBaseCell;
        txtCell.longpressStatus = YES;
    }else if ([messageType isEqualToString:kChatOtherShareType]){
        leftBaseCell = [tableView dequeueReusableCellWithIdentifier:kChatLeftGoodsTableViewCell];
        ChatLeftGoodsTableViewCell *txtCell = (ChatLeftGoodsTableViewCell*)leftBaseCell;
        txtCell.longpressStatus = YES;
    }
    leftBaseCell.c2cUserInfo = self.c2cUserInfo;
    leftBaseCell.multipleSelection = self.multipleSelection;
    leftBaseCell.baseOtherMessageCellDelegate = self;
    leftBaseCell.c2cUserInfo = self.c2cUserInfo;
    [leftBaseCell setcurrentChatModel:chatModel isShowName:isShowNickname isGroup:isGroup isShowTime:isShowTime];
    return leftBaseCell;
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        self.isScrollViewScroll=YES;
    }else{
        self.isScrollViewScroll=NO;
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
    NSMutableArray *arr2 = [[NSMutableArray alloc]init];
    NSString *scrollStatus = [[NSString alloc]init];
    ChatModel *visibleMsgs;
    for (NSIndexPath *indexVisible in self.tableView.indexPathsForVisibleRows) {
        NSInteger row = indexVisible.row;
        if (row >= 0 && row < self.messageItems.count) {
            CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexVisible];
            BOOL isVisible = CGRectContainsRect(self.tableView.bounds, cellRect);
            if (isVisible) {
                [arr addObject:indexVisible];
                [arr1 addObject:@(row)]; // Using NSNumber literal syntax
                visibleMsgs = self.messageItems[row];
                [arr2 addObject:visibleMsgs.messageID];
            }
        } else {
            NSLog(@"Row index out of bounds: %ld", (long)row);
        }
    }
    
    if(self.messageItems.count > 3) {
        for (NSString *idx in arr2) {
            if (idx ==  self.thirdMsg) {
                scrollStatus = @"jump";
            }
        }
    }
    
    if ([scrollStatus isEqualToString:@"jump"]) {
        //do the jump
        for (ChatModel *cmodel in self.inQ){
            [self.messageItems addObject:cmodel];
        }
        //        [self.messageItems addObject:chatModel];
        [self.tableView reloadData];
        [self.inQ removeAllObjects];
        self.goBottomBtnStatus = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                    [self scrollTableViewToBottom:YES needScroll:YES];
            [self.bottomActionView removeFromSuperview];
        });
        NSLog(@"scrolled to bottom while having godwn botton");
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isScrollViewScroll=NO;
    
}
- (void)scrollTableViewToBottom:(BOOL)animated needScroll:(BOOL)needScroll{
    if (!needScroll) {
        NSIndexPath*index = self.tableView.indexPathsForVisibleRows.firstObject;
        BOOL shouldScroll = YES;
        if (self.messageItems.count>30) {
            shouldScroll = index.row>=20;
        }
        if (self.isScrollViewScroll||!shouldScroll) {
            return;
        }
    }
    if (self.messageItems.count>0) {
        NSIndexPath*index=[NSIndexPath indexPathForRow:self.messageItems.count -1 inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        });
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (UserInfoManager.sharedManager.messageMenuView) {
        [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    }
    self.fastMessageView.hidden = YES;
}

#pragma mark 表格开始拖拽滚动，隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView ==self.tableView) {
        self.lastContentOffsetY = scrollView.contentOffset.y;
        self.isScrollViewScroll=YES;
        [self.chatFunctionView hiddenAllView];
        [self.view endEditing:YES];
        //如果是从搜索历史记录进来
        if (self.shouldStartLoad) {
            self.shouldHightShow=NO;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currentHightRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
}
#pragma mark - BaseMessageCelllDelegate 点击消息的代理

/// 点击了发送失败的按钮
/// @param cell cell description
-(void)didClickSendFailButtonWithCell:(UITableViewCell *)cell{
    if (WebSocketManager.sharedManager.hasNewWork) {
        if (self.messageSendTime) {
            NSInteger currentTime = [[NSDate date]timeIntervalSince1970]*1000;
            if ((currentTime - self.messageSendTime)<1000) {
                return;
            }else{
                self.messageSendTime = currentTime;
            }
        }else{
            self.messageSendTime = [[NSDate date]timeIntervalSince1970]*1000;
        }
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ChatModel *model = [self.messageItems objectAtIndex:indexPath.row];
        [self.messageItems removeObject:model];
        [[WCDBManager sharedManager]deleteOneChatModelWithMessageId:model.messageID];
        if ([model.messageType isEqualToString:TextMessageType]) {
            //创建文本消息
            ChatModel *textModel = [ChatUtil initTextMessage:model.showMessage config:self.config];
            [self sendAndSaveMessageWithChatModel:textModel];
        }else if ([model.messageType isEqualToString:URLMessageType]) {
            //创建文本消息
            model.messageTime = [NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
            [self sendAndSaveMessageWithChatModel:model];
        }else if ([model.messageType isEqualToString:GamifyMessageType]){
            [self deleteMoreMessageRequestWithMessageIds:@[model.messageID] deleteAll:NO];
            [self diceGame];
        }else if ([model.messageType isEqualToString:VoiceMessageType]) {
            model.messageTime = [NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
            [self sendAndSaveMessageWithChatModel:model];
        }else if ([model.messageType isEqualToString:ImageMessageType]) {
            if (model.uploadState == 1) {
                model.messageTime = [NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
                model.sendState = 2;
                [self sendAndSaveMessageWithChatModel:model];
            }
        }else if ([model.messageType isEqualToString:UserCardMessageType]) {
            model.messageTime = [NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
            model.sendState = 2;
            [self sendAndSaveMessageWithChatModel:model];
        }else if ([model.messageType isEqualToString:LocationMessageType]){
            model.messageTime = [NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
            model.sendState = 2;
            [self sendAndSaveMessageWithChatModel:model];
        }
    }
}

-(void)didMultipleSelectMessageWithCell:(UITableViewCell *)cell{
    [self checkMutipleCanHandle];
}
/// 点击了用户头像
- (void)didSelectIconViewWithOtherCell:(UITableViewCell *)cell{
    NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
    ChatModel*model=[self.messageItems objectAtIndex:indexPath.row];
    //如果当前页面是交友页面
    if ([self.config.authorityType isEqualToString:AuthorityType_circle]) {
        if (self.config.circleUserId) {
            //如果对方已经注销或者对方不喜欢我都不能点击看用户详情
            if (!self.circleUserInfo.deleted&&!self.circleDislikeMeInfo.dislikeMe) {
                CircleUserDetailViewController*vc=[[CircleUserDetailViewController alloc]init];
                vc.userId=self.config.circleUserId;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if ([self.config.authorityType isEqualToString:AuthorityType_c2c]){
        
    }else{
        [[ChatViewHandleTool  shareManager]tapOtherIconWithChatModel:model groupDetailInfo:self.groupDetailInfo chatModel:self.config];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.multipleSelection) {
        [self multipleSelection:indexPath];
    }
}
//多选cell
-(void)multipleSelection:(NSIndexPath*)indexPath{
    [self.messageItems objectAtIndex:indexPath.row].isSelect=![self.messageItems objectAtIndex:indexPath.row].isSelect;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
/// 点击了消息
/// @param cell cell description
-(void)didSelectMessageWithCell:(UITableViewCell *)cell {
    if (self.multipleSelection) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self multipleSelection:indexPath];
    }else{
        [self didSelectChatMessageCell:cell];
    }
    
}
-(void)didSelectChatMessageCell:(UITableViewCell*)cell{
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row >= self.messageItems.count) {
        return;
    }
    [self.chatFunctionView hiddenAllView];
    [self.view endEditing:YES];
    //获取聊天信息
    ChatModel *model = self.messageItems[indexPath.row];
    self.currentTapChatModel=model;
    if ([model.messageType isEqualToString: VoiceMessageType]) {
        if (!model.isOutGoing) {
            if (!model.voiceHasRead) {
                model.voiceHasRead = YES;
                [[WCDBManager sharedManager]updateVoiceMessageHasReadFromMessageId:model.messageID];
            }
        }
        self.currentPlayingVoiceModel=model;
        [[AudioPlayerManager shareDZAudioPlayerManager]playAudioWithURLString:model.isOutGoing?model.fileCacheName:model.fileServiceUrl atIndex:indexPath.row isSender:model.isOutGoing];
    }else if ([model.messageType isEqualToString:ImageMessageType]){
        NSArray * array=[[WCDBManager sharedManager]fetchMediaChatModelWihtChatId:self.config.chatID chatType:self.config.chatType];
        NSInteger curreIndex = 0;
        NSMutableArray *datas=[NSMutableArray arrayWithArray:array];
        //数组倒序
        datas = (NSMutableArray *)[[datas reverseObjectEnumerator] allObjects];
        for (ChatModel*chatModel in datas) {
            if ([chatModel.messageID isEqualToString:model.messageID]) {
                curreIndex=[datas indexOfObject:chatModel];
                break;
            }
        }
        self.ybImageBrowerTool=[[YBImageBrowerTool alloc]init];
        [self.ybImageBrowerTool showYBImageBrowerWithCurrentIndex:curreIndex chatModelArray:datas];
    }else if ([model.messageType isEqualToString:VideoMessageType]){
        self.currentPlayVideoModel=model;
        [self.view endEditing:YES];
    }else if ([model.messageType isEqualToString:SendSingleRedPacketType]){
        [self configurationChatViewHandleTool];
        [[ChatViewHandleTool shareManager]chatViewHandleShwoSingleRedPacketWithCurrentModel:model];
    }else if ([model.messageType isEqualToString:SendRoomRedPacketType]){//多人红包
        [self configurationChatViewHandleTool];
        [[ChatViewHandleTool shareManager]chatViewHandleShwoSingleRedPacketWithCurrentModel:model];
        
    }else if ([model.messageType isEqualToString:ChatCallMessageType]){
        ChatCallMessageInfo*info=[ChatCallMessageInfo mj_objectWithKeyValues:model.messageContent];
        if ([info.callType isEqualToString:@"VOICE"]) {
            [self startNIMWWithType:@"VOICE"];
        }else{
            [self startNIMWWithType:@"VIDEO"];
            
        }
        
    }else if ([model.messageType isEqualToString:kChat_PostShare]){
        ChatPostShareMessageInfo*info=[ChatPostShareMessageInfo mj_objectWithKeyValues:model.messageContent];
        TimelinesDetailViewController*vc=[[TimelinesDetailViewController alloc]init];
        vc.messageId=[[NSString alloc]initWithFormat:@"%ld",info.postId];;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
-(void)clickReplyActionWithOtherCell:(UITableViewCell *)cell{
    [self clickReplyActionByCell:cell];
}
/** 点击了回复的label */
-(void)clickReplyAction:(UITableViewCell *)cell{
    [self clickReplyActionByCell:cell];
}
-(void)clickReplyActionByCell:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row >= self.messageItems.count) {
        return;
    }
    [self.chatFunctionView hiddenAllView];
    [self.view endEditing:YES];
    [self configurationChatViewHandleTool];
    ChatModel *model = self.messageItems[indexPath.row];
    [[ChatViewHandleTool shareManager]clickReplyCellWithContainer:self chatModel:model];
}

#pragma mark - 撤回 删除 转发 复制 多选
-(void)didSelectItemArticleWithOtherSelectTypeWith:(SelectMessageType)selectType cell:(UITableViewCell *)cell{
    [self didSelectItemSelectType:selectType cell:cell];
}
-(void)didSelectItemArticleWithSelectType:(SelectMessageType)selectType cell:(UITableViewCell *)cell{
    [self didSelectItemSelectType:selectType cell:cell];
}

-(void)didSelectReactItemOfCell:(ReactItem *)reactItem cell:(UITableViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ChatModel *model = [self.messageItems objectAtIndex:indexPath.row];
    [self makeReaction:model reactItem:reactItem];
}

- (void)didSelectItemSelectType:(SelectMessageType)selectType cell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ChatModel *model = [self.messageItems objectAtIndex:indexPath.row];
    switch (selectType) {
            //删除消息
        case SelectMessageTypeDelete:
            [self deleteMessageWithTableViewCell:cell];
            break;
        case SelectMessageTypeForward:{//转发
            [self transpondWithSelectMessage:@[model]];
        }
            break;
        case SelectMessageTypeWithdraw:{//撤回
            [self withdrawMessageWithChatModel:model];
        }
            break;
        case SelectMessageTypeCollection:{
            [self collectMessageWithChatModel:model];
        }
            break;
        case SelectMessageTypeReply:{
            [self replayMessageWithModel:model];
        }
            break;
        case SelectMessageTypeMore:{
            //点击了选择更多的按钮
            self.multipleSelection=YES;
            [self.view endEditing:YES];
            [self.chatFunctionView hiddenAllView];
            [self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
            [self.chatViewNavBarView updateUiAfterSelectMore];
            [UIView animateWithDuration:0.25 animations:^{
                self.multipleShowView .frame=CGRectMake(0, ScreenHeight-self.defaultHeight, ScreenWidth, self.defaultHeight);
            } completion:^(BOOL finished) {
            }];
        }
            break;
        case SelectMessageTypeReceiver:{
            [self didSelectChatMessageCell:cell];
        }
            break;
        case SelectMessageTypeQuickMessage:{
            [self addQuickMessageRequest:model];
        }
            break;
        case SelectMessageTypePinMessage:{
            [self createPinMessagePopup:YES message:model];
        }
            break;
        case SelectMessageTypeUnpinMessage:{
            [self createPinMessagePopup:NO message:model];
        }
            break;
        default:
            break;
    }
}
- (void)makeReaction:(ChatModel *)message reactItem:(ReactItem *)item{
    if([message.authorityType isEqualToString: AuthorityType_friend]){
        self.reactChatModel = [[ChatModel alloc] init];
        self.reactChatModel = [message mutableCopy];
        self.reactChatModel.messageType = ReactionMessage;
        self.reactChatModel.messageID = [NSString getCFUUID];
        NSMutableDictionary *reactions = [NSMutableDictionary dictionary];
        if (message.reactions && [message.reactions isKindOfClass:[NSMutableDictionary class]]) {
            ChatModel *model = [[WCDBManager sharedManager] getChatModelByMessageId:message.messageID];
            reactions = model.reactions;
        }
        if(message.reactions.count == 0){
            if([message.chatType isEqualToString: @"userChat"]){
                self.reactChatModel.messageTo = self.reactChatModel.chatID;
            }else{
                self.reactChatModel.messageTo = nil;
            }
            ReactionMessageInfo *info = [[ReactionMessageInfo alloc]init];
            info.reactedMsgId = message.messageID;
            info.action = @"addReaction";
            info.reaction = item.title;
            self.reactChatModel.messageContent = [info mj_JSONString];
            [reactions setObject:[NSMutableArray arrayWithObject:[UserInfoManager sharedManager].userId] forKey:item.title];
            message.reactions = reactions;
            [[WebSocketManager sharedManager]sendMessageWithChatModel:self.reactChatModel];
            message.selfReaction = item.title;
            [[WCDBManager sharedManager] updateReactionMessageByMessageId:message.messageID reaction:item.title action:info.action reactedPerson:[UserInfoManager sharedManager].userId selfReaction:item.title];
        }else{
            if(message.selfReaction != nil){
                if([message.selfReaction isEqualToString:item.title]){
                    if([message.chatType isEqualToString: @"userChat"]){
                        self.reactChatModel.messageTo = self.reactChatModel.chatID;
                    }else{
                        self.reactChatModel.messageTo = nil;
                    }
                    ReactionMessageInfo *info = [[ReactionMessageInfo alloc]init];
                    info.reactedMsgId = message.messageID;
                    info.action = @"removeReaction";
                    info.reaction = item.title;
                    message.selfReaction = @"";
                    NSMutableArray *arrayForReaction = [reactions[item.title] mutableCopy];
                    [arrayForReaction removeObject:[UserInfoManager sharedManager].userId];
                    if(arrayForReaction.count == 0){
                        [reactions removeObjectForKey:item.title];
                    }else{
                        [reactions setObject:arrayForReaction forKey:item.title];
                    }
                    message.reactions = reactions;
                    self.reactChatModel.messageContent = [info mj_JSONString];
                    [[WebSocketManager sharedManager]sendMessageWithChatModel:self.reactChatModel];
                    [[WCDBManager sharedManager] updateReactionMessageByMessageId:message.messageID reaction:item.title action:info.action reactedPerson:[UserInfoManager sharedManager].userId selfReaction:@""];
                }else{
                    if([message.chatType isEqualToString: @"userChat"]){
                        self.reactChatModel.messageTo = self.reactChatModel.chatID;
                    }else{
                        self.reactChatModel.messageTo = nil;
                    }
                    ReactionMessageInfo *removeInfo = [[ReactionMessageInfo alloc]init];
                    removeInfo.reactedMsgId = message.messageID;
                    removeInfo.action = @"removeReaction";
                    removeInfo.reaction = message.selfReaction;
                    self.reactChatModel.messageContent = [removeInfo mj_JSONString];
                    NSMutableArray *arrayForReaction = [reactions[message.selfReaction] mutableCopy];
                    [arrayForReaction removeObject:[UserInfoManager sharedManager].userId];
                    if(arrayForReaction.count == 0){
                        [reactions removeObjectForKey:message.selfReaction];
                    }else{
                        [reactions setObject:arrayForReaction forKey:message.selfReaction];
                    }
                    [[WebSocketManager sharedManager]sendMessageWithChatModel:self.reactChatModel];
                    [[WCDBManager sharedManager] updateReactionMessageByMessageId:message.messageID reaction:message.selfReaction action:removeInfo.action reactedPerson:[UserInfoManager sharedManager].userId selfReaction:message.selfReaction];
                    self.reactChatModel.messageID = [NSString getCFUUID];
                    ReactionMessageInfo *addReactionInfo = [[ReactionMessageInfo alloc]init];
                    addReactionInfo.reactedMsgId = message.messageID;
                    addReactionInfo.action = @"addReaction";
                    addReactionInfo.reaction = item.title;
                    message.selfReaction = item.title;
                    if([reactions.allKeys containsObject:item.title]){
                        NSMutableArray *newArrayForReaction = [reactions[item.title] mutableCopy];
                        [newArrayForReaction addObject:[UserInfoManager sharedManager].userId];
                        [reactions setObject:newArrayForReaction forKey:item.title];
                    }else{
                        [reactions setObject:[NSMutableArray arrayWithObject:[UserInfoManager sharedManager].userId] forKey:item.title];
                    }
                    message.reactions = reactions;
                    self.reactChatModel.messageContent = [addReactionInfo mj_JSONString];
                    [[WebSocketManager sharedManager]sendMessageWithChatModel:self.reactChatModel];
                    [[WCDBManager sharedManager] updateReactionMessageByMessageId:message.messageID reaction:item.title action:addReactionInfo.action reactedPerson:[UserInfoManager sharedManager].userId selfReaction:item.title];
                }
            }else{
                if([message.chatType isEqualToString: @"userChat"]){
                    self.reactChatModel.messageTo = self.reactChatModel.chatID;
                }else{
                    self.reactChatModel.messageTo = nil;
                }
                ReactionMessageInfo *info = [[ReactionMessageInfo alloc]init];
                info.reactedMsgId = message.messageID;
                info.action = @"addReaction";
                info.reaction = item.title;
                self.reactChatModel.messageContent = [info mj_JSONString];
                NSMutableArray *arrayForReaction = [reactions[item.title] mutableCopy];
                [arrayForReaction removeObject:[UserInfoManager sharedManager].userId];
                if([reactions.allKeys containsObject:item.title]){
                    NSMutableArray *arrayForReaction = [reactions[item.title] mutableCopy];
                    [arrayForReaction addObject:[UserInfoManager sharedManager].userId];
                    [reactions setObject:arrayForReaction forKey:item.title];
                }else{
                    [reactions setObject:[NSMutableArray arrayWithObject:[UserInfoManager sharedManager].userId] forKey:item.title];
                }
                message.selfReaction = item.title;
                message.reactions = reactions;
                [[WebSocketManager sharedManager]sendMessageWithChatModel:self.reactChatModel];
                [[WCDBManager sharedManager] updateReactionMessageByMessageId:message.messageID reaction:item.title action:info.action reactedPerson:[UserInfoManager sharedManager].userId selfReaction:item.title];
            }
        }
    }
    [self.tableView reloadData];
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
}

#pragma mark - Message pin and unpin function
- (void)createPinMessage:(BOOL)isPin message:(ChatModel *)message pinType:(NSString *)pinType {
    if([message.authorityType isEqualToString: AuthorityType_friend]){
        self.selectedPinChatModel = message;
        self.pinChatModel = [[ChatModel alloc] init];
        self.pinChatModel = [message mutableCopy];
        if([message.chatType isEqualToString:@"groupChat"]) {
            if([self.groupDetailInfo.role isEqualToString: @"0"] || [self.groupDetailInfo.role isEqualToString: @"1"]) {
                if(isPin) {
                    if([pinType isEqualToString: @"group-all"]) {
                        self.msgContentModel = [[MsgContentModel alloc] init];
                        self.msgContentModel.pinnedMsgId = self.pinChatModel.messageID;
                        self.msgContentModel.audience = @"All";
                        self.msgContentModel.isUnpinAll = NO;
                        self.msgContentModel.action = @"Pin";
                        self.pinChatModel.messageID = [NSString getCFUUID];
                        self.pinChatModel.messageType = @"Pin_Message";
                        self.pinChatModel.messageTo = nil;
                        NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
                        NSError *error = nil;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
                        if (!jsonData) {
                            NSLog(@"Error converting to JSON: %@", error);
                        } else {
                            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                            NSLog(@"JSON string: %@", jsonString);
                            self.pinChatModel.messageContent = jsonString;
                        }
                        [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
                        [[WCDBManager sharedManager]updatePinStatusWithChatId:self.msgContentModel.pinnedMsgId isPin:isPin isOther:NO pinAudiance:@"All"];
                        [self setLastPinMessage];
                        self.selectedPinChatModel.pinAudiance = @"All";
                        [self.tableView reloadData];
                    }else if([pinType isEqualToString: @"group-self"]) {
                        self.msgContentModel = [[MsgContentModel alloc] init];
                        self.msgContentModel.pinnedMsgId = self.pinChatModel.messageID;
                        self.msgContentModel.audience = @"Self";
                        self.msgContentModel.isUnpinAll = NO;
                        self.msgContentModel.action = @"Pin";
                        self.pinChatModel.messageID = [NSString getCFUUID];
                        self.pinChatModel.messageType = @"Pin_Message";
                        self.pinChatModel.messageTo = [UserInfoManager sharedManager].userId;
                        NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
                        NSError *error = nil;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
                        if (!jsonData) {
                            NSLog(@"Error converting to JSON: %@", error);
                        } else {
                            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                            NSLog(@"JSON string: %@", jsonString);
                            self.pinChatModel.messageContent = jsonString;
                        }
                        [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
                        [[WCDBManager sharedManager]updatePinStatusWithChatId:self.msgContentModel.pinnedMsgId isPin:isPin isOther:NO pinAudiance:@"Self"];
                        [self setLastPinMessage];
                        self.selectedPinChatModel.pinAudiance = @"Self";
                        [self.tableView reloadData];
                    }
                    [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"SuccessfullyPined", SuccessfullyPined) inView:self.view];
                }else {
                    self.msgContentModel = [[MsgContentModel alloc] init];
                    self.msgContentModel.pinnedMsgId = message.messageID;
                    if([message.pinAudiance isEqualToString:@"Self"]) {
                        self.msgContentModel.audience = @"Self";
                        self.pinChatModel.messageTo = [UserInfoManager sharedManager].userId;
                        self.pinChatModel.chatID = nil;
                        message.pinAudiance = @"Self";
                    }else {
                        self.msgContentModel.audience = @"All";
                        message.pinAudiance = @"All";
                    }
                    self.msgContentModel.isUnpinAll = NO;
                    self.msgContentModel.action = @"Unpin";
                    self.pinChatModel.messageID = [NSString getCFUUID];
                    self.pinChatModel.messageType = @"Pin_Message";
                    NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
                    if (!jsonData) {
                        NSLog(@"Error converting to JSON: %@", error);
                    } else {
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSLog(@"JSON string: %@", jsonString);
                        self.pinChatModel.messageContent = jsonString;
                    }
                    [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
                    [[WCDBManager sharedManager]updatePinStatusWithChatId:self.msgContentModel.pinnedMsgId isPin:isPin isOther:NO pinAudiance:nil];
                    [self setLastPinMessage];
                    message.pinAudiance = nil;
                    [self.tableView reloadData];
                    [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"SuccessfullyUnpined", SuccessfullyUnpined) inView:self.view];
                }
            }else {
                self.msgContentModel = [[MsgContentModel alloc] init];
                self.msgContentModel.pinnedMsgId = message.messageID;
                self.msgContentModel.audience = @"Self";
                self.msgContentModel.isUnpinAll = NO;
                self.pinChatModel.messageID = [NSString getCFUUID];
                self.pinChatModel.messageType = @"Pin_Message";
                self.pinChatModel.messageTo = [UserInfoManager sharedManager].userId;
                self.pinChatModel.chatID = nil;
                if(isPin == YES) {
                    [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"SuccessfullyPined", SuccessfullyPined) inView:self.view];
                    self.msgContentModel.action = @"Pin";
                    message.pinAudiance = @"Self";
                }else {
                    [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"SuccessfullyUnpined", SuccessfullyUnpined) inView:self.view];
                    self.msgContentModel.action = @"Unpin";
                    message.pinAudiance = nil;
                }
                NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
                if (!jsonData) {
                    NSLog(@"Error converting to JSON: %@", error);
                } else {
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"JSON string: %@", jsonString);
                    self.pinChatModel.messageContent = jsonString;
                }
                [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
                [[WCDBManager sharedManager]updatePinStatusWithChatId:self.msgContentModel.pinnedMsgId isPin:isPin isOther:NO pinAudiance:message.pinAudiance];
                [self setLastPinMessage];
                [self.tableView reloadData];
            }
        }else if([message.chatType isEqualToString: @"userChat"]) {
            if(isPin) {
                if([pinType isEqualToString: @"single-all"]) {
                    self.msgContentModel = [[MsgContentModel alloc] init];
                    self.msgContentModel.pinnedMsgId = self.pinChatModel.messageID;
                    self.msgContentModel.audience = @"All";
                    self.msgContentModel.isUnpinAll = NO;
                    self.msgContentModel.action = @"Pin";
                    self.pinChatModel.messageID = [NSString getCFUUID];
                    self.pinChatModel.messageType = @"Pin_Message";
                    self.pinChatModel.messageTo = self.pinChatModel.chatID;
                    NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
                    if (!jsonData) {
                        NSLog(@"Error converting to JSON: %@", error);
                    } else {
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSLog(@"JSON string: %@", jsonString);
                        self.pinChatModel.messageContent = jsonString;
                    }
                    [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
                    [[WCDBManager sharedManager]updatePinStatusWithChatId:self.msgContentModel.pinnedMsgId isPin:isPin isOther:NO pinAudiance:@"All"];
                    [self setLastPinMessage];
                    self.selectedPinChatModel.pinAudiance = @"All";
                    [self.tableView reloadData];
                }else if([pinType isEqualToString: @"single-self"]) {
                    self.msgContentModel = [[MsgContentModel alloc] init];
                    self.msgContentModel.pinnedMsgId = self.pinChatModel.messageID;
                    self.msgContentModel.audience = @"Self";
                    self.msgContentModel.isUnpinAll = NO;
                    self.msgContentModel.action = @"Pin";
                    self.pinChatModel.messageID = [NSString getCFUUID];
                    self.pinChatModel.messageType = @"Pin_Message";
                    self.pinChatModel.messageTo = [UserInfoManager sharedManager].userId;
                    NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
                    if (!jsonData) {
                        NSLog(@"Error converting to JSON: %@", error);
                    } else {
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSLog(@"JSON string: %@", jsonString);
                        self.pinChatModel.messageContent = jsonString;
                    }
                    [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
                    [[WCDBManager sharedManager]updatePinStatusWithChatId:self.msgContentModel.pinnedMsgId isPin:isPin isOther:NO pinAudiance:@"Self"];
                    [self setLastPinMessage];
                    self.selectedPinChatModel.pinAudiance = @"Self";
                    [self.tableView reloadData];
                }
                [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"SuccessfullyPined", SuccessfullyPined) inView:self.view];
            }else {
                self.msgContentModel = [[MsgContentModel alloc] init];
                self.msgContentModel.pinnedMsgId = message.messageID;
                if([message.pinAudiance isEqualToString: @"All"]) {
                    self.msgContentModel.audience = @"All";
                    self.pinChatModel.messageTo = message.chatID;
                }else {
                    self.msgContentModel.audience = @"Self";
                    self.pinChatModel.messageTo = [UserInfoManager sharedManager].userId;
                    self.pinChatModel.chatID = nil;
                }
                self.msgContentModel.isUnpinAll = NO;
                self.msgContentModel.action = @"Unpin";
                self.pinChatModel.messageID = [NSString getCFUUID];
                self.pinChatModel.messageType = @"Pin_Message";
                NSDictionary *msgContentDict = [self.msgContentModel dictionaryWithValuesForKeys:@[@"pinnedMsgId", @"action", @"audience", @"isUnpinAll"]];
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msgContentDict options:0 error:&error];
                if (!jsonData) {
                    NSLog(@"Error converting to JSON: %@", error);
                } else {
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"JSON string: %@", jsonString);
                    self.pinChatModel.messageContent = jsonString;
                }
                [[WebSocketManager sharedManager]sendMessageWithChatModel:self.pinChatModel];
                [[WCDBManager sharedManager]updatePinStatusWithChatId:self.msgContentModel.pinnedMsgId isPin:isPin isOther:NO pinAudiance:nil];
                [self setLastPinMessage];
                message.pinAudiance = nil;
                [self.tableView reloadData];
                [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Successfully unpined", 成功创建) inView:self.view];
            }
        }
        [self updateFrame];
    }
    if(self.actionView.hidden == NO) {
        self.pinMessages = [self getPinMessage:self.config.chatID];
        if(self.pinMessages.count == 1) {
            [self.actionView removeFromSuperview];
            [self.view addSubview:_actionView];
            [_actionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(NavBarHeight+70));
                make.right.equalTo(@0);
                make.height.equalTo(@40);
                make.width.equalTo(@160);
            }];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoTop)];
            [_actionView addGestureRecognizer:tap];
        }
    }
}

- (void)createPinMessagePopup:(BOOL)isPin message:(ChatModel*)message {
    if([message.authorityType isEqualToString: AuthorityType_friend]) {
        // Add cancel button
        QMUIAlertAction *action0 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        // PinForMe Button
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"PinForMe".icanlocalized style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            message.isPin = YES;
            [self createPinMessage:YES message:message pinType:@"single-self"];
        }];
        // PinForMeBoth Button
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"PinForAll".icanlocalized  style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            message.isPin = YES;
            [self createPinMessage:YES message:message pinType:@"single-all"];
        }];
        // PinForMe Button for group
        QMUIAlertAction *action1g = [QMUIAlertAction actionWithTitle:@"PinForMe".icanlocalized style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            message.isPin = YES;
            [self createPinMessage:YES message:message pinType:@"group-self"];
        }];
        // PinForAll Button
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"PinForAll".icanlocalized  style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            message.isPin = YES;
            [self createPinMessage:YES message:message pinType:@"group-all"];
        }];
        // UnpinForMe Button
        QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"UnpinForMe".icanlocalized style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            message.isPin = NO;
            [self createPinMessage:NO message:message pinType:nil];
        }];
        // UnpinForBoth Button
        QMUIAlertAction *action5 = [QMUIAlertAction actionWithTitle:@"UnpinForAll".icanlocalized  style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            message.isPin = NO;
            [self createPinMessage:NO message:message pinType:nil];
        }];
        // UnpinForAll Button
        QMUIAlertAction *action6 = [QMUIAlertAction actionWithTitle:@"UnpinForAll".icanlocalized  style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            message.isPin = NO;
            [self createPinMessage:NO message:message pinType:nil];
        }];
        // Create alert
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        if([message.chatType isEqualToString:@"groupChat"]) {
            if([self.groupDetailInfo.role isEqualToString: @"0"] || [self.groupDetailInfo.role isEqualToString: @"1"]) {
                if(isPin) {
                    [alertController addAction:action0];
                    [alertController addAction:action1g];
                    [alertController addAction:action3];
                    [alertController showWithAnimated:YES];
                }else {
                    [alertController addAction:action0];
                    if([message.pinAudiance isEqualToString:@"Self"]) {
                        [alertController addAction:action4];
                        [alertController addAction:action3];
                    }else {
                        [alertController addAction:action6];
                    }
                    [alertController showWithAnimated:YES];
                }
            }else {
                [alertController addAction:action0];
                if(isPin == YES) {
                    [alertController addAction:action1];
                }else {
                    [alertController addAction:action4];
                }
                [alertController showWithAnimated:YES];
            }
        }else if([message.chatType isEqualToString: @"userChat"]) {
            if(isPin) {
                [alertController addAction:action0];
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController showWithAnimated:YES];
            }else {
                if([message.pinAudiance isEqualToString: @"All"]) {
                    [alertController addAction:action0];
                    [alertController addAction:action5];
                    [alertController showWithAnimated:YES];
                }else {
                    [alertController addAction:action0];
                    [alertController addAction:action4];
                    [alertController addAction:action2];
                    [alertController showWithAnimated:YES];
                }
            }
        }
    }
}


- (void)tapOnPinMenueButton {
    self.pinMessages = [self getPinMessage:self.config.chatID];
    if(self.pinMessages.count < 1) {
        return;
    }
    self.currentPinArrayIndex = self.currentPinArrayIndex + 1;
    if(self.pinMessages.count == 1 || (self.currentPinArrayIndex + 1) > self.pinMessages.count) {
        self.currentPinArrayIndex = 0;
    }
    if(self.pinMessages.count > self.currentPinArrayIndex) {
        if([self.pinMessages[self.currentPinArrayIndex].messageType isEqualToString:TextMessageType]) {
            self.pinMenueBar.messageLabel.text = [NSString stringWithFormat:@"#%@%@%@", [NSString stringWithFormat:@"%ld", (long)(self.currentPinArrayIndex + 1)], @" ",self.pinMessages[self.currentPinArrayIndex].showMessage];
        }else {
            self.pinMenueBar.messageLabel.text = [NSString stringWithFormat:@"#%@%@",[NSString stringWithFormat:@"%ld", (long)(self.currentPinArrayIndex + 1)], @" Image"];
        }
        __block BOOL isExist = NO;
        __block int index = 0;
        [self.messageItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:self.pinMessages[self.currentPinArrayIndex].messageID]) {
                index = idx;
                *stop = YES;
                isExist = YES;
            }
        }];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (void)setLastPinMessage {
    self.currentPinArrayIndex = 0;
    self.pinMessages = [self getPinMessage:self.config.chatID];
    if(self.pinMessages.count > 0) {
        if([self.pinMessages[0].messageType isEqualToString:TextMessageType]) {
            self.pinMenueBar.messageLabel.text = [NSString stringWithFormat:@"%@%@",@"#1 ",self.pinMessages[self.currentPinArrayIndex].showMessage];
        }else {
            self.pinMenueBar.messageLabel.text = @"#1 Image";
        }
    }else {
        self.pinMenueBar.hidden = YES;
        [self updateFrame];
    }
}

/// 撤回消息
/// @param withdrawModel withdrawModel description
-(void)withdrawMessageWithChatModel:(ChatModel*)withdrawModel{
    WithdrawMessageInfo*info=[[WithdrawMessageInfo alloc]init];
    info.content=withdrawModel.messageID;
    ChatModel*model=[ChatUtil creatChatMessageModelWithChatId:self.config.chatID chatType:self.config.chatType authorityType:self.config.authorityType circleUserId:self.config.circleUserId];
    model.messageType=WithdrawMessageType;
    model.messageContent=[info mj_JSONString];
    //先发送撤回的消息通知对方
    [[WebSocketManager sharedManager]sendMessageWithChatModel:model];
    [[WCDBManager sharedManager]updateMessageTypeWithMessageId:withdrawModel.messageID];
    //把原来的消息格式跟新为 @”Chat_withdraw“+元消息类型 这个是保存在本地的
    withdrawModel.messageType=[NSString stringWithFormat:@"%@+%@",WithdrawMessageType,withdrawModel.messageType];
    [[WCDBManager sharedManager]saveChatListModelWithChatModel:withdrawModel];
    NSInteger index=[self.messageItems indexOfObject:withdrawModel];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 回复
-(void)replayMessageWithModel:(ChatModel*)model{
    self.replyModel=model;
    self.replyView.hidden=NO;
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.chatFunctionView.mas_top).offset(-0.1);
    }];
    self.isreplyActive = YES;
    [self updateFrame];
    NSString*replyText,*userId;
    NSString*msgType=model.messageType;
    if (model.isOutGoing) {
        userId=[UserInfoManager sharedManager].userId;
    }else{
        userId=model.messageFrom;
    }
    if ([msgType isEqualToString:TextMessageType]||[msgType isEqualToString:AIMessageType]||[msgType isEqualToString:AIMessageQuestionType]) {
        TextMessageInfo *textInfo = [TextMessageInfo mj_objectWithKeyValues:model.messageContent];
        replyText = textInfo.content;
    }else if([msgType isEqualToString:GamifyMessageType]){
        replyText = NSLocalizedString(@"GameTips",[ 图片 ]);
    }else if ([msgType isEqualToString:URLMessageType]) {
        TextMessageInfo *textInfo = [TextMessageInfo mj_objectWithKeyValues:model.messageContent];
        replyText = textInfo.content;
    }
    else if ([msgType isEqualToString:AtSingleMessageType]||[msgType isEqualToString:AtAllMessageType]){
        AtSingleMessageInfo*info=[AtSingleMessageInfo mj_objectWithKeyValues:model.messageContent];
        replyText=info.content;
    }else if ([msgType isEqualToString:ImageMessageType]){
        replyText=NSLocalizedString(@"ImageTips",[ 图片 ]);
    }else if ([msgType isEqualToString:LocationMessageType]){
        replyText=NSLocalizedString(@"LocationTips",[ 位置 ]);
    }else if ([msgType isEqualToString:FileMessageType]){
        replyText=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"FileTips",[ 文件 ]),model.showFileName];
    }else if ([msgType isEqualToString:VideoMessageType]){
        replyText=NSLocalizedString(@"VideoTips",[ 视频 ]);
    }else if ([msgType isEqualToString:UserCardMessageType]){
        replyText=NSLocalizedString(@"ContactCardTips",[ 名片 ]);;
    }else if ([msgType isEqualToString:kChatOtherShareType]){
        replyText=@"Commodity sharing".icanlocalized;
    }
    else if ([msgType isEqualToString:kChat_PostShare]){
        replyText=@"ChatViewController.replyText".icanlocalized;
    }else{
        return;
    }
    @weakify(self);
    [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userId successBlock:^(UserMessageInfo * _Nonnull info) {
        @strongify(self);
        self.replyView.replyTitleLabel.text = [NSString stringWithFormat:@"%@ %@", @"Replying to".icanlocalized, info.nickname];
        self.replyView.contentLabel.text=[NSString stringWithFormat:@"%@",replyText];
    }];
    
}
#pragma mark - 收藏

-(void)collectMessageWithChatModel:(ChatModel*)collectionModel{
    [ChatViewHandleTool collectMessageWithChatModel:collectionModel];
}
#pragma mark - ChatViewHandleToolDelegate
-(void)chatViewHandleToolTranspondChatModel:(ChatModel *)model{
    [self transpondWithSelectMessage:@[model]];
}
#pragma mark - 转发
-(void)transpondSuccess:(NSNotification*)notifica{
    NSDictionary * dict = notifica.object;
    ChatModel * toModel = [dict objectForKey:@"config"];
    NSArray * messageItems = [dict objectForKey:@"messages"];
    if ([toModel.chatID isEqualToString:self.config.chatID]&&[toModel.chatType isEqualToString:self.config.chatType]){
        [self.messageItems addObjectsFromArray:messageItems];
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollTableViewToBottom:YES needScroll:YES];
        });
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"has been sent", 已发送) inView:self.view];
    }
}
-(void)transpondWithSelectMessage:(NSArray<ChatModel*>*)forwardArray{
    TranspondTableViewController*vc=[[TranspondTableViewController alloc]init];
    vc.transpondType=TranspondType_ChatVc;
    vc.selectMessagegArray=[NSMutableArray arrayWithArray:forwardArray];
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - 删除某条消息
-(void)deleteMessageWithTableViewCell:(UITableViewCell*)cell{
    
    [self actionSheetFunction:cell];
    
}

-(void)actionSheetFunction : (UITableViewCell*)cell{
    if([self.config.chatID isEqual:@"100"]) {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Delete on my device".icanlocalized style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [self deleteFriendMessageFromSingle:cell];
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        [alertController addAction:action1];
        [alertController addAction:action3];
        [alertController showWithAnimated:YES];
    }else {
        QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        }];
        QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"Delete on all device".icanlocalized  style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            [self deleteFriendMessageFromBoth:cell];
        }];
        QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Delete on my device".icanlocalized style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
            if([self.config.chatType isEqualToString:UserChat]){
                [self deleteFriendMessageFromSingle:cell];
            }else{
                [self deleteGroupFriendMessageFromSingle:cell];
            }
        }];
        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
        
        if ([self.config.chatType isEqualToString:GroupChat]) {
            if ([self.groupDetailInfo.role isEqualToString:@"0"]) {
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController addAction:action3];
                [alertController showWithAnimated:YES];
            }else{
                [alertController addAction:action1];
                [alertController addAction:action3];
                [alertController showWithAnimated:YES];
            }
        }else{
            if([[UserInfoManager sharedManager].vip intValue] < 5) {
                [alertController addAction:action1];
                [alertController addAction:action3];
                [alertController showWithAnimated:YES];
            }else {
                [alertController addAction:action1];
                [alertController addAction:action2];
                [alertController addAction:action3];
                [alertController showWithAnimated:YES];
            }
        }
    }
}



-(void)actionSheetFunctionMultiple {
    
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"Delete on all device".icanlocalized  style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
        [self deleteMultipleFromBoth];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Delete on my device".icanlocalized style:QMUIAlertActionStyleDestructive handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
        [self deleteMultipleFromSingle];
    }];
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    
    
    if ([self.config.chatType isEqualToString:GroupChat]) {
        if ([self.groupDetailInfo.role isEqualToString:@"0"]) {
            [alertController addAction:action1];
            [alertController addAction:action2];
            [alertController addAction:action3];
            [alertController showWithAnimated:YES];
        }else{
            [alertController addAction:action1];
            [alertController addAction:action3];
            [alertController showWithAnimated:YES];
        }
    }else{
        [alertController addAction:action1];
        [alertController addAction:action3];
        [alertController showWithAnimated:YES];
    }
    
}



-(void) deleteMultipleFromBoth{
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isSelect =%d ",1];
    NSArray* deleteMessageItems= [self.messageItems filteredArrayUsingPredicate:predicate];
    
    NSMutableArray*messageIds=[NSMutableArray array];
    for (ChatModel*model in deleteMessageItems) {
        [messageIds addObject:model.messageID];
        if ([self.currentPlayingVoiceModel.messageID isEqualToString: model.messageID]) {
            [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
        }
        [self.messageItems removeObject:model];
        [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
    }
    [self.tableView reloadData];
    [self deleteMoreMessageRequestWithMessageIds:messageIds deleteAll:YES];
    [self multipleShowViewAfterOperate];
}


-(void) deleteMultipleFromSingle{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isSelect =%d ",1];
    NSArray* deleteMessageItems= [self.messageItems filteredArrayUsingPredicate:predicate];
    
    NSMutableArray*messageIds=[NSMutableArray array];
    
    for (ChatModel*model in deleteMessageItems) {
        [messageIds addObject:model.messageID];
        if ([self.currentPlayingVoiceModel.messageID isEqualToString: model.messageID]) {
            [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
        }
        [self.messageItems removeObject:model];
        [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
    }
    [self.tableView reloadData];
    [self deleteMoreMessageRequestWithMessageIds:messageIds deleteAll:NO];
    [self multipleShowViewAfterOperate];
    
    //NSLog(deleteMessageItems)
}

-(void) deleteFriendMessageFromBoth: (UITableViewCell*)cellData{
    self.deleteIndexPath=[self.tableView indexPathForCell:cellData];
    ChatModel *model = self.messageItems[self.deleteIndexPath.row];
    [self.messageItems removeObject:model];
    [self.tableView deleteRowsAtIndexPaths:@[self.deleteIndexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    if ([self.currentPlayingVoiceModel.messageID isEqualToString: model.messageID]) {
        [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
    }
    [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
    [self deleteMoreMessageRequestWithMessageIds:@[model.messageID] deleteAll:YES];
    [self setLastPinMessage];
}


-(void)deleteFriendMessageFromSingle:(UITableViewCell*)cellData{
    
    self.deleteIndexPath=[self.tableView indexPathForCell:cellData];
    ChatModel *model = self.messageItems[self.deleteIndexPath.row];
    [self.messageItems removeObject:model];
    [self.tableView deleteRowsAtIndexPaths:@[self.deleteIndexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    if ([self.currentPlayingVoiceModel.messageID isEqualToString: model.messageID]) {
        [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
    }
    [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
    [self deleteMoreMessageRequestWithMessageIds:@[model.messageID] deleteAll:NO];
    [self setLastPinMessage];
}

-(void)deleteGroupFriendMessageFromSingle:(UITableViewCell*)cellData{
    self.deleteIndexPath = [self.tableView indexPathForCell:cellData];
    ChatModel *model = self.messageItems[self.deleteIndexPath.row];
    [self.messageItems removeObject:model];
    [self.tableView deleteRowsAtIndexPaths:@[self.deleteIndexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    if ([self.currentPlayingVoiceModel.messageID isEqualToString: model.messageID]) {
        [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
    }
    [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
    [self setLastPinMessage];
}


/**
 长按头像实现@的功能
 @param cell cell description
 */
- (void)longPressIconViewWithOtherCell:(UITableViewCell *)cell{
    if ([self.config.chatType isEqualToString:GroupChat]) {
        //如果用户在群里 并且该群并没有被禁言
        if (self.groupDetailInfo.isInGroup&&!self.groupDetailInfo.allShutUp) {
            NSIndexPath*indexPath=[self.tableView indexPathForCell:cell];
            ChatModel*model=[self.messageItems objectAtIndex:indexPath.row];
            if (!model.isOutGoing&&[self.config.chatType isEqualToString:GroupChat]) {
                NSString *message = self.chatFunctionView.messageTextView.text;
                self.chatFunctionView.messageTextView.text = [NSString stringWithFormat:@"%@@", message];
                @weakify(self);
                [[WCDBManager sharedManager]fetchGroupMemberInfoWihtGroupId:self.config.chatID userId:model.messageFrom successBlock:^(GroupMemberInfo * _Nonnull memberInfo) {
                    @strongify(self);
                    [self.chatFunctionView dealWithAtUserMessageWithShowName:![NSString isEmptyString:memberInfo.groupRemark]?memberInfo.groupRemark:memberInfo.nickname userId:memberInfo.userId longPress:YES];
                }];
            }
        }
        
    }
    
}
#pragma mark - DZAudioPlayerManagerDelegate
-(void)dzAudioPlayerStateDidChanged:(XMNVoiceMessageState)audioPlayerState forIndex:(NSUInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    switch (audioPlayerState) {
        case XMNVoiceMessageStatePlaying:{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (self.currentPlayingVoiceModel.isOutGoing) {
                [(ChatRightVoiceTableViewCell *)cell setVoiceMessageState:audioPlayerState];
            }else{
                [(ChatLeftVoiceTableViewCell *)cell setVoiceMessageState:audioPlayerState];
            }
        }
            break;
        case XMNVoiceMessageStateEnd:{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (self.currentPlayingVoiceModel.isOutGoing) {
                [(ChatRightVoiceTableViewCell *)cell setVoiceMessageState:audioPlayerState];
            }else{
                [(ChatLeftVoiceTableViewCell *)cell setVoiceMessageState:audioPlayerState];
            }
            //如果当前播放的是自己发送的 那么不自动播放
            if (!self.currentPlayingVoiceModel.isOutGoing) {
                //创建谓语查询是VoiceMessageType 并且是收到的
                NSPredicate*predicate= [NSPredicate predicateWithFormat:@"messageType CONTAINS[c] %@ && isOutGoing == %d",VoiceMessageType,0];
                //移除当前播放的语音之前未读的语音
                NSArray*lastAllItems=[self.messageItems subarrayWithRange:NSMakeRange(indexPath.row+1, self.messageItems.count-indexPath.row-1)];
                NSArray*receiveVoiceItems= [lastAllItems filteredArrayUsingPredicate:predicate];
                if (receiveVoiceItems.count>0) {
                    ChatModel*nextModel=receiveVoiceItems.firstObject;
                    if (!nextModel.voiceHasRead) {
                        //创建谓语查询是VoiceMessageType 并且是收到的
                        NSPredicate*noReadPredicate= [NSPredicate predicateWithFormat:@"messageType CONTAINS[c] %@ && voiceHasRead == %d",VoiceMessageType,0];
                        NSArray*receiveNoReadVoiceItems= [lastAllItems filteredArrayUsingPredicate:noReadPredicate];
                        if (receiveNoReadVoiceItems.count>0) {
                            self.currentPlayingVoiceModel=receiveNoReadVoiceItems.firstObject;
                            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[self.messageItems indexOfObject:self.currentPlayingVoiceModel] inSection:0];
                            if (!self.currentPlayingVoiceModel.isOutGoing) {
                                if (!self.currentPlayingVoiceModel.voiceHasRead) {
                                    self.currentPlayingVoiceModel.voiceHasRead = YES;
                                    [[WCDBManager sharedManager]updateVoiceMessageHasReadFromMessageId:self.currentPlayingVoiceModel.messageID];
                                }
                            }
                            [[AudioPlayerManager shareDZAudioPlayerManager]playAudioWithURLString:self.currentPlayingVoiceModel.isOutGoing?self.currentPlayingVoiceModel.fileCacheName:self.currentPlayingVoiceModel.fileServiceUrl atIndex:newIndexPath.row isSender:self.currentPlayingVoiceModel.isOutGoing];
                        }
                        
                    }
                }else{
                    
                    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
                }
            }else{
                [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
            }
            
            
        }
            break;
        case XMNVoiceMessageStateCancel:{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (self.currentPlayingVoiceModel.isOutGoing) {
                [(ChatRightVoiceTableViewCell *)cell setVoiceMessageState:audioPlayerState];
            }else{
                [(ChatLeftVoiceTableViewCell *)cell setVoiceMessageState:audioPlayerState];
            }
            [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        }
            break;
        default:{
        }
            break;
    }
    
    
}





#pragma mark - ChatFunctionViewDelegate
-(void)presentToAtUser{
    if ([self.config.chatType isEqualToString:GroupChat]) {
        SelectAtUserTableViewController *selectUserVC = [SelectAtUserTableViewController new];
        selectUserVC.groupId=self.config.chatID;
        selectUserVC.isNeedAtAll = YES;
        selectUserVC.atSingleBlcok = ^(GroupMemberInfo *groupMemberInfo) {
            [self.chatFunctionView dealWithAtUserMessageWithShowName:groupMemberInfo.groupRemark?:groupMemberInfo.nickname userId:groupMemberInfo.userId longPress:NO];
            
        };
        selectUserVC.atSingleBlcokAll= ^(NSArray<GroupMemberInfo*>* groupMemberInfo) {
            [self.chatFunctionView dealWithAtUserMessageWithShowNameAll:@"All" userId:@"All" longPress:NO usersDatas:groupMemberInfo];
            
        };
        QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:selectUserVC];
        nav.modalPresentationStyle=UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
    
}
-(void)clickSendMessageWithText:(NSString *)text{
    if (self.isTranslationEnabled == YES) {
        if([self.config.chatID isEqual:@"100"]) {
            IcanAIRequest *request = [IcanAIRequest request];
            request.message  = self.translatorViewMenue.translatedTextLabel.text;
            request.parameters = [request mj_JSONString];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                NSLog(@"AI_Request SUCCESS");
                [self sendTextMessage:self.translatorViewMenue.translatedTextLabel.text];
                    [self.chatFunctionView disableSendBtn];
                [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(updateSendButton) userInfo:nil repeats:NO];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                NSLog(@"AI_Request FAILURE");
            }];
        }else {
            if([NSString isEmptyString:self.translatorViewMenue.translatedTextLabel.text]) {
                [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Cannot send a blank message", 不能发送空白消息)inView:self.view];
            }else if (self.translatorViewMenue.translatedTextLabel.text.getLenth>5000) {
                [QMUITipsTool showErrorWihtMessage:@"Messagetoolong".icanlocalized inView:self.view];
            }else {
                if(![self.translatorViewMenue.translatedTextLabel.text isEqualToString:@"Translating...".icanlocalized]){
                    [self sendTextMessage:self.translatorViewMenue.translatedTextLabel.text];
                }
            }
        }
    }else {
        if([self.config.chatID isEqual:@"100"]) {
            IcanAIRequest *request = [IcanAIRequest request];
            request.message  = text;
            request.parameters = [request mj_JSONString];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
                NSLog(@"AI_Request SUCCESS");
                [self sendTextMessage:text];
                [self.chatFunctionView disableSendBtn];
                [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(updateSendButton) userInfo:nil repeats:NO];
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
                NSLog(@"AI_Request FAILURE");
            }];
        }else {
            if([NSString isEmptyString:text]) {
                [QMUITipsTool showErrorWihtMessage:NSLocalizedString(@"Cannot send a blank message", 不能发送空白消息)inView:self.view];
            }else if (text.getLenth>5000) {
                [QMUITipsTool showErrorWihtMessage:@"Messagetoolong".icanlocalized inView:self.view];
            }else {
                [self sendTextMessage:text];
            }
        }
    }
}
- (void)updateSendButton {
    [self.chatFunctionView enableSendBtn];
}
#pragma mark - 更多按钮的事件
-(void)moreItemClickWithXMChatMoreItemType:(XMChatMoreItemType)xmChatMoreItemType{
    switch (xmChatMoreItemType) {
        case XMChatMoreItemCamera:{//拍照或小视频
            @weakify(self);
            [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
                [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
                    [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                        @strongify(self);
                        [self pushCustomCamera];
                    } notDetermined:^{
                        
                    } failure:^{
                        
                    }];
                    
                } failure:^{
                    
                }];
                
                
            } failure:^{
                
            }];
            
            
        }
            break;
        case XMChatMoreItemPicture:{
            [self pushHXPhotoManager];
            
        }
            break;
        case XMChatMoreItemDiceGame:{
            [self diceGame];
        }
            break;
        case XMChatMoreItemSendRedEnvelope:{
            [self presentHongbaoViewController];
        }
            break;
        case XMChatMoreItemVideo:
            [self startNIMWWithType:@"VIDEO"];
            break;
        case XMChatMoreItemTransfer:{
            [self presentTransFerViewController:NO];
        }
            break;
        case XMChatMoreItemUSDTransfer:{
            [self presentTransFerViewController:YES];
        }
            break;
        case XMChatMoreItemUserVcard:{
            [self presentUserCardViewController];
        }
            break;
        case XMChatMoreItemVoice:
            [self startNIMWWithType:@"VOICE"];
            break;
        case XMChatMoreItemPaoFile:
            [self presentXMChatMoreItemFile];
            break;
        case XMChatMoreItemLocation:{
            [PrivacyPermissionsTool judgeLocationAuthorizationSuccess:^{
                [self presentLocationController];
            } failure:^{
                
                
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark -- 跳转到发红包页面
-(void)presentHongbaoViewController {
    if ([UserInfoManager sharedManager].tradePswdSet){
        [self configurationChatViewHandleTool];
        [[ChatViewHandleTool shareManager]pushSendHongbaoViewControllerWithGroupDetaiInfo:self.groupDetailInfo];
        [self.chatFunctionView hiddenAllView];
    }else{
        [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Please set a payment password first", 请先设置支付密码) target:self preferredStyle:(UIAlertControllerStyleAlert) actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                    EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
    }
    
}
#pragma mark -- 跳转到转账页面
-(void)presentTransFerViewController:(BOOL)isUsd  {
    if ([UserInfoManager sharedManager].openTransfer) {
        TransferViewController * vc = [TransferViewController new];
        vc.tranferType = TranfetFrom_chatView;
        vc.userMessageInfo=self.userMessageInfo;
        vc.isUsdTransfer = isUsd;
        vc.authorityType=self.config.authorityType;
        @weakify(self);
        vc.backAction = ^{
            @strongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.chatFunctionView moreViewAction];
            });
        };
        QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle =  UIModalPresentationFullScreen;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        [self.chatFunctionView hiddenAllView];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
    }
    
}

#pragma mark  跳转到选择好友页面
-(void)presentUserCardViewController {
    SelectUserCardViewController*vc=[[SelectUserCardViewController alloc]init];
    vc.config = self.config;
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    vc.selectUserChatBlock = ^(UserMessageInfo * _Nonnull userMessageInfo, NSString * _Nonnull remark) {
        [self sendUserCardMessageWithFriendModel:userMessageInfo];
        [self.chatFunctionView hiddenAllView];
    };
    @weakify(self);
    vc.backAction = ^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chatFunctionView moreViewAction];
        });
    };
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    [self.chatFunctionView hiddenAllView];
}

- (void)presentLocationController
{
    SelectMKMapLocationViewController *vc = [[SelectMKMapLocationViewController alloc] init];
    @weakify(self);
    vc.locationSelectBlock = ^(LocationMessageInfo * _Nonnull locationInfo) {
        @strongify(self);
        [self sendLocationMessageWithLocationMessageInfo:locationInfo];
        [self.chatFunctionView hiddenAllView];
    };
    vc.backAction = ^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chatFunctionView moreViewAction];
        });
    };
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle =  UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    [self.chatFunctionView hiddenAllView];
}


#pragma mark 发送文件
-(void)presentXMChatMoreItemFile{
    [self configurationChatViewHandleTool];
    [[ChatViewHandleTool shareManager]chatViewHandleUploadFile];
}
-(void)configurationChatViewHandleTool{
    [ChatViewHandleTool shareManager].tableView=self.tableView;
    [ChatViewHandleTool shareManager].messageItems=self.messageItems;
    [ChatViewHandleTool shareManager].config=self.config;
}
#pragma mark - lazy
-(ChatViewReplyView *)replyView{
    if (!_replyView) {
        _replyView=[[ChatViewReplyView alloc]initWithFrame:CGRectZero];
        _replyView.hidden=YES;
        @weakify(self);
        _replyView.cancelBlock = ^{
            @strongify(self);
            self.replyModel=nil;
        };
    }
    return _replyView;
}

- (FastMessageView *)fastMessageView {
    if (!_fastMessageView) {
        _fastMessageView = [[FastMessageView alloc]initWithFrame:CGRectZero];
        _fastMessageView.hidden = YES;
        @weakify(self);
        _fastMessageView.sendFastMessageBlock = ^(NSString * _Nonnull msg) {
            @strongify(self);
            [self sendTextMessage:msg];
        };
        
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.view.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){20.0, 20.0}].CGPath;
        
        _fastMessageView.layer.mask = maskLayer;
    }
    return _fastMessageView;
}

- (TranslatorViewMenue *)translatorViewMenue {
    if (!_translatorViewMenue) {
        _translatorViewMenue = [[TranslatorViewMenue alloc] initWithFrame:CGRectMake(0, self.defaultHeight, ScreenWidth, 50)];
        _translatorViewMenue.delegate = self;
        }
    return _translatorViewMenue;
}

- (PinMenueBar *)pinMenueBar {
    if (!_pinMenueBar) {
        _pinMenueBar = [[PinMenueBar alloc] initWithFrame:CGRectMake(0, self.defaultHeight, ScreenWidth, 40)];
        _pinMenueBar.delegate = self;
        }
    return _pinMenueBar;
}


- (void)setPinMenuBarHidden {
    [self setLastPinMessage];
    for(ChatModel *messageItem in self.messageItems) {
        if(messageItem.isPin) {
            messageItem.pinAudiance = nil;
            messageItem.isPin = NO;
        }
    }
    [self.tableView reloadData];
}

-(ChatFunctionView *)chatFunctionView{
    if (!_chatFunctionView) {
        _chatFunctionView=[[ChatFunctionView alloc]initWithFrame:CGRectMake(0, ScreenHeight-self.defaultHeight, ScreenWidth, self.defaultHeight)];
        _chatFunctionView.delegate=self;
        if ([self.config.authorityType isEqualToString:AuthorityType_friend]) {
            if ([self.config.chatType isEqualToString:GroupChat]) {
                _chatFunctionView.chatFunctionViewType = ChatFunctionViewType_group;
            }else if ([self.config.chatType isEqualToString:UserChat]){
                if([self.config.chatMode isEqualToString:ChatModeOtherChat]){
                    _chatFunctionView.chatFunctionViewType = ChatFunctionViewType_chatOther;
                }else{
                    _chatFunctionView.chatFunctionViewType = ChatFunctionViewType_userChat;
                }
            }
        }else if ([self.config.authorityType isEqualToString:AuthorityType_circle]){
            _chatFunctionView.chatFunctionViewType = ChatFunctionViewType_circle;
        }else if ([self.config.authorityType isEqualToString:AuthorityType_secret]){
            _chatFunctionView.chatFunctionViewType = ChatFunctionViewType_secret;
        }else if ([self.config.authorityType isEqualToString:AuthorityType_c2c]){
            _chatFunctionView.chatFunctionViewType = ChatFunctionViewType_c2c;
        }
        @weakify(self);
        _chatFunctionView.textViewDidChangeBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if (self.chatFunctionView.messageTextView.text.length > 0 && self.chatSetting.translateLanguageCode != nil && ![self.chatSetting.translateLanguageCode  isEqual: @"None"] && ![self.chatSetting.translateLanguageCode  isEqual: @""]){
                    if(self.chatFunctionView.messageTextView.text.length == 0){
                        self.translatorViewMenue.translatedTextLabel.text = @"";
                    }else{
                        [self translateTextString:self.chatSetting.translateLanguageCode textShouldConvert:text];
                    }
            }else{
                [self translateTextString:self.chatSetting.translateLanguageCode textShouldConvert:text];
            }
            [self savedraftMessage];
        };
    }
    return _chatFunctionView;
}

-(void)translateTextString:(NSString *) langCode textShouldConvert:(NSString *) textShouldConvert{
    [[NetworkRequestManager shareManager]translateGoogleTextString:langCode text:textShouldConvert success:^(NSString *translateText) {
        NSLog(@"%@",translateText);
        self.translatorViewMenue.translatedTextLabel.text = translateText;
        
        if (translateText.length > 0) {
            [self.chatFunctionView.fastButton setHidden: YES];
            [self.chatFunctionView.sendButton setHidden: NO];
        }else {
            [self.chatFunctionView.fastButton setHidden:NO];
            [self.chatFunctionView.sendButton setHidden: YES];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Fail");
    }];
}

#pragma mark - ChatFunctionViewDelegate
- (void)clickFastBtn:(id)functionView {
    
    if (self.fastMessageView.hidden == NO) {
        self.fastMessageView.hidden = YES;
    }else {
        self.fastMessageView.hidden = NO;
    }
}

- (void)frameHasChangeWithHeight:(CGFloat)height keyboardTime:(CGFloat)keyboardTime {
    self.pinMessages = [self getPinMessage:self.config.chatID];
    if ([self.config.chatType isEqualToString:GroupChat]||self.userMessageInfo.isFriend) {
        if (self.replyModel) {
            if(self.isTranslationEnabled){
                if(self.pinMessages.count > 0) {
                    self.pinMenueBar.hidden = NO;
                    self.pinMenueBar.messagesArray = self.pinMessages;
                    self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-self.translatorViewMenue.size.height-50);
                }else {
                    self.pinMenueBar.hidden = YES;
                    self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-self.translatorViewMenue.size.height);
                }
            }else{
                if(self.pinMessages.count > 0) {
                    self.pinMenueBar.hidden = NO;
                    self.pinMenueBar.messagesArray = self.pinMessages;
                    self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-80);
                }else {
                    self.pinMenueBar.hidden = YES;
                    self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-height);
                }
            }
        }else{
            if(self.isTranslationEnabled){
                if(self.pinMessages.count > 0) {
                    self.pinMenueBar.hidden = NO;
                    self.pinMenueBar.messagesArray = self.pinMessages;
                    self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-height-self.translatorViewMenue.size.height-50);
                }else {
                    self.pinMenueBar.hidden = YES;
                    self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-height-self.translatorViewMenue.size.height);
                }
            }else{
                if(self.pinMessages.count > 0) {
                    self.pinMenueBar.hidden = NO;
                    self.pinMenueBar.messagesArray = self.pinMessages;
                    self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-height-50);
                }else {
                    self.pinMenueBar.hidden = YES;
                    self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-height);
                }
            }
        }
    }else{
        if(self.pinMessages.count > 0) {
            self.pinMenueBar.hidden = NO;
            self.pinMenueBar.messagesArray = self.pinMessages;
            self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-height-90);
        }else {
            self.pinMenueBar.hidden = YES;
            self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-height-40);
        }
    }
    if(self.scrolledAfterNew == NO) {
        [self scrollTableViewToBottom:YES needScroll:YES];
    }
}

- (NSMutableArray *)inQ{
    if (!_inQ) {
        _inQ = [NSMutableArray array];
    }
    return _inQ;
}
- (NSMutableArray *)messageItems{
    if (!_messageItems) {
        _messageItems = [NSMutableArray array];
    }
    return _messageItems;
}
-(UnFriendHeaderTipsView *)unFriendHeaderTipsView{
    if (!_unFriendHeaderTipsView) {
        _unFriendHeaderTipsView = [[UnFriendHeaderTipsView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        @weakify(self);
        _unFriendHeaderTipsView.addFriendBlock = ^{
            @strongify(self);
            FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
            vc.userId=self.userMessageInfo.userId;
            vc.friendDetailType=FriendDetailType_push;
            [self.navigationController pushViewController:vc animated:YES];
            
        };
        
    }
    return _unFriendHeaderTipsView;
}
//多选删除消息
-(MultipleSelectionShowView *)multipleShowView{
    if (!_multipleShowView) {
        _multipleShowView=[[MultipleSelectionShowView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, TabBarHeight)];
        [self.view addSubview:_multipleShowView];
        _multipleShowView.authorityType=self.config.authorityType;
        @weakify(self);
        _multipleShowView.deleteButtonActionBlock = ^{
            @strongify(self);
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isSelect =%d ",1];
            NSArray* deleteMessageItems= [self.messageItems filteredArrayUsingPredicate:predicate];
            if (deleteMessageItems.count>0) {
                
                
                [self actionSheetFunctionMultiple];
                
                
            }else{
                [QMUITipsTool showOnlyTextWithMessage:@"Select the message you need to delete".icanlocalized inView:self.view];
            }
        };
        _multipleShowView.transpondButtonActionBlock = ^{
            @strongify(self);
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isSelect =%d ",1];
            NSArray* forwardMessageItems= [self.messageItems filteredArrayUsingPredicate:predicate];
            NSArray*messageTypes=[forwardMessageItems valueForKeyPath:@"messageType"];
            if ([messageTypes containsObject:TransFerMessageType]||[messageTypes containsObject:SendSingleRedPacketType]||[messageTypes containsObject:SendRoomRedPacketType]) {
                [QMUITipsTool showOnlyTextWithMessage:@"ChatViewController.transpond.unable.tip".icanlocalized inView:self.view];
                return;
            }
            [self transpondWithSelectMessage:forwardMessageItems];
            [self multipleShowViewAfterOperate];
        };
        _multipleShowView.collectButtonActionBlock = ^{
            @strongify(self);
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isSelect =%d ",1];
            NSArray* forwardMessageItems= [self.messageItems filteredArrayUsingPredicate:predicate];
            NSArray*messageTypes=[forwardMessageItems valueForKeyPath:@"messageType"];
            if ([messageTypes containsObject:TransFerMessageType]||[messageTypes containsObject:SendSingleRedPacketType]||[messageTypes containsObject:SendRoomRedPacketType]) {
                [QMUITipsTool showOnlyTextWithMessage:@"ChatViewController.collect.unable.tip".icanlocalized inView:self.view];
                return;
            }
            [ChatViewHandleTool colletcMoreMessageWithItems:forwardMessageItems];
            [self multipleShowViewAfterOperate];
            
        };
    }
    return _multipleShowView;
}
//多选操作之后恢复界面
-(void)multipleShowViewAfterOperate{
    [self.chatViewNavBarView updateUiAfterClickCancelButton:self.config.authorityType groupUserInfo:self.groupDetailInfo];
    self.multipleSelection=NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.multipleShowView .frame=CGRectMake(0, ScreenHeight, ScreenWidth, self.defaultHeight);
    } completion:^(BOOL finished) {
        
    }];
    for (ChatModel*model in self.messageItems) {
        model.isSelect=NO;
    }
    self.multipleShowView.enable=NO;
    [self.tableView reloadData];
}
-(void)checkMutipleCanHandle{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isSelect =%d ",1];
    NSArray* forwardMessageItems= [self.messageItems filteredArrayUsingPredicate:predicate];
    self.multipleShowView.enable=forwardMessageItems.count>0;
    
}
-(ChatViewNavBarView *)chatViewNavBarView{
    if (!_chatViewNavBarView) {
        _chatViewNavBarView = [[NSBundle mainBundle]loadNibNamed:@"ChatViewNavBarView" owner:self options:nil].firstObject;
        _chatViewNavBarView.frame = CGRectMake(0, 0, ScreenWidth, NavBarHeight);
        @weakify(self);
        _chatViewNavBarView.authorityType = self.config.authorityType;
        _chatViewNavBarView.statusLabel.hidden = [self.config.chatType isEqualToString:GroupChat];
        _chatViewNavBarView.iconImageViewTapBlock = ^{
            @strongify(self);
            //只有好友的聊天才能点击进去聊天详情页
            if ([self.config.authorityType isEqualToString:AuthorityType_friend]) {
                [self moreButtonAction];
            }else if([self.config.authorityType isEqualToString:AuthorityType_circle]){
                if (self.config.circleUserId) {
                    //如果对方已经注销或者对方不喜欢我都不能点击看用户详情
                    if (!self.circleUserInfo.deleted&&!self.circleDislikeMeInfo.dislikeMe) {
                        CircleUserDetailViewController*vc=[[CircleUserDetailViewController alloc]init];
                        vc.userId=self.config.circleUserId;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }
        };
        _chatViewNavBarView.chatViewNavBarViewButtonBlock = ^(NSInteger tag) {
            @strongify(self);
            switch (tag) {
                case 0:{
                    self.chatFunctionView.leftBgView.hidden=YES;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                case 1:{
                    //语音通话
                    [self startNIMWWithType:@"VOICE"];
                }
                    break;
                case 2:{
                    //视频通话
                    [self startNIMWWithType:@"VIDEO"];
                }
                    break;
                case 3:
                    [self moreButtonAction];
                    break;
                case 4:{//多选的情况下点击了取消按钮
                    [self.chatViewNavBarView updateUiAfterClickCancelButton:self.config.authorityType groupUserInfo:self.groupDetailInfo];
                    self.multipleSelection=NO;
                    [UIView animateWithDuration:0.25 animations:^{
                        self.multipleShowView .frame=CGRectMake(0, ScreenHeight, ScreenWidth, self.defaultHeight);
                    } completion:^(BOOL finished) {
                        
                    }];
                    for (ChatModel*model in self.messageItems) {
                        model.isSelect=NO;
                    }
                    [self.tableView reloadData];
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _chatViewNavBarView;
}
-(ChatViewConnectTipsView *)connectTipsView{
    if (!_connectTipsView) {
        _connectTipsView=[[ChatViewConnectTipsView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        _connectTipsView.status=[WebSocketManager sharedManager].connectStatus;
    }
    return _connectTipsView;
}
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.type = HXConfigurationTypeWXMoment;
        _manager.configuration.openCamera = NO;
        _manager.configuration.photoMaxNum = 9;
        _manager.configuration.videoMaxNum = 1;
        _manager.configuration.maxNum = 9;
        _manager.configuration.lookLivePhoto = NO;
        //是否允许图片和视频一起获取
        _manager.configuration.selectTogether = NO;
        _manager.configuration.lookLivePhoto = NO;
        _manager.configuration.videoCanEdit=NO;
        _manager.configuration.videoMaximumSelectDuration=60*15;
        
    }
    return _manager;
}
-(GoTopActionView *)actionView{
    if (!_actionView) {
        _actionView = [[NSBundle mainBundle]loadNibNamed:@"GoTopActionView" owner:self options:nil].firstObject;
        _actionView.hidden = YES;
        [self.view addSubview:_actionView];
        [_actionView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.pinMessages = [self getPinMessage:self.config.chatID];
            if(self.pinMessages.count > 0) {
                make.top.equalTo(@(NavBarHeight+70));
            }else {
                make.top.equalTo(@(NavBarHeight+20));
            }
            make.right.equalTo(@0);
            make.height.equalTo(@40);
            make.width.equalTo(@160);
        }];
        UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoTop)];
        [_actionView addGestureRecognizer:tap];
        
    }
    return _actionView;
}
-(void)gotoTop{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.actionView removeFromSuperview];
    self.scrolledAfterNew = YES;
}
-(void)diceGame{
    int randomNum = arc4random_uniform(7);
    if (!(randomNum == 0)) {
        NSString *gamifyRandom = [NSString stringWithFormat:@"Gamify_DICE_%d",randomNum];
        self.dicePresed = true;
        [self sendTextMessage:gamifyRandom];
    }
}
-(void)gotoBottom{
    NSLog(@"AAAAAA: %ld", (long)self.inQ.count);
    for (ChatModel *cmodel in self.inQ){
        [self.messageItems addObject:cmodel];
        //        NSLog(@"ABC: %@", cmodel.message);
        //        NSLog(@"ABC: %ld", (long)cmodel);
    }
    //    [self.messageItems addObject:_newmessageModel];
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollTableViewToBottom:YES needScroll:YES];
    });
    //    [self scrollTableViewToBottom:YES needScroll:YES];
    [self.bottomActionView removeFromSuperview];
    self.goBottomBtnStatus = 1;
    [self.inQ removeAllObjects];
}

-(void)callIcon{
    _bottomActionView = [[NSBundle mainBundle]loadNibNamed:@"GoBottomActionView" owner:self options:nil].firstObject;
    self.bottomActionView.hidden = NO;
    [self.view addSubview:_bottomActionView];
    [_bottomActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@100);
        make.height.equalTo(@40);
        make.width.equalTo(@160);
        make.top.equalTo(@(NavBarHeight+580));
    }];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoBottom)];
    [_bottomActionView addGestureRecognizer:tap];
    
    self.goBottomBtnTapCount = self.goBottomBtnTapCount + 1;
}


-(void)startNIMWWithType:(NSString*)type{
    [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
    if ([type isEqualToString:@"VOICE"]) {
        [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
            [self nimCallVCWithType:type];
        } notDetermined:^{
            [self nimCallVCWithType:type];
        } failure:^{
            
        }];
    }else{
        [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
            [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self nimCallVCWithType:type];
                });
            } notDetermined:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self nimCallVCWithType:type];
                });
            } failure:^{
                
            }];
            
        } failure:^{
            
        }];
    }
}
-(void)nimCallVCWithType:(NSString*)type{
    NSString*avtar;
    NSString*nickname;
    if ([self.config.authorityType isEqualToString:AuthorityType_friend]) {
        UserMessageInfo*info=[[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:self.config.chatID];
        nickname=info.remarkName?:info.nickname;
        avtar=info.headImgUrl;
    }else{
        CircleUserInfo*info=  [[WCDBManager sharedManager]fetchCircleUserInfoWithCircleUserId:self.config.circleUserId];
        nickname=info.nickname;
        avtar=info.avatar;
    }
    NSString*imAccid;
#if DEBUG
    imAccid = [NSString stringWithFormat:@"t_%@",self.config.chatID];
    
#else
    imAccid = [NSString stringWithFormat:@"p_%@",self.config.chatID];
    
#endif
    NeCallBaseViewController *callVC;
    if([CHANNELTYPE isEqualToString:ICANTYPETARGET]){
        callVC = [[NeCallBaseViewController alloc] initWithOtherMember:imAccid isCalled:NO type:[type isEqualToString:@"VOICE"]?NERtcCallTypeAudio:NERtcCallTypeVideo uuid:[NSUUID UUID]];
    }else{
        callVC = [[NeCallBaseViewController alloc] initWithOtherMember:imAccid isCalled:NO type:[type isEqualToString:@"VOICE"]?NERtcCallTypeAudio:NERtcCallTypeVideo uuid:nil];
    }
    callVC.modalPresentationStyle = UIModalPresentationFullScreen;
    //用来判断哪种聊天
    [NERtcCallKit sharedInstance].authorityType=self.config.authorityType;
    [NERtcCallKit sharedInstance].circleUserId=self.config.circleUserId;
    callVC.nickname=nickname;
    callVC.avtar=avtar;
    [self.navigationController presentViewController:callVC animated:YES completion:nil];
}
-(void)moreButtonAction{
    if ([self.config.authorityType isEqualToString:AuthorityType_secret]) {
        [UIAlertController alertControllerWithTitle:@"Immediately delete both party chat records".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
                request.userId=self.config.chatID;
                request.type=@"UserAll";
                request.deleteAll=true;
                request.authorityType=AuthorityType_secret;
                request.parameters=[request mj_JSONString];
                [[WCDBManager sharedManager]deleteAllChatModelWith:self.config];
                [self.messageItems removeAllObjects];
                [self.tableView reloadData];
                [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
                [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Clean up",清理完成) inView:self.view];
                } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                    
                }];
            }
        }];
    }else{
        if ([self.config.chatType isEqualToString: GroupChat]) {
            if (self.groupDetailInfo.isInGroup) {
                GroupDetailViewController * vc = [[GroupDetailViewController alloc]init];
                vc.config = self.config;
                @weakify(self);
                vc.deleteSuccessBlock = ^{
                    @strongify(self);
                    [self.messageItems removeAllObjects];
                    [self.tableView reloadData];
                };
                vc.selectDestorytimeBlock = ^(ChatModel * _Nonnull model) {
                    @strongify(self);
                    [self.messageItems addObject:model];
                    [self.tableView reloadData];
                };
                vc.clickIsShowNicknameBlock = ^(BOOL isOn) {
                    @strongify(self);
                    if (self.chatSetting) {
                        self.chatSetting.isShowNickName=isOn;
                    }else{
                        self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:self.config];
                    }
                    
                    [self.tableView reloadData];
                };
                vc.clickScreenNoticeBlock = ^(ChatModel * _Nonnull model) {
                    @strongify(self);
                    [self.messageItems addObject:model];
                    [self.tableView reloadData];
                };
                vc.atAllMemberBlock = ^(ChatModel * _Nonnull model) {
                    @strongify(self);
                    [self.messageItems addObject:model];
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            if (!self.userMessageInfo.beBlock) {
                if ([self.config.chatID isEqual:@"100"]) {
                    ChatDetailViewController *vc = [ChatDetailViewController new];
                    vc.typeAi = @"yes";
                    vc.userId = self.config.chatID;
                    vc.authorityType = self.config.authorityType;
                    if ([self.config.chatMode isEqualToString:ChatModeOtherChat]) {
                        vc.chatMode = @"Seller";
                    }
                    @weakify(self);
                    vc.deleteMessageBlock = ^{
                        @strongify(self);
                        [self.messageItems removeAllObjects];
                        [self.tableView reloadData];
                    };
                    vc.selectDestorytimeBlock = ^(ChatModel * _Nonnull model) {
                        @strongify(self);
                        [self.messageItems addObject:model];
                        [self.tableView reloadData];
                    };
                    vc.clickScreenNoticeBlock = ^(ChatModel * _Nonnull model) {
                        @strongify(self);
                        [self.messageItems addObject:model];
                        [self.tableView reloadData];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    ChatDetailViewController *vc = [ChatDetailViewController new];
                    vc.userId = self.config.chatID;
                    vc.authorityType = self.config.authorityType;
                    if ([self.config.chatMode isEqualToString:ChatModeOtherChat]) {
                        vc.chatMode = @"Seller";
                    }
                    @weakify(self);
                    vc.deleteMessageBlock = ^{
                        @strongify(self);
                        [self.messageItems removeAllObjects];
                        [self.tableView reloadData];
                    };
                    vc.selectDestorytimeBlock = ^(ChatModel * _Nonnull model) {
                        @strongify(self);
                        [self.messageItems addObject:model];
                        [self.tableView reloadData];
                    };
                    vc.clickScreenNoticeBlock = ^(ChatModel * _Nonnull model) {
                        @strongify(self);
                        [self.messageItems addObject:model];
                        [self.tableView reloadData];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}
#pragma mark 发送名片消息
-(void)sendUserCardMessageWithFriendModel:(UserMessageInfo *)cardModel {
    ChatModel *model = [ChatUtil initUserCardModelWithConfig:self.config];
    UserCardMessageInfo*cardInfo=[[UserCardMessageInfo alloc]init];
    cardInfo.nickname=cardModel.nickname;
    cardInfo.username=[NSString stringWithFormat:@"%@",cardModel.numberId];
    cardInfo.userId=[NSString stringWithFormat:@"%@",cardModel.userId];
    cardInfo.avatarUrl=cardModel.headImgUrl;
    model.messageContent=[cardInfo mj_JSONString];
    if ([self.config.chatMode isEqualToString:ChatModeOtherChat]){
        model.chatMode = ChatModeOtherChat;
    }
    [self sendAndSaveMessageWithChatModel:model];
}
#pragma mark  发送消息
- (void)sendTextMessage:(NSString *)text{
    if (self.messageSendTime) {
        NSInteger currentTime = [[NSDate date]timeIntervalSince1970]*1000;
        if ([text containsString:@"Gamify_DICE_"] || [self.config.chatID isEqual:@"100"] ) {
                   if ((currentTime - self.messageSendTime)<3000) {
                       [QMUITipsTool showOnlyTextWithMessage:@"SendingMessagesTooOften".icanlocalized inView:self.view];
                       return;
                   }else{
                       self.messageSendTime = currentTime;
                   }
               }else {
                   if ((currentTime - self.messageSendTime)<1000) {
                       [QMUITipsTool showOnlyTextWithMessage:@"SendingMessagesTooOften".icanlocalized inView:self.view];
                       return;
                   }else{
                       self.messageSendTime = currentTime;
                   }
               }
    }else{
        self.messageSendTime =  [[NSDate date]timeIntervalSince1970]*1000;
    }
    self.chatFunctionView.messageTextView.text = @"";
    ChatModel*textModel;
    NSMutableString *userStr = [NSMutableString string];
    if (self.chatFunctionView.atMemberArr.count!=0) {
        for (NSDictionary *infoDic in self.chatFunctionView.atMemberArr) {
            if ([infoDic isEqual:[self.chatFunctionView.atMemberArr firstObject]]) {
                [userStr appendFormat:@"%@", infoDic[@"userId"]];
            } else {
                [userStr appendFormat:@",%@", infoDic[@"userId"]];
            }
        }
        textModel=[ChatUtil creatAtSingleMessageInfoWithChatId:self.config.chatID text:text atIds:[userStr componentsSeparatedByString:@","]];
    }else{
        //创建文本消息
        textModel = [ChatUtil initTextMessage:text config:self.config];
    }
    if (self.replyModel) {
        NSString*originMessageContent=self.replyModel.messageContent;
        ReplyMessageInfo*replayInfo=[[ReplyMessageInfo alloc]init];
        replayInfo.originalMessageType=self.replyModel.messageType;
        if ([self.replyModel.messageType isEqualToString:AtSingleMessageType]||[self.replyModel.messageType isEqualToString:AtAllMessageType]) {
            AtSingleMessageInfo*atInfo=[AtSingleMessageInfo mj_objectWithKeyValues:originMessageContent];
            replayInfo.jsonMessage=[@{@"content":atInfo.content} mj_JSONString];
        }else{
            replayInfo.jsonMessage=originMessageContent;
        }
        
        if ([self.replyModel.chatType isEqualToString:GroupChat]) {
            replayInfo.groupId=self.replyModel.chatID;
        }
        if (self.replyModel.isOutGoing) {
            replayInfo.userId=[UserInfoManager sharedManager].userId;
        }else{
            replayInfo.userId=self.replyModel.messageFrom;
        }
        if ([self.replyModel.chatType isEqualToString:UserChat]) {
            
            NSData*data=[[replayInfo mj_JSONString]dataUsingEncoding:NSUTF8StringEncoding];
            NSString*contentStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            textModel.extra=contentStr;
        }else {
            textModel.extra=[replayInfo mj_JSONString];
        }
        if (self.chatFunctionView.atMemberArr.count!=0) {
            textModel.messageContent  = [@{@"content":text,@"atIds":[userStr componentsSeparatedByString:@","],@"extra":textModel.extra} mj_JSONString];
        }else{
            //创建文本消息
            textModel.messageContent  = [@{@"content":text,@"extra":textModel.extra} mj_JSONString];
        }
    }
    if ([self.config.chatMode isEqualToString:ChatModeOtherChat]){
        textModel.chatMode = ChatModeOtherChat;
    }
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [detector matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *emailMatches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    if (matches.count > 0 && emailMatches.count == 0){
        textModel.messageType = URLMessageType;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [matches[0] valueForKeyPath:@"_url"];
            WBGLinkPreview *urlPreview;
            urlPreview = [[WBGLinkPreview alloc] init];
            [urlPreview previewWithText:url.absoluteString
                              onSuccess:^(NSDictionary *result) {
                if([result[@"title"] isEqualToString:@"YouTube"]){
                    NSString *youtubeUrl = url.absoluteString;
                    NSArray *Array;
                    NSString *videoId;
                    if([result[@"url"] containsString:@"/www.youtube.com/"]){
                        Array = [youtubeUrl componentsSeparatedByString:@"="];
                        videoId = [Array objectAtIndex:1];
                    }else if ([result[@"url"] containsString:@"/youtu.be/"]){
                        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"youtu\\.be\\/(.+?)\\?" options:NSRegularExpressionCaseInsensitive error:nil];
                        NSTextCheckingResult *match = [regex firstMatchInString:youtubeUrl options:0 range:NSMakeRange(0, [youtubeUrl length])];
                        if (match) {
                            NSRange videoIDRange = [match rangeAtIndex:1];
                            videoId = [youtubeUrl substringWithRange:videoIDRange];
                        } else {
                            NSLog(@"Video ID not found");
                        }
                    }
                    NSString *urlString = [@"https://www.googleapis.com/youtube/v3/videos?key=AIzaSyAkeoMi-GD1Xaso9Z6l3wVVQcWO-m8tmqw&part=snippet&id=" stringByAppendingFormat:@"%@",videoId];
                    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
                    [urlRequest setHTTPMethod:@"GET"];
                    NSURLSession *session = [NSURLSession sharedSession];
                    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                        if(httpResponse.statusCode == 200){
                            NSError *parseError = nil;
                            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                            NSArray *responseItemsArray = [responseDictionary valueForKeyPath:@"items"];
                            if(responseItemsArray.count > 0){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    textModel.thumbnailTitleofTextUrl = [responseDictionary valueForKeyPath:@"items.snippet.localized.title"][0];
                                    textModel.thumbnailImageurlofTextUrl = [responseDictionary valueForKeyPath:@"items.snippet.thumbnails.medium.url"][0];
                                    [[WCDBManager sharedManager]updateMessageContentByMessageId:textModel];
                                    [self.tableView reloadData];
                                });
                            }
                        }
                    }];
                    [dataTask resume];
                }
                else{
                    if(![result[@"title"]  isEqual: @""] && ![result[@"image"] isEqual:@""] && ![result[@"image"] isEqual:@"undefined"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            textModel.thumbnailTitleofTextUrl = result[@"title"];
                            textModel.thumbnailImageurlofTextUrl = result[@"image"];
                            [[WCDBManager sharedManager]updateMessageContentByMessageId:textModel];
                            [self.tableView reloadData];
                        });
                    }
                }
            } onError:^(WBGPreviewError *error) {
            }];
        });
    }
    if([self.config.chatID isEqual:@"100"]) {
        textModel.sendState = 1;
    }
    if ([text containsString:@"Gamify_DICE_"] && [text length] == 13) {
        textModel.messageType = GamifyMessageType;
        textModel.gamificationStatus = 1;
    }
    [self sendAndSaveMessageWithChatModel:textModel];
    self.replyView.hidden = YES;
    self.isreplyActive = NO;
    [self updateReplayPanal];
    [self.chatFunctionView.atMemberArr removeAllObjects];
    self.replyModel = nil;
}
#pragma mark 发送定位消息
-(void)sendLocationMessageWithLocationMessageInfo:(LocationMessageInfo *)locationInfo{
    ChatModel *model = [ChatUtil initLocationWithChatModel:self.config];
    model.messageContent = [locationInfo mj_JSONString];
    [self sendAndSaveMessageWithChatModel:model];
}
-(void)sendVoiceWithChatAlbumModel:(ChatAlbumModel *)chatAlbumModel{
    ChatModel *audioModel = [ChatUtil initAudioMessage:chatAlbumModel config:self.config];
    audioModel.orignalImageData=chatAlbumModel.audioData;
    [self.messageItems addObject:audioModel];
    [self.tableView reloadData];
    [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:audioModel];
    [[WCDBManager sharedManager]insertChatModel:audioModel];
    [self scrollTableViewToBottom:YES needScroll:YES];
    if ([self.config.chatMode isEqualToString:ChatModeOtherChat]){
        audioModel.chatMode = ChatModeOtherChat;
    }
    [[[OSSWrapper alloc]init] uploadVoiceWithChatModel:audioModel uploadProgress:^(NSString * _Nonnull progress, ChatModel * _Nonnull chatModel) {
        
    } success:^(ChatModel * _Nonnull chatModel) {
        VoiceMessageInfo*info=[[VoiceMessageInfo alloc]init];
        info.content=chatModel.fileServiceUrl;
        info.duration=chatModel.mediaSeconds;
        audioModel.messageContent=[info mj_JSONString];
        [[WCDBManager sharedManager]insertChatModel:chatModel];
        [self sendMediaMessageWihtChatModel:audioModel];
    } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
        
    }];
}
-(void)handleHX:(HXPhotoModel*)model isOriginal:(BOOL)isOriginal{
    if (model.subType == HXPhotoModelMediaSubTypePhoto) {
        if (model.type == HXPhotoModelMediaTypePhoto) {
            CGSize size;
            if (isOriginal) {
                size = PHImageManagerMaximumSize;
            }else {
                size = CGSizeMake(model.imageSize.width * 0.5, model.imageSize.height * 0.5);
            }
            [self.view hx_showLoadingHUDText:@"Get the picture".icanlocalized];
            [model requestPreviewImageWithSize:size startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
                // 如果图片是在iCloud上的话会先走这个方法再去下载
            } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
                // iCloud的下载进度
            } success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                [self.view hx_handleLoading];
                ChatAlbumModel *imageModel = [[ChatAlbumModel alloc]init];
                imageModel.isOrignal = isOriginal;
                
                imageModel.name = [NSString getArc4random5:0];
                UIImage*newImage;
                if (model.photoEdit) {
                    newImage=model.photoEdit.editPreviewImage;
                }else{
                    newImage=image;
                }
                imageModel.picSize = newImage.size;
                NSData*originalData=[newImage returnCompressSize];
                imageModel.orignalImageData =originalData;
                imageModel.compressImageData= [newImage thumbImageToByte:1024*12];
                imageModel.isGif=NO;
                [self sendPictureMessage:@[imageModel] isGif:NO];
            } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                // 获取失败
                [self.view hx_handleLoading];
                [self.view hx_showImageHUDText:@"Get failed".icanlocalized];
            }];
        }
    }else if (model.subType == HXPhotoModelMediaSubTypeVideo) {
        // 当前为视频
        if (model.type == HXPhotoModelMediaTypeVideo) {
            [model requestAVAssetStartRequestICloud:nil progressHandler:nil success:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                // avAsset
                // 自己根据avAsset去导出视频
                [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
                NSString*videoName=[[NSString getArc4random5:1] stringByAppendingFormat:@".mp4"];
                if (![DZFileManager fileIsExistOfPath:MessageVideoCache([WebSocketManager sharedManager].currentChatID)]) {
                    [DZFileManager creatDirectoryWithPath:MessageVideoCache([WebSocketManager sharedManager].currentChatID)];
                }
                NSString*savePath=[MessageVideoCache([WebSocketManager sharedManager].currentChatID)stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",videoName]];
                
                [model requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
                    
                } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
                    
                } success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                    ChatModel*videoModel=[ChatUtil creatVideoChatModelWith:self.config saveUrl:[NSURL URLWithString:savePath] firstImage:image];
                    videoModel.localIdentifier=model.localIdentifier;
                    videoModel.mediaSeconds=model.videoDuration;
                    [[WCDBManager sharedManager]saveChatListModelWithChatModel:videoModel];
                    [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:videoModel];
                    [[WCDBManager sharedManager]insertChatModel:videoModel];
                    [self.messageItems addObject:videoModel];
                    [self.tableView reloadData];
                    [self scrollTableViewToBottom:YES needScroll:YES];
                    AVURLAsset *videoAsset = (AVURLAsset*)avAsset;
                    videoModel.videoAlbumUrl=videoAsset.URL.absoluteString;
                    NSData*data=[NSData dataWithContentsOfURL:videoAsset.URL];
                    NSString*hash=[NSString getHasNameData:data];
                    [self checkFileHasExistRequestWithHashId:hash successBlock:^(NSString *response) {
                        [QMUITips hideAllTips];
                        //如果服务器存在该视频
                        if (response.length>0) {
                            [self sendPhotoAlbumVideoWithChatModel:videoModel fileServiceUrl:response originalHash:hash exit:YES];
                        }else{
                            [self startCompressVideoWithAVURLAsset:videoAsset savePath:savePath chatModel:videoModel originalHash:hash];
                        }
                    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                        [self startCompressVideoWithAVURLAsset:videoAsset savePath:savePath chatModel:videoModel originalHash:hash];
                    }];
                } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                    
                }];
                
                
                
            } failed:nil];
        }
    }
    
    
}
-(void)pushCustomCamera{
    self.manager.configuration.saveSystemAblum = YES;
    [self.manager clearSelectedList];
    [self hx_presentCustomCameraViewControllerWithManager:self.manager done:^(HXPhotoModel *hxmodel, HXCustomCameraViewController *viewController) {
        [hxmodel getAssetURLWithSuccess:^(NSURL * _Nullable URL, HXPhotoModelMediaSubType mediaType, BOOL isNetwork, HXPhotoModel * _Nullable model) {
            [self handleHX:model isOriginal:YES];
        } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
            
        }];
    } cancel:^(HXCustomCameraViewController *viewController) {
        
    }];
}
-(void)pushHXPhotoManager{
    self.manager.configuration.saveSystemAblum = YES;
    [self.manager clearSelectedList];
    @weakify(self);
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        @strongify(self);
        for (HXPhotoModel*model in allList) {
            if (model.subType == HXPhotoModelMediaSubTypePhoto) {
                if (model.type == HXPhotoModelMediaTypePhoto) {
                    // 普通的照片，如果不可以查看和livePhoto的时候，这就也可能是GIF或者LivePhoto了，
                    // 如果你的项目不支持动图那就不要取NSData或URL，因为如果本质是动图的话还是会变成动图传上去
                    // 这样判断是不是GIF model.photoFormat == HXPhotoModelFormatGIF
                    // 如果 requestImageAfterFinishingSelection = YES 的话，直接取 model.previewPhoto 或者 model.thumbPhoto 在选择完成时候已经获取并且赋值了
                    // 获取image
                    // size 就是获取图片的质量大小，原图的话就是 PHImageManagerMaximumSize，其他质量可设置size来获取
                    CGSize size;
                    if (isOriginal) {
                        size = PHImageManagerMaximumSize;
                    }else {
                        size = CGSizeMake(model.imageSize.width * 0.5, model.imageSize.height * 0.5);
                    }
                    [self.view hx_showLoadingHUDText:@"Get the picture".icanlocalized];
                    [model requestPreviewImageWithSize:size startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
                        // 如果图片是在iCloud上的话会先走这个方法再去下载
                    } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
                        // iCloud的下载进度
                    } success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                        [self.view hx_handleLoading];
                        ChatAlbumModel *imageModel = [[ChatAlbumModel alloc]init];
                        imageModel.isOrignal = isOriginal;
                        
                        imageModel.name = [NSString getArc4random5:0];
                        UIImage*newImage;
                        if (model.photoEdit) {
                            newImage=model.photoEdit.editPreviewImage;
                        }else{
                            newImage=image;
                        }
                        imageModel.picSize = newImage.size;
                        NSData*originalData=[newImage returnCompressSize];
                        imageModel.orignalImageData =originalData;
                        imageModel.compressImageData= [newImage thumbImageToByte:1024*12];
                        imageModel.isGif=NO;
                        [self sendPictureMessage:@[imageModel] isGif:NO];
                    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                        // 获取失败
                        [self.view hx_handleLoading];
                        [self.view hx_showImageHUDText:@"Get failed".icanlocalized];
                    }];
                }else if (model.type == HXPhotoModelMediaTypePhotoGif) {
                    // 获取data
                    [self.view hx_showLoadingHUDText:@"Get the picture".icanlocalized];
                    [model requestImageDataStartRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
                        
                    } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
                        
                    } success:^(NSData * _Nullable imageData, UIImageOrientation orientation, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                        [self.view hx_handleLoading];
                        ChatAlbumModel *imageModel = [[ChatAlbumModel alloc]init];
                        imageModel.name = [NSString stringWithFormat:@"%@.gif",[NSString getArc4random5:0]];
                        imageModel.orignalImageData = imageData;
                        imageModel.picSize = model.imageSize;
                        imageModel.isGif=YES;
                        [self sendPictureMessage:@[imageModel] isGif:YES];
                    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                        [self.view hx_handleLoading];
                        [self.view hx_showImageHUDText:@"Get failed".icanlocalized];
                    }];
                }
                NSSLog(@"%ld个照片",photoList.count);
            }else if (model.subType == HXPhotoModelMediaSubTypeVideo) {
                // 当前为视频
                if (model.type == HXPhotoModelMediaTypeVideo) {
                    [model requestAVAssetStartRequestICloud:nil progressHandler:nil success:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                        // avAsset
                        // 自己根据avAsset去导出视频
                        [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
                        NSString*videoName=[[NSString getArc4random5:1] stringByAppendingFormat:@".mp4"];
                        if (![DZFileManager fileIsExistOfPath:MessageVideoCache([WebSocketManager sharedManager].currentChatID)]) {
                            [DZFileManager creatDirectoryWithPath:MessageVideoCache([WebSocketManager sharedManager].currentChatID)];
                        }
                        NSString*savePath=[MessageVideoCache([WebSocketManager sharedManager].currentChatID)stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",videoName]];
                        ChatModel*videoModel=[ChatUtil creatVideoChatModelWith:self.config saveUrl:[NSURL URLWithString:savePath] firstImage:model.previewPhoto];
                        //本地视频的标志
                        videoModel.localIdentifier=model.localIdentifier;
                        videoModel.mediaSeconds=model.videoDuration;
                        [[WCDBManager sharedManager]saveChatListModelWithChatModel:videoModel];
                        [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:videoModel];
                        [[WCDBManager sharedManager]insertChatModel:videoModel];
                        [self.messageItems addObject:videoModel];
                        [self.tableView reloadData];
                        if ([self.config.chatMode isEqualToString:ChatModeOtherChat]){
                            videoModel.chatMode = ChatModeOtherChat;
                        }
                        [self scrollTableViewToBottom:YES needScroll:YES];
                        AVURLAsset *videoAsset = (AVURLAsset*)avAsset;
                        videoModel.videoAlbumUrl=videoAsset.URL.absoluteString;
                        NSData*data=[NSData dataWithContentsOfURL:videoAsset.URL];
                        NSString*hash=[NSString getHasNameData:data];
                        [self checkFileHasExistRequestWithHashId:hash successBlock:^(NSString *response) {
                            [QMUITips hideAllTips];
                            //如果服务器存在该视频
                            if (response.length>0) {
                                [self sendPhotoAlbumVideoWithChatModel:videoModel fileServiceUrl:response originalHash:hash exit:YES];
                            }else{
                                [self startCompressVideoWithAVURLAsset:videoAsset savePath:savePath chatModel:videoModel originalHash:hash];
                            }
                        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                            [self startCompressVideoWithAVURLAsset:videoAsset savePath:savePath chatModel:videoModel originalHash:hash];
                        }];
                        
                        
                    } failed:nil];
                }
            }
            
        }
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSSLog(@"取消了");
    }];
}
#pragma mark - 压缩导出视频
-(void)startCompressVideoWithAVURLAsset:(AVURLAsset*)videoAsset savePath:(NSString*)savePath chatModel:(ChatModel*)videoModel originalHash:(NSString*)hash{
    //获取转码之后的视频
    NSNumber *size;
    [videoAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
    //如果大于5MB那么进行视频转码
    if (([size floatValue]/(1024.0*1024.0))>5.00) {
        [[UIImagePickerHelper sharedManager]startExportVideoWithVideoAsset:videoAsset preset:4 outputPath:savePath exportProgress:^(float progress) {
            videoModel.exportState=2;
            videoModel.exportProgress=progress;
            NSInteger index=[self.messageItems indexOfObject:videoModel];
            NSIndexPath*indexPath=[NSIndexPath indexPathForRow:index inSection:0];
            ChatRightVideoTableViewCell*cell=[self.tableView cellForRowAtIndexPath:indexPath];
            cell.videoModel=videoModel;
            
        } success:^(NSString * _Nonnull outputPath) {
            [QMUITips hideAllTips];
            videoModel.exportState=1;
            [self sendPhotoAlbumVideoWithChatModel:videoModel fileServiceUrl:nil originalHash:hash exit:NO];
        } failure:^(NSString * _Nonnull errorMessage, NSError * _Nullable error) {
            videoModel.exportState=0;
            [[WCDBManager sharedManager]insertChatModel:videoModel];
        }];
    }else{
        videoModel.showFileName=videoAsset.URL.absoluteString;
        [self sendPhotoAlbumVideoWithChatModel:videoModel fileServiceUrl:nil originalHash:hash exit:NO];
    }
}
-(void)sendPhotoAlbumVideoWithChatModel:(ChatModel*)model  fileServiceUrl:(NSString*)fileServiceUrl originalHash:(NSString*)originalHash exit:(BOOL)exit{
    if (exit) {//存在url
        OSSWrapper*wrapper=[[OSSWrapper alloc]init];
        [wrapper uploadImagesWithImage:[UIImage imageWithData:model.orignalImageData] successHandler:^(NSString * _Nonnull imageimageUrl) {
            model.imageUrl=imageimageUrl;
            model.uploadState=1;
            model.sendState=1;
            model.fileServiceUrl=fileServiceUrl;
            [self handleVideoAfterUploadSuccessWithChatModel:model];
            [self.tableView reloadData];
        } failureHandler:^(NSError * _Nonnull error, NSInteger statusCode) {
            
        }];
        
    }else{
        //先上传
        OSSWrapper*wrapper=[[OSSWrapper alloc]init];
        @weakify(self);
        [wrapper uploadVideoWithChatModel:model imageUploadProgress:^(ChatModel * _Nonnull model) {
            
        } imageUploadSuccess:^(ChatModel * _Nonnull chatModel) {
            if (chatModel.imageUrl&&chatModel.fileServiceUrl) {
                [self handleVideoAfterUploadSuccessWithChatModel:chatModel];
                NSData*data=[NSData dataWithContentsOfFile:model.showFileName];
                [self ossAddHashWihtHash:originalHash url:chatModel.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(data.length/1024)] path:model.thumbnails];
                NSString*hash=[NSString getHasNameData:data];
                [self ossAddHashWihtHash:hash url:chatModel.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(data.length/1024)] path:model.thumbnails];
                
            }
        } imagefailure:^(NSError * _Nonnull error, NSInteger statusCode) {
            
        } videoUploadProgress:^(ChatModel * _Nonnull model) {
            @strongify(self);
            NSInteger index=[self.messageItems indexOfObject:model];
            NSIndexPath*indexPath=[NSIndexPath indexPathForRow:index inSection:0];
            ChatRightVideoTableViewCell*cell=[self.tableView cellForRowAtIndexPath:indexPath];
            cell.videoModel=model;
        } videoUploadSuccess:^(ChatModel * _Nonnull chatModel) {
            if (chatModel.imageUrl&&chatModel.fileServiceUrl) {
                
                [self handleVideoAfterUploadSuccessWithChatModel:chatModel];
                NSData*data=[NSData dataWithContentsOfFile:model.showFileName];
                [self ossAddHashWihtHash:originalHash url:chatModel.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(data.length/1024)] path:model.thumbnails];
                NSString*hash=[NSString getHasNameData:data];
                [self ossAddHashWihtHash:hash url:chatModel.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(data.length/1024)] path:model.thumbnails];
                
            }
        } videofailure:^(NSError * _Nonnull error, NSInteger statusCode) {
            
        }];
    }
    
}
//通过自己拍摄发送的小视频处理
-(void)sendVideWithChatmodel:(ChatModel*)model{
    [[WCDBManager sharedManager]saveChatListModelWithChatModel:model ];
    [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:model];
    [[WCDBManager sharedManager]insertChatModel:model];
    [self.messageItems addObject:model];
    [self.tableView reloadData];
    [self scrollTableViewToBottom:YES needScroll:YES];
    //先上传
    OSSWrapper*wrapper=[[OSSWrapper alloc]init];
    @weakify(self);
    [wrapper uploadVideoWithChatModel:model imageUploadProgress:^(ChatModel * _Nonnull model) {
        
    } imageUploadSuccess:^(ChatModel * _Nonnull chatModel) {
        if (chatModel.imageUrl&&chatModel.fileServiceUrl) {
            [self handleVideoAfterUploadSuccessWithChatModel:chatModel];
        }
    } imagefailure:^(NSError * _Nonnull error, NSInteger statusCode) {
        
    } videoUploadProgress:^(ChatModel * _Nonnull model) {
        @strongify(self);
        NSInteger index=[self.messageItems indexOfObject:model];
        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        ChatRightVideoTableViewCell*cell=[self.tableView cellForRowAtIndexPath:indexPath];
        cell.videoModel=model;
    } videoUploadSuccess:^(ChatModel * _Nonnull chatModel) {
        if (chatModel.imageUrl&&chatModel.fileServiceUrl) {
            [self handleVideoAfterUploadSuccessWithChatModel:chatModel];
            NSData*data2= [NSData dataWithContentsOfURL:[NSURL URLWithString:model.showFileName]];
            NSString*hash=[NSString getHasNameData:data2];
            [self ossAddHashWihtHash:hash url:chatModel.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(data2.length/1024)] path:model.thumbnails];
            
            
        }
    } videofailure:^(NSError * _Nonnull error, NSInteger statusCode) {
        
    }];
}
-(void)handleVideoAfterUploadSuccessWithChatModel:(ChatModel*)chatModel{
    UIImage*coverImage=[UIImage imageWithData:chatModel.orignalImageData];
    VideoMessageInfo*info=[[VideoMessageInfo alloc]init];
    info.sightUrl=chatModel.fileServiceUrl;
    info.content=chatModel.imageUrl;
    info.name=[NSString stringWithFormat:@"%@",chatModel.fileCacheName];
    info.duration=chatModel.mediaSeconds;
    info.size=chatModel.totalUnitCount;
    info.width=coverImage.size.width;
    info.height=coverImage.size.height;
    chatModel.messageContent=[info mj_JSONString];
    [[WCDBManager sharedManager]insertChatModel:chatModel];
    [[WebSocketManager sharedManager]sendMessageWithChatModel:chatModel];
}
/**
 关于发送图片的计划 第一步 图片数据先插入数据库 图片缓存在本地
 图片按照顺序上传 上传成功之后更新本地数据库并且发送图片数据
 @return return value description
 */
#pragma mark  发送图片消息
- (void)sendPictureMessage:(NSArray<ChatAlbumModel *> *)picModels isGif:(BOOL)isGif{
    //消息基本信息配置
    self.needUploadImageItems = [ChatUtil initPicMessage:picModels config:self.config isGif:isGif];
    for (ChatModel*model in self.needUploadImageItems) {
        [[WCDBManager sharedManager]saveChatListModelWithChatModel:model];
        [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:model];
    }
    [[WCDBManager sharedManager]insertChatModels:self.needUploadImageItems];
    [self.messageItems addObjectsFromArray:self.needUploadImageItems];
    [self.tableView reloadData];
    [self scrollTableViewToBottom:YES needScroll:YES];
    for (ChatModel*model in self.needUploadImageItems) {
        if ([self.config.chatMode isEqualToString:ChatModeOtherChat]){
            model.chatMode = ChatModeOtherChat;
        }
        NSString*hashId=[NSString getHasNameData:model.orignalImageData];
        @weakify(self);
        [self checkFileHasExistRequestWithHashId:hashId successBlock:^(NSString *response) {
            if (response.length>0) {
                @strongify(self);
                model.fileServiceUrl=response;
                model.uploadProgress=@"100%";
                model.uploadState=1;
                model.sendState=1;
                model.imageUrl=response;
                UIImage*image=[UIImage imageWithData:model.orignalImageData];
                ImageMessageInfo*imageInfo=[[ImageMessageInfo alloc]init];
                imageInfo.imageUrl = model.imageUrl;
                imageInfo.height=image.size.height ;
                imageInfo.width=image.size.width;
                imageInfo.isFull=!model.isOrignal;
                model.messageContent=[imageInfo mj_JSONString];
                [self sendMediaMessageWihtChatModel:model];
                [self scrollTableViewToBottom:YES needScroll:YES];
                NSInteger index=[self.messageItems indexOfObject:model];
                NSIndexPath*indexPath=[NSIndexPath indexPathForRow:index inSection:0];
                ChatRightImgMsgTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.imageModel=model;
                [[WCDBManager sharedManager]insertChatModel:model];
            }else{
                [self uploadImageWihtModele:model hashId:hashId];
            }
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [self uploadImageWihtModele:model hashId:hashId];
        }];
        
    }
    
    
}

-(void)uploadImageWihtModele:(ChatModel*)model hashId:(NSString*)hashId{
    OSSWrapper*wrapper= [[OSSWrapper alloc] init];
    [wrapper uploadImageWithChatModel:model uploadProgress:^(NSString * _Nonnull, ChatModel * _Nonnull) {
        NSInteger index=[self.messageItems indexOfObject:model];
        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:index inSection:0];
        ChatRightImgMsgTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.imageModel=model;
        
    } success:^(ChatModel * _Nonnull chatModel) {
        [self ossAddHashWihtHash:hashId url:model.fileServiceUrl name:model.fileCacheName size:[NSString stringWithFormat:@"%d",(int)ceil(model.orignalImageData.length/1024)] path:model.thumbnails];
        [self sendMediaMessageWihtChatModel:model];
        [[WCDBManager sharedManager]insertChatModel:model];
        [self scrollTableViewToBottom:YES needScroll:YES];
    } failure:^(NSError * _Nonnull error, NSInteger statusCode) {
        
    }];
}
/// 插入聊天model在数组里面并且发送消息
/// @param chatModel chatModel description
-(void)sendAndSaveMessageWithChatModel:(ChatModel*)chatModel{
    if (chatModel) {
        if([chatModel.chatID isEqual:@"100"]) {
            [[WCDBManager sharedManager]cacheMessageWithChatModel:chatModel isNeedSend:NO];
        }else {
            [[WCDBManager sharedManager]cacheMessageWithChatModel:chatModel isNeedSend:YES];
        }
        [self.messageItems addObject:chatModel];
        [WebSocketManager sharedManager].delegate = self;
        [[WCDBManager sharedManager]resetChatListModelUnReadMessageCountWithChatModel:self.config];
        [self.tableView reloadData];
        [self scrollTableViewToBottom:YES needScroll:YES];
    }
}
/// 发送消息 主要是发送媒体类型的消息(由于媒体类型的消息都是先保存在数据库 再上传发送)
/// @param chatModel 消息model
-(void)sendMediaMessageWihtChatModel:(ChatModel*)chatModel{
    [[WebSocketManager sharedManager]sendMessageWithChatModel:chatModel];
    [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
    [WebSocketManager sharedManager].delegate = self;
}
#pragma mark WebSocketManagerDelegate----------------

/// 收到消息回执(消息发送成功之后服务器会返回一个回执)
/// @param receiptInfo receiptInfo description
-(void)webSocketManagerDidReceiveReceiptInfo:(ReceiptInfo *)receiptInfo{
    //TODO如果是多少秒内收不到回执 那么消息为发送失败
    if([receiptInfo.status isEqualToString:@"success"]) {
        [JudgeMessageTypeManager checkShoulPlaySendMessageSuccessVoice:receiptInfo messageItems:self.messageItems tableView:self.tableView];
    }
}

-(void)updateDidReceivePinMessageStatus:pinnedMsgId isPin:(BOOL)isPin audience:(nonnull NSString *)audience {
    __block BOOL isExist = NO;
    [self.messageItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.messageID isEqualToString:pinnedMsgId]) {
            obj.pinAudiance = audience;
            obj.isPin = isPin;
            *stop = YES;
            isExist = YES;
        }
    }];
    if(isExist) {
        self.pinMessages = [self getPinMessage:self.config.chatID];
        if(self.pinMessages.count > 0) {
            if([self.pinMessages[0].messageType isEqualToString:TextMessageType]) {
                self.pinMenueBar.messageLabel.text = [NSString stringWithFormat:@"%@%@",@"#1 ",self.pinMessages[0].showMessage];
            }else {
                self.pinMenueBar.messageLabel.text = @"#1 Image";
            }
        }
    }
    [self updateFrame];
    [self.tableView reloadData];
}

-(void)updateDidReceiveReation:reactedMessageId{
    __block BOOL isExist = NO;
    [self.messageItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.messageID isEqualToString:reactedMessageId]) {
            ChatModel *model = [[WCDBManager sharedManager] getChatModelByMessageId:reactedMessageId];
            obj.reactions = model.reactions;
            *stop = YES;
            isExist = YES;
        }
    }];
    [self.tableView reloadData];
}

- (void)updateFrame {
    [self updateReplayPanal];
    self.pinMessages = [self getPinMessage:self.config.chatID];
    if(self.userMessageInfo.isFriend) {
        [self.unFriendHeaderTipsView removeFromSuperview];
        if(self.pinMessages.count > 0) {
            self.pinMenueBar.hidden = NO;
            self.pinMenueBar.messagesArray = self.pinMessages;
            self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-50);
        }else {
            self.pinMenueBar.hidden = YES;
            self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight);
        }
    }else {
        if(self.pinMessages.count > 0) {
            self.pinMenueBar.hidden = NO;
            self.pinMenueBar.messagesArray = self.pinMessages;
            self.tableView.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight-50);
        }else {
            self.pinMenueBar.hidden = YES;
            self.tableView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-self.defaultHeight);
        }
    }
}

// 收到普通的消息
//@param chatModel chatModel description
-(void)webSocketManagerDidReceiveMessage:(ChatModel *)chatModel{
    if([chatModel.messageType isEqual:PinMessageType]) {
        NSData *data = [chatModel.messageContent dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *msgContent = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        BOOL isPin = NO;
        if([[msgContent objectForKey:@"action"] isEqualToString:@"Pin"]) {
            isPin = YES;
        }
        [self updateDidReceivePinMessageStatus:[msgContent objectForKey:@"pinnedMsgId"] isPin:isPin audience:[msgContent objectForKey:@"audience"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updatePinMessage" object:nil];
        return;
    }
    [self configurationChatViewHandleTool];
    if([chatModel.messageType isEqual:ReactionMessage]){
        ReactionMessageInfo *info = [ReactionMessageInfo mj_objectWithKeyValues:[NSString decodeUrlString:chatModel.messageContent]];
        [self updateDidReceiveReation:info.reactedMsgId];
        return;
    }
    if([chatModel.messageType isEqual:Notice_UserShutUp]) {
        if ([chatModel.messageContent isEqualToString:@"true"]) {
            [self.chatFunctionView disableAllFunctions];
        }else{
            [self.chatFunctionView enableAllFunctions];
            [ self.chatViewNavBarView showMoreItems];
        }
        return;
    }
    ///收到的消息发送人和当前聊天的人一样 并且authorityType和当前的一致，那么就保存在聊天列表中 别切刷新列表
    if([chatModel.messageType isEqual:AIMessageType]) {
        NSData *data = [chatModel.messageContent dataUsingEncoding:NSUTF8StringEncoding] ?: NSData.data;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *msg = [dic objectForKey:@"content"];
        chatModel.showMessage = msg;
        chatModel.chatID = @"100";
        [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:chatModel];
        [[WCDBManager sharedManager]insertChatModel:chatModel];
        [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
        [self.messageItems addObject:chatModel];
        [self scrollTableViewToBottom:YES needScroll:YES];
        [self.tableView reloadData];
        [self.chatFunctionView enableSendBtn];
    }
    if([chatModel.messageType isEqual:AIMessageQuestionType]) {
        NSData *data = [chatModel.messageContent dataUsingEncoding:NSUTF8StringEncoding] ?: NSData.data;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *msg = [dic objectForKey:@"content"];
        chatModel.showMessage = msg;
        chatModel.chatID = @"100";
        [[WCDBManager sharedManager]calculateChatModelWidthAndHeightWithChatModel:chatModel];
        [[WCDBManager sharedManager]insertChatModel:chatModel];
        [[WCDBManager sharedManager]saveChatListModelWithChatModel:chatModel];
        [self.messageItems addObject:chatModel];
//        [self scrollTableViewToBottom:YES needScroll:YES]; ---> comment for future devs
        [self.tableView reloadData];
        [self.chatFunctionView enableSendBtn];
    }
    if ([chatModel.chatID isEqualToString:self.config.chatID]&&[chatModel.authorityType isEqualToString:self.config.authorityType]) {
        __block BOOL isExist = NO;
        [self.messageItems enumerateObjectsUsingBlock:^(ChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.messageID isEqualToString:chatModel.messageID]) {//数组中已经存在该对象
                *stop = YES;
                isExist = YES;
            }
        }];
        if ([chatModel.messageType containsString:WithdrawMessageType]) {
            //当前正在撤回的model消息
            ChatModel*withdrawModel;
            //被撤回消息的原来的mesageType
            NSString*originMessageType;
            for (ChatModel*model in self.messageItems) {
                if ([model.messageID isEqualToString:chatModel.messageID]) {
                    withdrawModel=model;
                    originMessageType=model.messageType;
                    withdrawModel.messageType=chatModel.messageType;
                    withdrawModel.showMessage=chatModel.showMessage;
                    break;
                }
            }
            if ([originMessageType isEqualToString:ImageMessageType]) {
                [self.ybImageBrowerTool hiddenYBImageBrower];
            }else if ([originMessageType isEqualToString:VoiceMessageType]){
                if ([self.currentPlayingVoiceModel.messageID isEqualToString:withdrawModel.messageID]) {
                    [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
                }
            }else if ([originMessageType isEqualToString:VideoMessageType]){
                if ([self.currentPlayVideoModel.messageID isEqualToString:withdrawModel.messageID]) {
                    [[ChatViewHandleTool shareManager]hiddenPlayerView];
                }
            }
            NSInteger index=[self.messageItems indexOfObject:withdrawModel];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            if (!isExist) {
                [JudgeMessageTypeManager checkShouldSendHasReadMessageReceiptWhenReceiveMessage:chatModel];
                if ([chatModel.authorityType isEqualToString:self.config.authorityType]) {
                    self.newmessageModel = chatModel;
                    [self.inQ addObject:chatModel];
                    
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                    NSMutableArray *arr2 = [[NSMutableArray alloc]init];
                    NSString *scrollStatus = [[NSString alloc]init];
                    ChatModel *visibleMsgs;
                    for (NSIndexPath *indexVisible in self.tableView.indexPathsForVisibleRows) {
                        CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexVisible];
                        BOOL isVisible = CGRectContainsRect(self.tableView.bounds, cellRect);
                        if (isVisible) {
                            [arr addObject:indexVisible];
                            [arr1 addObject:[NSNumber numberWithInteger:indexVisible.row]];
                            visibleMsgs = [self.messageItems objectAtIndex:indexVisible.row];
                            [arr2 addObject:visibleMsgs.messageID];
                        }
                    }
                    
                    if(self.messageItems.count > 3) {
                        self.thirdMsg = self.messageItems[self.messageItems.count-4].messageID;
                    }
                    
                    if(self.messageItems.count > 3) {
                        for (NSString *idx in arr2) {
                            if (idx ==  self.thirdMsg) {
                                scrollStatus = @"jump";
                            }
                        }
                    }
                    
                    if ([scrollStatus isEqualToString:@"jump"]) {
                        //do the jump
                            if (![self.messageItems.lastObject.messageID isEqual:chatModel.messageID]) {
                                [self.messageItems addObject:chatModel];
                                [self.inQ removeAllObjects];
                            }
                        if ([chatModel.messageType containsString:SendRoomRedPacketType] || [chatModel.messageType containsString:TransFerMessageType] || [chatModel.messageType containsString:GamifyMessageType] || [chatModel.messageType containsString:ImageMessageType]) {
                                [self scrollTableViewToBottom:YES needScroll:YES];
                        }
                        NSLog(@"Jumppppppppppp");
                    }else {
                        //show the icon to go down
                        NSLog(@"My arrayAddedwith: %ld", (long)self.goBottomBtnStatus);
                        NSLog(@"My arrayAddedwith: %ld", (long)self.goBottomBtnTapCount);
                        if ((self.goBottomBtnStatus == 0 && self.goBottomBtnTapCount == 0) || (self.goBottomBtnStatus == 1)){
                            if ((arr2.count > 3) && (self.messageItems.count > 3)) {
                                [self callIcon];
                            }else {
                                    if (![self.messageItems.lastObject.messageID isEqual:chatModel.messageID]) {
                                        [self.messageItems addObject:chatModel];
                                        [self.inQ removeAllObjects];
                                    }
                            }
                            self.goBottomBtnStatus = 0;
                        }
                        NSLog(@"Go down buttonnnnnnn");
                    }
                }
            }
            [self.tableView reloadData];
        }
    }
    if(self.messageItems.count > 3) {
        self.thirdMsg = self.messageItems[self.messageItems.count-4].messageID;
    }
    
}
/// 收到对方发送的消息回执
-(void)webSocketDidReceiptBaseMessageInfo:(BaseMessageInfo *)baseMessageInfo{
    [self configurationChatViewHandleTool];
    [[ChatViewHandleTool shareManager]handleWebSocketDidReceiptMessageWithBaseMessageInfo:baseMessageInfo];
}
-(void)ossAddHashWihtHash:(NSString*)hash url:(NSString*)url name:(NSString*)name size:(NSString*)size path:(NSString*)path{
    [[ChatViewHandleTool shareManager]ossAddHashWihtHash:hash url:url name:name size:size path:path];
}
-(void)getRedPackeDetailRequestWithRedId:(NSString*)redId{
    RedPacketDetailRequest*request=[RedPacketDetailRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/redEnvelopes/%@/%@",[self.config.chatType isEqualToString:GroupChat]?@"g":@"s",redId];
    [QMUITipsTool showOnlyLodinginView:nil isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[RedPacketDetailInfo class] contentClass:[RedPacketDetailInfo class] success:^(RedPacketDetailInfo* response) {
        [QMUITips hideAllTips];
        if ([self.config.chatType isEqualToString:UserChat]) {//由于点击自己发送的单人红包的时候不需要显示开红包界面 所以在此需要判断一下开红包界面
            if (response.rejectTime&&self.currentTapChatModel.isOutGoing) {
                if (!self.currentTapChatModel.redPacketState) {
                    self.currentTapChatModel.redPacketState=KRedPacketExpired;
                    self.currentTapChatModel.showRedState=YES;
                    [[WCDBManager sharedManager]updateSingleRedPacketMessagStateByModel:self.currentTapChatModel];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[self.messageItems indexOfObject:self.currentTapChatModel] inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
        RedPacketReceiveDetailViewController*vc=[[RedPacketReceiveDetailViewController alloc]init];
        vc.redPacketDetailInfo=response;
        [[AppDelegate shared] pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
}
/// 检测用户是否在线
-(void)checkUserIsOnLineRequest{
    CheckUserOnlineRequest*request=[CheckUserOnlineRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/user/checkOnline/%@",self.config.chatID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[CheckUserOnlineInfo class] contentClass:[CheckUserOnlineInfo class] success:^(CheckUserOnlineInfo* response) {
        if (!(hashEqual(self.config.chatType, GroupChat))) {
            if (!(hashEqual(self.config.chatID, @"100"))) {
                [self.chatViewNavBarView updateUserOnline:response];
            }
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
/// 获取用户详情 判断是否是好友
-(void)getFriendDetailRequest{
    GetUserMessageRequest*request=[GetUserMessageRequest request];
    request.userId=self.config.chatID;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo* response) {
        self.userMessageInfo=response;
        [[WCDBManager sharedManager]updateIsBlock:self.userMessageInfo.block chatId:self.config.chatID];
        [[WCDBManager sharedManager]updateIsbeBlock:self.userMessageInfo.beBlock chatId:self.config.chatID];
        [self updateIsFriend];
        [[WCDBManager sharedManager]insertUserMessageInfo:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
//
#pragma mark -- 获取群详情 展示总人数
-(void)getGroupDetail {
    GetGroupDetailRequest*request=[GetGroupDetailRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/group/%@",request.baseUrlString,self.config.chatID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GroupListInfo class] contentClass:[GroupListInfo class] success:^(GroupListInfo* response) {
        self.groupDetailInfo=response;
        [self.chatViewNavBarView updateUiWithGroupInfo:response];
        [self.chatFunctionView configGroupWithGroupDetailInfo:response draftMessage:self.chatListModel.draftMessage];
        
        [[WCDBManager sharedManager]insertOrUpdateGroupListInfoWithArray:@[response]];
        if (response.locked) {
            [UIAlertController alertControllerWithTitle:@"ChatViewController.groupTip.locked".icanlocalized message:@"" target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        }
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
/// 删除多条或者一条消息的时候 告诉后台接口
/// @param messageId 需要删除的消息ID
/// @param deleteAll 是否在其他人设备上面删除
-(void)deleteMoreMessageRequestWithMessageIds:(NSArray*)messageId deleteAll:(BOOL)deleteAll{
    if (messageId.count>0) {
        UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
        if ([self.config.chatType isEqualToString:GroupChat]) {
            request.groupId=self.config.chatID;
            request.type=@"GroupPart";
        }else{
            request.userId=self.config.chatID;
            request.type=@"UserPart";
        }
        request.deleteAll=deleteAll;
        request.authorityType=self.config.authorityType;
        request.messageIds=messageId;
        request.parameters=[request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
        [self.needDeleteMessageIds removeAllObjects];
    }
    
}


-(void)checkFileHasExistRequestWithHashId:(NSString*)hashId successBlock:(void(^)(NSString*response))successBlock failure:(void (^_Nullable)(NSError *error, NetworkErrorInfo *info, NSInteger statusCode))failure{
    CheckFileHasExistRequest*request=[CheckFileHasExistRequest request];
    request.hashId=hashId;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSString class] contentClass:[NSString class] success:^(NSString* response) {
        successBlock(response);
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        failure(error,info,statusCode);
    }];
}
-(void)getCircleUserInfoRequest{
    GetCircleUserInfoRequest*request=[GetCircleUserInfoRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/api/users/info/%@",self.config.circleUserId];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[CircleUserInfo class] contentClass:[CircleUserInfo class] success:^(CircleUserInfo* response) {
        self.circleUserInfo=response;
        if (!response.enable) {
            [UIAlertController alertControllerWithTitle:@"CircleOtherUserEnable".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }else{
            [self updateCircleCansendMessageWith:self.circleDislikeMeInfo circleUserInfo:self.circleUserInfo];
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)getCircleDislikeMeRequest{
    GetCircleDislikeMeRequest*request=[GetCircleDislikeMeRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/api/dislikeUsers/dislikeMe/%@",self.config.circleUserId];
    request.isHttpResponse=YES;
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[GetCircleDislikeMeInfo class] contentClass:[GetCircleDislikeMeInfo class] success:^(GetCircleDislikeMeInfo* response) {
        self.circleDislikeMeInfo=response;
        [self updateCircleCansendMessageWith:self.circleDislikeMeInfo circleUserInfo:self.circleUserInfo];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)getC2CUserInfoRequest{
    C2CGetUserInfoRequest * request = [C2CGetUserInfoRequest request];
    request.pathUrlString = [request.baseUrlString stringByAppendingFormat:@"/api/user/%@",self.config.c2cUserId];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  _Nonnull response) {
        self.c2cUserInfo = response;
        [self.tableView reloadData];
        [self.chatViewNavBarView updateButtonStatusWithC2CUserInfo:response];
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
    
}
-(void)addQuickMessageRequest:(ChatModel*)model{
    PostQuickMessageRequest*request = [PostQuickMessageRequest request];
    request.value = model.attrStr.string;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(BaseResponse* response) {
        [self getAllQuickMessageRequest];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)getAllQuickMessageRequest{
    GetQuickMessageAllRequest*request = [GetQuickMessageAllRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass: [NSArray class] contentClass:[QuickMessageInfo class] success:^(NSArray* response) {
        self.quickMessageItems = response;
        self.fastMessageView.msgItems = response;
        CGFloat height = 50;
        if (response.count==0) {
            height = 96;
        }else if (response.count>5) {
            height = 44*5+96;
        }else{
            height = 44*response.count+96;
        }
        [self.fastMessageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@(height));
            make.bottom.equalTo(self.chatFunctionView.mas_top);
        }];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)updateCircleCansendMessageWith:(GetCircleDislikeMeInfo*)dislikeMeInfo circleUserInfo:(CircleUserInfo*)circleUserInfo{
    [self.chatViewNavBarView updateButtonStatusWith:dislikeMeInfo circleUserInfo:circleUserInfo];
    [self.chatFunctionView configCirclecanSendMessageWith:circleUserInfo dislikeMeInfo:dislikeMeInfo draftMessage:self.chatListModel.draftMessage];
    //交友账号 对方已经注销 或者对方不喜欢我
    if (circleUserInfo.deleted||dislikeMeInfo.dislikeMe) {
        [self showUnFriendTipsView];
    }
    
}
-(void)setThumbnailDetails:(ChatModel *)textModel ofUrl:(NSURL *)url{
    textModel.messageType = URLMessageType;
    WBGLinkPreview *urlPreview;
    urlPreview = [[WBGLinkPreview alloc] init];
    [urlPreview previewWithText:url.absoluteString
                      onSuccess:^(NSDictionary *result) {
        if([result[@"title"] isEqualToString:@"YouTube"]){
            NSString *youtubeUrl = url.absoluteString;
            NSArray *Array;
            NSString *videoId;
            if([result[@"url"] containsString:@"/www.youtube.com/"]){
                Array = [youtubeUrl componentsSeparatedByString:@"="];
                videoId = [Array objectAtIndex:1];
            }
            else if ([result[@"url"] containsString:@"/youtu.be/"]){
                Array = [youtubeUrl componentsSeparatedByString:@"https://youtu.be/"];
                videoId = [Array objectAtIndex:1];
            }
            NSString *urlString =[@"https://www.googleapis.com/youtube/v3/videos?key=AIzaSyAkeoMi-GD1Xaso9Z6l3wVVQcWO-m8tmqw&part=snippet&id=" stringByAppendingFormat:@"%@",videoId];
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            [urlRequest setHTTPMethod:@"GET"];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode == 200){
                    NSError *parseError = nil;
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                    NSArray *responseItemsArray = [responseDictionary valueForKeyPath:@"items"];
                    if(responseItemsArray.count > 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            textModel.thumbnailTitleofTextUrl = [responseDictionary valueForKeyPath:@"items.snippet.localized.title"][0];
                            textModel.thumbnailImageurlofTextUrl = [responseDictionary valueForKeyPath:@"items.snippet.thumbnails.medium.url"][0];
                            [[WCDBManager sharedManager]updateMessageContentByMessageId:textModel];
                            [self.tableView reloadData];
                        });
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            textModel.thumbnailTitleofTextUrl = nil;
                            textModel.thumbnailImageurlofTextUrl = nil;
                        });
                    }
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        textModel.thumbnailTitleofTextUrl = nil;
                        textModel.thumbnailImageurlofTextUrl = nil;
                    });
                }
            }];
            [dataTask resume];
        }
        else{
            if(![result[@"title"]  isEqual: @""] && ![result[@"image"] isEqual:@""] && ![result[@"image"] isEqual:@"undefined"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    textModel.thumbnailTitleofTextUrl = result[@"title"];
                    textModel.thumbnailImageurlofTextUrl = result[@"image"];
                    [[WCDBManager sharedManager]updateMessageContentByMessageId:textModel];
                    [self.tableView reloadData];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    textModel.thumbnailTitleofTextUrl = nil;
                    textModel.thumbnailImageurlofTextUrl = nil;
                });
            }
        }
        
    } onError:^(WBGPreviewError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            textModel.thumbnailTitleofTextUrl = nil;
            textModel.thumbnailImageurlofTextUrl = nil;
        });
        NSLog(@"%@", error.description);
    }];
}

- (void)clickChangeLanguage{
    [self.view endEditing:YES];
    [self  showGroupPickView:self.config.chatType];
}

- (NSString*)clickUseConvertedTextLanguage {
    self.chatFunctionView.messageTextView.text = self.translatorViewMenue.translatedTextLabel.text;
    return self.translatorViewMenue.translatedTextLabel.text;
}

-(void)addArrayData{
    [self.languageItems removeAllObjects];
    LanguageInfo *product001 = [LanguageInfo new];
    product001.name = @"None".icanlocalized;
    product001.code = @"None";
    LanguageInfo *product = [LanguageInfo new];
    product.name = @"English".icanlocalized;
    product.code = @"en-us";
    LanguageInfo *product1 = [LanguageInfo new];
    product1.name = @"Turkish".icanlocalized;
    product1.code = @"tr";
    LanguageInfo *product2 = [LanguageInfo new];
    product2.name = @"Chinese".icanlocalized;
    product2.code = @"zh-cn";
    LanguageInfo *product3 = [LanguageInfo new];
    product3.name = @"Vietnam".icanlocalized;
    product3.code = @"vi";
    LanguageInfo *product4 = [LanguageInfo new];
    product4.name = @"Khmer".icanlocalized;
    product4.code = @"km";
    LanguageInfo *product5 = [LanguageInfo new];
    product5.name = @"Thai".icanlocalized;
    product5.code = @"th";
    LanguageInfo *product6 = [LanguageInfo new];
    product6.name = @"Sinhala".icanlocalized;
    product6.code = @"si";
    LanguageInfo *product7 = [LanguageInfo new];
    product7.name = @"Tamil".icanlocalized;
    product7.code = @"ta";
    [self.languageItems addObject:product001];
    [self.languageItems addObject:product];
    [self.languageItems addObject:product1];
    [self.languageItems addObject:product2];
    [self.languageItems addObject:product3];
    [self.languageItems addObject:product4];
    [self.languageItems addObject:product5];
    [self.languageItems addObject:product6];
    [self.languageItems addObject:product7];
    NSLog(@"%lu",(unsigned long)self.languageItems.count);
}

-(void)showGroupPickView:(NSString*)userType{
    @weakify(self);
    NSString *translateLanguageCode = self.chatSetting.translateLanguageCode;
    if(translateLanguageCode == nil || [translateLanguageCode  isEqual: @""]){
        translateLanguageCode = @"None";
    }
    NSString *rightText=[ChatViewHandleTool getLanguageByLanguageCode:translateLanguageCode];
    NSArray *dataArray = [self.languageItems valueForKey:@"name"];
    NSInteger row = [dataArray indexOfObject:rightText];
    [[JKPickerView sharedJKPickerView] setPickViewWithTarget:self title:@"Select Language".icanlocalized leftItemTitle:@"UIAlertController.cancel.title".icanlocalized rightItemTitle:@"UIAlertController.sure.title".icanlocalized leftAction:@selector(removePick) rightAction:@selector(sureAction) dataArray:dataArray dataBlock:^(NSString *title) {
        @strongify(self);
        NSString *getLanguageCode = [ChatViewHandleTool getLanguageCodeByLanguage:title];
        if([userType isEqualToString: UserChat]){
            [[WCDBManager sharedManager] updateTranslationSettingStates:title translateLanguageCode:getLanguageCode chatId:self.config.chatID chatType:UserChat authorityType:AuthorityType_friend];
            ChatModel *config = [[ChatModel alloc]init];
            config.authorityType = AuthorityType_friend;
            config.chatID = self.config.chatID;
            config.chatType = UserChat;
            self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
            self.translatorViewMenue.languageNameLabel.text = [ChatViewHandleTool getLanguageByLanguageCode:self.chatSetting.translateLanguageCode];
            if([title isEqualToString:@"None".icanlocalized]){
                [self.translatorViewMenue hideTranslateView ];
                self.isTranslationEnabled = NO;
                [self updateFrame];
            }else{
                [self.translatorViewMenue showTranslateView ];
                [self translateTextString:self.chatSetting.translateLanguageCode textShouldConvert:self.chatFunctionView.messageTextView.text];
            }
            NSLog(@"UserChat");
        }else if ([userType isEqualToString: GroupChat]){
            [[WCDBManager sharedManager] updateTranslationSettingStates:title translateLanguageCode:getLanguageCode chatId:self.groupDetailInfo.groupId chatType:GroupChat authorityType:AuthorityType_friend];
            ChatModel *config = [[ChatModel alloc]init];
            config.authorityType = AuthorityType_friend;
            config.chatID = self.config.chatID;
            config.chatType = GroupChat;
            self.chatSetting = [[WCDBManager sharedManager]fetchChatSettingWith:config];
            self.translatorViewMenue.languageNameLabel.text = [ChatViewHandleTool getLanguageByLanguageCode:self.chatSetting.translateLanguageCode];;
            if([title isEqualToString:@"None".icanlocalized]){
                [self.translatorViewMenue hideTranslateView ];
            }else{
                [self.translatorViewMenue showTranslateView ];
                [self translateTextString:self.chatSetting.translateLanguageCode textShouldConvert:self.chatFunctionView.messageTextView.text];
            }
            NSLog(@"GroupChat");
        }
    }];
    [[JKPickerView sharedJKPickerView]selectRow:row inComponent:0 animated:YES];
}

- (NSMutableArray *)languageItems {
    if (!_languageItems) {
        _languageItems = [NSMutableArray array];
    }
    return _languageItems;
}

-(void)removePick{
    [[JKPickerView sharedJKPickerView] removePickView];
}
-(void)sureAction{
    [[JKPickerView sharedJKPickerView] sureAction];
}
@end



//    self.deleteIndexPath=[self.tableView indexPathForCell:cell];
//    self.hjcActionSheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:NSLocalizedString(@"Cancel", nil) OtherTitles:NSLocalizedString(@"DeleteMessageRemind", 是否删除该条消息), @"UIAlertController.sure.title".icanlocalized, nil];
//    self.hjcActionSheet.tag = 100;
//    [self.hjcActionSheet setBtnTag:1 TextColor:UIColor102Color textFont:14.0f enable:NO];
//    [self.hjcActionSheet setBtnTag:2 TextColor:UIColor244RedColor textFont:0 enable:YES];
//    [self.hjcActionSheet show];


//#pragma mark == __SHEET ===
//- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (self.hjcActionSheet.tag == 100) {
//        //消息长按之后 点击了删除按钮
//        if (buttonIndex == 2) {
//            //            ChatModel *model = self.messageItems[self.deleteIndexPath.row];
//            //            [self.messageItems removeObject:model];
//            //            [self.tableView deleteRowsAtIndexPaths:@[self.deleteIndexPath] withRowAnimation:(UITableViewRowAnimationNone)];
//            //            if ([self.currentPlayingVoiceModel.messageID isEqualToString: model.messageID]) {
//            //                [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
//            //            }
//            //            [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
//            //            [self deleteMoreMessageRequestWithMessageIds:@[model.messageID] deleteAll:YES];
//        }
//    }
//}



//                NSMutableArray*messageIds=[NSMutableArray array];
//                for (ChatModel*model in deleteMessageItems) {
//                    [messageIds addObject:model.messageID];
//                    if ([self.currentPlayingVoiceModel.messageID isEqualToString: model.messageID]) {
//                        [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer];
//                    }
//                    [self.messageItems removeObject:model];
//                    [[ChatViewHandleTool shareManager]deleteMessageFromChatModel:model config:self.config];
//                }
//                [self.tableView reloadData];
//                [self deleteMoreMessageRequestWithMessageIds:messageIds deleteAll:YES];
//                [self multipleShowViewAfterOperate];
