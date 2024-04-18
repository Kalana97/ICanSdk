//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  ExchangeCurrencyListTableViewCell.h
- Description:兑换界面列表的cell
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kExchangeCurrencyTableViewCell = @"ExchangeCurrencyTableViewCell";
@interface ExchangeCurrencyTableViewCell : BaseCell
@property(nonatomic, strong) CurrencyExchangeInfo *currencyInfo;
@end

NS_ASSUME_NONNULL_END
