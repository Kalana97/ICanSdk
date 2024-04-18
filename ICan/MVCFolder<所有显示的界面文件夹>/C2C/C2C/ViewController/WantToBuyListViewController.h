//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/11/2021
- File name:  WantToBuyListViewController.h
- Description:
- Function List:
*/
        

#import "C2CBaseTableListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WantToBuyListViewController : C2CBaseTableListViewController
/** 是否是自选 我要买 */
@property(nonatomic, assign) BOOL isOptionBuy;
/** 当前选择的法币 */
@property(nonatomic, strong) CurrencyInfo *currencyInfo;
/** 当前的汇率 */
@property(nonatomic, strong) C2CExchangeRateInfo *exchangeRateIno;
/** 筛选时候的金额 */
@property(nonatomic, copy) NSString *amount;
/** 收款类型,可用值:Wechat,AliPay,BankTransfer     */
@property(nonatomic, copy, nullable) NSString *paymentMethodType;
-(void)resetFetchRequest;
@end

NS_ASSUME_NONNULL_END
