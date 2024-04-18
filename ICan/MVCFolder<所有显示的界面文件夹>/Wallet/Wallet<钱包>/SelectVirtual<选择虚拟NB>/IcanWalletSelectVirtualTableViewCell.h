//
/**
- Copyright © 2022 dzl. All rights reserved.
- Author: Created  by DZL on 12/1/2022
- File name:  IcanWalletSelectVirtualTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kIcanWalletSelectVirtualTableViewCell = @"IcanWalletSelectVirtualTableViewCell";
@interface IcanWalletSelectVirtualTableViewCell : BaseCell
@property(nonatomic, strong) CurrencyInfo *currencyInfo;
@property(nonatomic, strong) NSString *fromToOtherCode;
@end

NS_ASSUME_NONNULL_END
