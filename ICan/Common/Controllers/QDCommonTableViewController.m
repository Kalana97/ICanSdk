//
//  QDCommonTableViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonTableViewController.h"

@implementation QDCommonTableViewController

- (void)initTableView {
    [super initTableView];
    self.tableView.backgroundColor=UIColorViewBgColor;
    self.view.backgroundColor=UIColorViewBgColor;
    self.navigationController.navigationBar.translucent=NO;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = UIColorNavBarBarTintColor;
        appearance.backgroundImage = [UIImage imageWithColor:UIColorNavBarBarTintColor];
        appearance.backgroundEffect = nil;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.standardAppearance = appearance;
    }
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return  UIStatusBarStyleDarkContent ;
    } else {
        return UIStatusBarStyleDefault;
    }
}
- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)qmui_themeDidChangeByManager:(QMUIThemeManager *)manager identifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject *)theme {
    [super qmui_themeDidChangeByManager:manager identifier:identifier theme:theme];
    [self.tableView reloadData];
}
-(BOOL)preferredNavigationBarHidden{
    return NO;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
@end
