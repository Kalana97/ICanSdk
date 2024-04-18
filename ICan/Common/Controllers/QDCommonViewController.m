//
//  QDCommonViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonViewController.h"

@implementation QDCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= UIColorViewBgColor;
   
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

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
   
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

@end
