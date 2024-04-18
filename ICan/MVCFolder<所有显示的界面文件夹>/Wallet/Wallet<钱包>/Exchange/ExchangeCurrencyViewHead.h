//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 27/9/2021
- File name:  ExchangeCurrencyListHead.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeCurrencyViewHead : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UITextField *buyTextField;
@property (weak, nonatomic) IBOutlet UITextField *saleTextField;
//更新时间
@property (weak, nonatomic) IBOutlet UILabel *updateLabe;

/** 当前点击进来的牌价 */
@property(nonatomic, strong) CurrencyExchangeInfo *currencyExchangeInfo;
/** 全部的牌价列表 */
@property(nonatomic, strong) NSArray<CurrencyExchangeInfo*> *currencyItems;


@property(nonatomic, copy) void (^exchangeBlock)(void);

@property(nonatomic, copy) void (^currencyCodeBlock)(CurrencyExchangeInfo*code);

@property(nonatomic, copy) void (^endEditingBlock)(void);
@end

NS_ASSUME_NONNULL_END
