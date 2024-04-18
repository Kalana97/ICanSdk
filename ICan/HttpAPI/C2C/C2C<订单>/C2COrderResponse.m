//
/*
- C2COrderResponse.m
- PackName: ICan
- TargetName: ICan
- Author: dzl
- Create: 2021/11/27
- Description:
- Function List:
Copyright © 2021 dzl. All rights reserved.
*/
    

#import "C2COrderResponse.h"

@implementation C2COrderResponse

@end
@implementation C2CAdOrderAppealInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Description":@"description"};
}
@end

@implementation C2COrderInfo
//+(NSDictionary *)mj_objectClassInArray{
//    return @{@"sellPaymentMethod":[C2CPaymentMethodInfo class]};
//}
@end
@implementation C2COrderListInfo
+(NSDictionary *)mj_objectClassInArray{
    return @{@"records":[C2COrderInfo class]};
}
@end

@implementation C2COrderUnReadCountInfo


@end
