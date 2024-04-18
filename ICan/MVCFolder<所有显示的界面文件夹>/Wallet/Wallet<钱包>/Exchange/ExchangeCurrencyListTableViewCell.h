//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  ExchangeCurrencyListTableViewCell.h
- Description:牌价列表的cell
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kExchangeCurrencyListTableViewCell = @"ExchangeCurrencyListTableViewCell";
@interface ExchangeCurrencyListTableViewCell : BaseCell
@property(nonatomic, assign) BOOL isExchangeList;
@property(nonatomic, strong) CurrencyExchangeInfo *currencyInfo;
@end

NS_ASSUME_NONNULL_END
