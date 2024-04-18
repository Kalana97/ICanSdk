//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 11/6/2020
- File name:  SubmitReportViewController.h
- Description:
- Function List:
*/
        

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubmitReportViewController : BaseViewController
@property(nonatomic, copy) NSString *timelineId;
@property(nonatomic, copy) NSString *reportType;
@property(nonatomic, copy) NSString *userId;
/** TimeLine  User */
@property(nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
