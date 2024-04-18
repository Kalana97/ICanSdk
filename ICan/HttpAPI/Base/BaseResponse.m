    

#import "BaseResponse.h"

@implementation BaseResponse
-(NSString *)description{
    return [self mj_JSONObject];
}
@end

@implementation IDInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
-(NSString *)description{
    return [self mj_JSONObject];
}
@end
@implementation ThirdPartyAuthorizationInfo


@end
@implementation RegisterInfo


@end
@implementation LoginInfo


@end

@implementation ErrorExtra
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
        @"isBlocked": @"isBlocked",
        @"errorCount": @"errorCount",
        @"remainingCount": @"remainingCount",
        @"blockedTimeMillis": @"blockedTimeMillis",
    };
}
@end

@implementation NetworkErrorInfo


@end

@implementation PageableInfo

+ (nullable NSDictionary<NSString *, id> *)ng_modelContainerPropertyGenericClass{
    return @{@"sort":[SortInfo class]};
}
@end
@implementation SortInfo


@end
@implementation ListInfo
+ (nullable NSDictionary<NSString *, id> *)ng_modelContainerPropertyGenericClass{
    return @{@"pageable":[PageableInfo class],@"sort":[SortInfo class]};
}

@end
