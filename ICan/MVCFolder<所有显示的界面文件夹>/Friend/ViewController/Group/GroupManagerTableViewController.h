//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 26/12/2019
- File name:  GroupManagerTableViewController.h
- Description:
- Function List:
*/
        
/**
 群管理
 */
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupManagerTableViewController : BaseViewController
@property(nonatomic, strong) NSArray<GroupMemberInfo*> *allMemberItems;
@property(nonatomic, strong) GroupListInfo *groupDetailInfo;
@property(nonatomic,copy) void(^sucessSettingOwnerBlock)(void);
@property (nonatomic, copy) void (^deleteSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
