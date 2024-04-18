//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 25/11/2021
- File name:  C2CHomeResponse.m
- Description:
- Function List:
*/
        

#import "C2CHomeResponse.h"

@implementation C2CHomeResponse

@end

@implementation C2CAdverInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"paymentMethods":[C2CPaymentMethodInfo class]};
}
@end

@implementation C2COptionalListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[C2CAdverInfo class]};
}
@end

@implementation C2CAdverDetailInfo

@end
@implementation C2CCollectCurrencyInfo

@end

