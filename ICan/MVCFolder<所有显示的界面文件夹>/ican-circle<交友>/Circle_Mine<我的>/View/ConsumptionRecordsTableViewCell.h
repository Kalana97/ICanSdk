//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 31/5/2021
- File name:  ConsumptionRecordsTableViewCell.h
- Description:套餐消费记录
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kConsumptionRecordsTableViewCell = @"ConsumptionRecordsTableViewCell";
@interface ConsumptionRecordsTableViewCell : BaseCell
@property(nonatomic, strong) ConsumptionRecordsInfo *consumptionRecordsInfo;
@end

NS_ASSUME_NONNULL_END
