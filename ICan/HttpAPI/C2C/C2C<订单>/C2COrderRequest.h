//
/*
- C2COrderRequest.h
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/11/27
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
    

#import "C2CBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface C2COrderRequest : C2CBaseRequest

@end

/*
 购买
 POST
 /api/adOrder/buy
 */
@interface C2CBuyAdverRequest : C2CBaseRequest
/*
 广告ID
 */
@property(nonatomic, assign) NSInteger adId;
/*
 购买金额
 */
@property(nonatomic, strong, nullable) NSNumber *buyPrice;
/*
 购买数量
 */
@property(nonatomic, strong, nullable) NSNumber *buyQuantity;
@end
/*
 取消订单
 POST
 /api/adOrder/cancel/{adOrderId}
 */
@interface C2CCancelOrderRequest : C2CBaseRequest
@property(nonatomic, copy) NSString *reason;
@end

/// 确认收款POST /api/adOrder/confirm/{adOrderId}

@interface C2CConfirmOrderRequest : BaseRequest
@property(nonatomic, assign) NSInteger adOrderId;
@property(nonatomic, copy) NSString *payPassword;
@end

/**
 评价
 POST
 /api/adOrder/evaluate/{adOrderId}/{trueOrFalse}
 adOrderId    订单id    path    false
 trueOrFalse    好评 boolean
 */
@interface C2CEvaluateOrderRequest : C2CBaseRequest

@end
/**
 某个人的评论
 GET
 /api/adOrder/evaluate/{userId}
 */
@interface C2CGetEvaluateRequest:C2CListRequest
@property(nonatomic, strong, nullable) NSNumber *trueOrFalse;
@end
/**
 我的订单
 GET
 /api/adOrder/myOrders
 */
@interface C2CMyOrderListRequest : C2CListRequest
/** 订单状态
 */
@property(nonatomic, strong) NSArray *orderStatus;
@end
/**
 确认已经付款
 POST
 /api/adOrder/pay/{adOrderId}
 */
@interface C2CConfirmOrderPayRequest : C2CBaseRequest

@end
/**
 确认已经付款
 POST
 /api/adOrder/pay/{adOrderId}
 */
@interface C2CConfirmOrderPayV2Request : C2CBaseRequest
@property(nonatomic, copy) NSString *certificate;

@end
/*
 出售
 POST
 /api/adOrder/sell
 */
@interface C2CSellAdverRequest : C2CBaseRequest
/*
 广告ID
 */
@property(nonatomic, assign) NSInteger adId;
/*
 购买金额
 */
@property(nonatomic, strong, nullable) NSNumber *buyPrice;
/*
 购买数量
 */
@property(nonatomic, strong, nullable) NSNumber *buyQuantity;
/*
 收款方式
 */
@property(nonatomic, copy, nullable) NSString *sellPaymentMethodId;

@end
/**
 订单详情
 GET
 /api/adOrder/{adOrderId}
 */
@interface C2CGetOrderDetailRequest : C2CBaseRequest

@end
/**
 申诉
 POST
 /api/adOrder/appeal
 */
@interface C2CPostOrderAppealRequest : C2CBaseRequest
@property(nonatomic, assign) NSInteger adOrderId;
@property(nonatomic, copy) NSString *contact;
@property(nonatomic, copy) NSString *contactNumber;
@property(nonatomic, copy) NSString *Description;
@property(nonatomic, copy) NSString *evidence;
@property(nonatomic, copy) NSString *reason;
@end
/**
 未完成的状态的条数
 GET
 /api/adOrder/undoneCount
 */
@interface C2CGetAdOrderUndoneCountRequest : C2CBaseRequest

@end
NS_ASSUME_NONNULL_END
