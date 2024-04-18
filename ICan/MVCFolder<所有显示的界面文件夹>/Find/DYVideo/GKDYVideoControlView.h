//
//  GKDYVideoControlView.h
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//  播放器视图控制层

#import <UIKit/UIKit.h>
#import "GKSliderView.h"
#import "TimelineBrowseImageView.h"
NS_ASSUME_NONNULL_BEGIN

@class GKDYVideoControlView;



@protocol GKDYVideoControlViewDelegate <NSObject>

- (void)controlViewDidClickSelf:(GKDYVideoControlView *)controlView;

- (void)controlViewDidClickIcon:(GKDYVideoControlView *)controlView;

- (void)controlViewDidClickNameLabel:(GKDYVideoControlView *)controlView;

- (void)controlViewDidClickPriase:(GKDYVideoControlView *)controlView;

- (void)controlViewDidClickComment:(GKDYVideoControlView *)controlView;

- (void)controlViewDidClickShare:(GKDYVideoControlView *)controlView;

- (void)controlView:(GKDYVideoControlView *)controlView touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

/// 当拖拉结束进度条
/// @param controlView controlView description
/// @param value value description
- (void)controlViewDidPanSelf:(GKDYVideoControlView *)controlView value:(float)value;

/// 当前拖拉进度条手势进行中
/// @param controlView controlView description
/// @param value value description
- (void)controlViewDidChangePanSelf:(GKDYVideoControlView *)controlView value:(float)value;
@end

@interface GKDYVideoControlView : UIView

@property(nonatomic, weak)  id<GKDYVideoControlViewDelegate> delegate;

// 视频封面图:显示封面并播放视频
@property(nonatomic,strong) UIImageView             * coverImgView;

@property(nonatomic,strong) TimelinesListDetailInfo * timeLineInfo;
@property(nonatomic,strong) GKSliderView            * sliderView;
@property(nonatomic,strong) UIButton                * playBtn;
@property(nonatomic,strong) TimelineBrowseImageView * timelineBrowseView;


- (void)setProgress:(float)progress;

- (void)startLoading;
- (void)stopLoading;

- (void)showPlayBtn;
- (void)hidePlayBtn;

- (void)showLikeAnimation;
- (void)showUnLikeAnimation;

- (void)showCurrentTimeLabelWithTotalTime:(float)totalTime  currentTime:(float)currentTime;
- (void)hiddenTimeBgView;
@end

NS_ASSUME_NONNULL_END
