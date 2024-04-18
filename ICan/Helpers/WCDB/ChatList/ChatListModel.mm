//
/**
- Copyright © 2019 EasyPay. All rights reserved.
- AUthor: Created  by DZL on 16/9/2019
- File name:  ChatListModel.mm
- Description:
- Function List: 
- History:/Users/dzl/Desktop/test/test/IDETemplateMacros.plist
*/
        

#import "ChatListModel+WCTTableCoding.h"
#import "ChatListModel.h"
#import <WCDB/WCDB.h>

@implementation ChatListModel

WCDB_IMPLEMENTATION(ChatListModel)
WCDB_SYNTHESIZE(ChatListModel, userID)
WCDB_SYNTHESIZE(ChatListModel, groupID)
WCDB_SYNTHESIZE(ChatListModel, chatID)
WCDB_SYNTHESIZE(ChatListModel, circleUserId)
WCDB_SYNTHESIZE(ChatListModel, messageContent)
WCDB_SYNTHESIZE(ChatListModel, lastMessageTime)
WCDB_SYNTHESIZE(ChatListModel, unReadMessageCount)
WCDB_SYNTHESIZE(ChatListModel, chatType)
WCDB_SYNTHESIZE(ChatListModel, isOutGoing)
WCDB_SYNTHESIZE(ChatListModel, isStick)
WCDB_SYNTHESIZE(ChatListModel, messageType)
WCDB_SYNTHESIZE(ChatListModel, draftMessage)
WCDB_SYNTHESIZE(ChatListModel, isShowAt)
WCDB_SYNTHESIZE(ChatListModel, isService)
WCDB_SYNTHESIZE(ChatListModel, isNoDisturbing)
WCDB_SYNTHESIZE(ChatListModel, messageFrom)
WCDB_SYNTHESIZE(ChatListModel, messageTo)
WCDB_SYNTHESIZE(ChatListModel, showName)
WCDB_SYNTHESIZE(ChatListModel, allShutUp)
WCDB_SYNTHESIZE(ChatListModel, chatMode)
WCDB_SYNTHESIZE(ChatListModel, block)
WCDB_SYNTHESIZE(ChatListModel, c2cUserId)
WCDB_SYNTHESIZE(ChatListModel, c2cOrderId)
WCDB_SYNTHESIZE(ChatListModel, beBlock)

//设置一个默认值
WCDB_SYNTHESIZE_DEFAULT(ChatListModel, authorityType, AuthorityType_friend)

-(NSString *)description{
    return [self mj_JSONString];
}
@end
