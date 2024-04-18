//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 14/2/2022
 - File name:  BillPageViewController.m
 - Description:
 - Function List:
 */


#import "BillPageViewController.h"
#import "BillListViewController.h"
@interface BillPageViewController ()
@property(nonatomic, strong) NSArray *titleItems;
@end

@implementation BillPageViewController
-(instancetype)init{
    if (self=[super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
    if(self.isFromOrganization){
        if(self.isFromAllTransactions){
            if(self.isFromAllTransactions){
                self.view.frame = CGRectMake(20, NavBarHeight+90, ScreenWidth - 40, ScreenHeight-90-NavBarHeight);
            }else{
                self.view.frame = CGRectMake(20, NavBarHeight+50, ScreenWidth - 40, ScreenHeight-50-NavBarHeight);
            }
        }else{
            self.view.frame = CGRectMake(20, NavBarHeight+50, ScreenWidth - 40, ScreenHeight-50-NavBarHeight);
        }
        [self.view layerWithCornerRadius:10 borderWidth:1 borderColor:UIColor.clearColor];
    }else{
        self.view.frame = CGRectMake(0, NavBarHeight+35, ScreenWidth, ScreenHeight-35-NavBarHeight);
    }
    if(self.isFromOrganization){
        self.selectIndex = self.selectedIndex;
        [self reloadVc];
    }
}

-(void)setupUI{
    if(self.isFromOrganization){
        if(self.isFromAllTransactions){
            if(self.isFromAllTransactions){
                self.titleItems =@[@"PENDING".icanlocalized,@"APPROVED".icanlocalized,@"REJECTED".icanlocalized];
            }else{
                self.titleItems =@[@"All".icanlocalized,@"Withdrawals".icanlocalized,@"Utility payments".icanlocalized];
            }
        }else{
            self.titleItems = @[@"All".icanlocalized,@"chatView.function.redPacket".icanlocalized,@"chatView.function.transfer".icanlocalized,@"Withdrawals".icanlocalized, @"Utility payments".icanlocalized,@"C2C Transfer".icanlocalized,@"C2C Withdrawal".icanlocalized,@"Utility Payments".icanlocalized,@"C2C".icanlocalized];
        }
    }else{
        self.titleItems =@[@"C2CAllTitle".icanlocalized,@"Income".icanlocalized,@"Expenditure".icanlocalized];
    }
    self.titleColorSelected = UIColorThemeMainColor;
    self.titleColorNormal = UIColor153Color;
    NSMutableArray * widthItems = [NSMutableArray arrayWithCapacity:self.titleItems.count];
    for (NSString*string in self.titleItems) {
        CGFloat width = [NSString widthForString:string withFontSize:16 height:20]+20;
        [widthItems addObject:@(width)];
    }
    self.itemsWidths = widthItems;
    self.titleSizeNormal = 16;
    self.titleSizeSelected = 16;
    self.pageAnimatable = YES;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    self.progressHeight = 2;
    self.progressWidth = 30;
    self.progressColor = UIColorThemeMainColor;
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

-(void)reloadVc{
    [self reloadData];
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

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    BillListViewController * vc = [[BillListViewController alloc]init];
    if(!self.isFromOrganization){
        if (index == 0) {
            vc.flowType = FlowTypeAll;
        }else if (index == 1){
            vc.flowType = FlowTypeIncome;
        }else{
            vc.flowType = FlowTypePay;
        }
        vc.year = self.year;
        vc.month = self.month;
        return vc;
    }else{
        if(self.isFromAllTransactions){
            if (index == 0) {
                vc.transactionStatusType = 1; // pending
            }else if (index == 1){
                vc.transactionStatusType = 2; //approved
            }else{
                vc.transactionStatusType = 3; //rejected
            }
            vc.dataTypeTrans = self.dataTypeTrans;
            vc.currencyType = self.currencyType;
            vc.fromSeeMoreMy = self.fromSeeMoreMy;
            vc.isFromOrganization = self.isFromOrganization;
            vc.isFromOrganizationAllTransactions = self.isFromAllTransactions;
            return vc;
        }else{
            vc.transactionType = index + 1; //All
            vc.memberInfo = self.memberInfo;
            vc.isFromOrganization = self.isFromOrganization;
            return vc;
        }
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, self.view.frame.size.width , 45);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0,originY , self.view.frame.size.width, self.view.frame.size.height - originY);
}

@end
