//
/*
- CTMediator+CTMediatorModuleChatActions.h
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/6/7
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
    

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (CTMediatorModuleChatActions)
- (UIViewController *)CTMediator_viewControllerForChatViewController:(NSDictionary *)parms;
- (UIViewController *)CTMediator_viewControllerForNewFriendsViewController;
@end

NS_ASSUME_NONNULL_END
