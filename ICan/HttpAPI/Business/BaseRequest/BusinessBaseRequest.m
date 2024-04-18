//
//  BusinessBaseRequest.m
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-12-09.
//  Copyright © 2023 dzl. All rights reserved.
//

#import "BusinessBaseRequest.h"

@implementation BusinessBaseRequest

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

+(NSMutableArray *)mj_totalIgnoredPropertyNames{
    return [NSMutableArray arrayWithObjects:@"baseUrlString",@"requestMethod",@"timeoutInterval",@"requestName",@"dataTask",@"isHttpResponse",@"isBodyParameter",@"parameters",@"pathUrlString", @"isPrivatAPi",nil];
}
@end

@implementation BusinessListRequest

@end

@implementation PutBusinessUserPOIRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Put;
}

-(NSString *)requestName{
    return @"设置用户经纬度";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/api/business/poi"];
}
@end
