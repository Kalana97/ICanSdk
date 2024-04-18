//
/**
- Copyright © 2019 dzl. All rights reserved.
- Author: Created  by DZL on 9/10/2019
- File name:  HomeResponse.m
- Description:
- Function List:
*/
        

#import "HomeResponse.h"

@implementation HomeResponse

@end

@implementation NewsHeadlineClassifyListInfo

@end

@implementation NewsHeadlineClassifyInfo



@end
@implementation RmbquotInfo



@end
@implementation ForeignRateInfo



@end
@implementation ExchangeRateBankcardInfo



@end

@implementation HomeTelqueryInfo


@end
@implementation MobileOnlineOrderInfo


@end

@implementation MobileOrderStateInfo



@end

@implementation GiftCardProductsInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list":[GiftCardProductsListInfo class]};
}

@end

@implementation GiftCardProductsListInfo


@end

@implementation BuyGiftCardInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"cards":[BuyGiftCardDetailInfo class]};
}

@end

@implementation BuyGiftCardDetailInfo



@end

@implementation GiftCardRecordInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"cards":[BuyGiftCardDetailInfo class]};
}

@end

@implementation MobileRechargesListInfo


@end


@implementation MobileRechargesRecordInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"content":[MobileRechargesListInfo class]};
}


@end

