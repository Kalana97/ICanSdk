//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 28/11/2019
- File name:  RechargeRecordListTableViewCell.h
- Description:充值记录
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kRechargeRecordListTableViewCell = @"RechargeRecordListTableViewCell";
static CGFloat const kHeightRechargeRecordListTableViewCell = 60;
@interface RechargeRecordListTableViewCell : BaseCell
@property(nonatomic, strong) RechargeRecordInfo *rechargeRecordInfo;
@end

NS_ASSUME_NONNULL_END
