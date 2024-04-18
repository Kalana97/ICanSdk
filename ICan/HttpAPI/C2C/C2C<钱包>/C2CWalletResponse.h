//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/12/2021
- File name:  C2CWalletResponse.h
- Description:
- Function List:
*/
        

#import "BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CWalletResponse : BaseResponse

@end

/** 牌价列表 */
@interface CurrencyExchangeInfo : IDInfo
@property(nonatomic, copy) NSString * createTime;
/** 持有的货币 */
@property(nonatomic, strong) CurrencyInfo * fromInfo;
/** 持有的货币 代码 */
@property(nonatomic, copy) NSString * fromCode;
/** 手续费率 */
@property(nonatomic, strong) NSDecimalNumber* handlingFee;
/** 买入价格     */
@property(nonatomic, strong) NSDecimalNumber* buyPrice;
/** 卖出价格     */
@property(nonatomic, strong) NSDecimalNumber* sellPrice;
/** 服务费     */
@property(nonatomic, strong) NSDecimalNumber* serviceCharge;
@property(nonatomic, strong) NSDecimalNumber* max;
@property(nonatomic, strong) NSDecimalNumber* min;
/** 目标货币 */
@property(nonatomic, strong) CurrencyInfo * toInfo;
/** 目标货币代码 */
@property(nonatomic, copy) NSString * toCode;

/// VirtualCurrency  LegalTender
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString * updateTime;
@end
///兑换记录返回的数据
@interface ExchangeOrderInfo : CurrencyExchangeInfo
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, strong) NSDecimalNumber * handlingFeeAmount;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSDecimalNumber * serviceChargeAmount;
@property (nonatomic, strong) NSDecimalNumber* toAmount;
@property (nonatomic, assign) NSInteger userId;
@end
@interface ExchangeOrderListInfo : ListInfo

@end
///主网地址
@interface ICanWalletMainNetworkInfo : NSObject
/** 通道code     */
@property (nonatomic, copy) NSString * channelCode;
@property (nonatomic, assign) NSInteger channelId;
@property (nonatomic, copy) NSString * channelName;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL isSelected;

/** 手续费 */
@property (nonatomic, strong) NSDecimalNumber* handlingFee;
/** 充值解锁确认数     */
@property (nonatomic, strong) NSDecimalNumber* rechargeConfirmNumber;
/** 最小充值数     */
@property (nonatomic, strong) NSDecimalNumber* rechargeMin;
/** 提现解锁确认数     */
@property (nonatomic, strong) NSDecimalNumber* withdrawConfirmNumber;
@property (nonatomic, copy) NSString * updateTime;
/**GetC2CFlowsExternalPayDetailInfo示不限制     */
@property (nonatomic, copy) NSString * walletAddressBegin;
/** 钱包地址的长度 0表示不限制     */
@property (nonatomic, assign) NSInteger walletAddressLength;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, strong) NSDecimalNumber *withdrawMax;
@property (nonatomic, strong) NSDecimalNumber *withdrawMin;
@property (nonatomic, strong) NSDecimalNumber *withdrawHandlingFeeMoney;

@end
/** 全部的钱包地址簿
 */
@interface ICanWalletAddressInfo : NSObject
@property (nonatomic, copy) NSString * address;
@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, copy) NSString * channelCode;
@property (nonatomic, copy) NSString * currencyCode;
@property (nonatomic, copy) NSString * tag;
@property (nonatomic, assign) NSInteger userId;

@end

@interface C2CQRCodeReceiveCodeInfo : NSObject
@property (nonatomic, strong) NSDecimalNumber* amount;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * currencyCode;
@property (nonatomic, assign) NSInteger qrcodeReceiveId;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, assign) NSInteger userId;

@end

@interface C2CWatchWalletInfo : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSDecimalNumber *money;
@property (nonatomic, copy) NSString *logo;
@end

@interface SimpleUserDTOInfo : NSObject
@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * headImgUrl;
@property (nonatomic, assign) BOOL kyc;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * numberId;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, assign) NSInteger userId;

@end
@interface C2CTransferHistoryInfo : NSObject
@property (nonatomic, copy) NSString * appId;
@property (nonatomic, copy) NSString * headImgUrl;
@property (nonatomic, assign) BOOL kyc;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * numberId;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, assign) NSInteger userId;

@end
@interface C2CFlowsInfo : NSObject
@property (nonatomic, strong) NSDecimalNumber* amount;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * currencyCode;
@property (nonatomic, assign) NSInteger flowId;
/**
 ExternalWithdraw => 提现 QrcodePayFlow => 二维码收款 TransferRecord => 转账 AdOrder => c2c交易 FundsTransfer => 划转
 ExternalRecharge => 外网充值   ExtPaymentOrderRefund->第三方充值退款

*/
@property (nonatomic, copy) NSString * flowType;
@property (nonatomic, copy) NSString * channelCode;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, strong) SimpleUserDTOInfo * simpleUserDTO;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *showTitle;
@end
@interface C2CTransferHistoryListInfo:C2CListInfo
@end

@interface C2CPrivateParameterInfo:NSObject
@property(nonatomic, assign) NSUInteger sellerAppealTime;
@property(nonatomic, assign) NSUInteger buyerAppealTime;
///默认的区号
@property(nonatomic, copy) NSString *defaultCountriesCode;

@end

@interface GetC2CFlowsExternalWithdrawDetailInfo : NSObject
/**
 是否确认到账
 */
@property(nonatomic, assign) BOOL confirm;
/**
 确认到账时间
 */
@property(nonatomic, copy) NSString *confirmTime;

@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, strong) NSDecimalNumber *amount;
@property(nonatomic, copy) NSDecimalNumber *handlingFeeMoney;
@property(nonatomic, copy) NSString *currencyCode;
/** 充值展示这个 */
@property(nonatomic, copy) NSString *fromAddress;
/** 提现展示这个 */
@property(nonatomic, copy) NSString *toAddress;
@property(nonatomic, copy) NSString *transactionHash;
///申请时间
@property(nonatomic, copy) NSString *createTime;
/** 订单状态,可用值:PROCESSING,SUCCESS,FAILED */
@property(nonatomic, copy) NSString *orderStatus;
@property(nonatomic, copy) NSString *channelCode;
@end
/**
 c2c收付款码流水
 */
@interface C2CQrcodePayFlowDetailInfo : NSObject
@property (nonatomic, strong) NSDecimalNumber* amount;
/** 收款码code */
@property (nonatomic, copy) NSString * code;
///申请时间
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * currencyCode;
/**付款留言 */
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSString * payFlowId;
@property (nonatomic, copy) NSString * payUid;
@property (nonatomic, assign) NSInteger payUserId;
@property (nonatomic, assign) NSString * receiveUid;
@property (nonatomic, assign) NSInteger receiveUserId;
@property (nonatomic, copy) NSString * remark;

@end

@interface GetC2CFlowsExternalRechargeDetailInfo : NSObject

@property(nonatomic, copy) NSString *orderId;
@property(nonatomic, strong) NSDecimalNumber *amount;
@property(nonatomic, copy) NSString *currencyCode;
/** 充值展示这个 */
@property(nonatomic, copy) NSString *fromAddress;
/** 提现展示这个 */
@property(nonatomic, copy) NSString *toAddress;
@property(nonatomic, copy) NSString *transactionHash;
///申请时间
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *rechargeId;
/** 订单状态,可用值:PROCESSING,SUCCESS,FAILED */
@property(nonatomic, copy) NSString *orderStatus;
@property(nonatomic, copy) NSString *channelCode;
@end

@interface GetC2CFlowsExternalPayDetailInfo : NSObject

@property(nonatomic, copy) NSString *merchantOrderId;
@property(nonatomic, copy) NSString *currencyCode;
@property(nonatomic, strong) NSDecimalNumber* amount;
@property(nonatomic, copy) NSString *appId;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *detail;
@end


@interface GetC2CFlowsExternalRefundDetailInfo : NSObject

@property (nonatomic, strong) NSDecimalNumber* actualAmount;
@property (nonatomic, copy) NSString * actualCurrencyCode;
@property (nonatomic, strong) NSDecimalNumber* amount;
@property (nonatomic, copy) NSString * appId;
///申请时间
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, strong) NSDecimalNumber* feeRate;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, copy) NSString * merchantOrderId;
@property (nonatomic, copy) NSString * refundReason;
@property (nonatomic, copy) NSString * refundTransactionId;
@property (nonatomic, copy) NSString * transactionId;
@property (nonatomic, assign) NSInteger userId;
@end
NS_ASSUME_NONNULL_END

