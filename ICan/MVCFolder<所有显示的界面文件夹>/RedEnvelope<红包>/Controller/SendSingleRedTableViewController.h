//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 31/3/2020
- File name:  SendSingleRedTableViewController.h
- Description:
- Function List:单个红包限额0.01-1万
*/
        

#import "QDCommonViewController.h"
#import "WCDBManager+ChatModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SendSingleRedTableViewController : QDCommonViewController
@property(nonatomic, copy) NSString *toUserId;
@property(nonatomic, copy) void (^sendRedPacketSuccessBlock)(ChatModel*model);
/**
 这个字段用来表示当前哪种聊天
 authorityType: friend//好友  secret 私聊  circle交友
 */
@property(nonatomic, copy) NSString *authorityType;
@end

NS_ASSUME_NONNULL_END
