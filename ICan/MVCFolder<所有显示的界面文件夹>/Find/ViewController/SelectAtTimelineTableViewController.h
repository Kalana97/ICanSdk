//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 30/10/2019
- File name:  SelectAtTimelineTableViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonTableViewController.h"

@class UserMessageInfo;
NS_ASSUME_NONNULL_BEGIN

@interface SelectAtTimelineTableViewController : QDCommonTableViewController

/**@人*/
@property (nonatomic, copy) void (^atSingleBlcok)(UserMessageInfo*userMessageInfo);
@end

NS_ASSUME_NONNULL_END
