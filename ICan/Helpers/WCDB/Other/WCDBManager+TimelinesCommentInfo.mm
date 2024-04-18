//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/7/2021
- File name:  WCDBManager+TimelinesCommentInfo.m
- Description:
- Function List:
*/
        
#import "WCDBManager+TimelinesCommentInfo.h"
#import "TimelinesCommentInfo+WCTTableCoding.h"
@implementation WCDBManager (TimelinesCommentInfo)
-(void)insertTimelinesCommentInfo:(TimelinesCommentInfo*)info{
    [self.wctDatabase insertOrReplaceObject:info into:KWCTimelinesCommentInfoTable];
}
-(void)updateTranslateTextWithCommentId:(NSString *)commentId translateText:(NSString *)translateText{
    [self.wctDatabase updateRowsInTable:KWCTimelinesCommentInfoTable onProperty:{TimelinesCommentInfo.translateMsg} withValue:translateText where:TimelinesCommentInfo.ID==commentId];
}
-(void)updateCommentTranslateStatusWithCommentId:(NSString *)commentId translateStatus:(NSInteger)translateStatus{
    [self.wctDatabase updateRowsInTable:KWCTimelinesCommentInfoTable onProperty:{TimelinesCommentInfo.translateStatus} withValue:@(translateStatus) where:TimelinesCommentInfo.ID==commentId];
}
-(void)deleteCommentWithCommentId:(NSString*)commentId{
    
}
-(TimelinesCommentInfo *)fetchCommentWithCommentId:(NSString *)commentId{
    return  [self.wctDatabase getOneObjectOfClass:[TimelinesCommentInfo class] fromTable:KWCTimelinesCommentInfoTable where:TimelinesCommentInfo.ID==commentId];
    
}
@end
