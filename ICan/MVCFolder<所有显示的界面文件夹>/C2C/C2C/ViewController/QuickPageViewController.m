//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 18/11/2021
- File name:  QuickPageViewController.m
- Description:
- Function List:
*/
        

#import "QuickPageViewController.h"
#import "QuickWantToSaleViewController.h"
@interface QuickPageViewController ()

@end

@implementation QuickPageViewController

-(instancetype)init{
    if (self=[super init]) {
        self.titleItems =@[@"UDST",@"ICAN",@"BTC",@"ETC"];
        self.titleColorSelected = UIColor.whiteColor;
        self.titleColorNormal = UIColor153Color;
        NSMutableArray * widthItems = [NSMutableArray arrayWithCapacity:self.titleItems.count];
        for (NSString*string in self.titleItems) {
            CGFloat width = [NSString widthForString:string withFontSize:16 height:20]+20;
            [widthItems addObject:@(width)];
        }
        self.menuViewContentMargin = 10;
        self.itemsWidths = widthItems;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    QuickWantToSaleViewController * vc = [[QuickWantToSaleViewController alloc]init];
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
