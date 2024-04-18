//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 25/11/2021
- File name:  C2CHomeResponse.h
- Description:
- Function List:
*/
        

#import "BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CHomeResponse : BaseResponse

@end
@interface C2CAdverInfo : NSObject
/** 广告ID */
@property (nonatomic, assign) NSInteger adId;
/** 自动消息 */
@property (nonatomic, copy) NSString * autoMessage;
/** 是否可用，上架 */
@property (nonatomic, assign) BOOL available;
/** 交易限制 BTC金额， -1表示不限制 */
@property (nonatomic, assign) NSInteger btcLimit;
/** 广告数量  由于使用NSDecimalNumber接收会出现浮点情况 例如8.33237614 会变成8.332376139999999*/
@property (nonatomic, copy) NSString* count;
/** 创建时间 */
@property (nonatomic, copy) NSString * createTime;
/** 删除时间 */
@property (nonatomic, copy) NSString * deleteTime;
/** 是否删除 */
@property (nonatomic, assign) BOOL deleted;
/** 完成数量 */
@property (nonatomic, strong) NSString* finishCount;
/** 固定价格 */
@property (nonatomic, strong) NSString* fixedPrice;
/** 法币Code */
@property (nonatomic, copy) NSString * legalTender;
/** 最大限额 */
@property (nonatomic, strong) NSString* max;
/**  最小限额 */
@property (nonatomic, strong) NSString* min;
/** 支付失效 单位分钟 */
@property (nonatomic, assign) NSInteger payCancelTime;
/** 价格浮动指数  */
@property (nonatomic, strong) NSString* priceFluctuationIndex;
/** 价格类型,可用值:Fixed,Fluctuation */
@property (nonatomic, copy) NSString * priceType;
/** 交易限制 注册天数 -1表示不限制 */
@property (nonatomic, assign) NSInteger registerDay;

/** 是否支持支付宝收款 */
@property (nonatomic, assign) BOOL supportAliPay;
/** 是否支持银行卡转账收款 */
@property (nonatomic, assign) BOOL supportBankTransfer;
/** 是否支持微信收款 */
@property (nonatomic, assign) BOOL supportWechat;
@property (nonatomic, assign) BOOL supportCash;
/** 交易条款 */
@property (nonatomic, copy) NSString * transactionTerms;
/**交易类型,可用值:Buy,Sell */
@property (nonatomic, copy) NSString * transactionType;
/**更新时间 */
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, strong) C2CUserInfo *user;
@property (nonatomic, assign) NSInteger userId;
/** 虚拟货币code */
@property (nonatomic, copy) NSString * virtualCurrency;
@property (nonatomic, assign) NSInteger weights;
///手续费率
@property (nonatomic, strong) NSString *handlingFee;
///总手续费
@property (nonatomic, strong) NSString *handlingFeeMoney;
///剩余手续费
@property (nonatomic, strong) NSString *remainingHandlingFeeMoney;
@property (nonatomic, strong) NSArray<C2CPaymentMethodInfo*> *paymentMethods;
@end
/** 自选列表 */
@interface C2COptionalListInfo : C2CListInfo

@end
//"account": "",
//            "bankName": "",
//            "branch": "",
//            "createTime": "",
//            "deleted": true,
//            "name": "",
//            "paymentMethodId": 0,
//            "paymentMethodType": "",
//            "qrCode": "",
//            "remark": "",
//            "updateTime": "",
//            "userId": 0
@interface C2CAdverDetailInfo : C2CAdverInfo

@end
@interface C2CCollectCurrencyInfo:NSObject
@property(nonatomic, copy) NSString *code;
@end
NS_ASSUME_NONNULL_END
