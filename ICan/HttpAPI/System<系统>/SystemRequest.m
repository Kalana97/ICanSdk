//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 14/4/2020
- File name:  SystemRequest.m
- Description:
- Function List:
*/
        

#import "SystemRequest.h"

@implementation SystemRequest

@end
@implementation PrivateParameterRequest

-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"控制展示";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/privateParameter"];
}

@end

@implementation VersionsRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"版本展示";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/versions"];
}
@end
/** /public/announcements/{id} */
@implementation AnnouncementsRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"公告展示";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/announcements"];
}
@end

@implementation TestDomainRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"心跳测试域名";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/public/hello"];
}
@end
@implementation GetPublicStartPagesRequest
-(RequestMethod)requestMethod{
    return RequestMethod_Get;
}
-(NSString *)requestName{
    return @"启动页";
}

-(NSString *)pathUrlString{
    return  [self.baseUrlString stringByAppendingString:@"/public/startPages"];
}
@end
