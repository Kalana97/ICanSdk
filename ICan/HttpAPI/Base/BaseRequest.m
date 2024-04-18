#import "BaseRequest.h"
#import "DomainExamineManager.h"
@implementation BaseRequest
+(instancetype)request{
    return [[self alloc]init];
}
//TODO
-(NSString *)baseUrlString{
//    return BASE_URL;
    if (IS_DEBUG) {
        return BASE_URL;
    }
    return [DomainExamineManager sharedManager].baseUrl?:BASE_URL;
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

@implementation ListRequest


@end


