//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 12/11/2019
- File name:  GroupAllMemberViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupAllMemberViewController : QDCommonTableViewController
@property(nonatomic, strong) NSArray<GroupMemberInfo*> *allMemberItems;
@property (nonatomic,strong) GroupListInfo * groupDetailInfo;
@end

NS_ASSUME_NONNULL_END
