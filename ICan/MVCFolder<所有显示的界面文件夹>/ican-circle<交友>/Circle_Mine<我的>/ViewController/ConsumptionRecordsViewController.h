//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  ConsumptionRecordsViewController.h
- Description:消费记录
- Function List:
*/
        

#import "CircleBaseTableListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConsumptionRecordsViewController : CircleBaseTableListViewController
/** 是否是消费详情 */
@property(nonatomic, assign) BOOL isDetail;
@property(nonatomic, copy) NSString *myPackageId;
@end

NS_ASSUME_NONNULL_END
