//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/11/3
- ICan
- File name:  AppDelegate+DZExtension.h
- Description:
- Function List:
*/
        




#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (DZExtension)
@property(nonatomic,weak,readonly)UINavigationController *curNav;
@property(nonatomic,weak,readonly)UIViewController *topVC;
@property(nonatomic, weak) UIViewController *topViewController;

+ (AppDelegate *)shared;

- (void)presentViewController:(UIViewController* __nullable)viewController animated:(BOOL)animated completion:(void(^__nullable)(void))completion;

- (void)pushViewController:(UIViewController *__nullable)viewController animated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
