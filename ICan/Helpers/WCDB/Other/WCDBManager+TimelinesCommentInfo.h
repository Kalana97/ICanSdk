//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 15/7/2021
- File name:  WCDBManager+TimelinesCommentInfo.h
- Description:
- Function List:
*/
        

#import "WCDBManager.h"
@class TimelinesCommentInfo;
NS_ASSUME_NONNULL_BEGIN

@interface WCDBManager (TimelinesCommentInfo)
-(void)insertTimelinesCommentInfo:(TimelinesCommentInfo*)info;
-(TimelinesCommentInfo *)fetchCommentWithCommentId:(NSString *)commentId;
-(void)updateCommentTranslateStatusWithCommentId:(NSString*)commentId translateStatus:(NSInteger)translateStatus;
-(void)updateTranslateTextWithCommentId:(NSString*)commentId translateText:(NSString*)translateText;
-(void)deleteCommentWithCommentId:(NSString*)commentId;
@end

NS_ASSUME_NONNULL_END
