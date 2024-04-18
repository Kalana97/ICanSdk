//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 12/3/2020
- File name:  TimeLineNoticeInfo.h
- Description:
- Function List:
*/
        
static NSString * const KWCTimeLineNoticeInfoTable= @"TimeLineNoticeInfo";
#import <Foundation/Foundation.h>

@interface TimeLineNoticeInfo : NSObject
/** 消息的ID */
@property (nonatomic, copy) NSString *msgId;
/** 是否已读 */
@property (nonatomic,assign)  BOOL  hasRead;
/** 评论ID */
@property(nonatomic, retain) NSString *commentId;
/**
 帖子 Message
 评论Comment
 回复Reply
 分享Share
 */

@property(nonatomic, retain) NSString* messageType;

@property(nonatomic, retain) NSString* msgType;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *nickName;
/** 帖子ID */
@property(nonatomic, copy) NSString *noteId;
/** 帖子的时间 */
@property(nonatomic, assign) NSInteger time;
@property(nonatomic, copy) NSString *gender;
@end
