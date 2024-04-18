//
//  TimelinesCommentBottomView.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/10.
//  Copyright © 2020 dzl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface TimelinesCommentBottomView : UIView
@property(nonatomic,strong) QMUITextView * textView;
@property(nonatomic,copy)   void(^sendCommentBlock)(NSString *comment);
@property(nonatomic,strong) UILabel * replyLabel;
@property(nonatomic,strong) UIImageView * closeImageView;
@property(nonatomic,strong) UIView * topBgView;
@property(nonatomic,copy)   void(^closeBlock)(void);
@property(nonatomic,strong) UIImageView * faceImageView;
@property(nonatomic,assign) BOOL isComment;

@property(nonatomic, copy)  void (^frameChangeFrameBlock)(CGFloat height);
/** 当点击回复他人的评论 */
-(void)showReplyView;
-(void)updateConstraintsFram;
-(void)hiddenAllView;
@end


NS_ASSUME_NONNULL_END
