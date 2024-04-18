//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/11/2021
- File name:  WantToBuyPageViewController.m
- Description:
- Function List:
*/
        

#import "OptionalPageViewController.h"
#import "WantToBuyListViewController.h"
#import "C2COOptionalFilterHeadView.h"

@interface OptionalPageViewController ()
@property(nonatomic, strong) C2COOptionalFilterHeadView *tableHeadView;

/** 交易类型的title */
@property(nonatomic, copy) NSString *paymentMethodType;
/** 交易类型的title */
@property(nonatomic, copy) NSString *amount;
@end

@implementation OptionalPageViewController
-(instancetype)init{
    if (self=[super init]) {
        
        self.titleColorSelected = UIColor.whiteColor;
        self.titleColorNormal = UIColor153Color;
        [self reloadDataUI];
        self.menuViewContentMargin = 10;
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.pageAnimatable = YES;
        self.menuViewStyle = WMMenuViewStyleFlood;
        self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
        self.progressViewCornerRadius = 5;
        self.progressHeight = 20;
        self.progressColor = UIColorThemeMainColor;
    }
    return self;
}

-(void)reloadDataUI{
    NSMutableArray * widthItems = [NSMutableArray arrayWithCapacity:self.titleItems.count];
    for (C2CExchangeRateInfo * info in self.titleItems) {
        CGFloat width = [NSString widthForString:info.virtualCurrency withFontSize:16 height:20]+20;
        [widthItems addObject:@(width)];
    }
    self.itemsWidths = widthItems;
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0,  StatusBarAndNavigationBarHeight + 70, ScreenWidth, ScreenHeight - 40 - TabBarHeight - StatusBarAndNavigationBarHeight);
    self.tableHeadView.frame = CGRectMake(0, 0, ScreenWidth, 50);
}
-(void)reloadPageView{
    [self reloadDataUI];
    [self reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableHeadView];
    self.menuView.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.currencyView hiddenView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    C2CExchangeRateInfo * info = [self.titleItems objectAtIndex:index];
    return info.virtualCurrency;
}
 
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
//    return 0;
    return self.titleItems.count;
}
 
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    WantToBuyListViewController * vc = [[WantToBuyListViewController alloc]initWithStyle:UITableViewStyleGrouped];
    C2CExchangeRateInfo * info = [self.titleItems objectAtIndex:index];
    vc.isOptionBuy = self.isOptionBuy;
    vc.exchangeRateIno = info;
    vc.currencyInfo = self.currencyInfo;
    vc.amount = self.amount;
    vc.paymentMethodType = self.paymentMethodType;
    return vc;
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, self.view.frame.size.width , 40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, 50 , self.view.frame.size.width, self.view.frame.size.height - originY - 50);
}
-(void)setCurrencyInfo:(CurrencyInfo *)currencyInfo{
    _currencyInfo = currencyInfo;
    _amountPopView.legalTenderLabel.text = self.currencyInfo.code;
    _popView.legalTenderLabel.text = self.currencyInfo.code;
}
-(C2COOptionalFilterHeadView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[NSBundle mainBundle]loadNibNamed:@"C2COOptionalFilterHeadView" owner:self options:nil].firstObject;
        _tableHeadView.frame = CGRectMake(0, 0, ScreenWidth, 50);
        @weakify(self);
        _tableHeadView.tapAmountBlock = ^{
            @strongify(self);
            [self.tradingPopView hiddenView];
            [self.popView hiddenView];
            [self.currencyView hiddenView];
            [self.amountPopView showView];
        };
        _tableHeadView.tapTradingBlock = ^{
            @strongify(self);
            [self.amountPopView hiddenView];
            [self.popView hiddenView];
            [self.currencyView hiddenView];
            [self.tradingPopView showView];
        };
        _tableHeadView.tapCurrencyBlock = ^{
            @strongify(self);
            [self.amountPopView hiddenView];
            [self.popView hiddenView];
            [self.tradingPopView hiddenView];
            self.currencyView.data = self.titleItems;
            self.currencyView.selectedC = self.tableHeadView.selectedCurrency.text;
            self.currencyView.tableViewHeight.constant = 50 * self.titleItems.count;
            [self.currencyView showView];
        };
        _tableHeadView.tapFilterBlock = ^{
            @strongify(self);
            self.popView.amount = self.amount;
            self.popView.paymentMethodType = self.paymentMethodType;
            [self.amountPopView hiddenView];
            [self.tradingPopView hiddenView];
            [self.currencyView hiddenView];
            [self.popView showView];
        };
        
    }
    return _tableHeadView;
}
-(C2COOptionalFilterAmountPopView *)amountPopView{
    if (!_amountPopView) {
        _amountPopView = [[NSBundle mainBundle]loadNibNamed:@"C2COOptionalFilterAmountPopView" owner:self options:nil].firstObject;
        _amountPopView.frame = CGRectMake(0, 120 + StatusBarAndNavigationBarHeight, ScreenWidth, ScreenHeight);
        _amountPopView.legalTenderLabel.text = self.currencyInfo.code;
        @weakify(self);
        _amountPopView.resetBlock = ^{
            @strongify(self);
            self.amount = nil;
            self.tableHeadView.amount = self.amount;
            [self reloadData];
        };
        _amountPopView.amountBlock = ^(NSString * _Nonnull amount) {
            @strongify(self);
            self.amount = amount;
            self.tableHeadView.amount = self.amount;
            [self reloadData];
        };
        _amountPopView.hiddenBlock = ^{
            
        };

    }
    return _amountPopView;
}
-(C2COOptionalFilterTradingPopView *)tradingPopView{
    if (!_tradingPopView) {
        _tradingPopView = [[NSBundle mainBundle]loadNibNamed:@"C2COOptionalFilterTradingPopView" owner:self options:nil].firstObject;
        _tradingPopView.frame = CGRectMake(0, 120 + StatusBarAndNavigationBarHeight, ScreenWidth, ScreenHeight);
        @weakify(self);
        _tradingPopView.selectBlock = ^(NSString * _Nonnull tradingTitle) {
            @strongify(self);
            self.paymentMethodType = tradingTitle;
            self.tableHeadView.paymentMethodType = self.paymentMethodType;
            [self reloadData];
        };
        
    }
    return _tradingPopView;
}
-(C2COOptionalFilterPopView *)popView{
    if (!_popView) {
        _popView = [[NSBundle mainBundle]loadNibNamed:@"C2COOptionalFilterPopView" owner:self options:nil].firstObject;
        _popView.frame = CGRectMake(0, 120 + StatusBarAndNavigationBarHeight, ScreenWidth, ScreenHeight);
        _popView.legalTenderLabel.text = self.currencyInfo.code;
        @weakify(self);
        _popView.selectBlock = ^(NSString *tradingTitle, NSString *amount) {
            @strongify(self);
            self.paymentMethodType = tradingTitle;
            self.amount = amount;
            self.tableHeadView.amount = self.amount;
            self.tableHeadView.paymentMethodType = self.paymentMethodType;
            self.amountPopView.amount = amount;
            self.tradingPopView.paymentMethodType = self.paymentMethodType;
            [self reloadData];
        };
        
        
    }
    return _popView;
}
-(SelectCurrencyDropDownView *)currencyView{
    if (!_currencyView) {
        _currencyView = [[NSBundle mainBundle]loadNibNamed:@"SelectCurrencyDropDownView" owner:self options:nil].firstObject;
        _currencyView.frame = CGRectMake(0, 120 + StatusBarAndNavigationBarHeight, ScreenWidth, ScreenHeight);
        @weakify(self);
        _currencyView.selectBlock = ^(NSInteger tradingTitle , NSString *currencyTitle) {
            @strongify(self);
            [self setSelectIndex:tradingTitle];
            self.tableHeadView.selectedCurrency.text = currencyTitle;
            if ([currencyTitle isEqual:@"USDT"]) {
                self.tableHeadView.selectedCurrencyImg.image = [UIImage imageNamed:@"usdt"];
            }else if ([currencyTitle isEqual:@"CNT"]) {
                self.tableHeadView.selectedCurrencyImg.image = [UIImage imageNamed:@"CNT Transfer"];
            }
        };
    }
    return _currencyView;
}
@end
