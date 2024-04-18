//
/**
- Copyright © 2020 dzl. All rights reserved.
- Author: Created  by DZL on 12/8/2020
- File name:  DYCommentTextView.h
- Description:
- Function List:
*/
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYCommentTextView : UIControl
@property(nonatomic,strong)QMUITextView * textView;
@property(nonatomic,copy) void(^sendCommentBlock)(NSString *comment);
@property(nonatomic,strong)UILabel * replyLabel;
@property(nonatomic,strong)UIImageView * closeImageView;
@property(nonatomic,strong)UIView * topBgView;
@property(nonatomic,copy) void(^closeBlock)(void);
@property(nonatomic,strong)UIImageView * faceImageView;
@property(nonatomic, assign) BOOL isComment;

@property(nonatomic, copy) void (^frameChangeFrameBlock)(CGFloat height);
/** 当点击回复他人的评论 */
-(void)showReplyView;
-(void)updateConstraintsFram;
@end

NS_ASSUME_NONNULL_END
