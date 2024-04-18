//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- File name:  FriendSubscriptionInfo.mm
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "FriendSubscriptionInfo+WCTTableCoding.h"
#import "FriendSubscriptionInfo.h"
#import <WCDB/WCDB.h>

@implementation FriendSubscriptionInfo

//+(NSDictionary *)mj_replacedKeyFromPropertyName{
//    return @{@"Description":@"description"};
//}
WCDB_IMPLEMENTATION(FriendSubscriptionInfo)
/** 主键  */

WCDB_PRIMARY(FriendSubscriptionInfo,sender)
WCDB_SYNTHESIZE(FriendSubscriptionInfo, messageTime)
WCDB_SYNTHESIZE(FriendSubscriptionInfo, message)
WCDB_SYNTHESIZE(FriendSubscriptionInfo, subscriptionType)
WCDB_SYNTHESIZE(FriendSubscriptionInfo, sender)
WCDB_SYNTHESIZE(FriendSubscriptionInfo, isRead)
WCDB_SYNTHESIZE(FriendSubscriptionInfo, showName)

@end
