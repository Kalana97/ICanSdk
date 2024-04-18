//
/*
- CTMediator+CTMediatorModuleChatActions.m
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/6/7
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
NSString * const kCTMediatorTargetChat = @"Chat";
static NSString * const kCTMediatorActionNativeFetchChatViewController = @"nativeFetchChatViewController";
static NSString * const kCTMediatorActionNativeFetchFriendDetailViewController = @"nativeFetchFriendDetailViewController";
static NSString * const kCTMediatorActionNativeFetchNewFriendsViewController = @"nativeFetchNewFriendsViewController";
#import "CTMediator+CTMediatorModuleChatActions.h"

@implementation CTMediator (CTMediatorModuleChatActions)
-(UIViewController*)CTMediator_viewControllerForChatViewController:(NSDictionary*)parms{
    UIViewController *viewController = [self performTarget:kCTMediatorTargetChat
   action:kCTMediatorActionNativeFetchChatViewController params:parms shouldCacheTarget:NO ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}

- (UIViewController*)CTMediator_viewControllerForNewFriendsViewController {
    UIViewController *viewController = [self performTarget:kCTMediatorTargetChat action:kCTMediatorActionNativeFetchNewFriendsViewController params:nil shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        return [[UIViewController alloc] init];
    }
}
@end
