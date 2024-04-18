//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 16/9/2019
- File name:  ChatListModel+WCTTableCoding.h
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "ChatListModel.h"
#import <WCDB/WCDB.h>

@interface ChatListModel (WCTTableCoding) <WCTTableCoding>

WCDB_PROPERTY(isShowAt)
WCDB_PROPERTY(service)
WCDB_PROPERTY(userID)
WCDB_PROPERTY(groupID)
WCDB_PROPERTY(chatID)
WCDB_PROPERTY(messageContent)
WCDB_PROPERTY(lastMessageTime)
WCDB_PROPERTY(unReadMessageCount)
WCDB_PROPERTY(chatType)
WCDB_PROPERTY(isOutGoing)
WCDB_PROPERTY(isStick)
WCDB_PROPERTY(isNoDisturbing)
WCDB_PROPERTY(messageType)
WCDB_PROPERTY(draftMessage)
WCDB_PROPERTY(messageFrom)
WCDB_PROPERTY(messageTo)
WCDB_PROPERTY(showName)
WCDB_PROPERTY(allShutUp)
WCDB_PROPERTY(chatMode)
WCDB_PROPERTY(block)
WCDB_PROPERTY(beBlock)
WCDB_PROPERTY(isService)
WCDB_PROPERTY(authorityType)
WCDB_PROPERTY(circleUserId)
WCDB_PROPERTY(c2cUserId)
WCDB_PROPERTY(c2cOrderId)
@end
