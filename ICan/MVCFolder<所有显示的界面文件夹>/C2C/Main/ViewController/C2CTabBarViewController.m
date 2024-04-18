

#import "C2CTabBarViewController.h"
#import "QDNavigationController.h"
#import "C2CMainViewController.h"
#import "C2COrderPageViewController.h"
#import "C2CMyAdvertisingViewController.h"
#import "C2CMineViewController.h"

@interface C2CTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation C2CTabBarViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
//-(BOOL)forceEnableInteractivePopGestureRecognizer{
//    return YES;
//}
+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[C2CTabBarViewController class]]) {
        return (C2CTabBarViewController *)vc;
    }else{
        return nil;
    }
}

-(void)viewDidLoad{
    self.hidesBottomBarWhenPushed = YES;
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundColor = UIColor.whiteColor;
        appearance.backgroundImage = [UIImage imageWithColor:UIColor.whiteColor];
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
    }
    [self createTabBarController];
//    if (@available(iOS 13.0, *)) {
//        UITabBarAppearance *appearance = [UITabBarAppearance new];
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName:YXMainColor};
//        self.tabBarItem.standardAppearance = appearance;
//    }else{
//        NSDictionary * noselectedTitleColordic =@{NSForegroundColorAttributeName:UIColor252730Color};
//        [[UITabBarItem appearance] setTitleTextAttributes:noselectedTitleColordic forState:UIControlStateNormal];
//        NSDictionary * selectedTitleColordic =@{NSForegroundColorAttributeName:YXMainColor};
//        [[UITabBarItem appearance] setTitleTextAttributes:selectedTitleColordic forState:UIControlStateSelected];
//    }
//    if (@available(iOS 15.0, *)) {
//        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
//        appearance.backgroundColor = UIColor.whiteColor;
//        appearance.backgroundImage = [UIImage imageWithColor:UIColor.whiteColor];
//        appearance.backgroundEffect = nil;
//        UITabBarItemAppearance *  itemAppearance =  [[UITabBarItemAppearance alloc]init];
//        NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.normal.titleTextAttributes.mutableCopy;
//        attributes[NSForegroundColorAttributeName] = UIColor252730Color;
//        itemAppearance.normal.titleTextAttributes = attributes.copy;
//        appearance.inlineLayoutAppearance = itemAppearance;
//        appearance.stackedLayoutAppearance = itemAppearance;
//        appearance.compactInlineLayoutAppearance = itemAppearance;
//        self.tabBar.scrollEdgeAppearance = appearance;
//        self.tabBar.standardAppearance = appearance;
//    }
}
//-(void)viewWillDisappear:(BOOL)animated{
//    if (@available(iOS 13.0, *)) {
//        UITabBarAppearance *appearance = [UITabBarAppearance new];
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName:YXMainColor};
//        self.tabBarItem.standardAppearance = appearance;
//    }else{
//        NSDictionary * noselectedTitleColordic =@{NSForegroundColorAttributeName:UIColor252730Color};
//        [[UITabBarItem appearance] setTitleTextAttributes:noselectedTitleColordic forState:UIControlStateNormal];
//        NSDictionary * selectedTitleColordic =@{NSForegroundColorAttributeName:UIColorThemeMainColor};
//        [[UITabBarItem appearance] setTitleTextAttributes:selectedTitleColordic forState:UIControlStateSelected];
//    }
//    if (@available(iOS 15.0, *)) {
//        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
//        appearance.backgroundColor = UIColor.whiteColor;
//        appearance.backgroundImage = [UIImage imageWithColor:UIColor.whiteColor];
//        appearance.backgroundEffect = nil;
//        UITabBarItemAppearance *  itemAppearance =  [[UITabBarItemAppearance alloc]init];
//        NSMutableDictionary<NSAttributedStringKey, id> *attributes = itemAppearance.normal.titleTextAttributes.mutableCopy;
//        attributes[NSForegroundColorAttributeName] = UIColor252730Color;
//        itemAppearance.normal.titleTextAttributes = attributes.copy;
//        appearance.inlineLayoutAppearance = itemAppearance;
//        appearance.stackedLayoutAppearance = itemAppearance;
//        appearance.compactInlineLayoutAppearance = itemAppearance;
//        self.tabBar.scrollEdgeAppearance = appearance;
//        self.tabBar.standardAppearance = appearance;
//    }
//
//}

- (void)createTabBarController {
    //C2C
    
    C2CMainViewController *mainController = [[C2CMainViewController alloc] init];
    mainController.hidesBottomBarWhenPushed = NO;
    mainController.shoulPopToRoot = self.shoulPopToRoot;
    QDNavigationController *uikitNavController = [[QDNavigationController alloc] initWithRootViewController:mainController];
    uikitNavController.tabBarItem = [self tabBarItemWithTitle:@"C2CTabarC2C".icanlocalized image:[UIImageMake(@"tab_c2c_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_c2c_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    C2COrderPageViewController *chatListViewController = [[C2COrderPageViewController alloc] init];
    chatListViewController.shoulPopToRoot = self.shoulPopToRoot;
    chatListViewController.hidesBottomBarWhenPushed = NO;
    QDNavigationController *chatListNavController = [[QDNavigationController alloc] initWithRootViewController:chatListViewController];
    chatListNavController.tabBarItem = [self tabBarItemWithTitle:@"C2CTabarOrder".icanlocalized image:[UIImageMake(@"tab_order_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_order_select")imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:1];
    
    C2CMyAdvertisingViewController * timelinesViewController = [[C2CMyAdvertisingViewController alloc]initWithStyle:UITableViewStyleGrouped];
    timelinesViewController.shoulPopToRoot = self.shoulPopToRoot;
    timelinesViewController.type = AdvertisingViewTypeMine;
    timelinesViewController.hidesBottomBarWhenPushed = NO;
    QDNavigationController *timelinsNavController = [[QDNavigationController alloc] initWithRootViewController:timelinesViewController];
    timelinesViewController.tabBarItem = [self tabBarItemWithTitle:@"C2CTabarAdvert".icanlocalized image:[UIImageMake(@"tab_advert_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_advert_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:2];
    
    C2CMineViewController *walletlabViewController = [[C2CMineViewController alloc] init];
    walletlabViewController.shoulPopToRoot = self.shoulPopToRoot;
    walletlabViewController.hidesBottomBarWhenPushed = NO;
    QDNavigationController *walletNavController = [[QDNavigationController alloc] initWithRootViewController:walletlabViewController];
    walletNavController.tabBarItem = [self tabBarItemWithTitle:@"C2CTabarMe".icanlocalized image:[UIImageMake(@"tab_me_unselect") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImageMake(@"tab_me_select") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:3];
    self.viewControllers = @[uikitNavController,chatListNavController,timelinsNavController,walletNavController];
    
}
- (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag {
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
    tabBarItem.selectedImage = selectedImage;
//    if (@available(iOS 13.0, *)) {
//        UITabBarAppearance *appearance = [UITabBarAppearance new];
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName:YXMainColor};
//        tabBarItem.standardAppearance = appearance;
//    }
    
    return tabBarItem;
}


@end
