//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  C2CBaseRequest.h
- Description:
- Function List:
*/
        

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CBaseRequest : NSObject
/**请求的域名*/
@property (nonatomic,copy)   NSString *  baseUrlString;
/**请求的地址*/
@property (nonatomic,copy)   NSString *  pathUrlString;
/** 请求的方法 */
@property (nonatomic,assign)  RequestMethod requestMethod;
/** 超时时间 */
@property (nonatomic,assign)  NSTimeInterval timeoutInterval;
/** 请求的接口名字 */
@property (nonatomic,copy)    NSString *  requestName;
/** 每个request对应的任务 */
@property (nonatomic,strong)  NSURLSessionDataTask * dataTask;
/** 是否是httpdata返回 默认就是NO  默认是json返回 */
@property (nonatomic,assign)  BOOL isHttpResponse;
/** 是否是body传递参数 */
@property (nonatomic, assign) BOOL isBodyParameter;
/** 请求参数 */
@property (nonatomic)         id  parameters;

@property (nonatomic,copy,nullable) NSString * ID;
@property (nonatomic,assign) bool isPrivatAPi;
+(instancetype _Nonnull )request;
@end
@interface C2CListRequest : C2CBaseRequest
@property(nonatomic, strong) NSNumber *current;
@property(nonatomic, strong) NSNumber *size;
@end
/**
 发布广告
 POST
 /c2c/ad
 */

@interface C2CPublishAdvertRequest : C2CBaseRequest
/** 自动消息     */
@property (nonatomic, copy, nullable) NSString * autoMessage;
/** 是否可用，上架 */
@property (nonatomic, assign) BOOL available;
/** 交易限制 BTC金额 -1表示为未选中     */
@property (nonatomic, strong, nullable) NSNumber* btcLimit;
/** 广告数量     */
@property (nonatomic, strong) NSDecimalNumber* count;
/** 固定价格     */
@property (nonatomic, strong, nullable) NSDecimalNumber* fixedPrice;
/** 法币Code     */
@property (nonatomic, copy, nullable) NSString * legalTender;
/** 最大限额     */
@property (nonatomic, strong, nullable) NSDecimalNumber* max;
/** 最小限额     */
@property (nonatomic, strong, nullable) NSDecimalNumber* min;
/** 支付失效 单位分钟     */
@property (nonatomic, assign) NSInteger payCancelTime;
/** 收款方式ids     */
@property (nonatomic, strong) NSArray * payMethodIds;
/** 价格浮动指数 最小值 */
@property (nonatomic, strong, nullable) NSDecimalNumber* priceFluctuationIndex;
/** 价格类型,可用值:Fixed,Fluctuation */
@property (nonatomic, copy) NSString * priceType;
/** 交易限制 注册天数  -1表示为未选中     */
@property (nonatomic, strong, nullable) NSNumber* registerDay;
/** 交易条款     */
@property (nonatomic, copy, nullable) NSString * transactionTerms;
/** 交易类型,可用值:Buy,Sell     */
@property (nonatomic, copy, nullable) NSString * transactionType;
/** 虚拟货币Code     */
@property (nonatomic, copy, nullable) NSString * virtualCurrency;
@end

/**
 添加收款方式
 POST
 /c2c/paymentMethod
 
 */
@interface C2CAddPaymentMethodRequest : C2CBaseRequest
/** 账号     */
@property (nonatomic, copy ,nullable) NSString * account;
/** 收款银行     */
@property (nonatomic, copy ,nullable) NSString * bankName;
/** 开户分行         */
@property (nonatomic, copy ,nullable) NSString * branch;
/** 姓名     */
@property (nonatomic, copy ,nullable) NSString * name;
/** 收款类型,可用值:Wechat,AliPay,BankTransfer     */
@property (nonatomic, copy ,nullable) NSString * paymentMethodType;
/** 二维码         */
@property (nonatomic, copy ,nullable) NSString * qrCode;
/** 备注   */
@property (nonatomic, copy ,nullable) NSString * remark;
@property (nonatomic, copy ,nullable) NSString * mobile;
@property (nonatomic, copy ,nullable) NSString * address;
@end

@interface C2CGetPaymentMethodRequest : C2CBaseRequest

@end
/*
 删除收款方式
 DELETE
 /api/paymentMethod/{paymentMethodId}
 */
@interface C2CDeleteMyPaymentMethodRequest : C2CBaseRequest

@end
/**
 支持的全部货币
 GET
 /c2c/exchange/allSupportedCurrencies
 */
@interface GetC2CAllSupportedCurrenciesRequest : C2CBaseRequest

@end

/**
 收藏的货币code
 GET
 /api/currency/collect/list
 */
@interface GetC2CCollectCurrencyRequest : C2CBaseRequest

@end

/**
 收藏
 POST
 /api/currency/collect/{code}
 */
@interface PostC2CCollectCurrencyRequest : C2CBaseRequest

@end
/**
 取消收藏复制接口复制文档复制地址
 DELETE
 /api/currency/collect/{code}
 */
@interface DeleteC2CCollectCurrencyRequest : C2CBaseRequest

@end
/**
 全部的汇率
 GET
 /c2c/exchange/list
 */
@interface GetC2CAllExchangeListRequest : C2CBaseRequest
/** 支持的类型 all c2c pay */
@property(nonatomic, copy) NSString *support;
@end
/*
 获取当前用户的信息
 GET
 /api/user/info
 */
@interface C2CGetCurrentUserInfoRequest : C2CBaseRequest

@end

@interface C2CCreateNewWalletRequest : C2CBaseRequest
@property (nonatomic, copy ,nullable) NSString *channelCode;
@property (nonatomic, copy ,nullable) NSString *numberId;
@end

/*
 获取用户信息
 GET
 /api/user/{id}
 */
@interface C2CGetUserInfoRequest : C2CBaseRequest

@end
/**
 收款信息详情
 GET
 /api/paymentMethod/{id}
 */
@interface C2CGetPaymentMethodDetailRequest : C2CBaseRequest


@end

/**
 用户数据
 GET
 /api/user/data/{id}
 */
@interface C2CGetUserMoreDataRequest : C2CBaseRequest


@end


/**
 通过numberId获取用户信息
 GET
 /api/user/numberId/{numberId}
 */

@interface C2CGetUserMessageByIcanNumberIdRequest : C2CBaseRequest

@end

/**
 根据订单ID获取第三方订单详情
 preparePayOrderDetail
 GET
 /api/preparePayOrder/{transactionId}
 */
@interface GetC2CPreparePayOrderDetailRequest : C2CBaseRequest

@end

/**
 支付订单
 PUT
 /api/preparePayOrder/{transactionId}
 */
@interface PutC2CPreparePayOrderRequest : C2CBaseRequest
/**
 实际支付的货币如果是我行余额还是传CNY
 */
@property(nonatomic, copy) NSString *actualCurrencyCode;
@end
NS_ASSUME_NONNULL_END
