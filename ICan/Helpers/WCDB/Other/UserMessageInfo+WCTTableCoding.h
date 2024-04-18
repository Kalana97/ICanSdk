//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 18/9/2019
- File name:  UserMessage+WCTTableCoding.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "UserMessageInfo.h"
#import <WCDB/WCDB.h>

@interface UserMessageInfo (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(nickname)
WCDB_PROPERTY(userId)
WCDB_PROPERTY(userName)
WCDB_PROPERTY(remarkName)
WCDB_PROPERTY(gender)
WCDB_PROPERTY(mobile)
WCDB_PROPERTY(realName)
WCDB_PROPERTY(email)

WCDB_PROPERTY(headImgUrl)
WCDB_PROPERTY(cardId)
WCDB_PROPERTY(token)
WCDB_PROPERTY(numberId)
WCDB_PROPERTY(isFriend)

WCDB_PROPERTY(signature)

WCDB_PROPERTY(cs)
WCDB_PROPERTY(shieldTimeLine)

WCDB_PROPERTY(block)
WCDB_PROPERTY(beBlock)
WCDB_PROPERTY(vip)
WCDB_PROPERTY(readReceipt)
WCDB_PROPERTY(userAuthStatus)
WCDB_PROPERTY(lastName)
WCDB_PROPERTY(firstName)

WCDB_PROPERTY(thirdPartySystemAppId)
@end
