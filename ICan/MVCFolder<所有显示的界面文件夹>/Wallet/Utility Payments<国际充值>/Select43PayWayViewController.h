//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 6/7/2021
- File name:  Select43PayWayViewController.h
- Description:
- Function List:
*/
        

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Select43PayWayViewController : QDCommonTableViewController
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
@property(nonatomic, copy) NSString *currencyCode;
/** 备注 */
@property(nonatomic, copy) NSString *remark;
//充值渠道 余额还是兰卡支付
@property(nonatomic, strong)  RechargeChannelInfo *selectChannelInfo;
/** 是否是充值余额 */
@property(nonatomic, assign) BOOL isRechargeBalance;
@end

NS_ASSUME_NONNULL_END
