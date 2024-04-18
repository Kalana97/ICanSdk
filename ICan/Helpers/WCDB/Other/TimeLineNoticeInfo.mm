//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 12/3/2020
- File name:  TimeLineNoticeInfo.mm
- Description:
- Function List:
*/
        

#import "TimeLineNoticeInfo+WCTTableCoding.h"
#import "TimeLineNoticeInfo.h"
#import <WCDB/WCDB.h>

@implementation TimeLineNoticeInfo

WCDB_IMPLEMENTATION(TimeLineNoticeInfo)
WCDB_PRIMARY(TimeLineNoticeInfo,msgId)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, msgId)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, hasRead)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, commentId)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, messageType)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, avatar)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, userId)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, nickName)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, msgType)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, time)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, gender)
WCDB_SYNTHESIZE(TimeLineNoticeInfo, noteId)
@end
