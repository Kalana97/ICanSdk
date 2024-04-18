//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 25/9/2019
- File name:  FriendSubscriptionInfo+WCTTableCoding.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "FriendSubscriptionInfo.h"
#import <WCDB/WCDB.h>

@interface FriendSubscriptionInfo (WCTTableCoding) <WCTTableCoding>
//WCDB_PROPERTY(messageID)

WCDB_PROPERTY(messageTime)
WCDB_PROPERTY(message)
WCDB_PROPERTY(showName)
WCDB_PROPERTY(subscriptionType)
WCDB_PROPERTY(sender)
WCDB_PROPERTY(isRead)

@end
