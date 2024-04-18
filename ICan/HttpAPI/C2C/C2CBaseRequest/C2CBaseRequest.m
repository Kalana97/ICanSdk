//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  C2CBaseRequest.m
- Description:
- Function List:
*/
        

#import "C2CBaseRequest.h"

@implementation C2CBaseRequest
+(instancetype)request{
    return [[self alloc]init];
}
-(NSString *)baseUrlString{
    return C2CBASE_URL;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
-(bool)isPrivatAPi{
    return YES;
}
/**
 框架在进行model<->json解析的时忽略一下字段
 
 @return 数组
 */
+(NSMutableArray *)mj_totalIgnoredPropertyNames{
    return [NSMutableArray arrayWithObjects:@"baseUrlString",@"requestMethod",@"timeoutInterval",@"requestName",@"dataTask",@"isHttpResponse",@"isBodyParameter",@"parameters",@"pathUrlString", @"isPrivatAPi",nil];
}
@end

@implementation C2CListRequest

@end
/**
 发布广告
 POST
 */
@implementation C2CPublishAdvertRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"发布广告";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/ad"];
}
@end

/**
 添加收款方式
 POST
 /c2c/paymentMethod
 */
@implementation C2CAddPaymentMethodRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"添加收款方式";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/paymentMethod"];
}
@end
@implementation C2CGetPaymentMethodRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取我的收款方式";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/paymentMethod/all"];
}
@end
/*
 删除收款方式
 DELETE
 /api/paymentMethod/{paymentMethodId}
 */
@implementation C2CDeleteMyPaymentMethodRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"删除收款方式";
}
@end
/**
 支持的全部货币
 GET
 /c2c/exchange/allSupportedCurrencies
 */
@implementation GetC2CAllSupportedCurrenciesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"支持的全部货币";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/currency/allSupportedCurrencies"];
}
@end
@implementation GetC2CCollectCurrencyRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"收藏的全部货币";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/currency/collect/list"];
}
@end
@implementation PostC2CCollectCurrencyRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"收藏货币";
}
@end
@implementation DeleteC2CCollectCurrencyRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"取消收藏货币";
}
@end
/**
 全部的汇率
 GET
 /c2c/exchange/list
 */
@implementation GetC2CAllExchangeListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"全部的汇率";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/exchange/list"];
}
@end
/*
 获取当前用户的信息
 GET
 /api/user/info
 */
@implementation C2CGetCurrentUserInfoRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取当前用户的信息";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/user/info"];
}
@end

@implementation C2CCreateNewWalletRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"C2CCreateNewWalletRequest";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/user/want/wallet"];
}
@end
/*
 获取用户信息
 GET
 /api/user/{id}
 */
@implementation C2CGetUserInfoRequest : C2CBaseRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取用户的信息";
}
@end
/**
 收款信息详情
 GET
 /api/paymentMethod/{id}
 */
@implementation C2CGetPaymentMethodDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"收款信息详情";
}
@end
/**
 用户数据
 GET
 /api/user/data/{id}
 */
@implementation C2CGetUserMoreDataRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"用户数据";
}
@end


/**
 通过numberId获取c2c用户信息
 GET
 /api/user/numberId/{numberId}
 */
@implementation C2CGetUserMessageByIcanNumberIdRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"通过numberId获取c2c用户信息";
}
@end
/**
 根据订单ID获取第三方订单详情
 preparePayOrderDetail
 GET
 /api/preparePayOrder/{transactionId}
 */
@implementation GetC2CPreparePayOrderDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"根据订单ID获取第三方订单详情";
}
@end
/**
 支付订单
 PUT
 /api/preparePayOrder/{transactionId}
 */
@implementation PutC2CPreparePayOrderRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"支付订单";
}
@end
