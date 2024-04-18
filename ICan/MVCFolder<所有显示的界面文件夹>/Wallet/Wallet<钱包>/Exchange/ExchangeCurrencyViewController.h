//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 24/9/2021
- File name:  ExchangeCurrencyViewController.h
- Description: 兑换货币的操作界面
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeCurrencyViewController : QDCommonTableViewController
/** 当前点击进来的牌价 */
@property(nonatomic, strong) CurrencyExchangeInfo *currencyExchangeInfo;
/** 全部的牌价列表 */
@property(nonatomic, strong) NSArray<CurrencyExchangeInfo*> *currencyItems;

@end

NS_ASSUME_NONNULL_END
