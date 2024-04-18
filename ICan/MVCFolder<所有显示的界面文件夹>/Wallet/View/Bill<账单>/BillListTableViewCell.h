//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 11/11/2019
- File name:  BillListTableViewCell.h
- Description: 账单页面
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString* const kBillListTableViewCell = @"BillListTableViewCell";
static CGFloat const kHeightBillListTableViewCell = 75;
@interface BillListTableViewCell : BaseCell
@property(nonatomic, strong)  BillInfo *billInfo;
@property(nonatomic, strong)  C2CFlowsInfo *c2cFlowsInfo;

@end

NS_ASSUME_NONNULL_END
