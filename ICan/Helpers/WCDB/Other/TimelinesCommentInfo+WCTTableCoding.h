//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/7/2021
- File name:  TimelinesCommentInfo+WCTTableCoding.h
- Description:
- Function List:
*/
        

#import "TimelinesCommentInfo.h"
#import <WCDB/WCDB.h>

@interface TimelinesCommentInfo (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(ID)
WCDB_PROPERTY(publishTime)
WCDB_PROPERTY(belongsId)
WCDB_PROPERTY(belongsNickName)
WCDB_PROPERTY(belongsHeadImgUrl)
WCDB_PROPERTY(belongsGender)
WCDB_PROPERTY(replyToGender)
WCDB_PROPERTY(replyToId)
WCDB_PROPERTY(replyToNickName)
WCDB_PROPERTY(replyToHeadImgUrl)
WCDB_PROPERTY(content)
WCDB_PROPERTY(targetCommentId)
WCDB_PROPERTY(targetMomentId)
WCDB_PROPERTY(translateStatus)
WCDB_PROPERTY(translateMsg)
@end
