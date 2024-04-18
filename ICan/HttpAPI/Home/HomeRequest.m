//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 9/10/2019
- File name:  HomeRequest.m
- Description:
- Function List:
*/
        

#import "HomeRequest.h"

@implementation HomeRequest

@end



@implementation NewsHeadlineClassifyRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取首页新闻头条分类";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/newsHead/type"];
    
}


@end
@implementation NewsHeadlineClassifyListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"获取首页新闻头条某个分类下面的数据";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/newsHeadline/list"];
    
}


@end
@implementation ForeignRateRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"外汇汇率";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/exchange/frate"];
    
}


@end
@implementation RmbquotRateRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"人民币汇率";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/exchange/rmbquot"];
    
}


@end

@implementation ExchangeBankRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"货币汇率-银行代码列表";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/exchange/bank"];
    
}


@end

@implementation HomeTelqueryRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"话费接口-根据手机号和面值查询商品信息";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/mobile/telquery"];
    
}


@end

@implementation GetMobileCardNumRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"话费接口-充值金额列表";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/mobile/cardnum"];
    
}


@end

@implementation MobileOnlineOrderRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"话费接口-手机直充接口";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/mobile/onlineOrder"];
    
}


@end

@implementation GetMobileOrderStateRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"话费接口-订单状态查询";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/mobile/ordersta"];
    
}


@end

@implementation GetGiftCardProductsRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"通用礼品卡接口文档-获取礼品列表";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/giftCard/products"];
    
}



@end

@implementation BuyGiftCardRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Post;
}
-(NSString *)requestName{
    return @"通用礼品卡接口文档-购买";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/giftCard/buy"];
    
}


@end
@implementation GetGiftCardRecordRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"通用礼品卡接口文档-购买记录";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/juhe/giftCard/record"];
    
}



@end
@implementation MobileRechargesListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"话费充值记录";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/mobileRecharges"];
    
}



@end
