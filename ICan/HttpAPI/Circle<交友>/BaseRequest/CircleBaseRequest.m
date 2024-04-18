//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 21/5/2021
- File name:  CircleBaseRequest.m
- Description:
- Function List:
*/
        

#import "CircleBaseRequest.h"


@implementation CircleBaseRequest
+(instancetype)request{
    return [[self alloc]init];
}
-(NSString *)baseUrlString{
//    https://circie.server.shinianwangluo.com
    return CircleBASE_URL;
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

@implementation CircleListRequest


@end

@implementation GetCircleOssRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"getSecurityToken";
}
-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/oss/securityToken"];
}


@end
