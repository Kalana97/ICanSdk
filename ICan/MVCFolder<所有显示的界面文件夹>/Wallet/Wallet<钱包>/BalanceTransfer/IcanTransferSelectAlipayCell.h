//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 18/2/2022
- File name:  IcanTransferSelectBankCardCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kIcanTransferSelectAlipayCell = @"IcanTransferSelectAlipayCell";
@interface IcanTransferSelectAlipayCell : BaseCell
@property(nonatomic, strong) BindingAliPayListInfo *alipayInfo;
@end

NS_ASSUME_NONNULL_END
