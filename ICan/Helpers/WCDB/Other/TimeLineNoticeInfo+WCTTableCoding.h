//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 12/3/2020
- File name:  TimeLineNoticeInfo+WCTTableCoding.h
- Description:
- Function List:
*/
        

#import "TimeLineNoticeInfo.h"
#import <WCDB/WCDB.h>

@interface TimeLineNoticeInfo (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(msgId)
WCDB_PROPERTY(hasRead)
WCDB_PROPERTY(commentId)
WCDB_PROPERTY(messageType)
WCDB_PROPERTY(avatar)
WCDB_PROPERTY(userId)
WCDB_PROPERTY(nickName)
WCDB_PROPERTY(time)
WCDB_PROPERTY(msgType)
WCDB_PROPERTY(noteId)
WCDB_PROPERTY(gender)

@end
