//
//  GKDYVideoPlayer.h
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DZDYVideoPlayerStatus) {
    DZDYVideoPlayerStatusUnload,      // 未加载
    DZDYVideoPlayerStatusPrepared,    // 准备播放
    DZDYVideoPlayerStatusLoading,     // 加载中
    DZDYVideoPlayerStatusPlaying,     // 播放中
    DZDYVideoPlayerStatusPaused,      // 暂停
    DZDYVideoPlayerStatusEnded,       // 播放完成
    DZDYVideoPlayerStatusError        // 错误
};

@class DZDYVideoPlayer;

@protocol DZDYVideoPlayerDelegate <NSObject>

- (void)player:(DZDYVideoPlayer *)player statusChanged:(DZDYVideoPlayerStatus)status;

- (void)player:(DZDYVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress;

@end

@interface DZDYVideoPlayer : NSObject

@property (nonatomic, weak) id<DZDYVideoPlayerDelegate>     delegate;

@property (nonatomic, assign) DZDYVideoPlayerStatus         status;

@property (nonatomic, assign) BOOL                          isPlaying;

@property (nonatomic, assign) float         duration;
/**
 根据指定url在指定视图上播放视频
 
 @param playView 播放视图
 @param url 播放地址
 */
- (void)playVideoWithView:(UIView *)playView url:(NSString *)url;

/**
 停止播放并移除播放视图
 */
- (void)removeVideo;

/**
 暂停播放
 */
- (void)pausePlay;

/// 跳转到视频的指定时间
/// @param time 单位秒
- (void)seekToTime:(float)time;
/**
 恢复播放
 */
- (void)resumePlay;
/**
 重新播放
 */
- (void)resetPlay;
/**
 移除观察者
 */
- (void)removeObserver;
@end

NS_ASSUME_NONNULL_END
