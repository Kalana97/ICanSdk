//
/**
 - Copyright © 2019 dzl. All rights reserved.
 - Author: Created  by DZL on 13/11/2019
 - File name:  WalletResponse.h
 - Description:
 - Function List:
 */


#import "BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@class QTPermission;

@interface WalletResponse : BaseResponse

@end

/** 常用银行列表 */
@interface CommonBankCardsInfo : IDInfo
/** 银行名     */
@property(nonatomic, copy) NSString *name;
/** 银行编码     */
@property(nonatomic, copy) NSString *sh;
@property(nonatomic, copy) NSString *aliPay;
@property(nonatomic, copy) NSString *priority;
@property(nonatomic, copy) NSString *logo;
@end

/** 绑定的支付宝列表 */
@interface BindingAliPayListInfo : BaseResponse
/** 绑定id     */
@property(nonatomic, copy) NSString *bindId;
/** 账号 */
@property(nonatomic, copy) NSString *account;
/** 类型     */
@property(nonatomic, copy) NSString *type;
/** 银行名     */
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy)   NSString *username;
@end

@interface AdPriceInfo : BaseResponse

@property(nonatomic, assign) NSInteger adId;
@property(nonatomic, assign) NSNumber *count;
@property(nonatomic, assign) BOOL supportWechat;
@property(nonatomic, assign) BOOL supportBankTransfer;
@property(nonatomic, assign) BOOL supportCash;
@property(nonatomic, assign) BOOL supportAliPay;
@end

/** 绑定的银行卡列表 */
@interface BindingBankCardListInfo : BaseResponse
/** 绑定id     */
@property(nonatomic, copy)   NSString *bindId;
/** 卡号         */
@property(nonatomic, copy)   NSString *cardNo;
/** 银行名         */
@property(nonatomic, copy)   NSString *bankName;
/** 银行缩写         */
@property(nonatomic, copy)   NSString *bankCode;
/** 银行缩写         */
@property(nonatomic, copy)   NSString *logo;
/** 用户姓名 */
@property(nonatomic, copy)   NSString *username;
@end

@interface UserBalanceInfo : BaseResponse
@property(nonatomic, strong) NSDecimalNumber* balance;
//是否设置了支付密码 1是设置
@property(nonatomic, assign) BOOL tradePswdSet;
//钱包是否可用
@property(nonatomic, copy)   NSString *walletStatus;
//walletUserNo
@property(nonatomic, copy)   NSString *walletUserNo;
//提现的手续费费率
@property(nonatomic, strong)   NSDecimalNumber *withdrawRate;
/** 冻结金额 */
@property(nonatomic, copy)   NSString *frozenAmount;
@property(nonatomic, strong) NSDecimalNumber *withdrawMinAmount;
@property(nonatomic, assign) BOOL isEmailBound;
@property(nonatomic, assign) BOOL mustBindEmailPayPswd;
@end



@interface BillListInfo : BaseResponse

@end


@interface BillInfo : IDInfo
@property(nonatomic, copy) NSString *unit;
@property(nonatomic, copy) NSString *payChannelTypeName;
/**
 支付渠道类型,可用值:Balance,BankCard,CreditCard,AliPay,WeChatPay
 */
@property(nonatomic, copy) NSString *payChannelType;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *flowCode;
/**
 转账Transfer
 发红包RedEnvelopes
 收红包 ReceiveRedEnvelope
 退红包RefundRedEnvelope
 余额支付BalancePayment
 余额充值 BalanceRecharge
 提现Withdraw
 交易扣款是TransactionPayment
 交易退款TransactionRefund
 第三方代付ThirdPartyPayment
 商城佣金  ShopCommission
 线下充值 OfflineRecharge
 购买会员  MemberBuy
 购买ID NumberIdBuy
 
 */
@property(nonatomic, copy) NSString *flowType;
/** 备注     */
@property(nonatomic, copy) NSString *reason;
@property(nonatomic, copy) NSString *userId;
/** 流水说明     */
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *contentEn;

@property(nonatomic, copy) NSString *imageStr;
/** 当前余额 */
@property(nonatomic, assign) double balance;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, assign) double amount;

/** 实际充值金额 */
@property(nonatomic,assign)   double actualAmount;
/** 实际订单金额单位     */
@property(nonatomic,strong) NSString * actualUnit;
@property(nonatomic, copy) NSString *flowTypeCn;
@property(nonatomic, copy) NSString *flowTypeEn;
@property(nonatomic, copy) NSString *reasonEn;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *titleEn;

@property(nonatomic, copy) NSString *listTitle;
@property(nonatomic, copy) NSString *flowTypeTitle;

@end

@interface FlowsListInfo : ListInfo

@end

@interface RechargeInfo : BaseResponse
//支付url
@property(nonatomic, copy) NSString *payUrl;
//唤起sdk的地址
@property(nonatomic, copy) NSString *payInfo;

@end

@interface RechargeChannelListInfo : BaseResponse
@property(nonatomic,strong)NSArray * object;

@end

@interface RechargeChannelInfo : IDInfo
//充值类型
@property(nonatomic, copy) NSString *payType;
//充值通道ID
@property(nonatomic, copy) NSString *channelCode;
//是否预填写银行卡信息，如果是，就跳转到选择银行卡的页面
@property(nonatomic, assign) BOOL autoAddBank;
//最小金额
@property(nonatomic, copy) NSString *minAmount;
//最大金额
@property(nonatomic, copy) NSString *maxAmount;

@property(nonatomic, copy) NSString *channelName;

@property(nonatomic, copy) NSString *enabled;

@property(nonatomic, copy) NSString *weights;
@property(nonatomic, copy) NSString *scope;
@property(nonatomic, copy) NSString *imageurl;
@property(nonatomic, copy) NSString *logo;
@property(nonatomic, assign) BOOL select;
@property(nonatomic, copy) NSString *acceptedCurrencyCode;
@property(nonatomic, copy) NSString *convertedAmount;
@property(nonatomic, assign) BOOL isSelected;
@end

@interface RechargeChannelListNewInfo : IDInfo

@property(nonatomic, copy) NSString *paymentStatus;

@property(nonatomic, copy) NSString *amount;

@property(nonatomic, copy) NSString *code;

@property(nonatomic, copy) NSString *symbol;

@property(nonatomic, copy) NSString *nameCn;

@property(nonatomic, copy) NSString *nameEn;

@property(nonatomic, copy) NSString *icon;

@property(nonatomic, copy) NSString *type;

@property(nonatomic, copy) NSString *weights;

@property(nonatomic, copy) NSString *paymentType;

@property(nonatomic, copy) NSArray *payChannels;
@end

@interface BankCardsUsuallyInfo : BaseResponse
//卡号
@property(nonatomic, copy) NSString *bankCardName;
//使用时间
@property(nonatomic, copy) NSString *updateDate;
//使用次数
@property(nonatomic, copy) NSString *use;

@end
@interface WithdrawRecordListInfo : ListInfo

@end
/** 提现记录 */

@interface WithdrawRecordInfo : IDInfo
/** 用户ID     */
@property(nonatomic, copy) NSString *userId;
/** 订单号     */
@property(nonatomic, copy) NSString *orderId;
/** 支付系统订单号     */
@property(nonatomic, copy) NSString *payOrderId;
/** 是否是支付宝提现     */
@property(nonatomic, copy) NSString *isAliPay;
/** 提现选择的银行卡/支付宝     */
@property(nonatomic, copy) NSString *cardNumber;
/** 提现的银行     */
@property(nonatomic, copy) NSString *bankName;
/** 订单金额     */
@property(nonatomic, copy) NSString *amount;
/** 提现手续费     */
@property(nonatomic, copy) NSString *commissionRate;
/** 申请时间         */
@property(nonatomic, copy) NSString *createTime;
/** 完成时间     */
@property(nonatomic, copy) NSString *finishTime;
@property(nonatomic, copy) NSString *content;
/**
 处理中(待审核)Processing,成功Success,失败Fail,审核通过AuditPassed,* PayingPrePaying,线下支付处理中OfflinePaying
 */
@property(nonatomic, copy) NSString *withdrawStatus;
/** 原因 */
@property(nonatomic, copy) NSString *reason;
@end

@interface RechargeRecordListInfo : ListInfo

@end
@interface RechargeRecordInfo : IDInfo
/** 是否完成     */
@property(nonatomic, copy) NSString *done;
/** 充值状态     */
@property(nonatomic, copy) NSString *rechargeStatus;
/** 金额 */
@property(nonatomic, copy) NSString *amount;
/** 所属的用户     */
@property(nonatomic, copy) NSString *userId;
/** 创建时间     */
@property(nonatomic, copy) NSString *createTime;
/** 订单号     */
@property(nonatomic, copy) NSString *merchantOrderId;
/** 支付系统订单号     */
@property(nonatomic, copy) NSString *payOrderId;
/** 备注 */
@property(nonatomic, copy) NSString *reason;
@end

@interface PreparePayOrderDetailInfo : NSObject
/**应用名称    */
@property (nonatomic,copy,nullable) NSString * name;
/**应用图片URL    */
@property (nonatomic,copy,nullable) NSString * avatar;
/**金额*/
@property (nonatomic,copy,nullable) NSString * amount;
/**商品*/
@property (nonatomic,copy,nullable) NSString * body;
/**商品详情    */
@property (nonatomic,copy,nullable) NSString * detail;

@end

/** 收款记录 */
@interface ReceiveFlowsInfo : IDInfo
/**
 流水号
 */
@property(nonatomic, copy) NSString *orderId;
/**
 付款用户id
 */
@property(nonatomic, copy) NSString *payUserId;
/**
 付款用户昵称
 
 */
@property(nonatomic, copy) NSString *payUserNickname;
/**
 付款用户头像
 
 */
@property(nonatomic, copy) NSString *payUserHeadImgUrl;
/**
 付款用户性别
 
 */
@property(nonatomic, copy) NSString *payUserGender;
/**
 付款用户numberid
 
 */
@property(nonatomic, copy) NSString *payUserNumberId;
/**
 收款人id
 
 */
@property(nonatomic, copy) NSString *receiveUserId;
/**
 金额
 
 */
@property(nonatomic, copy) NSString *money;
/**
 时间
 
 */
@property(nonatomic, assign) NSInteger payTime;
/**
 二维码类型
 
 */
@property(nonatomic, copy) NSString *qrCodeType;
/**
 备注
 
 */
@property(nonatomic, copy) NSString *comment;
/**
 二维码
 
 */
@property(nonatomic, copy) NSString *code;
@end

@interface ReceiveFlowsListInfo : ListInfo

@end

@interface GetPaymentListInfo : NSObject
@property(nonatomic, strong) NSArray *list;
@property(nonatomic, assign) float moneyMax;
@property(nonatomic, assign) float moneyMin;
@property(nonatomic, assign) NSInteger receiptCodeExpirationTime;
@end
@interface PayQrcodeInfo:NSObject
@property(nonatomic, assign) float money;
@property (nonatomic, assign) NSInteger status;
@end

/** 支持的全部货币 */
@interface CurrencyInfo : NSObject<NSCoding>
/** 货币编码     */
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * nameCn;
@property (nonatomic, copy) NSString * nameEn;
@property (nonatomic, assign) BOOL openC2C;
@property (nonatomic, assign) BOOL openExchange;
/** 货币符号 symbol用来显示的     */
@property (nonatomic, copy) NSString * symbol;
/** 货币类型,可用值:LegalTender 法币,VirtualCurrency 虚拟币 */
@property (nonatomic, copy) NSString * type;
@property (nonatomic, assign) NSInteger weights;
///国旗的图标
@property (nonatomic, copy) NSString *flag;
/** 支持的支付类型 Wechat,AliPay,BankTransfer */
@property (nonatomic, copy) NSString *supportPaymentMethodType;
@property (nonatomic, copy)  NSString *countriesCode;
@end


@interface GetCurrencyBalanceListInfo : NSObject
@property (nonatomic, strong) NSNumber* amount;
@property (nonatomic, strong) CurrencyInfo * currency;
@property (nonatomic, assign) NSInteger frozenAmount;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *code;
@end

@interface BindingBackInfo:NSObject
@property(nonatomic, copy) NSString *bindId;
@end

//Organization
@interface OrganizationDetailsInfo: NSObject
@property (nonatomic, assign) NSInteger orgId;
@property (nonatomic, assign) BOOL isVerified;
@property (nonatomic, assign) BOOL isInOrganization;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, assign) NSInteger orgNumberId;
@property (nonatomic, copy, nullable) NSString *organizationImageUrl;
@property (nonatomic, assign) NSInteger pendingApprovals;
@property (nonatomic, assign) NSInteger transactionApprovalLevels;
@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, assign) NSInteger userMode;
@end

@interface InOutResponse : NSObject
@property (nonatomic, strong) NSArray *currencyAmounts;
@end

@interface InOutCurrencyResponse:NSObject
@property (nonatomic, copy)   NSString *currencyCode;
@property (nonatomic, assign) double inAmount;
@property (nonatomic, assign) double outAmount;
@end

@interface TransactionData : ListInfo

@end

@interface TransactionDataContentResponse:NSObject
@property (nonatomic, assign) NSInteger transactionId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy, nullable) NSString *nickName;
@property (nonatomic, copy, nullable) NSString *headImgUrl;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) double amount;
@property (nonatomic, copy, nullable) NSString *unit;
@property (nonatomic, assign) double actualAmount;
@property (nonatomic, copy, nullable) NSString *actualUnit;
@property (nonatomic, copy, nullable) NSString *transactionType;
@property (nonatomic, assign) NSInteger approvalLevel;
@property (nonatomic, strong) NSArray *previousRemarks;
@property (nonatomic, copy, nullable) NSString *status;
@property (nonatomic, copy, nullable) NSString *to;
@property (nonatomic, copy, nullable) NSString *lastOperateNickName;
@end

@interface FailIdResponseInfo: NSObject
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy, nullable) NSString *reason;
@end

@interface InviteResponseInfo: NSObject
@property (nonatomic, assign) BOOL allInvited;
@property (nonatomic, strong) NSArray<NSDictionary *> *failedIds;
@end

@interface TransactionsResponseInfo: NSObject
@property(nonatomic, assign) float actualAmount;
@property (nonatomic, copy, nullable) NSString *actualUnit;
@property(nonatomic, assign) float amount;
@property (nonatomic, assign) NSInteger approvalLevel;
@property (nonatomic, copy, nullable) NSString *status;
@property (nonatomic, assign) NSInteger transactionId;
@property (nonatomic, copy, nullable) NSString *transactionType;
@property (nonatomic, copy, nullable) NSString *unit;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy, nullable) NSString *userName;
@end

@interface MemebersResponseInfo : NSObject
@property (nonatomic, copy)   NSString *headImgUrl;
@property (nonatomic, assign) NSInteger inviteType;
@property (nonatomic, copy)   NSString *nickname;
@property (nonatomic, assign) NSInteger numberId;
@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger userType;
@end

@interface QTPermission : NSObject
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *permission;
@end

@interface PermissionResponse : NSObject
@property (nonatomic, strong) NSString *showName;
@property (nonatomic, strong) NSString *permission;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSString *imageName;
@property (nonatomic, strong) NSString *data;
- (instancetype)initWithShowName:(NSString *)showName permissionType:(NSString *)permissionType imageName:(NSString *)imageName isSelected:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END

