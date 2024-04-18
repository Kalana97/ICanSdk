//
//  TimelinesSubCommentTableViewCell.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/10.
//  Copyright © 2020 dzl. All rights reserved.
// 回复评论的回复显示的cell

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TimelinesSubCommentTableViewCellDelegate <NSObject>

-(void)replyMegWith:(NSString *)replyId commentId:(NSString *)commentId nickName:(NSString *)nickName;


-(void)deleteReplyMegWith:(NSString *)deleteId;


@end

static NSString * const KTimelinesSubCommentTableViewCell =@"TimelinesSubCommentTableViewCell";
@interface TimelinesSubCommentTableViewCell : BaseCell
@property(nonatomic,strong)ReplyVOsInfo *replyVOsInfo;
@property(nonatomic,weak) id<TimelinesSubCommentTableViewCellDelegate>delegate;
/** 该回复属于哪个评论 */
@property(nonatomic,copy)NSString * commentId;
@end

NS_ASSUME_NONNULL_END
