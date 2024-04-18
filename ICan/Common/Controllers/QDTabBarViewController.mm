//
//  QDTabBarViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/6/2.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDTabBarViewController.h"
#import "QDNavigationController.h"
#import "MineViewController.h"
#import "ChatListViewController.h"
#import "FriendListTableViewController.h"
#import "FindTableViewController.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "WCDBManager+ChatList.h"
#import "TimelinesViewController.h"
#import "WCDBManager+TimeLineNotice.h"
#import "FriendListTableViewController.h"
#import "C2CTabBarViewController.h"
#import "IcanWalletPageViewController.h"
#import "CoinsTableViewController.h"
#import "WatchList.h"

@interface QDTabBarViewController ()<UITabBarControllerDelegate>
@end

@implementation QDTabBarViewController
+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[QDTabBarViewController class]]) {
        return (QDTabBarViewController *)vc;
    }else{
        return nil;
    }
}

-(void)viewDidLoad{
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundColor = UIColorTabBarBgColor;
        appearance.backgroundImage = [UIImage imageWithColor:UIColorTabBarBgColor];
        appearance.backgroundEffect = nil;
        UITabBarItemAppearance *  itemAppearance =  [[UITabBarItemAppearance alloc]init];
        NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.normal.titleTextAttributes.mutableCopy;
        attributes[NSForegroundColorAttributeName] = UIColor252730Color;
        itemAppearance.normal.titleTextAttributes = attributes.copy;
        appearance.inlineLayoutAppearance = itemAppearance;
        appearance.stackedLayoutAppearance = itemAppearance;
        appearance.compactInlineLayoutAppearance = itemAppearance;
        self.tabBar.scrollEdgeAppearance = appearance;
        self.tabBar.standardAppearance = appearance;
    }else{
        [[UITabBar appearance] setBackgroundColor:UIColorTabBarBgColor];
    }
    [self createTabBarController];
    
}


- (void)createTabBarController {
    NSInteger UnReadMsgNumber =[[WCDBManager sharedManager]fetchAllUnReadNumberCount].integerValue;
    // Lab
    ChatListViewController *chatListViewController = [[ChatListViewController alloc] init];
    chatListViewController.hidesBottomBarWhenPushed = NO;
    QDNavigationController *chatListNavController = [[QDNavigationController alloc] initWithRootViewController:chatListViewController];
    //聊天
    chatListNavController.tabBarItem = [self tabBarItemWithTitle:@"tabbar.chat".icanlocalized image:[UIImageMake(@"tab_chat_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_chat_select")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    chatListNavController.tabBarItem.qmui_badgeInteger = UnReadMsgNumber;
    
    if (UnReadMsgNumber >99) {
        chatListNavController.tabBarItem.qmui_badgeString =@"...";
    }else if(UnReadMsgNumber>0){
        chatListNavController.tabBarItem.qmui_badgeString =[NSString stringWithFormat:@"%ld",UnReadMsgNumber];
    }
    //发现
    FindTableViewController *findController = [[FindTableViewController alloc] init];
    findController.hidesBottomBarWhenPushed = NO;
    QDNavigationController *findNavController = [[QDNavigationController alloc] initWithRootViewController:findController];
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        findNavController.tabBarItem = [self tabBarItemWithTitle:@"tabbar.discover".icanlocalized image:[UIImageMake(@"tab_find_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_find_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:2];
    }else {
        findNavController.tabBarItem = [self tabBarItemWithTitle:@"tabbar.discoverOld".icanlocalized image:[UIImageMake(@"tab_find_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_find_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:2];
    }
    
    ///c2c
    C2CTabBarViewController *c2cVc = [[C2CTabBarViewController alloc] init];
    c2cVc.hidesBottomBarWhenPushed = NO;
    QDNavigationController *c2cVcNav = [[QDNavigationController alloc] initWithRootViewController:c2cVc];
    c2cVcNav.tabBarItem = [self tabBarItemWithTitle:@"C2CTabarC2C".icanlocalized image:[UIImageMake(@"tab_c2c_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_c2c_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:2];
    
    IcanWalletPageViewController * walletVc = [[IcanWalletPageViewController alloc]init];
    walletVc.hidesBottomBarWhenPushed = NO;
    QDNavigationController *walletNav = [[QDNavigationController alloc] initWithRootViewController:walletVc];
    walletNav.tabBarItem = [self tabBarItemWithTitle:@"Wallet".icanlocalized image:[UIImageMake(@"tab_wallet_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_wallet_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:2];
    
    TimelinesViewController*timelineVc=[[TimelinesViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [[AppDelegate shared] pushViewController:timelineVc animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
    QDNavigationController *timelineNav = [[QDNavigationController alloc] initWithRootViewController:timelineVc];
    timelineNav.tabBarItem = [self tabBarItemWithTitle:@"tabbar.share".icanlocalized image:[UIImageMake(@"tab_share_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_share_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:2];
    
    MineViewController *mineViewController = [[MineViewController alloc] init];
    mineViewController.hidesBottomBarWhenPushed = NO;
    //我的
    QDNavigationController *mineNavController = [[QDNavigationController alloc] initWithRootViewController:mineViewController];
    mineNavController.tabBarItem = [self tabBarItemWithTitle:@"tabbar.me".icanlocalized image:[UIImageMake(@"tab_me_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_me_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:4];
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
    if ([UserInfoManager.sharedManager.userAuthStatus isEqualToString:@"Authed"] && [UserInfoManager.sharedManager.vip integerValue] > 5) {
            self.viewControllers = @[findNavController,chatListNavController,c2cVcNav,walletNav,mineNavController];
        }else{
            self.viewControllers = @[findNavController,chatListNavController,walletNav,mineNavController];
        }
    }else {
        self.viewControllers = @[chatListNavController,findNavController,timelineNav,mineNavController];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transfetSucessAndGotoChatViewVcWithNotification:) name:KTransferSucessNotification object:nil];
    self.selectedIndex=0;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;

}
-(BOOL)shouldAutorotate{
    QDNavigationController * nav =(QDNavigationController*)self.selectedViewController;
    if ([nav.visibleViewController isKindOfClass:NSClassFromString(@"DZAVPlayerViewController")]) {
        return YES;
    }
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}
- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag {
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
    tabBarItem.selectedImage = selectedImage;
    
    return tabBarItem;
}
-(void)transfetSucessAndGotoChatViewVcWithNotification:(NSNotification *)noti{
    
    self.selectedIndex =0;
}
@end
