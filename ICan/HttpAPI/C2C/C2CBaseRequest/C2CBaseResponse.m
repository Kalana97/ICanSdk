//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/11/2021
- File name:  C2CBaseResponse.m
- Description:
- Function List:
*/
        

#import "C2CBaseResponse.h"
#import "MJExtension.h"
@implementation C2CBaseResponse

@end

@implementation C2CListInfo

@end

@implementation C2CPaymentMethodInfo

@end

@implementation C2CExchangeRateInfo
MJCodingImplementation
@end
@implementation ExternalWalletsInfo

@end
@implementation C2CUserInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"externalWallets":[ExternalWalletsInfo class]};
}
@end

@implementation C2CUserMoreDataInfo

@end
@implementation C2CBalanceListInfo

@end

@implementation C2CAddAddressResponse

@end

@implementation WatchWalletListInfo

@end

@implementation C2CPreparePayOrderDetailInfo

@end
