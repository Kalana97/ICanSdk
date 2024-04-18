//
//  C2COrderPendingViewController.m
//  ICan
//
//  Created by dzl on 16/5/2022.
//  Copyright © 2022 dzl. All rights reserved.
//

#import "C2COrderPendingViewController.h"
#import "C2COrderListViewController.h"
@interface C2COrderPendingViewController ()
@property (nonatomic, strong) NSArray *titleItems;
@end

@implementation C2COrderPendingViewController
-(instancetype)init{
    if (self=[super init]) {
        /**
         "C2COrderStateAll"="全部";
         "C2COrderStateUnpaid"="未付款";
         "C2COrderStatePaid"="已付款";
         "C2COrderStateCompleted"="已完成";
         "C2COrderStateCancelled"="已取消";
         "C2COrderStateAppeal"="申诉";
         */
        self.titleItems =@[@"C2COrderStateAll".icanlocalized,@"C2COrderStateUnpaid".icanlocalized,@"C2COrderStatePaid".icanlocalized,@"C2COrderStateAppeal".icanlocalized];
        self.titleColorSelected = UIColor252730Color;
        self.titleColorNormal = UIColor153Color;
        
//        NSMutableArray * widthItems = [NSMutableArray arrayWithCapacity:self.titleItems.count];
//        for (NSString*string in self.titleItems) {
//            CGFloat width = [NSString widthForString:string withFontSize:16 height:20]+20;
//            [widthItems addObject:@(width)];
//        }
        self.menuViewContentMargin = 10;
//        self.itemsWidths = widthItems;
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.pageAnimatable = YES;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.progressViewCornerRadius = 5;
        self.progressHeight = 2;
        self.progressColor = UIColorThemeMainColor;
                
    }
    return self;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0, NavBarHeight+10, ScreenWidth, ScreenHeight-NavBarHeight-10);
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return [self.titleItems objectAtIndex:index];
}
 
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleItems.count;
}
 
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    C2COrderListViewController * vc = [[C2COrderListViewController alloc]init];
    switch (index) {
        case 0:
            vc.orderStatus = @[@"Unpaid",@"Paid",@"Appeal"];
            break;
        case 1:
            vc.orderStatus = @[@"Unpaid"];
            break;
        case 2:
            vc.orderStatus = @[@"Paid"];
            break;
        case 3:
            vc.orderStatus = @[@"Appeal"];
            break;
        default:
            break;
    }
    return vc;
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, self.view.frame.size.width , 40);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0,originY , self.view.frame.size.width, self.view.frame.size.height - originY);
}


@end
