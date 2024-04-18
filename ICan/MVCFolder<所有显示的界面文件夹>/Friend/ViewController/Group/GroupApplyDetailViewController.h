//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  GroupApplyDetailViewController.h
- Description:邀请详情
- Function List:
*/
        

#import "BaseViewController.h"
@class GroupApplyInfo;
NS_ASSUME_NONNULL_BEGIN

@interface GroupApplyDetailViewController : BaseViewController
@property(nonatomic, strong) GroupApplyInfo *info;
@property(nonatomic, copy) void (^agreeBlock)(GroupApplyInfo *groupApplyInfo);
@end

NS_ASSUME_NONNULL_END
