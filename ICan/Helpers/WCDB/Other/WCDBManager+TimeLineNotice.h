//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 12/3/2020
- File name:  WCDBManager+TimeLineNotice.h
- Description:
- Function List:
*/
    


#import "WCDBManager.h"
@class TimeLineNoticeInfo;
NS_ASSUME_NONNULL_BEGIN

@interface WCDBManager (TimeLineNotice)
-(void)insertTimeLineNoticeInfoOf:(TimeLineNoticeInfo*)info;
-(NSArray<TimeLineNoticeInfo*>*)fetchAllTimeLineNoticeInfo;
-(void)updateTimeLineNoticeReadByMsgId:(NSString*)msgId;
-(void)deleteOneTimeLineNoticeInfoByMsgId:(NSString*)msgId;
-(void)updateAllTimeLineNoticeHasRead;
-(NSArray *)fetchAllUnReadTimeLineNoticeInfo;
-(NSArray *)fetchAllReadTimeLineNoticeInfo;
-(void)deleteAllTimeLineNoticeInfo;
-(void)updateTimeLineNoticeReadByTimeLineNoticeInfo:(TimeLineNoticeInfo*)info;
@end

NS_ASSUME_NONNULL_END
