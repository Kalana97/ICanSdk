//
//  ChatListViewController.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/4/19.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "ChatListViewController.h"
#import "DynamicChatHelperViewController.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "ChatListCell.h"
#import "ChatListModel.h"
#import "WebSocketManager.h"
#import "WCDBManager.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "ChatListMenuView.h"
#import "FriendListTableViewController.h"
#import "AddFriendsViewController.h"
#import "QRCodeController.h"
#import "QRCodeView.h"
#import "PrivacyPermissionsTool.h"
#import "GroupListViewController.h"
#import "ChatListSearchViewController.h"
#import "ServiceTableViewController.h"
#import "ICanHelpViewController.h"
#import "ChatListTableHeaderView.h"
#import "ShopHelperViewController.h"
#import "PrivacyPermissionsTool.h"
#import <CoreLocation/CoreLocation.h>
#import "FindNearbyPersonsViewController.h"
#import "AdvertisingView.h"
#import "SecretChatListViewController.h"
#import "QDNavigationController.h"
#import "BindingTipsView.h"
#import "UserBindingMobileOrEmailViewController.h"
#import "SettingPasswordViewController.h"
#import "SystemHelperViewController.h"
#import "AnnouncementHelperViewController.h"
#import "C2CHelperViewController.h"
#import "NoticeOTPViewController.h"
#import "NERtcCallKit.h"
#import "NeCallBaseViewController.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+CircleUserInfo.h"
#import "LocalNotificationManager.h"
#import "MyInfoViewController.h"
#import "ChatViewHandleTool.h"
#import "UIView+Nib.h"
#import "FriendListTableViewHeaderView.h"
#ifdef ICANTYPE
#import <CallKit/CallKit.h>
#endif

#ifdef ICANTYPE
@interface ChatListViewController ()<NERtcCallKitDelegate,CLLocationManagerDelegate,CXProviderDelegate>
#else
@interface ChatListViewController ()<NERtcCallKitDelegate,CLLocationManagerDelegate>
#endif
@property(nonatomic, weak) IBOutlet DZIconImageView *iconImageView;
@property(weak, nonatomic) IBOutlet UIStackView *tipBgView;
//显示登录状态
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *activityView;
@property(nonatomic, weak) IBOutlet UILabel *showInfoLB;
@property(nonatomic, weak) IBOutlet UILabel *nameLabel;
@property(nonatomic, weak) IBOutlet UIButton *addButton;
@property(nonatomic, weak) IBOutlet UIButton *nearButton;
@property(nonatomic, weak) IBOutlet UIView * secretBgView;
@property(nonatomic, weak) IBOutlet UIButton *secretButton;
@property(nonatomic, weak) IBOutlet UILabel *secretUnredLabel;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *secretUnReadLabelHeight;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *secretUnReadLabelWidth;
@property(nonatomic, assign) NSInteger secretUnreadCount;

///消息数据源
@property(nonatomic, strong) NSArray *messagesArray;

@property(nonatomic, strong) ChatListMenuView *menuView;
@property(nonatomic, strong) ChatListTableHeaderView *chatListTableHeaderView;
@property(nonatomic, strong) CLLocationManager *mapkitLocationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property(nonatomic, strong) BindingTipsView *tipsView;
@property(nonatomic, assign) BOOL first;
@property(nonatomic, strong) NeCallBaseViewController *callVC;
@property (nonatomic, strong) NSUUID *uuid;
@end

@implementation ChatListViewController

-(instancetype)init{
    if (self=[super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setChatListItemUnReadCount:) name:KChatListRefreshNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMessages) name:kUpdateGroupMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chatWithFriend:) name:kChatWithFriendNotification object: nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transfetSucessAndGotoChatViewVcWithNotification:) name:KTransferSucessNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noNetWorkNotification) name:KAFNetworkReachabilityStatusNotReachable object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connenctSuccessNotification) name:KConnectSocketSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectSocketStartNotification) name:KConnectSocketStartNotification object:nil];
        //As per Mr.Roshan's request
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkShouldShowBindingMobieTipsView) name:kBindingSucessNotification object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkShouldShowBindingMobieTipsView) name:ksetPasswordSuccessNotification object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkShouldShowBindingMobieTipsView) name:KShowNewTipViewNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(creatGroupSuccess:) name:KCreatGroupSuccessNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateIconImageView) name:KUpdateUserMessageNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateShowNear) name:kUpdateShowNearPeopleNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSecretShow) name:kGetPriviSuccessNotification object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer*iconTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconImageViewTapAction)];
    [self.iconImageView addGestureRecognizer:iconTap];
    self.nameLabel.text = @"friend.detail.chat".icanlocalized;
    [self updateSecretShow];
    [self updateIconImageView];
    
    [[NERtcCallKit sharedInstance] addDelegate:self];
    NSInteger secretUnReadMsgNumber= [[WCDBManager sharedManager]fetchAllSecretUnReadNumberCount].integerValue;
    [self setSecretUnreadCount:secretUnReadMsgNumber];
    [self getMessages];
    [self settingFriendListUnRead];
    self.first = YES;
    self.view.backgroundColor=UIColor.whiteColor;
    [self settingTabbarUnReadNumber];
    [self getCurrentLocation];
    if (!UserInfoManager.sharedManager.hasShowAdver) {
        //获取沙河路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        //获取文件路径
        NSString * pathName = [path stringByAppendingString:@"/PublicStart.data"];
        GetPublicStartInfo*info= [NSKeyedUnarchiver unarchivedObjectOfClass:[GetPublicStartInfo class] fromData:[NSData dataWithContentsOfFile:pathName] error:nil];
        //        if (@available(iOS 12.0, *)) {
        //
        //        } else {
        //            GetPublicStartInfo*info= [NSKeyedUnarchiver unarchiveObjectWithFile:pathName];
        //        }
        
        if (info.imgUrl) {
            if (info.endTime) {
                NSInteger currentTime=[[NSDate date]timeIntervalSince1970]*1000;
                if (info.startTime<currentTime<info.endTime) {
                    AdvertisingView*view=[[AdvertisingView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    view.startInfo=info;
                    UserInfoManager.sharedManager.hasShowAdver=YES;
                    [[UIApplication sharedApplication].delegate.window addSubview:view];
                    
                }
            }else{
                AdvertisingView*view=[[AdvertisingView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                view.startInfo=info;
                UserInfoManager.sharedManager.hasShowAdver=YES;
                [[UIApplication sharedApplication].delegate.window addSubview:view];
            }
            
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.messagesArray= [[WCDBManager sharedManager]getAllIcanChatListModel];
    [self.tableView reloadData];
    [self networkMonitoring];
}
-(void)iconImageViewTapAction{
    if ([UserInfoManager sharedManager].loginStatus) {
        [[AppDelegate shared]pushViewController:[MyInfoViewController new] animated:YES];
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //不是新用户 在启动的过程中 仅仅显示一次
//As per Mr.Roshan's request
//    if (self.first) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self checkShouldShowBindingMobieTipsView];
//        });
//    }
    
    
}
-(void)updateSecretShow{
//    self.secretBgView.hidden=self.secretButton.hidden=![UserInfoManager sharedManager].isSecret; ----> not necessary ,since the logic chnged ,but keep it to future fine tunes
}
-(void)setSecretUnreadCount:(NSInteger)secretUnreadCount{
    if (secretUnreadCount==0) {
        self.secretUnredLabel.hidden=YES;
    }else{
        self.secretUnredLabel.hidden=NO;
        if (secretUnreadCount > 9&&secretUnreadCount<=99) {
            self.secretUnReadLabelWidth.constant = 20;
            self.secretUnReadLabelHeight.constant = 20;
            self.secretUnredLabel.text = [NSString stringWithFormat:@"%ld",(long)secretUnreadCount];
            [self.secretUnredLabel layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
        }else if (secretUnreadCount > 99) {
            self.secretUnredLabel.text = @"··";
            self.secretUnReadLabelWidth.constant = 20;
            self.secretUnReadLabelHeight.constant = 20;
            [self.secretUnredLabel layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
        } else {
            [self.secretUnredLabel layerWithCornerRadius:9 borderWidth:0 borderColor:nil];
            self.secretUnReadLabelWidth.constant = 18;
            self.secretUnReadLabelHeight.constant = 18;
            self.secretUnredLabel.text = [NSString stringWithFormat:@"%ld",(long)secretUnreadCount];
        }
    }
}
///是否显示附近的人的按钮
-(void)updateShowNear{
//    self.nearButton.hidden=![UserInfoManager sharedManager].openNearbyPeople;
}
-(void)updateIconImageView{
    [self.iconImageView setDZIconImageViewWithUrl:[UserInfoManager sharedManager].headImgUrl gender:[UserInfoManager sharedManager].gender];
}
-(IBAction)buttonAction:(UIButton*)sender{
    if (sender.tag==0) {
        //群聊，加好友，扫一扫，二维码 ----> Group chat, add friends, scan, QR code, private chat
        NSArray *array;
        if ([UserInfoManager sharedManager].isSecret) {
            array = @[@{@"icon":@"icon_chatList_pop_group",@"title":@"chatlist.menu.list.group".icanlocalized},@{@"icon":@"icon_chatList_pop_addFriend",@"title":@"chatlist.menu.list.addfriend".icanlocalized},
                            @{@"icon":@"icon_chatList_pop_scan",@"title":@"chatlist.menu.list.scan".icanlocalized},
                            @{@"icon":@"icon_chatList_pop_qrcode",@"title":@"chatlist.menu.list.qrcode".icanlocalized},
                            @{@"icon":@"icon_chatList_private_black",@"title":@"friend.detail.privateChat".icanlocalized}];
        }else {
            array = @[@{@"icon":@"icon_chatList_pop_group",@"title":@"chatlist.menu.list.group".icanlocalized},@{@"icon":@"icon_chatList_pop_addFriend",@"title":@"chatlist.menu.list.addfriend".icanlocalized},
                            @{@"icon":@"icon_chatList_pop_scan",@"title":@"chatlist.menu.list.scan".icanlocalized},
                            @{@"icon":@"icon_chatList_pop_qrcode",@"title":@"chatlist.menu.list.qrcode".icanlocalized}];
        }
        [ChatListMenuView showMenuViewWithMenuItems:array didSelectBlock:^(NSInteger index) {
            switch (index) {
                case 0:{
                    [self addGroudClick];
                }
                    
                    break;
                case 1:{
                    [self.navigationController pushViewController:[AddFriendsViewController new] animated:YES];
                }
                    
                    break;
                case 2:
                    [self gotoScanVc];
                    break;
                case 3:{
                    QRCodeView*view = [[NSBundle mainBundle]loadNibNamed:@"QRCodeView" owner:self options:nil].firstObject;
                    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                    view.qrCodeViewTyep=QRCodeViewTyep_user;
                    [view showQRCodeView];
                }
                    
                    break;
                case 4:{
                    SecretChatListViewController *vc =[[SecretChatListViewController alloc]init];
                    QDNavigationController *nav =[[QDNavigationController alloc]initWithRootViewController:vc];
                    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    nav.hidesBottomBarWhenPushed = YES;
                    [self presentViewController:nav animated:YES completion:nil];
                }
                    
            }
        }];
    }else if(sender.tag == 1){
        [self fetchCurretnLoacationAndJudeIsNeedUpdateLocation ];
    }else{
        //ican AI
        ChatModel *chatModel   = [[ChatModel alloc]init];
        chatModel.chatID = @"100";
        chatModel.chatType = UserChat;
        UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
        [[AppDelegate shared] pushViewController:vc animated:YES];
    }
}

-(void)networkMonitoring{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];

    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];

    [reachability startMonitoring];
}


-(void)applicationNetworkStatusChanged:(NSNotification*)userinfo{

    NSInteger status = [[[userinfo userInfo]objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];

    switch (status) {
        case AFNetworkReachabilityStatusUnknown:{
            [self connectSocketStartNotification];
            break;
        }
        case AFNetworkReachabilityStatusNotReachable:{
            [self noNetWorkNotification];
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWWAN:{
            [self connenctSuccessNotification];
            break;
        }
        case AFNetworkReachabilityStatusReachableViaWiFi:{
            [self connenctSuccessNotification];
            break;
        }
        default:{
            [self connectSocketStartNotification];
            break;
        }
    }
}
-(void)connenctSuccessNotification{
    self.tipBgView.hidden = YES;
}
-(void)connectSocketStartNotification{
    self.tipBgView.hidden = NO;
    self.activityView.hidden = NO;
    self.showInfoLB.text = @"Connecting".icanlocalized;
    [self.activityView startAnimating];
}
-(void)noNetWorkNotification{
    self.tipBgView.hidden = NO;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    self.showInfoLB.text=@"Waiting for network".icanlocalized;
}
-(void)sucessCreateGroupChat:(NSNotification *)notification{
    NSString *groupId = notification.userInfo[@"groupId"];
    NSString *groupName =notification.userInfo[@"groupName"];
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:groupId,kchatType:GroupChat,kauthorityType:AuthorityType_friend,kshowName:groupName}];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)chatWithFriend:(NSNotification *)notification{
    self.tabBarController.selectedIndex=0;
    ChatModel *model = notification.object;
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:model.chatID,kchatType:model.chatType,kauthorityType:AuthorityType_friend}];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)creatGroupSuccess:(NSNotification *)notification{
    self.tabBarController.selectedIndex=0;
    ChatModel *model = notification.object;
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:model.chatID,kchatType:model.chatType,kauthorityType:AuthorityType_friend}];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)transfetSucessAndGotoChatViewVcWithNotification:(NSNotification *)noti{
    ChatModel * model = noti.userInfo[@"chatModel"];
    UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:model.chatID,kchatType:model.chatType,kauthorityType:AuthorityType_friend}];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)friendlist{
    [self.navigationController pushViewController:[FriendListTableViewController new] animated:YES];
}
-(void)settingTabbarUnReadNumber{
    UITabBarItem *item = [CHANNELTYPE isEqualToString:ICANTYPETARGET] ? self.tabBarController.tabBar.items[1] : self.tabBarController.tabBar.items[0];
    NSInteger UnReadMsgNumber =[[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
    item.qmui_badgeInteger = UnReadMsgNumber;
    if (UnReadMsgNumber >99) {
        item.qmui_badgeString =@"...";
    }
    
}
-(void)settingFriendListUnRead{
    UITabBarItem *item = [CHANNELTYPE isEqualToString:ICANTYPETARGET] ? self.tabBarController.tabBar.items[0] : self.tabBarController.tabBar.items[1];
    NSInteger unReadAmount=[[WCDBManager sharedManager]fetchFriendSubscriptionUnReadAmount];
    item.qmui_badgeInteger = unReadAmount;
    if (unReadAmount >99) {
        item.qmui_badgeString =@"...";
    }
}
-(void)setChatListItemUnReadCount:(NSNotification*)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger UnReadMsgNumber= [[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
        UITabBarItem *item = [CHANNELTYPE isEqualToString:ICANTYPETARGET] ? self.tabBarController.tabBar.items[1] : self.tabBarController.tabBar.items[0];
        item.qmui_badgeInteger = UnReadMsgNumber;
        if (UnReadMsgNumber >99) {
            item.qmui_badgeString =@"...";
        }
        [self getMessages];
        NSInteger secretUnReadMsgNumber= [[WCDBManager sharedManager]fetchAllSecretUnReadNumberCount].integerValue;
        [self setSecretUnreadCount:secretUnReadMsgNumber];
    });
    
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}


-(void)initTableView{
    [super initTableView];
    self.tableView.rowHeight       = kChatListCellHeight;
    [self.tableView registNibWithNibName:kChatListCell];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(NavBarHeight+5));
        make.bottom.equalTo(@(-TabBarHeight));
    }];
    
    self.tableView.showsVerticalScrollIndicator=YES;
    self.tableView.tableHeaderView = self.chatListTableHeaderView;
    
}
-(void)layoutTableView{
    
}

#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatListCell *listCell  = [tableView dequeueReusableCellWithIdentifier:kChatListCell];
    listCell.chatListModel = self.messagesArray[indexPath.row];
    listCell.contentView.backgroundColor = [UIColor whiteColor];
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColorMakeHEXCOLOR(0xF6F6F6);
    NSTimeInterval delay = 0.005;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ChatListModel *seletedChatListModel = self.messagesArray[indexPath.row];
        if([seletedChatListModel.messageType isEqualToString:PayHelperMessageType]) {
            ICanHelpViewController *vc = [ICanHelpViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([seletedChatListModel.messageType isEqualToString:SystemHelperMessageType]) {
            [self.navigationController pushViewController:[SystemHelperViewController new] animated:YES];
        }else if([seletedChatListModel.messageType isEqualToString:ShopHelperMessageType]) {
            ShopHelperViewController *vc = [[ShopHelperViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([seletedChatListModel.chatType isEqualToString:C2CHelperMessageType]) {
            C2CHelperViewController *vc=[[C2CHelperViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([seletedChatListModel.chatType isEqualToString:AIMessageType]) {
            UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:seletedChatListModel.chatID,kchatType:seletedChatListModel.chatType,kauthorityType:AuthorityType_friend}];
            [self.navigationController pushViewController:vc animated:YES];
        }else if([seletedChatListModel.messageType isEqualToString:AnnouncementHelperMessageType]) {
            AnnouncementHelperViewController *vc = [[AnnouncementHelperViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"seletedChatListModel");
        }else if([seletedChatListModel.messageType isEqualToString:DynamicMessageType]) {
            DynamicChatHelperViewController *vc = [[DynamicChatHelperViewController alloc]init];
            vc.chatID = seletedChatListModel.chatID;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([seletedChatListModel.messageType isEqualToString:NoticeOTPMessageType]) {
            NoticeOTPViewController *vc = [[NoticeOTPViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if(![seletedChatListModel.chatMode  isEqual: @""] && seletedChatListModel.chatMode != nil){
                UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:seletedChatListModel.chatID,kchatType:seletedChatListModel.chatType,kauthorityType:AuthorityType_friend,kchatMode:seletedChatListModel.chatMode}];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:seletedChatListModel.chatID,kchatType:seletedChatListModel.chatType,kauthorityType:AuthorityType_friend}];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        [self performSubtleVibration];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kChatListCellHeight;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListModel *dataModel = [self.messagesArray objectAtIndex:indexPath.row];
    if([dataModel.chatMode isEqualToString:ChatModeOtherChat]){
        return NO;
    }else{
        return YES;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ChatModel *config = [self.messagesArray objectAtIndex:indexPath.row];
        if([config.chatType isEqualToString:UserChat]){
            [self clearActionUserChat:[self.messagesArray objectAtIndex:indexPath.row]];
        }else if([config.chatType isEqualToString:GroupChat] || [config.chatType isEqualToString:C2CHelperMessageType] || [config.chatType isEqualToString:NoticeOTPMessageType]) {
            [self clearActionGroupChat:[self.messagesArray objectAtIndex:indexPath.row]];
        }
    }
}

- (void)performSubtleVibration {
    UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc] init];
    [generator selectionChanged];
    [generator prepare];
}

-(void)clearActionUserChat:(ChatModel *)chatModelData{
    [self deleteFriendAllMessage:NO configModel:chatModelData];
}

-(void)clearActionGroupChat:(ChatModel *)chatModelData{
    [self deleteFromMySide:chatModelData];
}

-(void)deleteFriendAllMessage:(BOOL)deleteAll configModel:(ChatModel*)configModel{
    UserRemoveMessageRequest *request=[UserRemoveMessageRequest request];
    request.userId = UserInfoManager.sharedManager.userId;
    request.type = @"UserAll";
    if (deleteAll) {
        request.deleteAll = deleteAll;
    }
    request.authorityType = AuthorityType_friend;
    request.parameters = [request mj_JSONString];
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        ChatModel*config = [[ChatModel alloc]init];;
        config.chatID = configModel.chatID;
        config.chatType = UserChat;
        config.authorityType = configModel.authorityType;
        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
        [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
        [[WCDBManager sharedManager]deleteResourceWihtChatId:configModel.chatID];
        [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
        WebSocketManager.sharedManager.currentChatID = @"";
        [QMUITips hideAllTips];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        NSLog(@"Fail");
    }];
}

-(void)deleteFromMySide:(ChatModel*)configModel{
    ChatModel *config = [[ChatModel alloc]init];;
    config.chatID = configModel.chatID;
    config.chatType = configModel.chatType;
    config.authorityType = AuthorityType_friend;;
    [[WCDBManager sharedManager]deleteAllChatModelWith:config];
    [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
    [[WCDBManager sharedManager]deleteResourceWihtChatId:configModel.chatID];
    [[WCDBManager sharedManager]updateChatListModelLastMessageWithChatModel:config];
    if (self.deleteSuccessBlock) {
        self.deleteSuccessBlock();
    }
    WebSocketManager.sharedManager.currentChatID = @"";
    [QMUITips hideAllTips];
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [@"timeline.post.operation.delete" icanlocalized:@"删除"];
}

#pragma mark - 拉取数据库数据
- (void)getMessages{
    self.messagesArray= [[WCDBManager sharedManager]getAllIcanChatListModel];
    [self.tableView reloadData];
    
}
-(void)gotoScanVc {
    QRCodeController *friendsVC = [[QRCodeController alloc]init];
    [self.navigationController pushViewController:friendsVC animated:YES];
}
//扫一扫
-(void)goToScanVc{
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [self.navigationController pushViewController:[QRCodeController new] animated:YES];
    } failure:^{
        
    }];
}

-(void)addGroudClick{
    GroupListViewController * vc = [GroupListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (NSArray *)messagesArray{
    if (!_messagesArray) {
        _messagesArray = [NSArray new];
    }
    return _messagesArray;
}
-(ChatListTableHeaderView *)chatListTableHeaderView{
    if (!_chatListTableHeaderView) {
        _chatListTableHeaderView=[ChatListTableHeaderView loadFromNibWithFrame:CGRectMake(0, 0, ScreenWidth, 96)];
        
        @weakify(self);
        _chatListTableHeaderView.searchCallBack  = ^{
            @strongify(self);
            ChatListSearchViewController*vc=[ChatListSearchViewController new];
            vc.tapBlock = ^(NSString * _Nonnull chatId, NSString * _Nonnull chatType) {
                UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatId,kchatType:chatType,kauthorityType:AuthorityType_friend}];
                [self.navigationController pushViewController:vc animated:YES];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        _chatListTableHeaderView.nearCallBack = ^{
            @strongify(self);
            if (WebSocketManager.sharedManager.hasNewWork) {
                [self fetchCurretnLoacationAndJudeIsNeedUpdateLocation];
            }else{
                [QMUITipsTool showOnlyTextWithMessage:@"Waiting for network".icanlocalized inView:self.view];
            }
        };
    }
    return _chatListTableHeaderView;
}
-(ChatListMenuView *)menuView{
    if (!_menuView) {
        _menuView=[[ChatListMenuView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        @weakify(self);
        _menuView.didSelectBlock = ^(NSInteger index) {
            @strongify(self);
            switch (index) {
                case 0:{
                    [self addGroudClick];
                }
                    
                    break;
                case 1:{
                    [self.navigationController pushViewController:[AddFriendsViewController new] animated:YES];
                }
                    
                    break;
                case 2:
                    [self gotoScanVc];
                    break;
                case 3:{
                    QRCodeView*view = [[NSBundle mainBundle]loadNibNamed:@"QRCodeView" owner:self options:nil].firstObject;
                    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
                    view.qrCodeViewTyep=QRCodeViewTyep_user;
                    [view showQRCodeView];
                }
                    
                    break;
                    
            }
        };
    }
    return _menuView;
}

-(void)deleteFriendAllMessage:(ChatListModel*)listModel{
    ChatModel * config = [[ChatModel alloc]init];
    config.authorityType = AuthorityType_friend;
    config.chatID = listModel.chatID;
    config.chatType = listModel.chatType;
    NSArray*allItems=[[WCDBManager sharedManager]fetchAllMessageWihtChatModel:config];
    if (allItems.count) {
        
        [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
        [[WCDBManager sharedManager]deleteResourceWihtChatId:listModel.chatID];
        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
        [self getMessages];
        [self settingTabbarUnReadNumber];
        UserRemoveMessageRequest*request=[UserRemoveMessageRequest request];
        [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:NO];
        if ([listModel.chatType isEqualToString:GroupChat]) {
            request.groupId=listModel.chatID;
            request.type=@"GroupAll";
            request.authorityType=AuthorityType_friend;
            request.parameters=[request mj_JSONString];
            [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                WebSocketManager.sharedManager.currentChatID=@"";
            } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                
            }];
        }else if ([listModel.chatType isEqualToString:UserChat]){
            if (![listModel.chatID isEqualToString:PayHelperMessageType]&&![listModel.chatID isEqualToString:SystemHelperMessageType]) {
                request.userId=listModel.chatID;
                request.type=@"UserAll";
                request.deleteAll=true;
                request.authorityType=AuthorityType_friend;
                request.parameters=[request mj_JSONString];
                [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
                    WebSocketManager.sharedManager.currentChatID=@"";
                } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
                    
                }];
            }
         
            
        }
    }else{
        [[WCDBManager sharedManager]deleteOneChatListWithChatModel:config];
        [[WCDBManager sharedManager]deleteResourceWihtChatId:listModel.chatID];
        [[WCDBManager sharedManager]deleteAllChatModelWith:config];
        [self getMessages];
        [self settingTabbarUnReadNumber];
    }
    
    [QMUITips hideAllTips];
}
//获得当前位置 ， 上报用户当前的位置
-(void)fetchCurretnLoacationAndJudeIsNeedUpdateLocation{
    if (![UserInfoManager sharedManager].nearbyVisible) {
        [UIAlertController alertControllerWithTitle:@"Notice".icanlocalized message:@"Is it visible to nearby people?".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                [self start];
                [UserInfoManager sharedManager].nearbyVisible = YES;
            }
        }];
    }else{
        [self start];
    }
    
}

- (void)getCurrentLocation
{
    self.mapkitLocationManager = [[CLLocationManager alloc] init];
    self.mapkitLocationManager.delegate = self;
    self.mapkitLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.mapkitLocationManager.distanceFilter=kCLDistanceFilterNone;
    [self.mapkitLocationManager requestWhenInUseAuthorization];
    [self.mapkitLocationManager startMonitoringSignificantLocationChanges];
    [self.mapkitLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if ([locations firstObject]) {
        [self.mapkitLocationManager stopUpdatingLocation];
        self.currentLocation = [locations firstObject];
    }
}

-(void)start
{
    UploadUserLocationRequest * request = [UploadUserLocationRequest request];
    request.longitude = [NSString stringWithFormat:@"%f",_currentLocation.coordinate.longitude];
    request.latitude=[NSString stringWithFormat:@"%f",_currentLocation.coordinate.latitude];
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITips hideAllTips];
        FindNearbyPersonsViewController*vc=[[FindNearbyPersonsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(void)checkShouldShowBindingMobieTipsView{
    [self.tipsView removeFromSuperview];
    self.tipsView=[[NSBundle mainBundle]loadNibNamed:@"BindingTipsView" owner:self options:nil].firstObject;
    self.tipsView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    if (!UserInfoManager.sharedManager.mobile&&![UserInfoManager sharedManager].email) {
        self.tipsView.tipsLabel.text=@"Binding Prompt".icanlocalized;
        self.tipsView.contentLabel.text=@"Your account has security risks. For your account security, you need to bind your mobile phone or email account. Please do it as soon as possible.".icanlocalized;
        [self.tipsView.agreeButton setTitle:@"Go to bind".icanlocalized forState:UIControlStateNormal];
        [self.tipsView.refuseButton setTitle:@"Let me think again".icanlocalized forState:UIControlStateNormal];
        @weakify(self);
        self.tipsView.agreeBlock = ^{
            @strongify(self);
            UserBindingMobileOrEmailViewController*vc=[[UserBindingMobileOrEmailViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        self.tipsView.logoutBlock = ^{
            @strongify(self);
            self.first=NO;
            [self.tipsView removeFromSuperview];
        };
        [self.tabBarController.view insertSubview:self.tipsView aboveSubview:self.tabBarController.tabBar];
        
    }else{
        //没有设置登录密码 不强制设置
        if (![UserInfoManager sharedManager].isSetPassword) {
            self.tipsView.tipsLabel.text=@"WarmReminder".icanlocalized;
            self.tipsView.contentLabel.text=@"Your account has not yet set a password, you need to go to improve it before you can continue to use the APP".icanlocalized;
            [self.tipsView.agreeButton setTitle:@"Go to Settings".icanlocalized forState:UIControlStateNormal];
            [self.tipsView.refuseButton setTitle:@"Let me think again".icanlocalized forState:UIControlStateNormal];
            @weakify(self);
            self.tipsView.agreeBlock = ^{
                @strongify(self);
                SettingPasswordViewController*vc=[[SettingPasswordViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            self.tipsView.logoutBlock = ^{
                @strongify(self);
                [self.tipsView removeFromSuperview];
                self.first=NO;
            };
            [UIApplication.sharedApplication.keyWindow addSubview:self.tipsView];
        }
    }
}

- (void)onInvited:(NSString *)invitor userIDs:(NSArray<NSString *> *)userIDs isFromGroup:(BOOL)isFromGroup groupID:(nullable NSString *)groupID type:(NERtcCallType)type {
    //    [[AudioPlayerManager shareDZAudioPlayerManager]stopAudioPlayer]; --> According to requirements
    if (type ==NERtcCallTypeAudio) {
        [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
            [self nimCallVCWithType:type onInvited:invitor];
        } notDetermined:^{
            [self nimCallVCWithType:type onInvited:invitor];
        } failure:^{
            NSLog(@"Fail");
        }];
    }else{
        [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
            [PrivacyPermissionsTool judgeMicrophoneAuthorizationSuccess:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self nimCallVCWithType:type onInvited:invitor];
                });
            } notDetermined:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self nimCallVCWithType:type onInvited:invitor];
                });
            } failure:^{
                NSLog(@"Fail");
            }];

        } failure:^{
            NSLog(@"Fail");
        }];
    }

}

-(void)nimCallVCWithType:(NERtcCallType)type onInvited:(NSString *)invitor {
    BOOL active = UIApplication.sharedApplication.applicationState == UIApplicationStateActive;
    self.uuid = [NSUUID UUID];
    #ifdef ICANTYPE
    if(active){
            self.callVC = [[NeCallBaseViewController alloc] initWithOtherMember:invitor isCalled:YES type:type uuid:self.uuid];
            NSString *urserid = [invitor componentsSeparatedByString:@"_"].lastObject;
            DDLogInfo(@"[NERtcCallKit sharedInstance].authorityType=%@",[NERtcCallKit sharedInstance].authorityType);
            if ([[NERtcCallKit sharedInstance].authorityType isEqualToString:AuthorityType_circle]) {
                [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithCircleUserId:[NERtcCallKit sharedInstance].circleUserId successBlock:^(CircleUserInfo * _Nonnull info) {
                    self.callVC.avtar = info.avatar;
                    CXHandle *callHandle = [[CXHandle alloc] initWithType:CXHandleTypeGeneric value:invitor];
                    [AppDelegate shared].callUpdate = [[CXCallUpdate alloc]init];
                    [AppDelegate shared].callUpdate.remoteHandle = callHandle;
                    [AppDelegate shared].callUpdate.localizedCallerName = info.nickname;
                    [AppDelegate shared].callUpdate.supportsHolding = NO;
                    [AppDelegate shared].callUpdate.supportsGrouping = NO;
                    [AppDelegate shared].callUpdate.supportsUngrouping = NO;
                    CXProviderConfiguration *config = [[CXProviderConfiguration alloc] initWithLocalizedName:@"My App"];
                    config.maximumCallsPerCallGroup = 1;
                    config.maximumCallGroups = 1;
                    config.iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:@"callIcon"]);
                    config.includesCallsInRecents = YES;
                    config.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypeGeneric)];
                    if(type == NERtcCallTypeAudio){
                        config.supportsVideo = NO;
                        [AppDelegate shared].callUpdate.hasVideo = NO;
                    } else{
                        config.supportsVideo = YES;
                        [AppDelegate shared].callUpdate.hasVideo = YES;
                    }
                    CXStartCallAction *startCallAction = [[CXStartCallAction alloc] initWithCallUUID:self.uuid handle:callHandle];
                    [AppDelegate shared].provider = [[CXProvider alloc]initWithConfiguration:config];
                    [[AppDelegate shared].provider setDelegate:self queue:nil];
                    [[AppDelegate shared].provider reportNewIncomingCallWithUUID:[AppDelegate shared].callKitID  update:[AppDelegate shared].callUpdate completion:^(NSError * _Nullable error) {
                        if (@available(iOS 11.0, *)) {
                            [[AppDelegate shared].callController requestTransactionWithActions:@[startCallAction] completion:^(NSError * _Nullable error) {
                                if (error) {
                                    // Handle error
                                } else {
                                    // Call connected successfully
                                }
                            }];
                        } else {
                            // Fallback on earlier versions
                        }
                    }];
                    [AppDelegate shared].callController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
                }];
            }else {
                [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:urserid successBlock:^(UserMessageInfo * _Nonnull info) {
                    self.callVC.nickname = info.remarkName?:info.nickname;
                    self.callVC.avtar = info.headImgUrl;
                    self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
                    CXHandle *callHandle = [[CXHandle alloc] initWithType:CXHandleTypeGeneric value:invitor];
                    [AppDelegate shared].callUpdate = [[CXCallUpdate alloc]init];
                    [AppDelegate shared].callUpdate.remoteHandle = callHandle;
                    [AppDelegate shared].callUpdate.localizedCallerName = info.remarkName?:info.nickname;
                    [AppDelegate shared].callUpdate.supportsHolding = NO;
                    [AppDelegate shared].callUpdate.supportsGrouping = NO;
                    [AppDelegate shared].callUpdate.supportsUngrouping = NO;
                    CXProviderConfiguration *config = [[CXProviderConfiguration alloc] initWithLocalizedName:@"My App"];
                    config.maximumCallsPerCallGroup = 1;
                    config.maximumCallGroups = 1;
                    config.iconTemplateImageData = UIImagePNGRepresentation([UIImage imageNamed:@"callIcon"]);
                    config.includesCallsInRecents = YES;
                    config.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypeGeneric)];
                    if(type == NERtcCallTypeAudio){
                        config.supportsVideo = NO;
                        [AppDelegate shared].callUpdate.hasVideo = NO;
                    } else{
                        config.supportsVideo = YES;
                        [AppDelegate shared].callUpdate.hasVideo = YES;
                    }
                    CXStartCallAction *startCallAction = [[CXStartCallAction alloc] initWithCallUUID:self.uuid handle:callHandle];
                    [AppDelegate shared].provider = [[CXProvider alloc]initWithConfiguration:config];
                    [[AppDelegate shared].provider setDelegate:self queue:nil];
                    [[AppDelegate shared].provider reportNewIncomingCallWithUUID:self.uuid  update:[AppDelegate shared].callUpdate completion:^(NSError * _Nullable error) {
                        if (@available(iOS 11.0, *)) {
                            [[AppDelegate shared].callController requestTransactionWithActions:@[startCallAction] completion:^(NSError * _Nullable error) {
                                if (error) {
                                    // Handle error
                                } else {
                                    // Call connected successfully
                                }
                            }];
                        } else {
                            // Fallback on earlier versions
                        }
                    }];
                    [AppDelegate shared].callController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
                }];
            }
        }
    #else
    BOOL backGroud = UIApplication.sharedApplication.applicationState == UIApplicationStateBackground;
    self.callVC = [[NeCallBaseViewController alloc] initWithOtherMember:invitor isCalled:YES type:type uuid:[AppDelegate shared].callKitID];
    NSString*urserid=[invitor componentsSeparatedByString:@"_"].lastObject;
    DDLogInfo(@"[NERtcCallKit sharedInstance].authorityType=%@",[NERtcCallKit sharedInstance].authorityType);
    if ([[NERtcCallKit sharedInstance].authorityType isEqualToString:AuthorityType_circle]) {
        [[WCDBManager sharedManager]fetchCircleCacheUserInfoWithCircleUserId:[NERtcCallKit sharedInstance].circleUserId successBlock:^(CircleUserInfo * _Nonnull info) {
            self.callVC.nickname = info.nickname;
            if (backGroud) {
                [LocalNotificationManager setLacalAvdioOrAudioNotificationWithMediaType:type == NERtcCallTypeVideo?@"VIDEO":@"AUDIO"  user:self.callVC.nickname];
            }
            self.callVC.avtar = info.avatar;
            self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController presentViewController:self.callVC animated:YES completion:nil];
        }];
    }else{
        [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:urserid successBlock:^(UserMessageInfo * _Nonnull info) {
            self.callVC.nickname = info.remarkName?:info.nickname;
            if (backGroud) {
                [LocalNotificationManager setLacalAvdioOrAudioNotificationWithMediaType:type == NERtcCallTypeVideo?@"VIDEO":@"AUDIO"  user:self.callVC.nickname];
            }
            self.callVC.avtar = info.headImgUrl;
            self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController presentViewController:self.callVC animated:YES completion:nil];
        }];
    }
    #endif
}

- (void)onUserCancel:(NSString *)userID {
    [[NERtcCallKit sharedInstance] hangup:nil];
    #ifdef ICANTYPE
    if(self.uuid != nil){
        CXEndCallAction *endCallAction = [[CXEndCallAction alloc] initWithCallUUID:self.uuid];
        CXTransaction *transaction = [[CXTransaction alloc] initWithAction:endCallAction];
        [[AppDelegate shared].callController requestTransaction:transaction completion:^(NSError * _Nullable error) {
            if (error) {
                // Handle any errors
            } else{
                //Handle success
            }
        }];
        [[AppDelegate shared].provider reportCallWithUUID:self.uuid endedAtDate:[NSDate date] reason:CXCallEndedReasonRemoteEnded];
    }
    #endif
}

#ifdef ICANTYPE
- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action {
    self.callVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:self.callVC animated:YES completion:nil];
    [self.callVC  acceptBtnAction];
    [action fulfill];
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action {
    [self.callVC refuseBtnAction];
    [action fulfill];
}

- (void)providerDidReset:(nonnull CXProvider *)provider {
    NSLog(@"Provider");
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    NSLog(@"Provider");
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    NSLog(@"Provider");
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    NSLog(@"Provider");
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    NSLog(@"Provider");
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"Provider");
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"Provider");
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    NSLog(@"Provider");
}

- (void)setNeedsFocusUpdate {
    NSLog(@"Provider");
}

- (void)updateFocusIfNeeded {
    NSLog(@"Provider");
}
#endif

@end
