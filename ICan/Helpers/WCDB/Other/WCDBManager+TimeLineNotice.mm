//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 12/3/2020
 - File name:  WCDBManager+TimeLineNotice.m
 - Description:
 - Function List:
 */

#import "TimeLineNoticeInfo+WCTTableCoding.h"
#import "WCDBManager+TimeLineNotice.h"
#import "TimeLineNoticeInfo.h"
@implementation WCDBManager (TimeLineNotice)
-(void)insertTimeLineNoticeInfoOf:(TimeLineNoticeInfo *)info{
    NSArray*array= [self.wctDatabase getObjectsOfClass:[TimeLineNoticeInfo class] fromTable:KWCTimeLineNoticeInfoTable where:{TimeLineNoticeInfo.hasRead==NO&&TimeLineNoticeInfo.userId==info.userId&&TimeLineNoticeInfo.noteId==info.noteId}];
    if (array.count>0) {
        TimeLineNoticeInfo*ainfo=array.firstObject;
        ainfo.time=info.time;
        NSArray*row=@[@(ainfo.time)];
        [self.wctDatabase updateRowsInTable:KWCTimeLineNoticeInfoTable onProperties:TimeLineNoticeInfo.time withRow:row where:{TimeLineNoticeInfo.hasRead==NO&&TimeLineNoticeInfo.userId==info.userId&&TimeLineNoticeInfo.noteId==info.noteId}];
    }else{
        [self.wctDatabase insertOrReplaceObject:info into:KWCTimeLineNoticeInfoTable];
    }
    
}
-(NSArray *)fetchAllTimeLineNoticeInfo{
    return  [self.wctDatabase getObjectsOfClass:[TimeLineNoticeInfo class] fromTable:KWCTimeLineNoticeInfoTable orderBy:{TimeLineNoticeInfo.time.order(WCTOrderedDescending)}];
}
-(void)deleteAllTimeLineNoticeInfo{
    [self.wctDatabase deleteAllObjectsFromTable:KWCTimeLineNoticeInfoTable];
}
-(NSArray *)fetchAllUnReadTimeLineNoticeInfo{
    return  [self.wctDatabase getObjectsOfClass:[TimeLineNoticeInfo class] fromTable:KWCTimeLineNoticeInfoTable where:TimeLineNoticeInfo.hasRead==NO orderBy:{TimeLineNoticeInfo.time.order(WCTOrderedDescending)}];
}
-(NSArray *)fetchAllReadTimeLineNoticeInfo{
    
    return  [self.wctDatabase getObjectsOfClass:[TimeLineNoticeInfo class] fromTable:KWCTimeLineNoticeInfoTable where:TimeLineNoticeInfo.hasRead==YES orderBy:{TimeLineNoticeInfo.time.order(WCTOrderedDescending)}];
}
-(void)updateAllTimeLineNoticeHasRead{
    [self.wctDatabase updateAllRowsInTable:KWCTimeLineNoticeInfoTable onProperty:{TimeLineNoticeInfo.hasRead} withValue:@(1)];
}
-(void)updateTimeLineNoticeReadByTimeLineNoticeInfo:(TimeLineNoticeInfo *)info{
    [self.wctDatabase deleteObjectsFromTable:KWCTimeLineNoticeInfoTable  where:{TimeLineNoticeInfo.hasRead==YES&&TimeLineNoticeInfo.userId==info.userId&&TimeLineNoticeInfo.noteId==info.noteId}];
    [self.wctDatabase insertOrReplaceObject:info into:KWCTimeLineNoticeInfoTable];
}
-(void)updateTimeLineNoticeReadByMsgId:(NSString *)msgId{
    [self.wctDatabase updateRowsInTable:KWCTimeLineNoticeInfoTable onProperty:TimeLineNoticeInfo.hasRead withValue:@(1) where:TimeLineNoticeInfo.msgId==msgId];
}
-(void)deleteOneTimeLineNoticeInfoByMsgId:(NSString *)msgId{
    [self.wctDatabase deleteObjectsFromTable:KWCTimeLineNoticeInfoTable where:TimeLineNoticeInfo.msgId==msgId];
}
@end
