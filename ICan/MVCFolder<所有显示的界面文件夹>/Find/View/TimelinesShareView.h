//
//  TimelinesShareView.h
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/11.
//  Copyright © 2020 dzl. All rights reserved.
//  点击分享帖子弹出的界面

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TimelinesShareViewDelegate <NSObject>
/** 点击分享按钮
 */
-(void)timelinesShareViewShareAction;
@end

@interface TimelinesShareView : UIView
-(void)showTimelinesShareView;
-(void)hiddenTimelinesShareView;
//隐藏表情view
-(void)hiddenFaceView;

-(void)showKeyBoard;

-(void)dealWithAtContent:(NSString *)content;

@property(nonatomic,strong)QMUITextView * textView;

@property(nonatomic,strong)UIButton * shareBtn;

@property(nonatomic,weak) id<TimelinesShareViewDelegate>delegate;

@property(nonatomic, strong) NSMutableArray *atMemberArr;
/** 当前@的人 */
@property(nonatomic, strong) NSMutableArray *reminders;
@end

NS_ASSUME_NONNULL_END
