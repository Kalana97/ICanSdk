//
//  BaseViewController.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/4/19.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()<UIGestureRecognizerDelegate>
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=UIColorNavBarBarTintColor;
    self.navigationController.navigationBar.translucent=NO;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = UIColorNavBarBarTintColor;
        appearance.backgroundImage = [UIImage imageWithColor:UIColorNavBarBarTintColor];
        appearance.backgroundEffect = nil;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.standardAppearance = appearance;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return  UIStatusBarStyleDarkContent ;
    } else {
        return UIStatusBarStyleDefault;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
-(BOOL)preferredNavigationBarHidden{
    return NO;
}
@end
