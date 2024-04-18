//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 12/10/2019
 - File name:  FindTableViewController.m
 - Description:
 - Function List:
 */


#import "FindTableViewController.h"
#import "GroupListViewController.h"
#import "ChatListMenuView.h"
#import "CoinsTableViewController.h"
#import "PrivacyPermissionsTool.h"
#import "UITabBar+Extension.h"
#import "CircleOssWrapper.h"
#import "WCDBManager+ChatList.h"
#import "QRCodeController.h"
#import "FindNearbyPersonsViewController.h"
#import "UtilityPaymentsViewController.h"
#import "CircleHomeListViewController.h"
#ifdef ICANTYPE
#import "iCan_我行-Swift.h"
#else
#import "ICanCN-Swift.h"
#endif
#import <CoreLocation/CoreLocation.h>
#import "CommonWebViewController.h"
#import "C2CTabBarViewController.h"
#import "C2COssWrapper.h"
#import "TelecomListViewController.h"
#import "FindMoreTableViewController.h"
#import "UtilityPaymentsViewController.h"
#import "RechargeViewController.h"
#import "SelectTransferTypePopView.h"
#import "ReceiptMoneyViewController.h"
#import "PayMentAgreementView.h"
#import "PayMoneyInputViewController.h"
#import "SettingPaymentPasswordViewController.h"
#import "CertificationViewController.h"
#import "EmailBindingViewController.h"
#import "BusinessListViewController.h"
#import "BussinessInfoManager.h"
#import "BusinessNetworkReqManager.h"
#import "FavoriteContactTableViewCell.h"
#import "WCDBManager+ChatModel.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "ChatUtil.h"
#import "FriendDetailViewController.h"
#import "NewFriendsViewController.h"
#import "FriendListTableViewController.h"
#import "AddFriendsViewController.h"
#import "QRCodeView.h"
#import "SecretChatListViewController.h"
#import "QDNavigationController.h"
#import "MyInfoViewController.h"
@interface FindTableViewController ()<UIScrollViewDelegate, CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet QMUITextField *searchTextFiled;

@property (weak, nonatomic) IBOutlet UILabel *hangqingLab;
@property (weak, nonatomic) IBOutlet UILabel *jioayiLab;
@property (weak, nonatomic) IBOutlet UILabel *nftLab;
@property (weak, nonatomic) IBOutlet UILabel *licaiLab;
@property (weak, nonatomic) IBOutlet UILabel *huafeiLab;
@property (weak, nonatomic) IBOutlet UILabel *jiaofeiLab;
@property (weak, nonatomic) IBOutlet UILabel *circleLab;
///物流
@property (weak, nonatomic) IBOutlet UILabel *logisticsLab;
@property (weak, nonatomic) IBOutlet UILabel *estateLab;
@property (weak, nonatomic) IBOutlet UILabel *stockLab;
@property (weak, nonatomic) IBOutlet UILabel *moreLab;
@property (weak, nonatomic) IBOutlet UILabel *walletLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *topTittlelab;


@property(nonatomic, strong) NSArray *resultItems;
@property(nonatomic, strong) NSString *addressW;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, assign)  NSInteger unReadAmount;
@property (weak, nonatomic) IBOutlet DZIconImageView *profilePicImage;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navbarHeight;
@property (weak, nonatomic) IBOutlet UIImageView *cntImgView;
@property (weak, nonatomic) IBOutlet UIControl *cntActionView;
@property(nonatomic, strong) SelectTransferTypePopView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *businsessImg;
@property (weak, nonatomic) IBOutlet UILabel *businessLbl;
@property(nonatomic,strong)  NSMutableArray<UserMessageInfo *> *friendItem;
@property (weak, nonatomic) IBOutlet UILabel *secretUnredLabel;
@property(nonatomic, strong)  NSMutableArray <UserRecommendListInfo *>* itemlist;
@property (weak, nonatomic) IBOutlet UIButton *hiddenBanlanceBtn;
@property (nonatomic, strong) NSString *totalNumber;
@end

@implementation FindTableViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getFriendDetailRequest];
    [self getCircleUnreadCount];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCircleUnreadCount) name:KChatListRefreshNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCicleToken) name:kCancelCircleUserNotificatiaon object:nil];
    self.view.backgroundColor=UIColorBg243Color;
    self.cntImgView.hidden = YES;
    self.logisticsLab.hidden = YES;
    self.cntActionView.enabled = NO;
    self.topTittlelab.text = @"iCanbalanceD".icanlocalized;
    #ifdef ICANCNTYPE
    self.cntImgView.image = [UIImage imageNamed:@"icon_cnt"];
    self.logisticsLab.text = @"CNT".icanlocalized;
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        self.cntActionView.enabled = YES;
        self.cntImgView.hidden = NO;
        self.logisticsLab.hidden = NO;
    }else {
        self.cntImgView.hidden = YES;
        self.logisticsLab.hidden = YES;
        self.cntActionView.enabled = NO;
    }
    #endif
    if ([CircleUserInfoManager.shared.icanId isEqualToString:UserInfoManager.sharedManager.userId]&&CircleUserInfoManager.shared.token) {
        [self getCircleOssTokenRequest];
        [self getAllprofessionRequest];
        [self fetchCircleCurretnLoacationAndJudeIsNeedUpdateLocation];
    }
    NSLog(@"%@",[BussinessInfoManager shared].token);
    if([BussinessInfoManager shared].token){
        [self getCircleOssTokenRequest];
        [self getAllprofessionRequest];
        [self fetchCircleCurretnLoacationAndJudeIsNeedUpdateLocation];
    }
    NSInteger secretUnReadMsgNumber = [[WCDBManager sharedManager]fetchAllSecretUnReadNumberCount].integerValue;
    [self setSecretUnreadCount:secretUnReadMsgNumber];
    self.titleLabel.text = @"tabbar.discover".icanlocalized;
    self.searchTextFiled.placeholder = @"Search".icanlocalized;
    self.navbarHeight.constant = StatusBarAndNavigationBarHeight;
    self.hangqingLab.text = @"Top Up".icanlocalized;
    self.jioayiLab.text = @"Transfer".icanlocalized;
    self.nftLab.text = @"Receive".icanlocalized;
    self.licaiLab.text = @"payment".icanlocalized;
    self.huafeiLab.text = @"CallFee".icanlocalized;
    self.jiaofeiLab.text = @"Payment".icanlocalized;
    self.circleLab.text = @"Friendship".icanlocalized;
    self.estateLab.text = @"RealEstate".icanlocalized;
    self.stockLab.text = @"Market".icanlocalized;
    self.moreLab.text = @"mine.profile.title.more".icanlocalized;
    self.businessLbl.text = @"Business".icanlocalized;
    [self getCurrentLocation];
    [self getFriendDetailRequest];
    [self initCollectionView];
    [self getFriendsListRequest];
    [self fetchUserRecommendRequest];
    UITapGestureRecognizer *mineGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mineAction)];
    [self.profilePicImage addGestureRecognizer:mineGesture];
    self.profilePicImage.userInteractionEnabled = YES;
}

-(void)mineAction{
    if ([UserInfoManager sharedManager].loginStatus) {
        [[AppDelegate shared]pushViewController:[MyInfoViewController new] animated:YES];
    }else{
        [BaseSettingManager resetAppToLoginViewControllershowOtherLoginTips:NO tips:@""];
    }
}

- (IBAction)moreAction:(id)sender {
    if (self.friendItem.count < 5) {
        NewFriendsViewController *newFriendsVC = [[NewFriendsViewController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:newFriendsVC animated:YES];
    }else {
        [[AppDelegate shared] pushViewController:[FriendListTableViewController new] animated:YES];
    }
}

- (IBAction)flightAct:(id)sender {
}

-(void)getFriendsListRequest {
    GetFriendsListRequest *request = [GetFriendsListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserMessageInfo class] success:^(NSArray<UserMessageInfo *>* response) {
        self.friendItem = [NSMutableArray arrayWithArray:response];
        [self.collectionView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

-(void)fetchUserRecommendRequest{
    GertUserRecommendRequest *request = [GertUserRecommendRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserRecommendListInfo class] success:^(NSArray *response) {
        self.itemlist = [NSMutableArray arrayWithArray:response];
        [self.collectionView reloadData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

-(void)getFriendDetailRequest{
    GetUserMessageRequest *request = [GetUserMessageRequest request];
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserMessageInfo class] contentClass:[UserMessageInfo class] success:^(UserMessageInfo *response) {
        self.titleLabel.text = [NSString stringWithFormat:@"Hi,%@",response.nickname];
        if(response.headImgUrl) {
            [self.profilePicImage sd_setImageWithURL:[NSURL URLWithString:response.headImgUrl]];
        }else {
            [self.profilePicImage setImageWithString:response.headImgUrl placeholder:[response.gender isEqualToString:@"2"]?GirlDefault:BoyDefault];
        }
        self.balanceLabel.text = [NSString stringWithFormat:@"%@",[response.balance calculateByNSRoundDownScale:2].currencyString];
        self.totalNumber = [NSString stringWithFormat:@"%@",[response.balance calculateByNSRoundDownScale:2].currencyString];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

- (IBAction)hiddenBanlanceAction {
    self.hiddenBanlanceBtn.selected = !self.hiddenBanlanceBtn.selected;
    if (self.hiddenBanlanceBtn.selected) {
        self.balanceLabel.text = @"*****";
    }else {
        self.balanceLabel.text =  self.totalNumber;
    }
}

-(void)initCollectionView{
    [self.collectionView registNibWithNibName:KFavoriteContactTableViewCell];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (BOOL)preferredNavigationBarHidden {
    return YES;
}

- (IBAction)cntAction{
    UIStoryboard *board;
    board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
    WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
    View.isCnt = YES;
    View.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:View animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (IBAction)rechargeAction{
// I have commented below lines due to future enhancement
//    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
//        RechargeViewController*vc = [[RechargeViewController alloc]init];
//        [[AppDelegate shared]pushViewController:vc animated:YES];
//    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authing"]) {
//        [QMUITipsTool showOnlyTextWithMessage:@"RealnameAuthingTip".icanlocalized inView:self.view];
//    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"NotAuth"]) {
//        [UIAlertController alertControllerWithTitle:@"RealnameNoAuthTip".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
//            if (index==1) {
//                CertificationViewController *vc =[[CertificationViewController alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        }];
//
//    }
    UIStoryboard *board;
    board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
    WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
    View.isCnt = YES;
    View.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:View animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (IBAction)transferAction{
    [self.popView showView];
}

- (IBAction)collectionAction{
    
    if ([UserInfoManager sharedManager].openPay) {
        if ([UserInfoManager sharedManager].isSetPayPwd) {
            UserConfigurationInfo*info= [BaseSettingManager sharedManager].userConfigurationInfo;
            if (info.isAgreePayment) {
                ReceiptMoneyViewController * vc = [ReceiptMoneyViewController new];
                [[AppDelegate shared] pushViewController:vc animated:YES];
            }else{
                PayMentAgreementView*view=[[PayMentAgreementView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                view.agreeBlock = ^{
                    ReceiptMoneyViewController * vc = [ReceiptMoneyViewController new];
                    [[AppDelegate shared] pushViewController:vc animated:YES];
                };
                [[UIApplication sharedApplication].delegate.window addSubview:view];
            }
        }else{
            [UIAlertController alertControllerWithTitle:@"PleaseSetAPaymentPassword".icanlocalized message:nil target:self preferredStyle:(UIAlertControllerStyleAlert) actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index==1) {
                    if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                        EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }else{
                        SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }
            }];
        }
        
    }else{
        [QMUITipsTool showErrorWihtMessage:@"PaymentFunctionIsClosed".icanlocalized inView:nil];
    }
    
}

- (IBAction)payAction{
    if ([UserInfoManager sharedManager].openPay) {
        if ([UserInfoManager sharedManager].isSetPayPwd) {
            UserConfigurationInfo*info= [BaseSettingManager sharedManager].userConfigurationInfo;
            if (info.isAgreePayment) {
                PayMoneyInputViewController * vc = [PayMoneyInputViewController new];
                [[AppDelegate shared] pushViewController:vc animated:YES];
            }else{
                PayMentAgreementView*view=[[PayMentAgreementView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                view.agreeBlock = ^{
                    PayMoneyInputViewController * vc = [PayMoneyInputViewController new];
                    [[AppDelegate shared] pushViewController:vc animated:YES];
                };
                [[UIApplication sharedApplication].delegate.window addSubview:view];
            }
        }else{
            [UIAlertController alertControllerWithTitle:@"PleaseSetAPaymentPassword".icanlocalized message:nil target:self preferredStyle:(UIAlertControllerStyleAlert) actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                if (index==1) {
                    if(![UserInfoManager sharedManager].isEmailBinded && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                        EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }else{
                        SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                        [[AppDelegate shared]pushViewController:vc animated:YES];
                    }
                }
            }];
        }
        
    }else{
        [QMUITipsTool showErrorWihtMessage:@"PaymentFunctionIsClosed".icanlocalized inView:nil];
    }
}

- (IBAction)hangqingAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}

- (IBAction)jioayiAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}

- (IBAction)nftAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}

- (IBAction)licaiAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}

- (IBAction)shopAction{
    NSString*blockStr=[NSString stringWithFormat:@"icanStore://type=openMall"];
    NSURL*url=[NSURL URLWithString:blockStr.netUrlEncoded];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }else{
        UIStoryboard *board;
        board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
        WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
        View.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:View animated:YES];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
}

- (IBAction)huafeiAction{
    UtilityPaymentsViewController*vc=[UtilityPaymentsViewController new];
    vc.dialogClass=@"Telecom";
    vc.titleName=@"CallFee".icanlocalized;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)jiaofeiAction{
    UtilityPaymentsViewController*vc=[UtilityPaymentsViewController new];
    vc.dialogClass=@"OtherUtility";
    vc.titleName = @"Payment".icanlocalized;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)circleAction{
    //如果聊天登录用户的ID等于交友的icanId 那么判断本地是否存在token 如果存在token 那么不再获取token
    if ([CircleUserInfoManager.shared.icanId isEqualToString:UserInfoManager.sharedManager.userId]&&CircleUserInfoManager.shared.token) {
        CircleHomeListViewController * vc = [CircleHomeListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self getCicleToken];
    }
}

- (IBAction)wuliuAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}

- (IBAction)fangdichangAction{
    UIStoryboard *board;
    board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
    WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
    View.isProperty = YES;
    View.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:View animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (IBAction)gupiaoAction{
    [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
}

- (IBAction)moreAction{
    
    [self.navigationController pushViewController:[FindMoreTableViewController new] animated:YES];
}

- (IBAction)marketaction:(id)sender {
    CoinsTableViewController *vc = [CoinsTableViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag == 0) {
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
                    QRCodeView *view = [[NSBundle mainBundle]loadNibNamed:@"QRCodeView" owner:self options:nil].firstObject;
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
                    break;
            }
        }];
    }else if(sender.tag == 1) {
        [self fetchCurretnLoacationAndJudeIsNeedUpdateLocation ];
    }else {
        //ican AI
        ChatModel *chatModel = [[ChatModel alloc]init];
        chatModel.chatID = @"100";
        chatModel.chatType = UserChat;
        UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
        [[AppDelegate shared] pushViewController:vc animated:YES];
    }
}

-(void)addGroudClick{
    GroupListViewController *vc = [GroupListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)gotoScanVc {
    QRCodeController *friendsVC = [[QRCodeController alloc]init];
    [self.navigationController pushViewController:friendsVC animated:YES];
}

-(void)setSecretUnreadCount:(NSInteger)secretUnreadCount{
    if (secretUnreadCount == 0) {
        self.secretUnredLabel.hidden = YES;
    }else {
        self.secretUnredLabel.hidden = NO;
        if (secretUnreadCount > 9 && secretUnreadCount <= 99) {
            self.secretUnredLabel.text = [NSString stringWithFormat:@"%ld",(long)secretUnreadCount];
            [self.secretUnredLabel layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
        }else if (secretUnreadCount > 99) {
            self.secretUnredLabel.text = @"··";
            [self.secretUnredLabel layerWithCornerRadius:10 borderWidth:0 borderColor:nil];
        } else {
            [self.secretUnredLabel layerWithCornerRadius:9 borderWidth:0 borderColor:nil];
            self.secretUnredLabel.text = [NSString stringWithFormat:@"%ld",(long)secretUnreadCount];
        }
    }
}

-(void)getCircleUnreadCount{
    self.unReadAmount= [[WCDBManager sharedManager]fetchAllCircleUnReadNumberCount].integerValue;
    [self setFindTabbarUnReadBage:self.unReadAmount resultCount:self.resultItems.count];
}

-(void)setFindTabbarUnReadBage:(NSInteger)unReadAmount resultCount:(NSInteger)resultCount {
    if (unReadAmount==0&&resultCount==0) {
        [self.tabBarController.tabBar removeBadgeOnItemIndex:1];
    }else{
        [self.tabBarController.tabBar showBadgeOnItmIndex:1 tabbarNum:5];
    }
}

-(SelectTransferTypePopView *)popView{
    if (!_popView) {
        _popView = [[NSBundle mainBundle]loadNibNamed:@"SelectTransferTypePopView" owner:self options:nil].firstObject;
        _popView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }
    return _popView;
}
/** 上传用户位置 */
- (void)fetchCurretnLoacationAndJudeIsNeedUpdateLocation {
    [QMUITipsTool showOnlyLodinginView:self.view isAutoHidden:YES];
    [PrivacyPermissionsTool judgeLocationAuthorizationSuccess:^{
        [self uploadChatPoiRequest:self.currentLocation];
    } failure:^{
        [QMUITips hideAllTips];
    }];
}

- (void)fetchCircleCurretnLoacationAndJudeIsNeedUpdateLocation {
    [PrivacyPermissionsTool judgeLocationAuthorizationSuccess:^{
        [self uploadCirclePoiRequest:self.currentLocation];
        [self uploadBusinessPoiRequest:self.currentLocation];
    } failure:^{
        [QMUITips hideAllTips];
    }];
}

- (void)uploadChatPoiRequest:(CLLocation*)location {
    UploadUserLocationRequest *request = [UploadUserLocationRequest request];
    request.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    request.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITips hideAllTips];
        FindNearbyPersonsViewController *vc = [[FindNearbyPersonsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

- (void)uploadCirclePoiRequest:(CLLocation*)location {
    PutCircleUserPOIRequest * crequest = [PutCircleUserPOIRequest request];
    crequest.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    crequest.latitude=[NSString stringWithFormat:@"%f", location.coordinate.latitude];
    crequest.parameters = [crequest mj_JSONString];
    [[CircleNetRequestManager shareManager]startRequest:crequest responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

- (void)uploadBusinessPoiRequest:(CLLocation*)location {
    PutBusinessUserPOIRequest * crequest = [PutBusinessUserPOIRequest request];
    crequest.longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    crequest.latitude=[NSString stringWithFormat:@"%f", location.coordinate.latitude];
    crequest.parameters = [crequest mj_JSONString];
    [[BusinessNetworkReqManager shareManager]startRequest:crequest responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}

- (void)getCurrentLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if ([locations firstObject]) {
        [self.locationManager stopUpdatingLocation];
        self.currentLocation = [locations firstObject];
    }
}

-(void)getCicleToken{
    GetCircleTokenRequest*request=[GetCircleTokenRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetCircleToeknInfo class] contentClass:[GetCircleToeknInfo class] success:^(GetCircleToeknInfo* response) {
        [CircleUserInfoManager shared].token=response.token;
        [self getCircleOssTokenRequest];
        [self getAllprofessionRequest];
        [self fetchCircleCurretnLoacationAndJudeIsNeedUpdateLocation];
        CircleHomeListViewController * vc = [CircleHomeListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
-(void)getCircleOssTokenRequest{
    GetCircleOssRequest*request=[GetCircleOssRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[OSSSecurityTokenInfo class] contentClass:[OSSSecurityTokenInfo class] success:^(OSSSecurityTokenInfo* response) {
        [CircleOssWrapper shared].bucket=response.bucket;
        [CircleOssWrapper shared].urlBegin=response.urlBegin;
        OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
        cfg.maxRetryCount = 10;
        cfg.timeoutIntervalForRequest = 15;
        cfg.isHttpdnsEnable = NO;
        cfg.crc64Verifiable = YES;
        OSSFederationToken*token = [OSSFederationToken new];
        token.tAccessKey = response.credentials.accessKeyId;
        token.tSecretKey = response.credentials.accessKeySecret;
        token.tToken = response.credentials.securityToken;
        token.expirationTimeInGMTFormat = response.credentials.expiration;
        OSSStsTokenCredentialProvider *provider = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:token.tAccessKey secretKeyId:token.tSecretKey securityToken:token.tToken];
        OSSClient *defaultClient = [[OSSClient alloc] initWithEndpoint:response.ossEndpoint credentialProvider:provider clientConfiguration:cfg];
        [CircleOssWrapper shared].defaultClient = defaultClient;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
//获取职业
-(void)getAllprofessionRequest{
    GetProfessionsRequest*request=[GetProfessionsRequest request];
    [[CircleNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[ProfessionInfo class] success:^(NSArray<ProfessionInfo*>* response) {
        CircleUserInfoManager.shared.professionArray=response;
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}

- (IBAction)businessAction:(id)sender {
    if([BussinessInfoManager shared].token && [[NSString stringWithFormat:@"%ld", (long)[BussinessInfoManager shared].icanId] isEqualToString:UserInfoManager.sharedManager.userId]){
        NSLog(@"%@",[BussinessInfoManager shared].token);
        BusinessListViewController * vc = [BusinessListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self getBusinessToken];
    }
}

- (void)getBusinessToken{
    GetCircleTokenRequest *request=[GetCircleTokenRequest request];
    request.type = 2;
    request.parameters = [request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[GetCircleToeknInfo class] contentClass:[GetCircleToeknInfo class] success:^(GetCircleToeknInfo* response) {
        [BussinessInfoManager shared].token=response.token;
        [self getCicleToken];
        BusinessListViewController * vc = [BusinessListViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.friendItem.count < 5 ? self.itemlist.count : self.friendItem.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteContactTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KFavoriteContactTableViewCell forIndexPath:indexPath];
    if (self.friendItem.count < 5) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.itemlist[indexPath.row].headImgUrl] placeholderImage:[self.itemlist[indexPath.row].gender isEqualToString:@"2"]?[UIImage imageNamed:GirlDefault]:[UIImage imageNamed:BoyDefault]];
        cell.nameLabel.text = self.itemlist[indexPath.row].nickname;
    }else {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.friendItem[indexPath.row].headImgUrl] placeholderImage:[self.friendItem[indexPath.row].gender isEqualToString:@"2"]?[UIImage imageNamed:GirlDefault]:[UIImage imageNamed:BoyDefault]];
    cell.nameLabel.text = self.friendItem[indexPath.row].nickname;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.friendItem.count < 5) {
        FriendDetailViewController *vc = [[FriendDetailViewController alloc]init];
        vc.userId = [self.itemlist objectAtIndex:indexPath.row].ID;
        vc.friendDetailType = FriendDetailType_push;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        ChatModel *chatModel  = [[ChatModel alloc]init];
        chatModel.showName = self.self.friendItem[indexPath.row].nickname;
        chatModel.chatID = self.self.friendItem[indexPath.row].userId;
        chatModel.chatType = UserChat;
        UIViewController *vc = [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75,80);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

@end                           

