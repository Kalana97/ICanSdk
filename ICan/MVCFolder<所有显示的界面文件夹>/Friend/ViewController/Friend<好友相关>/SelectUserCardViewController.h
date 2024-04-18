//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 17/10/2019
- File name:  SelectUserCardViewController.h
- Description: 选择用户名片
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectUserCardViewController : QDCommonTableViewController
@property(nonatomic, copy) void (^selectUserChatBlock)(UserMessageInfo*userMessageInfo,NSString*remark);
@property (nonatomic, strong) ChatModel *config;
@property(copy, nonatomic) void(^backAction)(void);
@end

NS_ASSUME_NONNULL_END
