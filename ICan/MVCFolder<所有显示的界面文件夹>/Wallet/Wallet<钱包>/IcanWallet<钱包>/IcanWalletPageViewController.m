//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  IcanWalletPageViewController.m
- Description:
- Function List:
*/
        

#import "IcanWalletPageViewController.h"
#import "QDNavigationController.h"
#import "WalletViewController.h"
#import "ExchangeCurrencyListViewController.h"
#import "ExchangeCurrencyViewController.h"
#import "ChatListMenuView.h"
#import "QRCodeController.h"
#import "PayMentAgreementView.h"
#import "ReceiptMoneyViewController.h"
#import "SettingPaymentPasswordViewController.h"
#import "PayMoneyInputViewController.h"
#import "PrivacyPermissionsTool.h"
#import "WalletBalanceViewController.h"
#import "CertificationViewController.h"
#import "C2CTabBarViewController.h"
#import "ViewWatchWalletDetails.h"
#import "EmailBindingViewController.h"
#import "NewWalletViewController.h"
#import "CoinsTableViewController.h"

@interface IcanWalletPageViewController ()
@property(nonatomic, strong) NSArray *titleItems;
@property(nonatomic, weak) IBOutlet UIButton *leftArrowButton;
///资产
@property(nonatomic, weak) IBOutlet UIButton *assetButton;
@property(nonatomic, weak) IBOutlet UILabel *assetLabel;
///钱包
@property (weak, nonatomic) IBOutlet UIControl *walletBgCon;
@property(nonatomic, weak) IBOutlet UIButton *walletButton;
@property(nonatomic, weak) IBOutlet UILabel *walletLabel;
///证券
@property (weak, nonatomic) IBOutlet UIControl *c2cBgCon;
@property(nonatomic, weak) IBOutlet UIButton *securityButton;
@property(nonatomic, weak) IBOutlet UILabel *securityLabel;
///余额宝
@property(nonatomic, weak) IBOutlet UIButton *yebButton;
@property(nonatomic, weak) IBOutlet UILabel *yebLabel;
@property (weak, nonatomic) IBOutlet UIControl *yebBgCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yebLeading;

@property(nonatomic, weak) IBOutlet UILabel *countryCodeLabel;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backBtnTop;


@property(nonatomic, strong) WalletBalanceViewController *walletCapitalVc;
@property(nonatomic, strong) WalletViewController *walletVc;
@property(nonatomic, strong) ViewWatchWalletDetails *watchListVc;
@property(nonatomic, strong) NewWalletViewController *walletNewVc;
@property(nonatomic, strong) CoinsTableViewController *coinMarketVc;
@property(nonatomic, strong) NSArray<ExternalWalletsInfo *> *externalWallets;

@end

@implementation IcanWalletPageViewController
-(IBAction)assetAction{
    self.walletCapitalVc.view.hidden = NO;
    self.watchListVc.view.hidden = YES;
    self.walletNewVc.view.hidden = YES;
    self.walletVc.view.hidden = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:KRefreshCurrencyValuesNotification object:nil userInfo:nil];
    self.walletVc.view.hidden = YES;
    self.assetButton.selected = YES;
    self.walletButton.selected = NO;
    self.assetLabel.textColor = UIColorMakeHEXCOLOR(0Xffffff);
    self.walletLabel.textColor = UIColorMakeHEXCOLOR(0Xccdef3);
    self.securityButton.selected = NO;
    self.securityLabel.textColor  = UIColorMakeHEXCOLOR(0Xccdef3);
}
-(IBAction)walletAction{
    self.walletCapitalVc.view.hidden = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:KRefreshCurrencyValuesNotification object:nil userInfo:nil];
    C2CGetCurrentUserInfoRequest *request = [C2CGetCurrentUserInfoRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2CUserInfo class] contentClass:[C2CUserInfo class] success:^(C2CUserInfo*  _Nonnull response) {
        self.externalWallets = response.externalWallets;
        if (self.externalWallets.count > 0) {
            for (ExternalWalletsInfo *walletInfo in self.externalWallets) {
                if (walletInfo.externalWalletId > 0 && walletInfo.walletAddress != nil) {
                    self.walletNewVc.view.hidden = YES;
                    self.walletVc.view.hidden = NO;
                    break;
                }else if (walletInfo.externalWalletId > 0 && walletInfo.walletAddress == nil){
                    NSLog(@"Wallet ID is not nil and address is nil");
                    self.walletNewVc.view.hidden = NO;
                    self.walletNewVc.coverImg.image = [UIImage imageNamed:@"creating_wallet_icon"];
                    self.walletNewVc.titleLab.text = @"Creating Your Secure Wallet...";
                    if ([walletInfo.channelCode isEqual:@"TRC20"]) {
                        self.walletNewVc.trcBtn.hidden = YES;
                    }else {
                        self.walletNewVc.ercBtn.hidden = YES;
                    }
                    self.walletVc.view.hidden = YES;
                }
            }
        }else {
            self.walletNewVc.view.hidden = NO;
            self.walletVc.view.hidden = YES;
        }
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
    self.assetButton.selected = NO;
    self.walletButton.selected = YES;
    self.securityButton.selected = NO;
    self.securityLabel.textColor  = UIColorMakeHEXCOLOR(0Xccdef3);
    self.assetLabel.textColor  = UIColorMakeHEXCOLOR(0Xccdef3);
    self.walletLabel.textColor =UIColorMakeHEXCOLOR(0Xffffff);
}
///C2C
-(IBAction)securityAction{
//    self.assetButton.selected = NO;
//    self.walletButton.selected = NO;
//    self.securityButton.selected = YES;
//    self.assetLabel.textColor  = UIColorMakeHEXCOLOR(0Xccdef3);
//    self.walletLabel.textColor = UIColorMakeHEXCOLOR(0Xccdef3);
//    self.securityLabel.textColor = UIColorMakeHEXCOLOR(0Xffffff);
    C2CTabBarViewController * vc = [[C2CTabBarViewController alloc]init];
    vc.shoulPopToRoot = NO;
    [self.navigationController pushViewController:vc animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:KRefreshCurrencyValuesNotification object:nil userInfo:nil];
}
-(IBAction)yebAction{
    ViewWatchWalletDetails *findController = [[ViewWatchWalletDetails alloc] init];
    findController.hidesBottomBarWhenPushed = NO;
    findController.isFromPageViewController = YES;
    [self.navigationController pushViewController:findController animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"] && ![CHANNELTYPE isEqualToString:ICANCNTYPETARGET] && [UserInfoManager.sharedManager.vip integerValue] > 5) {
        self.c2cBgCon.hidden = NO;
    }else{
        self.c2cBgCon.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.assetLabel.text = @"Balance".icanlocalized;
    self.walletLabel.text = @"Wallet".icanlocalized;
    self.yebLabel.text = @"Watch".icanlocalized;
  
    self.view.backgroundColor = UIColorViewBgColor;
    
    self.walletCapitalVc =  [[WalletBalanceViewController alloc]init];
    [self addChildViewController:self.walletCapitalVc];
    self.walletCapitalVc.view.frame = CGRectMake(0, StatusBarHeight+78, ScreenWidth, ScreenHeight-78-StatusBarHeight);
    self.walletCapitalVc.view.hidden = NO;
    [self.walletCapitalVc didMoveToParentViewController:self];
    [self.view addSubview:self.walletCapitalVc.view];
    
    self.watchListVc =  [[ViewWatchWalletDetails alloc]init];
    [self addChildViewController:self.watchListVc];
    self.watchListVc.view.frame = CGRectMake(0, StatusBarHeight+78, ScreenWidth, ScreenHeight-78-StatusBarHeight);
    [self.watchListVc didMoveToParentViewController:self];
    [self.view addSubview:self.watchListVc.view];
    self.navHeight.constant = StatusBarHeight+78;
    self.backBtnTop.constant = StatusBarHeight+15;
    
    self.walletVc =  [[WalletViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:self.walletVc];
    self.walletVc.view.frame = CGRectMake(0, StatusBarHeight+78, ScreenWidth, ScreenHeight-78-StatusBarHeight);
    self.walletVc.view.hidden = YES;
    [self.walletVc didMoveToParentViewController:self];
    [self.view addSubview:self.walletVc.view];
    
    self.walletNewVc =  [[NewWalletViewController alloc]init];
    [self addChildViewController:self.walletVc];
    self.walletNewVc.view.frame = CGRectMake(0, StatusBarHeight+78, ScreenWidth, ScreenHeight-78-StatusBarHeight);
    self.walletNewVc.view.hidden = YES;
    [self.walletNewVc didMoveToParentViewController:self];
    [self.view addSubview:self.walletNewVc.view];
    
    [self.assetButton setImage:UIImageMake(@"btn_wallet_balance_nor") forState:UIControlStateNormal];
    [self.assetButton setImage:UIImageMake(@"btn_wallet_balance_select") forState:UIControlStateSelected];
    [self.walletButton setImage:UIImageMake(@"icon_walletpage_wallet_nor") forState:UIControlStateNormal];
    [self.walletButton setImage:UIImageMake(@"icon_walletpage_wallet_sel") forState:UIControlStateSelected];
    [self.securityButton setImage:UIImageMake(@"btn_wallet_c2c_nor") forState:UIControlStateNormal];
    [self.securityButton setImage:UIImageMake(@"btn_wallet_c2c_select") forState:UIControlStateSelected];
    [self.yebButton setImage:UIImageMake(@"Watch 1x") forState:UIControlStateNormal];
    [self.yebButton setImage:UIImageMake(@"Watch filled 1x") forState:UIControlStateSelected];
    self.assetButton.selected = YES;
    self.assetLabel.textColor = UIColorMakeHEXCOLOR(0Xffffff);
    self.walletLabel.textColor = UIColorMakeHEXCOLOR(0Xccdef3);
    ///当实名认证通过的时候 需要刷新c2ctoken
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getC2cToken) name:KUserAuthPassNotification object:nil];
    if (self.fromFind) {
        [self walletAction];
    }else{
        [self assetAction];
    }
    if ([CHANNELTYPE isEqualToString:ICANCNTYPETARGET]) {
        self.c2cBgCon.hidden = YES;
        self.walletBgCon.hidden = YES;
        self.walletCapitalVc.view.hidden = NO;
        self.watchListVc.view.hidden = YES;
    }
}

-(BOOL)preferredNavigationBarHidden{
    return YES;
}

-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}

-(IBAction)buttonAction{
    [[AppDelegate shared].curNav popViewControllerAnimated:YES];
}

- (void)qrcodeAction {
    [PrivacyPermissionsTool judgeCameraAuthorizationSuccess:^{
        [self.navigationController pushViewController:[QRCodeController new] animated:YES];
    } failure:^{
        
    }];
}

- (void)gotoPayMoneyViewController {
    //    1、系统控制
    //    2、实名认证
    //    3、支付密码
    //    4、协议
    if ([UserInfoManager sharedManager].openPay) {
        
            if ([UserInfoManager sharedManager].isSetPayPwd) {
                UserConfigurationInfo*info= [BaseSettingManager sharedManager].userConfigurationInfo;
                if (info.isAgreePayment) {
                    PayMoneyInputViewController * vc = [PayMoneyInputViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    PayMentAgreementView*view=[[PayMentAgreementView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    view.agreeBlock = ^{
                        PayMoneyInputViewController * vc = [PayMoneyInputViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                    [[UIApplication sharedApplication].delegate.window addSubview:view];
                }
            }else{
                [UIAlertController alertControllerWithTitle:@"PleaseSetAPaymentPassword".icanlocalized message:nil target:self preferredStyle:(UIAlertControllerStyleAlert) actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
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
        
    }else{
        [QMUITipsTool showErrorWihtMessage:@"PaymentFunctionIsClosed".icanlocalized inView:nil];
    }
}

-(void)gotoRecieveViewController{
    if ([UserInfoManager sharedManager].openPay) {
        
            if ([UserInfoManager sharedManager].isSetPayPwd) {
                UserConfigurationInfo*info= [BaseSettingManager sharedManager].userConfigurationInfo;
                if (info.isAgreePayment) {
                    ReceiptMoneyViewController * vc = [ReceiptMoneyViewController new];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    PayMentAgreementView*view=[[PayMentAgreementView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                    view.agreeBlock = ^{
                        ReceiptMoneyViewController * vc = [ReceiptMoneyViewController new];
                        [self.navigationController pushViewController:vc animated:YES];
                    };
                    [[UIApplication sharedApplication].delegate.window addSubview:view];
                }
            }else{
                [UIAlertController alertControllerWithTitle:@"PleaseSetAPaymentPassword".icanlocalized message:nil target:self preferredStyle:(UIAlertControllerStyleAlert) actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
                    if (index==1) {
                        if(([UserInfoManager sharedManager].isEmailBinded == NO) && [UserInfoManager sharedManager].mustBindEmailPayPswd){
                            EmailBindingViewController *vc = [[EmailBindingViewController alloc]init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            SettingPaymentPasswordViewController *vc = [[SettingPaymentPasswordViewController alloc]init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                }];
            }
        
    }else{
        [QMUITipsTool showErrorWihtMessage:@"PaymentFunctionIsClosed".icanlocalized inView:nil];
    }
    
}
/** 牌价列表 */
-(void)getC2CExchangeRequest{
    GetC2CExchangeRequest*request = [GetC2CExchangeRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[CurrencyExchangeInfo class] success:^(NSArray* response) {
        
        C2CUserManager.shared.currencyExchangeItems = response;
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showOnlyTextWithMessage:info.desc inView:self.view];
    }];
}
/// 拿c2cToken
-(void)getC2cToken{
    [C2CUserManager.shared getC2cToken:^(C2CTokenInfo *  response) {
        
    } failure:^(NetworkErrorInfo *  info, NSInteger statusCode) {
        
    }];
}
@end
