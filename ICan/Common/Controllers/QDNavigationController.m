//
//  QDNavigationController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDNavigationController.h"

@interface QDNavigationController ()

@end

@implementation QDNavigationController
-(void)viewDidLoad{
    [super viewDidLoad];
 // 字体颜色
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navBarAppearance = [UINavigationBarAppearance new];
        navBarAppearance.backgroundColor = UIColorNavBarBarTintColor; // 设置导航栏背景色
        navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
        self.navigationBar.scrollEdgeAppearance = navBarAppearance;
        self.navigationBar.standardAppearance = navBarAppearance;
    } else {
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
        
    }
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return  UIStatusBarStyleDarkContent ;
    } else {
        return UIStatusBarStyleDefault;
    }
}
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    viewController.hidesBottomBarWhenPushed=YES;
//    [super pushViewController:viewController animated:animated];
//}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
@end
