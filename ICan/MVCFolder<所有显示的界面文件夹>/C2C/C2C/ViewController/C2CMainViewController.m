//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/11/2021
- File name:  C2CMainViewController.m
- Description:
- Function List:
*/
        

#import "C2CMainViewController.h"
#import "OptionalPageViewController.h"
#import "QuickPageViewController.h"
#import "C2CSelectLegalTenderViewController.h"
#import "C2CChangeOptionOrQuickPopView.h"
#import "UITabBar+Extension.h"
@interface C2CMainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
/** 自选 */
@property (weak, nonatomic) IBOutlet UILabel *optionalLabel;

/** 当前的货币 */
@property (weak, nonatomic) IBOutlet UILabel *exchangeLabel;
///我要买
@property (weak, nonatomic) IBOutlet UILabel *wantToBuyLabel;
///我要卖
@property (weak, nonatomic) IBOutlet UILabel *wantToSaleLabel;
@property (weak, nonatomic) IBOutlet UIControl *buyBgView;

@property (weak, nonatomic) IBOutlet UIControl *sellBgView;
@property (weak, nonatomic) IBOutlet UIControl *swapBgBtn;

@property (nonatomic, strong) CurrencyInfo *selectCurrencyInfo;
/** 是否是自选 我要买 */
@property(nonatomic, assign) BOOL isOptionBuy;
@property (nonatomic, strong) OptionalPageViewController *optionalPageVc;
@property (nonatomic, strong) QuickPageViewController *quickPageVc;

@property(nonatomic, strong) C2CChangeOptionOrQuickPopView *popView;
@end

@implementation C2CMainViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
-(void)setOptionalPageVcWith:(CurrencyInfo*)info{
    self.exchangeLabel.text = info.code;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"legalTender contains [cd] %@ AND supportC2C== YES ",info.code];
    NSArray * countItems =  [C2CUserManager.shared.allExchangenRateItems filteredArrayUsingPredicate:predicate];
    self.optionalPageVc.isOptionBuy = self.isOptionBuy;
    self.optionalPageVc.currencyInfo= info;
    NSMutableArray *mutableArray = [countItems mutableCopy];
    for (C2CExchangeRateInfo *info in mutableArray) {
        if ([info.virtualCurrency isEqual:@"CNT"]) {
            [mutableArray removeObject:info];
            [mutableArray insertObject:info atIndex:0];
        }
    }
    self.optionalPageVc.titleItems = mutableArray;
    [self.optionalPageVc reloadPageView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isOptionBuy = YES;
    self.optionalPageVc =  [[OptionalPageViewController alloc]init];
    self.optionalPageVc.isOptionBuy = self.isOptionBuy;
    self.selectCurrencyInfo = C2CUserManager.shared.currentCurrencyInfo;
    if (!self.selectCurrencyInfo) {
        NSPredicate * predicate ;
        if (UserInfoManager.sharedManager.countriesCode.length>0) {
            predicate = [NSPredicate predicateWithFormat:@"countriesCode == [cd] %@ ",UserInfoManager.sharedManager.countriesCode];
        }else{
            predicate = [NSPredicate predicateWithFormat:@"countriesCode == [cd] %@ ",C2CUserManager.shared.countriesCode];
        }
        NSArray * filterItems = [C2CUserManager.shared.allSupportedLegalTenderCurrencyItems filteredArrayUsingPredicate:predicate];
        if (filterItems.count>0) {
            self.selectCurrencyInfo = filterItems.firstObject;
        }else{
            self.selectCurrencyInfo = C2CUserManager.shared.allSupportedLegalTenderCurrencyItems.firstObject;
        }
        C2CUserManager.shared.currentCurrencyInfo = self.selectCurrencyInfo;
    }
    self.exchangeLabel.text = self.selectCurrencyInfo.code;
    [self setOptionalPageVcWith:self.selectCurrencyInfo];
    self.optionalPageVc.view.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-50-NavBarHeight);
    [self addChildViewController:self.optionalPageVc];
    [self.optionalPageVc didMoveToParentViewController:self];
    [self.view addSubview:self.optionalPageVc.view];

    self.quickPageVc =  [[QuickPageViewController alloc]init];
     
    
    [self addChildViewController:self.quickPageVc];
    self.quickPageVc.view.frame = CGRectMake(0, NavBarHeight+50, ScreenWidth, ScreenHeight-50);
    self.quickPageVc.view.hidden = YES;
    [self.quickPageVc didMoveToParentViewController:self];
    [self.view addSubview:self.quickPageVc.view];
    [self selectOptionalAction];

    self.swapBgBtn.layer.borderWidth = 1.0;
    self.swapBgBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.swapBgBtn.layer.cornerRadius = 15;
    self.wantToBuyLabel.text = @"C2CMainViewControllerWantToBuyLabel".icanlocalized;
    self.wantToSaleLabel.text = @"C2CMainViewControllerWantToSaleLabel".icanlocalized;
    [self getCollectCurrencyRequest];
    [self getC2CUndoneCountRequest];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getC2CUndoneCountRequest) name:kC2CRefreshOrderListNotification object:nil];
}
//选择当前的模式
- (IBAction)selectPatternAction {
    return;
    [self.popView showView];
    [self.optionalPageVc.amountPopView hiddenView];
    [self.optionalPageVc.tradingPopView hiddenView];
    [self.optionalPageVc.popView hiddenView];
}
//选择了自选模式
- (void)selectOptionalAction {
    self.popView.hidden = YES;
    self.quickPageVc.view.hidden = YES;
    self.optionalPageVc.view.hidden = NO;
    
    self.optionalLabel.text = @"C2CMainViewControllerOption".icanlocalized;
}
//选择了快捷模式
- (void)selectQuickAction {
    self.popView.hidden = YES;
    self.quickPageVc.view.hidden = NO;
    self.optionalPageVc.view.hidden = YES;
    self.optionalLabel.text = @"C2CMainViewControllerQuick".icanlocalized;
}
//返回
- (IBAction)backAction {
    [self.optionalPageVc.amountPopView hiddenView];
    [self.optionalPageVc.tradingPopView hiddenView];
    [self.optionalPageVc.popView hiddenView];
    self.popView.hidden = YES;
    if (self.shoulPopToRoot) {
        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }
    
    
}
//我要买
- (IBAction)wantToBuyAction {
    self.isOptionBuy = YES;
    self.optionalPageVc.isOptionBuy = self.isOptionBuy;
    self.wantToBuyLabel.textColor = UIColor252730Color;
    self.wantToSaleLabel.textColor = UIColor153Color;
    self.wantToBuyLabel.font = [UIFont boldSystemFontOfSize:19];
    self.wantToSaleLabel.font = [UIFont systemFontOfSize:16];
    self.buyBgView.backgroundColor = UIColor.whiteColor;
    self.sellBgView.backgroundColor = UIColor.clearColor;
    [self.optionalPageVc reloadPageView];
}
//我要卖
- (IBAction)wantToSaleAction {
    self.isOptionBuy = NO;
    self.optionalPageVc.isOptionBuy = self.isOptionBuy;
    self.wantToBuyLabel.textColor = UIColor153Color;
    self.wantToSaleLabel.textColor = UIColor252730Color;
    
    self.wantToSaleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.wantToBuyLabel.font = [UIFont systemFontOfSize:16];
    self.buyBgView.backgroundColor = UIColor.clearColor;
    self.sellBgView.backgroundColor = UIColor.whiteColor;
    [self.optionalPageVc reloadPageView];
}
//切换
- (IBAction)exchangeAction {
    [self.optionalPageVc.amountPopView hiddenView];
    [self.optionalPageVc.tradingPopView hiddenView];
    [self.optionalPageVc.popView hiddenView];
    self.popView.hidden = YES;
    C2CSelectLegalTenderViewController * vc = [[C2CSelectLegalTenderViewController alloc]initWithStyle:UITableViewStyleGrouped];
    vc.selectCurrencyInfo = self.selectCurrencyInfo;
    vc.selectBlock = ^(CurrencyInfo * _Nonnull info) {
        self.selectCurrencyInfo = info;
        self.exchangeLabel.text = info.code;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:info.code forKey:@"P2PAddSelectCurrencyInfo"];
        [prefs synchronize];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"legalTender contains [cd] %@ AND supportC2C== YES ",info.code];
        NSArray * countItems =  [C2CUserManager.shared.allExchangenRateItems filteredArrayUsingPredicate:predicate];
        NSMutableArray *mutableArray = [countItems mutableCopy];
        for (C2CExchangeRateInfo *info in mutableArray) {
            if ([info.virtualCurrency isEqual:@"CNT"]) {
                [mutableArray removeObject:info];
                [mutableArray insertObject:info atIndex:0];
            }
        }
        self.optionalPageVc.titleItems = mutableArray;
        self.optionalPageVc.isOptionBuy = self.isOptionBuy;
        self.optionalPageVc.currencyInfo = info;
        [self.optionalPageVc reloadPageView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


//更多
- (IBAction)moreButtonAction:(id)sender {
    
}
-(C2CChangeOptionOrQuickPopView *)popView{
    if (!_popView) {
        _popView = [[NSBundle mainBundle]loadNibNamed:@"C2CChangeOptionOrQuickPopView" owner:self options:nil].firstObject;
        _popView.frame = CGRectMake(0, StatusBarAndNavigationBarHeight-10, ScreenWidth, ScreenHeight);
        @weakify(self);
        _popView.optionBlock = ^{
            @strongify(self);
            [self selectOptionalAction];
        };
        _popView.quickBlock = ^{
            @strongify(self);
            [self selectQuickAction];
        };
    }
    return _popView;
}

-(void)getCollectCurrencyRequest{
    GetC2CCollectCurrencyRequest * request = [GetC2CCollectCurrencyRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[C2CCollectCurrencyInfo class] success:^(NSArray* response) {
        
        C2CUserManager.shared.collectCurrencyItems = response;
        
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
-(void)getC2CUndoneCountRequest{
    C2CGetAdOrderUndoneCountRequest * request = [C2CGetAdOrderUndoneCountRequest request];
    [[C2CNetRequestManager shareManager]startRequest:request responseClass:[C2COrderUnReadCountInfo class] contentClass:[C2COrderUnReadCountInfo class] success:^(C2COrderUnReadCountInfo * response) {
        if (response.count.intValue>0) {
            [self.tabBarController.tabBar showBadgeOnItmIndex:1 tabbarNum:4];
        }else{
            [self.tabBarController.tabBar removeBadgeOnItemIndex:1];
        }
       
    } failure:^(NSError * _Nonnull error, NetworkErrorInfo * _Nonnull info, NSInteger statusCode) {
        
    }];
}
@end
