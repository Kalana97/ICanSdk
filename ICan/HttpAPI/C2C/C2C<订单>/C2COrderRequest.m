//
/*
- C2COrderRequest.m
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/11/27
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
    

#import "C2COrderRequest.h"

@implementation C2COrderRequest

@end
/*
 购买
 POST
 /api/adOrder/buy
 */
@implementation C2CBuyAdverRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"购买";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/adOrder/buy"];
}
@end
/*
 取消订单
 POST
 /api/adOrder/cancel/{adOrderId}
 */
@implementation C2CCancelOrderRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"取消订单";
}
@end
/*
 确认收款
 POST
 /api/adOrder/confirm/{adOrderId}
 */
@implementation C2CConfirmOrderRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/c2c/adOrder/confirm"];
}
-(NSString *)requestName{
    return @"确认收款";
}
@end
/*
 评价
 POST
 /api/adOrder/evaluate/{adOrderId}/{trueOrFalse}
 adOrderId    订单id    path    false
 trueOrFalse    好评 boolean
 */
@implementation C2CEvaluateOrderRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"评价";
}
@end
/**
 某个人的评论
 GET
 /api/adOrder/evaluate/{userId}
 */
@implementation C2CGetEvaluateRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"某个人的评论";
}
@end
/*
 我的订单
 GET
 /api/adOrder/myOrders
 */
@implementation C2CMyOrderListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"我的订单";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/adOrder/myOrders/v1"];
}
@end
/*
 确认已经付款
 POST
 /api/adOrder/pay/{adOrderId}
 */
@implementation C2CConfirmOrderPayRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"确认已经付款";
}

@end/*
 确认已经付款
 POST
 /api/adOrder/pay/{adOrderId}
 */
@implementation C2CConfirmOrderPayV2Request
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"确认已经付款";
}

@end
/*
 出售
 POST
 /api/adOrder/sell
 */
@implementation C2CSellAdverRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"出售";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/adOrder/sell"];
}
@end
/**
 订单详情
 GET
 /api/adOrder/{adOrderId}
 */
@implementation C2CGetOrderDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"订单详情";
}
@end


@implementation C2CPostOrderAppealRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"订单详情";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/adOrder/appeal"];
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}
@end
@implementation C2CGetAdOrderUndoneCountRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"未完成的状态的条数";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/adOrder/undoneCount"];
}
@end
