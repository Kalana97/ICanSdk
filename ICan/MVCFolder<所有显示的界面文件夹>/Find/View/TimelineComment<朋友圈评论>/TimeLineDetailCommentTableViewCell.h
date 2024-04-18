//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 14/7/2021
- File name:  TimeLineDetailCommentTableViewCell.h
- Description:
- Function List:
*/
        

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const kTimeLineDetailCommentTableViewCell = @"TimeLineDetailCommentTableViewCell";
@interface TimeLineDetailCommentTableViewCell : BaseCell
@property(nonatomic, strong) TimelinesCommentInfo *comment;
@property(nonatomic, strong) TimelinesListDetailInfo *detailInfo;
@property(nonatomic, copy) void (^replyBlock)(NSString*nickname,NSString*commentId);
@property(nonatomic, copy) void (^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
