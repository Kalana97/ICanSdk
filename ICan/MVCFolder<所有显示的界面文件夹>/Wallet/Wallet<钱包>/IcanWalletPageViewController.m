//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  IcanWalletPageViewController.m
- Description:
- Function List:
*/
        

#import "IcanWalletPageViewController.h"
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
#import "WalletCapitalViewController.h"
#import "C2CTabBarViewController.h"
@interface IcanWalletPageViewController ()<WMMenuViewDelegate>
@property(nonatomic, strong) NSArray *titleItems;
@property(nonatomic, strong) UIView *navBarView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *leftArrowButton;
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, assign) NSInteger currentIndex;
@end

@implementation IcanWalletPageViewController

-(instancetype)init{
    if (self=[super init]) {
        if ([CHANNCLTYPE isEqualToString:@"ICANTYPE"]) {
            if (UserInfoManager.sharedManager.openExchange) {
                self.titleItems =@[@"Assets".icanlocalized,@"Wallet".icanlocalized,@"License price".icanlocalized,@"C2C".icanlocalized];
            }else{
                self.titleItems =@[@"Assets".icanlocalized,@"Wallet".icanlocalized,@"C2C".icanlocalized];
            }
            
        }else{
            self.titleItems =@[@"GrayscaleMyBalance".icanlocalized];
        }
        self.titleColorSelected = UIColor.whiteColor;
        self.titleColorNormal = UIColorThemeMainSubTitleColor;
        NSMutableArray * widthItems = [NSMutableArray arrayWithCapacity:self.titleItems.count];
        for (NSString*string in self.titleItems) {
            CGFloat width = [NSString widthForString:string withFontSize:16 height:20]+20;
            [widthItems addObject:@(width)];
        }
        self.menuView.delegate = self;
        self.menuViewContentMargin = 10;
        self.itemsWidths = widthItems;
//        self.itemsWidths = @[@(10),@(20),@(20),@(10)];
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
//        self.scrollEnable = NO;
        self.pageAnimatable= YES;
        self.menuViewStyle = WMMenuViewStyleFlood;
        self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
        self.progressViewCornerRadius = 5;
        self.progressHeight = 34;
        self.progressColor = UIColorThemeMainColor;
        self.currentIndex = 0;
                
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([CHANNCLTYPE isEqualToString:@"ICANTYPE"]) {
        self.menuView.backgroundColor = UIColorBg243Color;
    }else{
        self.menuView.backgroundColor = UIColor10PxClearanceBgColor;
    }
    self.view.backgroundColor = UIColorViewBgColor;
    [self getC2CExchangeRequest];
    [self.view addSubview:self.navBarView];
    [self.navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@(NavBarHeight));
    }];
    [self.navBarView addSubview:self.leftArrowButton];
    [self.leftArrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@17);
        make.height.equalTo(@17);
        make.left.equalTo(@10);
        make.bottom.equalTo(@-13.5);
    }];
    [self.navBarView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
        make.centerX.equalTo(self.navBarView);
    }];
    [self.navBarView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.centerY.equalTo(self.leftArrowButton.mas_centerY);
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCurrencyRequest) name:kBuyCurrencySuccessNotification object:nil];
    
}
-(void)getCurrencyRequest{
    self.selectIndex = 1;
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return [self.titleItems objectAtIndex:index];
}
 
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleItems.count;
}
-(void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    if ([[info objectForKey:@"title"] isEqualToString:@"C2C"]) {
//        self.selectIndex = self.currentIndex;
        C2CTabBarViewController * vc = [[C2CTabBarViewController alloc]init];
        vc.shoulPopToRoot = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (BOOL)menuView:(WMMenuView *)menu shouldSelesctedIndex:(NSInteger)index{
    if (UserInfoManager.sharedManager.openExchange) {
        if (index==3) {
            C2CTabBarViewController * vc = [[C2CTabBarViewController alloc]init];
            vc.shoulPopToRoot = NO;
            [self.navigationController pushViewController:vc animated:YES];
            return NO;
        }
    }
    return YES;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (UserInfoManager.sharedManager.openExchange) {
        switch (index) {
            case 0:{
                WalletCapitalViewController * vc = [[WalletCapitalViewController alloc]init];
                return vc;
            }
                
                break;
            case 1:{
                WalletViewController * vc = [[WalletViewController alloc]initWithStyle:UITableViewStyleGrouped];
                return vc;
            }
                break;
            case 2:{
                ExchangeCurrencyListViewController * vc = [[ExchangeCurrencyListViewController alloc]initWithStyle:UITableViewStylePlain];
                return vc;
            }
                
                break;
            default:
                break;
        }
        UIViewController * vc = [[UIViewController alloc]init];
        return vc;
    }
    switch (index) {
        case 0:{
            WalletCapitalViewController * vc = [[WalletCapitalViewController alloc]init];
            return vc;
        }
            
            break;
        case 1:{
            WalletViewController * vc = [[WalletViewController alloc]initWithStyle:UITableViewStyleGrouped];
            return vc;
        }
            break;
        default:
            break;
    }
    UIViewController * vc = [[UIViewController alloc]init];
    return vc;
    
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, NavBarHeight, self.view.frame.size.width , 34);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0,originY , self.view.frame.size.width, self.view.frame.size.height - originY);
}

-(UIView *)navBarView{
    if (!_navBarView) {
        _navBarView=[[UIView alloc]init];
        _navBarView.backgroundColor=UIColor.clearColor;
    }
    return _navBarView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        
        NSString *title = @"mine.listView.cell.banlance".icanlocalized;
        if (![CHANNCLTYPE isEqualToString:@"ICANTYPE"]) {
            title = @"GrayscaleMyBalance".icanlocalized;;
        }
        
        _titleLabel=[UILabel centerLabelWithTitle:title font:17 color:UIColorThemeMainTitleColor];
        _titleLabel.font=[UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}
-(UIButton *)leftArrowButton{
    if (!_leftArrowButton) {
        _leftArrowButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:UIColor.clearColor target:self action:@selector(buttonAction)];
        [_leftArrowButton setBackgroundImage:UIImageMake(@"icon_nav_return") forState:UIControlStateNormal];
    }
    return _leftArrowButton;
}
-(void)buttonAction{
    [[AppDelegate shared].curNav popViewControllerAnimated:YES];
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(rightAction)];
        _rightButton.frame=CGRectMake(0, 0, 20, 20);
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"find_more"] forState:UIControlStateNormal];
        
    }
    return _rightButton;
}
-(void)rightAction{
    NSArray*array=@[@{@"icon":@"currency_scan",@"title":@"chatlist.menu.list.scan".icanlocalized},@{@"icon":@"currency_payment",@"title":@"payment".icanlocalized},
                    @{@"icon":@"currency_Collection",@"title":@"Receive".icanlocalized}];
    @weakify(self);
    [ChatListMenuView showMenuViewWithMenuItems:array didSelectBlock:^(NSInteger index) {
        @strongify(self);
        switch (index) {
            case 0:{
                [self qrcodeAction];
            }
                
                break;
            case 1:{
                [self gotoPayMoneyViewController];
            }
                
                break;
            case 2:
                [self gotoRecieveViewController];
              
                break;
                
        }
    }];
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
                        SettingPaymentPasswordViewController*vc=[[SettingPaymentPasswordViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
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
                        SettingPaymentPasswordViewController*vc=[[SettingPaymentPasswordViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
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
@end
