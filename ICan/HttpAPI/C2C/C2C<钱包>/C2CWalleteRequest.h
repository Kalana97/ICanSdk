//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 16/12/2021
- File name:  C2CWalleteRequest.h
- Description:
- Function List:
*/
        

#import "C2CBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2CWalleteRequest : C2CBaseRequest

@end
/**
 c2c钱包
 资产列表
 /currency/balance
 GET
 /api/wallet
 */
@interface GetC2CBalanceListRequest : C2CBaseRequest

@end
/**
 牌价列表
 GET
 /api/currency/exchange/list
 */
@interface GetC2CExchangeRequest : C2CBaseRequest
/** 持有货币代码 */
@property(nonatomic, copy) NSString *from;
/** 目标货币代码 */
@property(nonatomic, copy) NSString *to;
@end

/**
 兑换
 POST
 /currency/exchange
 */
@interface PostC2CCurrencyExchangeRequest : C2CBaseRequest
/** 持有货币金额 */
@property(nonatomic, copy) NSDecimalNumber * money;
/** 持有货币代码 */
@property(nonatomic, copy) NSString * fromCode;
/**目标货币代码 */
@property(nonatomic, copy) NSString * toCode;
@property(nonatomic, copy) NSString *payPassword;
@end
/**
 兑换记录
 GET
 /currency/exchange/order/page
 */
@interface GetC2CExchangeOrderListRequest : C2CListRequest

@end

/**
 根据货币获取主网
 GET
 /api/channel/byCurrency/{code}
 */
@interface GetC2CMainNetworkByCurrencyRequest : C2CBaseRequest

@end
/**
 添加地址簿
 POST
 /api/address
 */
@interface AddIcanWalletAddressRequest : C2CBaseRequest
@property (nonatomic, copy,nullable) NSString * address;
@property (nonatomic, copy,nullable) NSString * channelCode;
@property (nonatomic, copy,nullable) NSString * currencyCode;
@property (nonatomic, strong,nullable) NSString * tag;

@end
/**
 全部的钱包地址簿
 GET
 /api/address/list
 */
@interface GetAllIcanWalletAddressRequest : C2CBaseRequest

@end
/**
 删除
 DELETE
 /api/address/{id}
 */
@interface DeleteIcanWalletAddressRequest : C2CBaseRequest

@end
/**
 提现
 POST
 /api/ext/wallet/withdraw
 */
@interface IcanWalletWithdrawRequest : BaseRequest
@property (nonatomic, strong) NSDecimalNumber* amount;
/** 提现的主网Code */
@property (nonatomic, copy) NSString * channelCode;
@property (nonatomic, copy) NSString * currencyCode;
/** 提现的钱包地址     */
@property (nonatomic, copy) NSString * walletAddress;
@property(nonatomic, copy) NSString *payPassword;
@end
/**
 获取C2C收款二维码code
 POST
 /api/qrcodeReceive/init
 */
@interface GetC2CQRCodeReceiveRequest : C2CBaseRequest
@property(nonatomic, copy,nullable) NSString *currencyCode;
@property(nonatomic, strong,nullable) NSDecimalNumber *amount;
@property(nonatomic, copy,nullable) NSString *remark;
@end

/**
 扫描收款码进行付款
 POST
 /api/qrcodeReceive/pay
 */
@interface C2CQRCodeReceivePayRequest : C2CBaseRequest
/** 货币单位     */
@property(nonatomic, copy,nullable) NSString *currencyCode;

@property(nonatomic, copy,nullable) NSString *code;
@property(nonatomic, strong,nullable) NSDecimalNumber *amount;
/** 收款留言 */
@property(nonatomic, copy,nullable) NSString *message;
@property(nonatomic, copy) NSString *payPassword;
@end

/**
 通过code，获取收款码信息
 GET
 /api/qrcodeReceive/{code}
 */
@interface GetQRCodeReceiveMessageRequest : C2CBaseRequest

@end
/**
 c2c转账
 POST
 /api/transfer
 */
@interface C2CTransferRequest : BaseRequest
@property(nonatomic, strong) NSDecimalNumber *amount;
@property(nonatomic, copy) NSString *currencyCode;
@property(nonatomic, copy, nullable) NSString *remark;
@property(nonatomic, copy) NSString *toUserId;
@property(nonatomic, copy) NSString *payPassword;
@property(nonatomic, copy) NSString *operationSource;
@end

@interface C2CAddWalletRequest : C2CBaseRequest
@property(nonatomic, copy) NSString *channelCode;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *verifyCode;
@property(nonatomic, copy) NSString *walletAddress;
@end

@interface C2CAddWalletVerifyRequest : C2CBaseRequest

@end

@interface C2CAddWalletAsDefault : C2CBaseRequest

@end
/**
 c2c最近转账
 GET
 /api/transfer/history
 */
@interface C2CTransferHistoryRequest : C2CBaseRequest

@end
/**
 c2c流水列表
 GET
 /api/flows/page
 */
@interface C2CTransferHistoryListRequest : C2CListRequest
/** ExternalWithdraw => 提现 QrcodePayFlow => 二维码收款 TransferRecord => 转账 AdOrder => c2c交易 FundsTransfer => 划转
*/
@property(nonatomic, copy,nullable) NSString *type;
@property(nonatomic, copy,nullable) NSString *start;
@property(nonatomic, copy,nullable) NSString *end;
@end
/**
 wallet
 GET 获取某个资产
 /api/wallet/{code}
 */
@interface GetAssetRequest : C2CBaseRequest

@end
/**
 获取隐私参数
 GET
 /api/privateParameter
 */
@interface GetWatchWalletListRequest : C2CBaseRequest

@end

@interface DeleteWalletFromListRequest : C2CBaseRequest

@end

@interface C2CGetWalletDetailsRequest : C2CBaseRequest

@end

@interface GetC2CPrivateParameterRequest : C2CBaseRequest

@end

/**
 获取c2c流水的广告订单详情
 GET
 /api/flows/adOrder/{orderId}
 */
@interface GetC2CFlowsAdOrderDetailRequest : C2CBaseRequest
@end
/**
 获取c2c流水的第三方支付详情 C2CPreparePayOrderDetailInfo
 GET
 /api/flows/extPay/{orderId}
 */
@interface GetC2CFlowsExtPayDetailRequest : C2CBaseRequest
@end
/**
 获取c2c流水的提现详情 GetC2CFlowsExternalWithdrawDetailInfo
 GET
 /api/flows/externalWithdraw/{orderId}
 */
@interface GetC2CFlowsExternalWithdrawDetailRequest : C2CBaseRequest
@end
/**
 获取c2c流水的收款详情 C2CQrcodePayFlowDetailInfo
 GET
 /api/flows/qrcodePayFlow/{orderId}
 */
@interface GetC2CFlowsQrcodePayFlowDetailRequest : C2CBaseRequest
@end

/**
 账单外网充值流水详情 GetC2CFlowsExternalRechargeDetailInfo
 GET
 /api/flows/externalRecharge/{orderId}
 */
@interface GetC2CFlowsExternalRechargeDetailRequest : C2CBaseRequest
@end

/**
 退款详情
 GET
 /api/flows/extPayRefund/{orderId}
 */
@interface GetC2CFlowsExternalRefundDetailRequest : C2CBaseRequest
@end
NS_ASSUME_NONNULL_END
