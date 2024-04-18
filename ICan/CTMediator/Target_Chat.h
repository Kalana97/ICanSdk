//
/*
- Target_Chat.h
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/6/7
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_Chat : NSObject
- (UIViewController *)Action_nativeFetchChatViewController:(NSDictionary *)params;
- (UIViewController *)Action_nativeFetchNewFriendsViewController:(NSString *)isAccept;
@end

NS_ASSUME_NONNULL_END
