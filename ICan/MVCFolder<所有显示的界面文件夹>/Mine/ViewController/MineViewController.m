#import "MineViewController.h"
#import "MySettingViewController.h"
#import "CertificationViewController.h"
#import "MyInfoViewController.h"
#import "BillPageContentViewController.h"
#import "BankCardListViewController.h"
#import "AlipayListViewController.h"
#import "ServiceTableViewController.h"
#import "QRCodeView.h"
#import "MyCollectionViewController.h"
#import "PrivacyPermissionsTool.h"
#import "UIImagePickerHelper.h"
#import "SaveViewManager.h"
#import "OSSWrapper.h"
#import "UpDownLineViewController.h"
#import "CommonWebViewController.h"
#import "FriendDetailViewController.h"
#import "QDNavigationController.h"
#import "BuyVipOrIdViewController.h"
#import "IcanWalletPageViewController.h"
#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+ChatModel.h"
#import "CTMediator+CTMediatorModuleChatActions.h"
#import "OrganizationHomeVC.h"
#import "MainPageVC.h"

@interface MineViewController ()
@property(nonatomic,strong) UserMessageInfo *userMessageInfo;
@property(nonatomic, copy)   NSString *balance;
@property(nonatomic, strong) CloudWalletBalanceInfo *cloudWalletBalanceInfo;
@property(nonatomic, strong) UserBalanceInfo *userBalanceInfo;
@property(weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *idLabel;
@property(weak, nonatomic) IBOutlet DZIconImageView *iconImageView;
@property(weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UIStackView *vipBgView;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *billLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankcardLabel;
@property (weak, nonatomic) IBOutlet UILabel *aliLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navbarHeight;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *organizationLbl;
@property (weak, nonatomic) IBOutlet UILabel *settingLabel;
@property (weak, nonatomic) IBOutlet UIControl *realNameSectionView;
@property (weak, nonatomic) IBOutlet UIImageView *verifyUserStatusImg;
@property (weak, nonatomic) IBOutlet UILabel *authStatusLbl;

@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *userIdLbl;
@property (weak, nonatomic) IBOutlet UIView *redBgView;
@property (weak, nonatomic) IBOutlet UIView *blueBgView;
@property (weak, nonatomic) IBOutlet DZIconImageView *userLogo;

@end

@implementation MineViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorBg243Color;
    self.titleLabel.text = @"tabbar.me".icanlocalized;
    self.navbarHeight.constant = StatusBarAndNavigationBarHeight;
    self.billLabel.text = @"mine.listView.cell.bill".icanlocalized;
    self.balanceLabel.text = NSLocalizedString(@"mine.listView.cell.banlance", 余额);
    self.bankcardLabel.text = NSLocalizedString(@"mine.listView.cell.bankCard", 银行卡);
    self.aliLabel.text = NSLocalizedString(@"mine.listView.cell.alipay", 支付宝);
    self.collectLabel.text = [@"mine.listView.cell.collect" icanlocalized:@"收藏"];
    self.inviteLabel.text = [@"mine.listView.cell.invite" icanlocalized:@"我的邀请"];
    self.serviceLabel.text = @"mine.listView.cell.service".icanlocalized;
    self.settingLabel.text = [@"mine.listView.cell.setting" icanlocalized:@"设置"];
    self.organizationLbl.text = @"Organization".icanlocalized;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.bgImageView addGestureRecognizer:tap];
    ViewRadius(self.iconImageView, 30);
    self.idLabel.textColor=UIColor238Color;
    
    UITapGestureRecognizer * tapQRCode = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQrCodeAction)];
    self.tapView.userInteractionEnabled = YES;
    [self.tapView addGestureRecognizer:tapQRCode];
    
    UITapGestureRecognizer * tapIcon = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIconAction)];
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:tapIcon];
    
    UITapGestureRecognizer * tapVip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVipAction)];
    [self.vipBgView addGestureRecognizer:tapVip];
    
    [self updateUserMessage];
    [self getUserInfoMessage];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserMessage) name:KUpdateUserMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserMessage) name:KBuyVIPNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserMessage) name:KBuyNumberIdNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserMessage) name:KUserAuthPassNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self realNameAuthUser];
    [self fetchUserBalance];
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET] || [CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        self.blueBgView.hidden = NO;
        self.redBgView.hidden = YES;
    }else{
        self.blueBgView.hidden = false;
        self.redBgView.hidden = true;
        self.blueBgView.hidden = YES;
        self.redBgView.hidden = NO;
    }
}

-(void)realNameAuthUser{
    self.realNameLbl.text = @"mine.profile.title.more.realName".icanlocalized;
    if (![UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"]) {
        self.realNameSectionView.hidden = NO;
        self.verifyUserStatusImg.hidden = YES;
        self.verifyUserStatusImg.image = UIImageMake(@"mine_authentication_unselect");
        self.authStatusLbl.text = @"NoAuthedUser".icanlocalized;
    }else{
        self.realNameSectionView.hidden = YES;
        self.verifyUserStatusImg.hidden = NO;
        self.verifyUserStatusImg.image = UIImageMake(@"mine_authentication_select");
        self.authStatusLbl.text = @"AuthedUser".icanlocalized;
    }
}

-(void)updateUserMessage{
    [self.iconImageView setDZIconImageViewWithUrl:[UserInfoManager sharedManager].headImgUrl gender:[UserInfoManager sharedManager].gender];
    self.nameLabel.text =  [NSString stringWithFormat:@"%@",[UserInfoManager sharedManager].nickname?:[UserInfoManager sharedManager].numberId];
    self.idLabel.text =[NSString stringWithFormat:@"ID: %@",[UserInfoManager sharedManager].numberId] ;
    if (UserInfoManager.sharedManager.diamondValid) {
        self.vipLabel.text =@"DiamondVIP".icanlocalized;
        self.vipImageView.image = UIImageMake(@"icon_buyvip_diamonds");
    }else if (UserInfoManager.sharedManager.seniorValid){
        self.vipLabel.text =@"SeniorVIP".icanlocalized;
        self.vipImageView.image = UIImageMake(@"icon_senior_hightlight");
    }else{
        self.vipLabel.text =@"Standard".icanlocalized;
        self.vipImageView.image = UIImageMake(@"icon_senior_nor");
    }
    
    self.userLogo.layer.cornerRadius = self.userLogo.size.height/2;
    [self.userLogo setDZIconImageViewWithUrl:[UserInfoManager sharedManager].headImgUrl gender:[UserInfoManager sharedManager].gender];
    self.userNameLbl.text =  [NSString stringWithFormat:@"%@",[UserInfoManager sharedManager].nickname?:[UserInfoManager sharedManager].numberId];
    self.userIdLbl.text =[NSString stringWithFormat:@"ID: %@",[UserInfoManager sharedManager].numberId] ;
}
-(void)tapAction{
    [self.navigationController pushViewController:[MyInfoViewController new] animated:YES];
}
-(void)tapVipAction{
    return;
    BuyVipOrIdViewController*vc = [[BuyVipOrIdViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)tapIconAction{
    [self showAlert];
}
-(void)tapQrCodeAction{
    QRCodeView*view = [[NSBundle mainBundle]loadNibNamed:@"QRCodeView" owner:self options:nil].firstObject;
    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    view.qrCodeViewTyep=QRCodeViewTyep_user;
    [view showQRCodeView];
}

- (IBAction)qrAction:(id)sender {
    [self tapQrCodeAction];
}

- (IBAction)copyAction:(id)sender {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.userIdLbl.text;
    [QMUITipsTool showOnlyTextWithMessage:@"CopySuccess".icanlocalized inView:self.view];
}

- (IBAction)realNameAction:(id)sender {
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authing"]) {
        [QMUITipsTool showOnlyTextWithMessage:@"RealnameAuthingTip".icanlocalized inView:self.view];
    }else if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"NotAuth"]) {
        CertificationViewController *vc =[[CertificationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)billAction{
    BillPageContentViewController*vc=[[BillPageContentViewController alloc]init];

    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)balanceAction{
    if ([UserInfoManager sharedManager].openPay) {
        IcanWalletPageViewController*walletVc = [[IcanWalletPageViewController alloc]init];
        walletVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:walletVc animated:YES];
    }else{
        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"ThisFunctionNotAvailable", 该功能暂未在线上开放) inView:nil];
    }
}
-(IBAction)bankcardAction{
    BankCardListViewController*vc=[[BankCardListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)alipayAction{
    AlipayListViewController*vc=[AlipayListViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)collectAction{
    MyCollectionViewController * vc = [[MyCollectionViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)inviteAction{
    UpDownLineViewController *upDownLineVC = [[UpDownLineViewController alloc]initWithStyle:UITableViewStyleGrouped];
    upDownLineVC.userId=[UserInfoManager sharedManager].userId;
    [self.navigationController pushViewController:upDownLineVC animated:YES];
}
-(IBAction)serviceAction{
    [self getUserServiceRequest];
}

- (IBAction)organizationAction:(id)sender {
    [self checkOrgStatus];
}

-(void)checkOrgStatus{
    GetOrganizationInfoForUserRequest *request = [GetOrganizationInfoForUserRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[OrganizationDetailsInfo class] contentClass:[OrganizationDetailsInfo class] success:^(OrganizationDetailsInfo* response){
        self.organizationInfoModel = response;
        if(self.organizationInfoModel.isInOrganization == true){
            MainPageVC *homeVc = [[MainPageVC alloc]init];
            homeVc.organizationInfoModel = self.organizationInfoModel;
            homeVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homeVc animated:YES];
        }else{
            OrganizationHomeVC *homeVc = [[OrganizationHomeVC alloc]init];
            homeVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homeVc animated:YES];
        }
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        DDLogInfo(@"error=%@",error);
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:nil];
    }];
}

-(IBAction)settingAction{
    MySettingViewController *mysettingVC = [[MySettingViewController alloc]init];
    [self.navigationController pushViewController:mysettingVC animated:YES];
}

/// 获取用户信息
-(void)getUserInfoMessage{
    [UserInfoManager.sharedManager getMineMessageRequest:^(UserMessageInfo * _Nonnull info) {
        [self updateUserMessage];
    }];
    
    
}

/// 获取用户余额
-(void)fetchUserBalance{
    UserBalanceRequest*request=[UserBalanceRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[UserBalanceInfo class] contentClass:[UserBalanceInfo class] success:^(UserBalanceInfo* response) {
        [UserInfoManager sharedManager].isEmailBinded=response.isEmailBound;
        [UserInfoManager sharedManager].mustBindEmailPayPswd=response.mustBindEmailPayPswd;
        [UserInfoManager sharedManager].tradePswdSet=response.tradePswdSet;
        self.userBalanceInfo = response;
        self.balanceAmountLabel.text = [NSString stringWithFormat:@"￥%.2f",response.balance.doubleValue];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
- (void)showAlert {
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"ChooseFromAlbum", 从相册选择)  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self selectPickFromeTZImagePicker];
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"chatView.function.camera".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self photographToSetHeaderPic];
    }];
    //    QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:NSLocalizedString(@"Save", 保存) style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    //    }];
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController addAction:action2];
    //    [alertController addAction:action4];
    [alertController showWithAnimated:YES];
    
}
//从相册选择
-(void)selectPickFromeTZImagePicker{
    [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
        [UIImagePickerHelper selectMorePictureWithTarget:self maxCount:1 minCount:1 isAllowEditing:YES pickingPhotosHandle:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            [self setHeadPicWithImage:photos.firstObject];
        } didFinishPickingPhotosWithInfosHandle:nil cancelHandle:nil pickingVideoHandle:nil pickingGifImageHandle:nil];
        
    } failure:^{
        
    }];
    
    
}
//拍照
-(void)photographToSetHeaderPic{
    
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [[UIImagePickerHelper sharedManager]photographFromImagePickerController:self isAllowEditing:YES didFinishPhotographPhotosHandle:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info) {
            
            [self setHeadPicWithImage:image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
                    [SaveViewManager saveImageToPhotos:image success:^{
                        
                    } failed:^{
                        
                    }];
                    
                } failure:^{
                    
                }];
                
            });
        }];
        
    } failure:^{
        
    }];
}

-(void)setHeadPicWithImage:(UIImage*)image{
    [QMUITipsTool showLoadingWihtMessage: NSLocalizedString(@"Setup...", 设置中...) inView:self.view isAutoHidden:NO];
    NSData*smallAlbumData=[UIImage compressImageSize:image toByte:1024*50];
    [[[OSSWrapper alloc]init] setUserHeadImageWithImage:smallAlbumData type:@"1" success:^(NSString * _Nonnull url) {
        [self setHeadPortraitWihtUrl:url];
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

-(void)setHeadPortraitWihtUrl:(NSString*)path{
    EditUserMessageRequest*request=[EditUserMessageRequest request];
    request.headImgUrl=path;
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Set up successfully", 设置成功) inView:self.view];
        [UserInfoManager sharedManager].headImgUrl=path;
        [[NSNotificationCenter defaultCenter]postNotificationName:KUpdateUserMessageNotification object:nil];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
-(void)getUserServiceRequest{
    UserServiceListRequest *request = [UserServiceListRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[CustomerServicesInfo class] contentClass:[CustomerServicesInfo class] success:^(CustomerServicesInfo* response) {
        if (response.csUserList.count > 0) {
            if (response.csUserList.count == 1) {
                ServicesInfo *info = response.csUserList[0];
//                self.userMessageInfo = [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:info.ID];
                ChatModel *chatModel   = [[ChatModel alloc]init];
                chatModel.showName = info.nickname;
                chatModel.chatID = info.ID;
                chatModel.chatType = UserChat;
                            UIViewController*vc= [[CTMediator sharedInstance]  CTMediator_viewControllerForChatViewController:@{kchatID:chatModel.chatID,kchatType:UserChat,kauthorityType:AuthorityType_friend}];
                            [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }else if (response.csWebList.count > 0){
            if (response.csWebList.count == 1) {
                CommonWebViewController *vc = [CommonWebViewController new];
                ServicesInfo *info = response.csWebList[0];
                vc.urlString = info.linkUrl;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
        }else{
            return;
        }
        ServiceTableViewController *serviceVC = [[ServiceTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        serviceVC.info = response;
        [self.navigationController pushViewController:serviceVC animated:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
}
@end

