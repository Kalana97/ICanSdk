//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 11/6/2020
- File name:  ReportListTableViewController.h
- Description: 举报页面的View
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportListTableViewController : QDCommonTableViewController
@property(nonatomic, copy) NSString *timelineId;
@property(nonatomic, copy) NSString *userId;
/** TimeLine  User */
@property(nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
