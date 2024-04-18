//
/*
- C2COrderResponse.h
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/11/27
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
    

#import "BaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2COrderResponse : BaseResponse

@end
@interface C2CAdOrderAppealInfo:NSObject
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, assign) NSInteger adOrderId;
@property (nonatomic, assign) NSInteger appealId;
///联系人
@property (nonatomic, copy) NSString * contact;
///联系电话
@property (nonatomic, copy) NSString * contactNumber;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * descriptionField;
///凭证
@property (nonatomic, copy) NSString * evidence;
@property (nonatomic, assign) NSInteger handlerId;
@property (nonatomic, copy) NSString * handlingAdvice;
@property (nonatomic, copy) NSString * reason;
///审核状态,可用值:UnderAppeal,AppealSuccess申诉成功  AppealReject申诉拒绝
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, assign) NSInteger userId;
@end
@interface C2COrderInfo : BaseResponse
@property(nonatomic, strong) C2CAdOrderAppealInfo *adOrderAppeal;
/** 广告id */
@property (nonatomic, assign) NSInteger adId;
@property (nonatomic, assign) NSInteger adOrderId;
/** 买家的评价 true 好评 false 差评     */
@property (nonatomic, assign) BOOL buyEvaluate;
/** 买家id     */
@property (nonatomic, assign) NSInteger buyUserId;
/** 取消理由     */
@property (nonatomic, copy) NSString * cancelReason;
/** 取消时间     */
@property (nonatomic, copy) NSString * cancelTime;
/** 取消的人     */
@property (nonatomic, assign) NSInteger cancelUserId;
/** 创建时间     */
@property (nonatomic, copy) NSString * createTime;
/** 完成时间     */
@property (nonatomic, copy) NSString * finishTime;
@property (nonatomic, copy) NSString * legalTender;
/** 订单编号     */
@property (nonatomic, copy) NSString * orderId;
/** 支付失效 单位分钟     */
@property (nonatomic, assign) NSInteger payCancelTime;
/** 虚拟币数量     */
@property (nonatomic, strong) NSDecimalNumber* quantity;
/** 卖家的评价 true 好评 false 差评     */
@property (nonatomic, assign) BOOL sellEvaluate;
/** 卖家收款方式id     */
@property (nonatomic, assign) NSInteger sellPaymentMethodId;
/** 买家id     */
@property (nonatomic, assign) NSInteger sellUserId;
/**
 未付款 Unpaid,   您有新的订单
 已付款 Paid,    订单已付款
 申诉 Appeal,     订单正在进行申诉
 已完成 Completed,   订单已完成
 已取消 Cancelled    订单已取消
 */
@property (nonatomic, copy) NSString * status;
/** 法币总额     */
@property (nonatomic, strong) NSDecimalNumber* totalCount;
/** 交易条款 */
@property (nonatomic, copy) NSString * transactionTerms;
/** 交易时间     */
@property (nonatomic, copy) NSString * transactionTime;
/** 交易类型,可用值:Buy,Sell 不能作为是否是收款或者是去付款的依据*/
@property (nonatomic, copy) NSString * transactionType;
/** 价格 */
@property (nonatomic, strong) NSDecimalNumber* unitPrice;
@property (nonatomic, copy)   NSString * virtualCurrency;
///手续费率
@property (nonatomic, strong) NSDecimalNumber *handlingFee;
///总手续费
@property (nonatomic, strong) NSDecimalNumber *handlingFeeMoney;
///剩余手续费
@property (nonatomic, strong) NSDecimalNumber *remainingHandlingFeeMoney;
@property (nonatomic, strong) C2CUserInfo *buyUser;
@property (nonatomic, strong) C2CUserInfo *sellUser;
@property (nonatomic, strong) C2CPaymentMethodInfo *sellPaymentMethod;
@end

@interface C2COrderListInfo : C2CListInfo
@end

@interface C2COrderUnReadCountInfo : NSObject
@property(nonatomic, strong) NSDecimalNumber* count;
@end

NS_ASSUME_NONNULL_END
