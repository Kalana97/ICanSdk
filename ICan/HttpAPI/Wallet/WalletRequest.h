//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 13/11/2019
- File name:  WalletRequest.h
- Description:
- Function List:
*/
        

#import "BaseRequest.h"
@class QTPermission;

NS_ASSUME_NONNULL_BEGIN

@interface WalletRequest : BaseRequest

@end
/** 常用银行列表 */
@interface CommonBankCardsRequest : BaseRequest
/** /如果传了name 就是模糊搜索那些不常用的银行。不传就是获取常用银行 */
@property(nonatomic, copy,nullable) NSString *name;
@end
/** 绑定的支付宝列表 */
@interface BindingAliPayListRequest : BaseRequest

@end
/** 绑定支付宝 */
@interface BindingAliPayRequest : BaseRequest
/** 支付宝账号     */
@property(nonatomic, copy) NSString *account;
@end
/** 解绑支付宝 /bankCards/aliPay/{bindId} */
@interface DeleteAlipayRequest : BaseRequest

@end
/** 绑定的银行卡列表 */
@interface BindingBankCardListRequest : BaseRequest

@end
/** 绑定银行卡 */
@interface BindingBankCardRequest : BaseRequest
/** 银行类型id     */
@property(nonatomic, copy) NSString *bankTypeId;
/** 账号     */
@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSString *cardholderName;
@end

/** 解绑银行卡/bankCards/bankCard/{bindId}/{account}*/
@interface DeleteBankCardRequest : BaseRequest

@end


/// 用户余额
@interface UserBalanceRequest : BaseRequest

@end

@interface TransferRequest : BaseRequest
// 收款人ID
@property (nonatomic,strong,nullable) NSNumber *to;
// 金额
@property (nonatomic,strong,nullable) NSNumber *money;
// 留言
@property(nonatomic, copy,nullable) NSString *reason;
@property(nonatomic, copy) NSString *password;

@property(nonatomic, copy) NSString *currencyCode;
@end
@interface C2CGetAdverPriceListRequest : BaseRequest

@property(nonatomic, copy,nullable) NSString* legalTender;
@property(nonatomic, copy,nullable) NSString* virtualCurrency;
@end

@interface GetFlowsRequest : ListRequest

@property(nonatomic, copy,nullable) NSString *flowType;
@property(nonatomic, copy,nullable) NSString *startTime;
@property(nonatomic, copy,nullable) NSString *endTime;
@property(nonatomic, copy,nullable) NSString *income;

/**
 转账Transfer,
发红包RedPacket
 收红包ReceiveRedPacket, 退红包
RefundRedPacket, 余额支付
BalancePayment,
 余额充值BalanceRecharge
提现Withdraw
,交易扣款是5
TransactionPayment,交易退款 6
TransactionRefund, 第三方代付
ThirdPartyPayment, 第三方代付退款
ThirdPartyPaymentRefund,商城佣金
ShopCommission, 付款码交易
QRCode_Payment,
 * 收款码交易
QRCode_ReceivePayment,
 斯里兰卡充值 Dialog,
线下充值。OfflineRecharge
 */
//@property(nonatomic, copy,nullable) NSString *flowType;
@end

@interface C2CTransferSwipeRequest : BaseRequest
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSNumber *money;
@property(nonatomic, assign) BOOL toC2C;
@end
 
@interface RechargeRequest : BaseRequest
//通道类型
@property(nonatomic, copy,nullable) NSString *payType;
//订单金额
@property(nonatomic,copy,nullable) NSString *orderAmount;
//银行卡账号（银行卡渠道）
@property(nonatomic, copy,nullable) NSString *bankCardNo;
@property (nonatomic, strong,nullable) NSNumber* isSaveCard;
@property (nonatomic, copy,nullable) NSString* quickPayInfoId;

@end

@interface RechargeChannelRequest : BaseRequest
/**
 * 余额充值Balance,
 * 兰卡话费充值 LankaDialog LankaDialog
 */
@property(nonatomic, copy) NSString *scope;
@property(nonatomic, copy) NSString *currencyCode;
@property(nonatomic, copy) NSString *countryCode;
@property(nonatomic, copy) NSString *amount;
@end

@interface RechargeChannelListRequest : BaseRequest
@property(nonatomic, copy) NSString *countryCode;
@property(nonatomic, copy) NSString *paymentId;
@end


/// 获取常用的银行卡列表
@interface GetBankCardsUsuallyRequest : BaseRequest

@end


/// 提现
@interface WithdrawsRequest : BaseRequest
// 银行卡 0  支付宝 1
@property (nonatomic,strong,nullable) NSNumber *type;
// 提现的银行卡，或者支付宝ID
@property (nonatomic,strong,nullable) NSNumber *bindId;
// 金额
@property (nonatomic,strong,nullable) NSDecimalNumber *amount;
//password
@property (nonatomic,copy,nullable) NSString *password;
//password
@property (nonatomic,copy,nullable) NSString *remark;

@end


@interface WithdrawRecordRequest : ListRequest
@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;
@end

/// 充值记录
@interface RechargeRecordListRequest : WithdrawRecordRequest

@end


/// 获取第三方代付订单详情/preparePayOrder/{transactionId}
@interface GetPreparePayOrderDetailRequest : BaseRequest

@end


/// 第三方代付 /preparePayOrder/{transactionId}
@interface PayPreparePayOrderRequest : BaseRequest
@property(nonatomic, copy) NSString *password;
@end

/**
 获取code
 /payQRCode/{type}
 路径参数：
 payment 付款
 receivePayment 收款
 */
@interface GetCodeRequest : BaseRequest
@property(nonatomic, copy,nullable) NSString *money;
@end
/**
 /payQRCode/receivePayment
 通过收款码付款
 */
@interface PayQRCodeReceivePaymentRequest : BaseRequest
@property(nonatomic, copy) NSString *receive;
@property(nonatomic, copy) NSNumber *money;
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy,nullable) NSString *payPassword;
@property(nonatomic, copy,nullable) NSString *comment;

@end
///
/**
 通过付款码收款
 payQRCode/payment
 */
@interface PayQRCodePaymentRequest : BaseRequest
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSNumber *money;
@property(nonatomic, copy,nullable) NSString *comment;
@end

///payQRCode/receiveFlows
@interface PayQRCodereceiveFlowsRequest:ListRequest

@end
/*
付款码页面的金额复制接口复制文档复制地址
GET
/payQRCode/payment/list
 */
@interface GetPayQRCodePaymentListRequest : BaseRequest

@end
/** 支持的全部货币
 GET
 /currency/allSupportedCurrencies
 */
@interface GetAllSupportedCurrenciesRequest:BaseRequest

@end
/**
 c2c划转 金额为正数表示划转到C2C钱包、金额为负数表示划转出C2C钱包
 POST
 /c2c/transfer
 */
@interface WalletTransferRequest:BaseRequest
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy,nullable) NSString *payPassword;
/** 划转金额 */
@property(nonatomic, copy) NSNumber *money;
@property(nonatomic, assign) BOOL toC2C;
@end
/**
 绑定银行卡 v2
 POST
 /bankCards/bankCard/v2
 */
@interface BindingBankCardRequestV2 : BaseRequest
/** 银行类型id     */
@property(nonatomic, copy) NSString *bankTypeId;
/** 账号     */
@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSString *username;
@end
/**
 绑定支付宝 v2
 POST
 /bankCards/aliPay/v2
 */
@interface BindingAliPayRequestV2 : BaseRequest
/** 账号     */
@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSString *username;
@end

@interface BindingAccountRequestV2:BaseRequest
@property(nonatomic, copy) NSString *account;
@property(nonatomic, copy) NSNumber *bankType;
@property(nonatomic, copy) NSString *bankTypeId;
@property(nonatomic, copy) NSString *username;
@end

/**
 支持的全部银行
 GET
 /bankCards/all
 */
@interface IcanAllBankCardsRequest:BaseRequest
@property(nonatomic, copy,nullable) NSString *name;
@end

//Organization
@interface AddOrganizationRequest : BaseRequest
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *organizationImageUrl;
@end

@interface GetOrganizationInfoForUserRequest: BaseRequest
@end

@interface PutOrganizationRequest : BaseRequest
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger orgId;
@property(nonatomic, copy) NSString *organizationImageUrl;
@end

@interface SendInviteRequest : BaseRequest
@property (nonatomic, copy) NSArray<NSNumber *> *inviteeList;
@end

@interface GetInOutTransactionAmountsRequest : BaseRequest
@property(nonatomic, assign) NSInteger filter;
@end

@interface GetSelfTransactionAmountsRequest : BaseRequest
@property(nonatomic, assign) NSInteger filter;
@end

@interface GetTransactionsRequest : ListRequest
@property(nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSArray <NSString *> *types;
@property(nonatomic, assign) NSInteger userId;
@end

@interface GetMemeberListRequest : BaseRequest
@property(nonatomic, copy) NSString *search;
@end

@interface GetContactListRequest : BaseRequest
@property(nonatomic, copy) NSString *search;
@property(nonatomic, assign) BOOL isNumberIdSearch;
@end

@interface GetOrgUserInfoRequest : BaseRequest

@end

@interface GetPermissionsListRequest : BaseRequest
@property (nonatomic, copy) NSArray <NSString *> *types;
@end

@interface OrganizationRemoveUserRequest : BaseRequest
@property(nonatomic, copy) NSString *payPassword;
@property(nonatomic, assign) NSInteger userID;
@end

@interface GetInvitedOTPUsers : BaseRequest
@property(nonatomic, copy) NSString *payPassword;
@property(nonatomic, assign) NSInteger userID;
@end

@interface ConfirmUserByOtpRequest : BaseRequest
@property(nonatomic, copy) NSString *otp;
@property(nonatomic, assign) NSInteger userId;
@end

@interface DeleteOrganizationRequest : BaseRequest
@property(nonatomic, copy) NSString *payPassword;
@property(nonatomic, assign) NSInteger userID;
@end

@interface AddEditLevelRequest : BaseRequest
@property(nonatomic, assign) BOOL isAdd;
@property(nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSArray<NSNumber *> *usersAssigned;
@end

@interface ApproveOrRejectTransaction : BaseRequest
@property(nonatomic, assign) BOOL isApproved;
@property(nonatomic, copy) NSString *payPassword;
@property(nonatomic, copy) NSString *remarks;
@property(nonatomic, assign) NSInteger transactionId;
@end

@interface ChangeUserPermissions : BaseRequest
@property (nonatomic, copy) NSArray<QTPermission *> *permissions;
@property(nonatomic, assign) NSInteger userId;
@end


NS_ASSUME_NONNULL_END
