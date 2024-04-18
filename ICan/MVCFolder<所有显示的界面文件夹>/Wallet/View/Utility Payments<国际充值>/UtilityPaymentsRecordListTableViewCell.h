//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/6/2021
- File name:  UtilityPaymentsRecordListTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kUtilityPaymentsRecordListTableViewCell = @"UtilityPaymentsRecordListTableViewCell";
static CGFloat  const kHeightUtilityPaymentsRecordListTableViewCell = 85;
@interface UtilityPaymentsRecordListTableViewCell : BaseCell
@property(nonatomic, strong) DialogOrderInfo *dialogOrderInfo;
@end

NS_ASSUME_NONNULL_END
