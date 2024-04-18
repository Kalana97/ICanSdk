//
//  GKDYVideoPlayer.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
// IJKFFMoviePlayerController

#import "DZDYVideoPlayer.h"
#import "VideoCacheManager.h"
#import "DZPlayerLayerView.h"
@interface DZDYVideoPlayer()
@property (nonatomic, strong) AVPlayerItem * playerItem;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@property (nonatomic, strong) DZPlayerLayerView * layerView;
@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, assign) BOOL          isNeedResume;
@property (nonatomic, assign) NSTimeInterval current;
@property (nonatomic, copy) NSString *currentUrl;
@end

@implementation DZDYVideoPlayer

- (instancetype)init {
    if (self = [super init]) {
        // 监听APP退出后台及进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    DDLogInfo(@"%s",__func__);
    [self removeObserver];
}

#pragma mark - Notification
// APP退出到后台
- (void)appDidEnterBackground{
    if (self.status == DZDYVideoPlayerStatusLoading || self.status == DZDYVideoPlayerStatusPlaying) {
        [self pausePlay];
        self.isNeedResume = YES;
    }
    //恢复其他的APP播放
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
   });
}

// APP进入前台
- (void)appWillEnterForeground:(NSNotification *)notify {
    if (self.isNeedResume && self.status == DZDYVideoPlayerStatusPaused) {
        self.isNeedResume = NO;
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resumePlay];
        });
    }
}

#pragma mark - Public Methods
- (void)playVideoWithView:(UIView *)playView url:(NSString *)url {
    // 准备播放
    self.current = 0;
    self.currentUrl = url;
    [self playerStatusChanged:DZDYVideoPlayerStatusPrepared];
    [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:url cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
        if (hasCache) {
            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:data]];
        }else{
            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
        }
        [self addObserverWithPlayerItem:self.playerItem];
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        [self.layerView addPlayerLayer:self.playerLayer];
        [playView addSubview:self.layerView];
        [self.layerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        ///监听视频播放结束
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        
        
    }];
 
}
///监听播放完成
-(void)playbackEnd:(NSNotification*)noti{
    id object = noti.object;
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem*playUrl =(AVPlayerItem*) object;
        if (playUrl == self.playerItem) {
            if ([self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
                [self.delegate player:self currentTime:self.duration totalTime:self.duration progress:1.0f];
            }
            self.current = 0;
            [self playerStatusChanged:DZDYVideoPlayerStatusEnded];
        }
    }
}
-(void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
     //恢复其他的APP播放
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"KTimelineVideoResumePlay" object:nil];
    });
    DDLogInfo(@"%s",__func__);
}
- (void)removeVideo {
    // 停止播放
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    // 移除播放视图
    [self.layerView removeFromSuperview];
    // 改变状态
    [self playerStatusChanged:DZDYVideoPlayerStatusUnload];
}

- (void)pausePlay {
    [self playerStatusChanged:DZDYVideoPlayerStatusPaused];
    [self.player pause];
}

- (void)resumePlay {
    if (self.status == DZDYVideoPlayerStatusPaused) {
        [self.player play];
        [self playerStatusChanged:DZDYVideoPlayerStatusPlaying];
    }
}

- (void)resetPlay {
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
    self.current = 0;
    [self playerStatusChanged:DZDYVideoPlayerStatusPlaying];
}

- (BOOL)isPlaying {
    return self.status==DZDYVideoPlayerStatusPlaying;
}

#pragma mark - Private Methods
- (void)playerStatusChanged:(DZDYVideoPlayerStatus)status {
    self.status = status;
    if ([self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
        [self.delegate player:self statusChanged:status];
    }
}
-(void)seekToTime:(float)time{
    CMTime seekTime = CMTimeMake(time, 1);
    self.current = time;
    [self.player seekToTime:seekTime];
    [self.player play];
    [self playerStatusChanged:DZDYVideoPlayerStatusPlaying];
}
#pragma mark - 懒加载
- (DZPlayerLayerView *)layerView {
    if (!_layerView) {
        _layerView = [[DZPlayerLayerView alloc] init];
    }
    return _layerView;
}
#pragma mark - 监听视频缓冲和加载状态
//注册观察者监听状态和缓冲
- (void)addObserverWithPlayerItem:(AVPlayerItem *)playerItem {
    
    if (playerItem) {
        
        //        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
}

//移除观察者
- (void)removeObserverWithPlayerItem:(AVPlayerItem *)playerItem {
    
    if (playerItem) {
        
        //        [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [playerItem removeObserver:self forKeyPath:@"status"];
    }
}

// 监听变化方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem * playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            CMTime seekTime = CMTimeMake(0, 1);
            [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
                
            }];
            self.duration = roundf(CMTimeGetSeconds(self.player.currentItem.duration));
            [self.player play];
            [self playerStatusChanged:DZDYVideoPlayerStatusPlaying];
            @weakify(self);
            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 60) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                @strongify(self);
                self.current = self.current+1/60.0;
                NSTimeInterval total =roundf(CMTimeGetSeconds(self.player.currentItem.duration));
                float progress = self.current / total;
                if ([self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
                    [self.delegate player:self currentTime:self.current totalTime:total progress:progress];
                }
            }];
            [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
        }else if (playerItem.status == AVPlayerItemStatusFailed){
            [self playerStatusChanged:DZDYVideoPlayerStatusError];
        }else if (playerItem.status == AVPlayerItemStatusUnknown){
            [self playerStatusChanged:DZDYVideoPlayerStatusError];
        }
    }
}
@end
