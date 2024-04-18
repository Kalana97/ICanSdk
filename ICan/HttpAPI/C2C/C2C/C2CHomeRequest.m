//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 25/11/2021
- File name:  C2CHomeRequest.m
- Description:
- Function List:
*/
        

#import "C2CHomeRequest.h"

@implementation C2CHomeRequest

@end
/**
 自选列表
 GET
 /api/ad/choose
 */
@implementation C2CGetOptionalListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"自选列表";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/ad/choose"];
}
@end
/**
 我的广告
 GET
 /api/ad/myAds
 */
@implementation C2CGetUserAdverListRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"我的广告";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/ad/myAds"];
}
@end
/*
 广告详情
 GET
 /api/ad/{id}
 */

@implementation C2CGetAdverDetailRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"广告详情";
}

@end
@implementation C2CRechargeRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"广告详情";
}

@end

/*
 修改广告
 PUT
 /api/ad/{id}
 */
@implementation C2CPutAdverRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"修改广告";
}

@end
/*
 上架
 PUT
 /api/ad/{id}/onShelf
 */
@implementation C2COnShelfAdverRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"上架";
}
@end
/*
 下架复制
 PUT
 /api/ad/{id}/offShelf
 */
@implementation C2COffShelfAdverRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}
-(NSString *)requestName{
    return @"下架";
}
@end
/*
 关闭广告
 DELETE
 /api/ad/{id}
 */
@implementation C2CDeleteAdverRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Delete;
}
-(NSString *)requestName{
    return @"关闭广告";
}
@end

@implementation GetC2COssTokenRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"getSecurityToken";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/oss/securityToken"];
}


@end
