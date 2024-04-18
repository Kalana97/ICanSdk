//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 25/11/2021
- File name:  C2CHomeRequest.h
- Description:
- Function List:
*/
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface C2CHomeRequest : NSObject

@end
/**
 自选列表
 GET
 /api/ad/choose
 */
@interface C2CGetOptionalListRequest : C2CListRequest
/** 法定货币code */
@property(nonatomic, copy, nullable) NSString *legalTender;
/** 总额 */
@property(nonatomic, copy, nullable) NSString *money;
/** 收款类型,可用值:Wechat,AliPay,BankTransfer     */
@property(nonatomic, copy, nullable) NSString *paymentMethodType;
/** 购买 Buy/出售 Sell */
@property(nonatomic, copy, nullable) NSString *transactionType;
/** 虚拟货币code */
@property(nonatomic, copy, nullable) NSString *virtualCurrency;

@end

/**
 某个人的广告
 GET
 /api/ad/myAds
 */
@interface C2CGetUserAdverListRequest : C2CListRequest
/** 交易状态 */
@property(nonatomic, strong,nullable) NSNumber* available;
/** 法定货币code */
@property(nonatomic, copy,nullable) NSString* legalTender;
/** 交易类型 Buy Sell    */
@property(nonatomic, copy,nullable) NSString* transactionType;
/** 虚拟货币code */
@property(nonatomic, copy,nullable) NSString* virtualCurrency;
/** 虚拟货币code */
@property(nonatomic, copy,nullable) NSString* userId;
/** 是否是关闭 */
@property(nonatomic, strong,nullable) NSNumber*deleted;
@end
/*
 广告详情
 GET
 /api/ad/{id}
 */
@interface C2CGetAdverDetailRequest : C2CBaseRequest

@end
@interface C2CRechargeRequest : C2CBaseRequest
@property(nonatomic, copy,nullable) NSString* legalTender;
@property(nonatomic, copy,nullable) NSString* virtualCurrency;
@property(nonatomic, copy,nullable) NSString* adId;
@property(nonatomic, copy,nullable) NSString* amount;
@end
/*
 修改广告
 PUT
 /api/ad/{id}
 */
@interface C2CPutAdverRequest : C2CBaseRequest
/** 自动消息     */
@property (nonatomic, copy, nullable) NSString * autoMessage;
/** 是否可用，上架 */
@property (nonatomic, assign) BOOL available;
/** 交易限制 BTC金额 -1表示为未选中     */
@property (nonatomic, strong, nullable) NSNumber* btcLimit;
/** 广告数量     */
@property (nonatomic, assign) NSInteger count;
/** 固定价格     */
@property (nonatomic, strong, nullable) NSNumber* fixedPrice;
/** 最大限额     */
@property (nonatomic, strong, nullable) NSNumber* max;
/** 最小限额     */
@property (nonatomic, strong, nullable) NSNumber* min;
/** 支付失效 单位分钟     */
@property (nonatomic, assign) NSInteger payCancelTime;
/** 收款方式ids     */
@property (nonatomic, strong) NSArray * payMethodIds;
/** 价格浮动指数 最小值 */
@property (nonatomic, strong, nullable) NSNumber* priceFluctuationIndex;
/** 价格类型,可用值:Fixed,Fluctuation */
@property (nonatomic, copy) NSString * priceType;
/** 交易限制 注册天数  -1表示为未选中     */
@property (nonatomic, strong, nullable) NSNumber* registerDay;
/** 交易条款     */
@property (nonatomic, copy, nullable) NSString * transactionTerms;
@end

/*
 上架
 PUT
 /api/ad/{id}/onShelf
 */
@interface C2COnShelfAdverRequest : C2CBaseRequest
/** 自动消息     */
@property (nonatomic, copy, nullable) NSString * autoMessage;
/** 交易限制 BTC金额 -1表示为未选中     */
@property (nonatomic, strong, nullable) NSNumber* btcLimit;
/** 广告数量     */
@property (nonatomic, strong,nullable) NSNumber* count;
/** 固定价格     */
@property (nonatomic, strong, nullable) NSNumber* fixedPrice;
/** 最大限额     */
@property (nonatomic, strong, nullable) NSNumber* max;
/** 最小限额     */
@property (nonatomic, strong, nullable) NSNumber* min;
/** 支付失效 单位分钟     */
@property (nonatomic, strong,nullable) NSNumber* payCancelTime;
/** 收款方式ids     */
@property (nonatomic, strong,nullable) NSArray * payMethodIds;
/** 价格浮动指数 最小值 */
@property (nonatomic, strong, nullable) NSNumber* priceFluctuationIndex;
/** 价格类型,可用值:Fixed,Fluctuation */
@property (nonatomic, copy, nullable) NSString * priceType;
/** 交易限制 注册天数  -1表示为未选中     */
@property (nonatomic, strong, nullable) NSNumber* registerDay;
/** 交易条款     */
@property (nonatomic, copy, nullable) NSString * transactionTerms;
@end
/**
 下架
 PUT
 /api/ad/{id}/offShelf
 */
@interface C2COffShelfAdverRequest : C2CBaseRequest

@end
/**
 关闭广告
 DELETE
 /api/ad/{id}
 */
@interface C2CDeleteAdverRequest : C2CBaseRequest

@end
/**
 getSecurityToken
 GET
 /api/oss/securityToken
 */
@interface GetC2COssTokenRequest : C2CBaseRequest

@end
NS_ASSUME_NONNULL_END
