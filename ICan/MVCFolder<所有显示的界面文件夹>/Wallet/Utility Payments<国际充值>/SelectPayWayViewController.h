//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 1/7/2021
- File name:  SelectPayWayViewController.h
- Description:选择支付方式
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectPayWayViewController : QDCommonTableViewController
/** 转换后的金额数据 */
@property(nonatomic, strong) ExchangeByAmountInfo *currentExchangeByAmountInfo;
@property(nonatomic, strong) DialogListInfo *dialogInfo;
/** 是不是从收藏页面跳转过来 */
@property(nonatomic, assign) BOOL isFromFavorite;
/** 充值的金额 RS */
@property(nonatomic, copy) NSString *amount;
/** 通知号码 */
@property(nonatomic, copy) NSString *noticeMobile;
/** 充值号码 */
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *paymentId;
@property(nonatomic, copy) NSString *countryCode;
/** 备注 */
@property(nonatomic, copy) NSString *remark;
@property(nonatomic, copy) NSString *currencyCode;
@property (nonatomic,strong) UserBalanceInfo *userBalanceInfo;
@property(nonatomic, strong) C2CBalanceListInfo *currentInfo;
@end

NS_ASSUME_NONNULL_END
