//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 11/4/2022
- File name:  C2COrderListCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kC2COrderListCell = @"C2COrderListCell";
@interface C2COrderListCell : BaseCell
@property (nonatomic, strong) C2COrderInfo *orderInfo;
@end

NS_ASSUME_NONNULL_END
