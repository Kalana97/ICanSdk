//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 30/10/2019
- File name:  SelectAtUserTableViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonTableViewController.h"
#import "WCDBManager+GroupMemberInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface SelectAtUserTableViewController : QDCommonTableViewController
@property (nonatomic,copy) NSString*groupId;
@property(nonatomic, assign) BOOL isNeedAtAll;
/**@人*/
@property (nonatomic, copy) void (^atSingleBlcok)(GroupMemberInfo*groupMemberInfo);
@property (nonatomic, copy) void (^atSingleBlcokAll)(NSArray<GroupMemberInfo*>* groupMemberInfo);


@end

NS_ASSUME_NONNULL_END
