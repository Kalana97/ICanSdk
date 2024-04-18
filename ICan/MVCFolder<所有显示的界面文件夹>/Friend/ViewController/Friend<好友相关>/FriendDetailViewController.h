//
/**
- Copyright © 2019 dzl. All rights reserved.
- AUthor: Created  by DZL on 2019/10/16
- ICan
- File name:  FriendDetailViewController.h
- Description://如果是好友 那么顺序为设置备注 朋友圈  否则为  朋友圈  添加好友提示框
- Function List:
*/
        

#import "QDCommonViewController.h"
@class UserMessageInfo;
@class FriendSubscriptionInfo;
NS_ASSUME_NONNULL_BEGIN

@interface FriendDetailViewController: QDCommonViewController
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) UserMessageInfo *userMessageInfo;
@property (nonatomic, assign) FriendDetailType friendDetailType;
@property (nonatomic, strong) FriendSubscriptionInfo *friendSubscriptionInfo;
@property (nonatomic, assign) BOOL isGroupOwnerOrAdmin;
@property (nonatomic, assign) NSString *viwerRole;
@property (nonatomic, assign) NSArray *sortGroupMemberInfoItems;
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
@property (nonatomic, copy) NSString *authorityType;
@property (nonatomic, copy) void (^refuseButtonBlock)(void);
@end


NS_ASSUME_NONNULL_END

