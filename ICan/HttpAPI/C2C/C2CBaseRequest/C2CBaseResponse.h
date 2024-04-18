//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  C2CBaseResponse.h
- Description:
- Function List:
*/
        

#import "BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CBaseResponse : BaseResponse

@end
@interface C2CListInfo : NSObject
@property(nonatomic, assign) NSInteger current;
/** 一共有多少页 */
@property(nonatomic, assign) NSInteger pages;
@property(nonatomic, strong) NSArray  *records;
@property(nonatomic, assign) NSInteger size;
@property(nonatomic, assign) NSInteger total;

@end

@interface C2CAddAddressResponse : NSObject
@property (nonatomic, assign) BOOL verify;
@end

@interface C2CPaymentMethodInfo : IDInfo
/** 账号     */
@property (nonatomic, copy) NSString * account;
/** 收款银行     */
@property (nonatomic, copy) NSString * bankName;
/** 开户分行         */
@property (nonatomic, copy) NSString * branch;
/** 姓名     */
@property (nonatomic, copy) NSString * name;
/** 收款类型,可用值:Wechat,AliPay,BankTransfer     */
@property (nonatomic, copy) NSString * paymentMethodType;
/** 二维码         */
@property (nonatomic, copy) NSString * qrCode;
@property(nonatomic, copy) NSString *paymentMethodId;
/** 备注   */
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, assign) NSInteger userId;
@end

@interface C2CExchangeRateInfo : IDInfo<NSCoding>
@property (nonatomic, copy) NSString * createTime;
/** 固定价格/推荐价格     1个虚拟货币等于多少个法币 */
@property (nonatomic, strong) NSDecimalNumber* fixedPrice;
/** 手续费率     */
@property (nonatomic, strong) NSDecimalNumber* handlingFee;
@property (nonatomic, assign) NSInteger idField;
/** 法币Code     */
@property (nonatomic, copy) NSString * legalTender;
/** 法币名称     */
@property (nonatomic, strong) CurrencyInfo * legalTenderInfo;
/** 市场最高价     */
@property (nonatomic, strong) NSDecimalNumber* maxPrice;
/** 价格浮动指数 最大值 */
@property (nonatomic, strong) NSDecimalNumber* maxPriceFluctuationIndex;
/** 市场最低价     */
@property (nonatomic, strong) NSDecimalNumber* minPrice;
/** 价格浮动指数 最小值     */
@property (nonatomic, strong) NSDecimalNumber* minPriceFluctuationIndex;
@property (nonatomic, copy) NSString * updateTime;
/** 虚拟货币Code     */
@property (nonatomic, copy) NSString * virtualCurrency;
/** 虚拟货币名称     */
@property (nonatomic, strong) CurrencyInfo * virtualCurrencyInfo;
///最小限额
@property (nonatomic, strong) NSDecimalNumber *minQuota;
///最大限额
@property (nonatomic, strong) NSDecimalNumber *maxQuota;
@property (nonatomic, assign) BOOL supportC2C;
@property (nonatomic, assign) BOOL supportPay;
@end
@interface ExternalWalletsInfo:NSObject
/** 所属的主网通道 */
@property (nonatomic, copy) NSString * channelCode;
@property (nonatomic, copy) NSString * createTime;
/** 钱包id */
@property (nonatomic, assign) NSInteger externalWalletId;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, assign) NSInteger userId;
/** 钱包地址     */
@property (nonatomic, copy) NSString * walletAddress;

@end
@interface C2CUserInfo:NSObject
/** 外网钱包信息    用来充值使用的 */
@property(nonatomic, strong) NSArray<ExternalWalletsInfo*> *externalWallets;
@property (nonatomic, copy) NSString * appId;
/** 30日平均收款时间     */
@property (nonatomic, assign) float averageConfirmTime;
/// 30日平均付款时间
@property (nonatomic, assign) float averagePayTime;
/** 购买总成单数     */
@property (nonatomic, assign) NSInteger buyClinchCount;
/** 购买订单数量     */
@property (nonatomic, assign) NSInteger buyOrderCount;
/** 总完成单数     */
@property (nonatomic, assign) NSInteger clinchCount;
/** 总订单数     */
@property (nonatomic, assign) NSInteger orderCount;
/** 注册时间     */
@property (nonatomic, copy) NSString * createTime;
/** 是否注销 */
@property (nonatomic, assign) BOOL deleted;
/** 首次下单时间     */
@property (nonatomic, copy) NSString * firstOrderTime;
/** 头像     */
@property (nonatomic, copy) NSString * headImgUrl;
/** 是否实名     */
@property (nonatomic, assign) BOOL kyc;
/** 差评数量     */
@property (nonatomic, assign) NSInteger negativeCount;
/** 昵称 */
@property (nonatomic, copy) NSString * nickname;
@property(nonatomic, copy) NSString *numberId;
/** 好评数     */
@property (nonatomic, assign) NSInteger praiseCount;
/** 出售总成单数     */
@property (nonatomic, assign) NSInteger sellClinchCount;
/** 出售订单数     */
@property (nonatomic, assign) NSInteger sellOrderCount;
/** 交易人数     */
@property (nonatomic, assign) NSInteger transactionUserCount;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * userId;
@end
@interface C2CUserMoreDataInfo : NSObject

@end
///c2c 钱包返回的数据
@interface C2CBalanceListInfo : NSObject
@property (nonatomic, strong) NSDecimalNumber* money;
@property (nonatomic, strong) NSDecimalNumber* frozenMoney;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger walletId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy)   NSString *code;

@end

@interface WatchWalletListInfo : NSObject
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *channelCode;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger observeWalletId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *walletAddress;
@property (nonatomic, copy) NSString *extendAddress;
@property (nonatomic, copy) NSString *extendAddress1;
@property (nonatomic, copy) NSString *extendAddress2;
@property (nonatomic, assign) BOOL isDefault;

@end
///外部支付
@interface C2CPreparePayOrderDetailInfo:NSObject
/**
 下单的订单金额
 */
@property (nonatomic, copy) NSString* amount;


@property (nonatomic, copy) NSString * appId;
/// 附加数据
@property (nonatomic, copy) NSString * attach;
/// 商品描述
@property (nonatomic, copy) NSString * body;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, strong) CurrencyInfo * currency;
@property (nonatomic, copy) NSString * currencyCode;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, copy) NSString * finishTime;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, copy) NSString * merchantOrderId;
@property (nonatomic, assign) BOOL notifyFailed;
@property (nonatomic, assign) BOOL notifySuccess;
@property (nonatomic, copy) NSString * notifySuccessTime;
/// 通知地址
@property (nonatomic, copy) NSString * notifyUrl;
/// 支付系统订单号
@property (nonatomic, copy) NSString * transactionId;
/// 是否已经尝试支付了
@property (nonatomic, assign) BOOL tryToPay;
@property (nonatomic, assign) NSInteger userId;
///预设的支付币种
@property (nonatomic, copy) NSString *presetCurrencyCodes;

@end
NS_ASSUME_NONNULL_END
