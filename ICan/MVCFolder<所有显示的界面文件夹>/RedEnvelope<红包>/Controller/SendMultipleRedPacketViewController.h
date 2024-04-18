//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 31/3/2020
- File name:  SendMultipleRedPacketViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SendMultipleRedPacketViewController : QDCommonViewController
@property(nonatomic, copy) NSString *groupId;
/** 也是群详情 */
@property(nonatomic, strong) GroupListInfo *groupListInfo;

@property(nonatomic, copy) void (^sendMultipleRedPacketSuccessBlock)(ChatModel*model);
@end

NS_ASSUME_NONNULL_END
