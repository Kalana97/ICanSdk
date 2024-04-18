//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/11/3
- ICan
- File name:  AppDelegate+DZExtension.m
- Description:
- Function List:
*/
        

#import "AppDelegate+DZExtension.h"

#import "QDNavigationController.h"


@implementation AppDelegate (DZExtension)
+(AppDelegate *)shared{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)presentViewController:(UIViewController* __nullable)viewController animated:(BOOL)animated completion:(void(^__nullable)(void))completion{
    viewController.modalPresentationStyle=UIModalPresentationFullScreen;
    [self.topVC presentViewController:viewController animated:YES completion:completion];
}

- (void)pushViewController:(UIViewController *__nullable)viewController animated:(BOOL)animated{
    if ([self.curNav isKindOfClass:[UINavigationController class]]) {
        [self.curNav pushViewController:viewController animated:YES];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated{
    if ([self.curNav isKindOfClass:[UINavigationController class]]) {
        [self.curNav popToRootViewControllerAnimated:NO];
    }
}

-(UIViewController *)topVC{
    if ([self.curNav isKindOfClass:[UINavigationController class]]) {
        return self.curNav.topViewController;
    }
    return nil;
}

-(UINavigationController *)curNav{
    return [self recursiveViewController:self.window.rootViewController];
}

- (UINavigationController *)recursiveViewController:(UIViewController *)vc
{
    if ([vc isKindOfClass:[QDNavigationController class]]) {
        return [self recursiveViewController:[(QDNavigationController *)vc visibleViewController]];
    }
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self recursiveViewController:[(UITabBarController *)vc selectedViewController]];
    }
    if (vc.presentedViewController) {
        return [self recursiveViewController:vc.presentedViewController];
    }
    if ([vc isKindOfClass:[UISearchController class]]) {
        UIViewController *presentingViewController = vc.presentingViewController;
        if ([presentingViewController isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)presentingViewController;
        } else {
            return presentingViewController.navigationController;
        }
    }
    return vc.navigationController;
}
//这个只能获取presentationController跳转的最顶层VC
- (UIViewController *)topViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (void)dpushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UINavigationController *navigationController = (UINavigationController *)[self topViewController];
    
    if ([navigationController isKindOfClass:[UINavigationController class]] == NO) {
        if ([navigationController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbarController = (UITabBarController *)navigationController;
            navigationController = tabbarController.selectedViewController;
            if ([navigationController isKindOfClass:[UINavigationController class]] == NO) {
                navigationController = tabbarController.selectedViewController.navigationController;
            }
        } else {
            navigationController = navigationController.navigationController;
        }
    }
    
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        [navigationController pushViewController:viewController animated:animated];
    }
}

- (void)dpresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    UIViewController *viewController = [self topViewController];
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        viewController = navigationController.topViewController;
    }
    
    if ([viewController isKindOfClass:[UIAlertController class]]) {
        UIViewController *viewControllerToUse = viewController.presentingViewController;
        [viewController dismissViewControllerAnimated:false completion:nil];
        viewController = viewControllerToUse;
    }
    
    if (viewController) {
        [viewController presentViewController:viewControllerToPresent animated:animated completion:completion];
    }
}

@end
