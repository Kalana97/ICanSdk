//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  GroupApplyInfo+WCTTableCoding.h
- Description:
- Function List:
*/
        

#import "GroupApplyInfo.h"
#import <WCDB/WCDB.h>

@interface GroupApplyInfo (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(addGroupMode)
WCDB_PROPERTY(groupId)
WCDB_PROPERTY(inviterId)
WCDB_PROPERTY(userId)
WCDB_PROPERTY(messageId)
WCDB_PROPERTY(isRead)
WCDB_PROPERTY(isAgree)
WCDB_PROPERTY(messageTime)
WCDB_PROPERTY(joinType)
@end
