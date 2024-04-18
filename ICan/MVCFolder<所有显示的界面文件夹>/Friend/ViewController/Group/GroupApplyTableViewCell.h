//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  GroupApplyTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"
@class GroupApplyInfo;
NS_ASSUME_NONNULL_BEGIN
static NSString* const kGroupApplyTableViewCell = @"GroupApplyTableViewCell";
@interface GroupApplyTableViewCell : BaseCell
@property(nonatomic, strong) GroupApplyInfo *info;
@property(nonatomic, copy) void (^deleteBlock)(void);
@property(nonatomic, copy) void (^agreeBlock)(void);
@end

NS_ASSUME_NONNULL_END
