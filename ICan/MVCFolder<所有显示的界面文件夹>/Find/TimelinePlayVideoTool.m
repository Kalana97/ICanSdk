//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 7/5/2020
 - File name:  TimelinePlayVideoTool.m
 - Description:
 - Function List:
 */


#import "TimelinePlayVideoTool.h"
#import "DZProgressSlider.h"
#import "DZPlayerLayerView.h"
#import "PrivacyPermissionsTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DZPlayerLayerView.h"
@interface TimelinePlayVideoTool()<UIGestureRecognizerDelegate>{
    CGPoint _interactStartPoint;
    BOOL _interacting;
}

@property (nonatomic, strong) AVPlayerItem * playerItem;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@property (nonatomic, strong) DZPlayerLayerView * layerView;
@property (nonatomic, strong) UIActivityIndicatorView * activity;
@property (nonatomic, strong) UIImageView * coverImageView;
@property(nonatomic, strong)  UIButton * playOrStopButton;
/**
 是一个定时器对象，它可以让你与屏幕刷新频率相同的速率来刷新你的视图。就说CADisplayLink是用于同步屏幕刷新频率的计时器。
 */
@property (nonatomic, strong) CADisplayLink * link;
@property (nonatomic, assign) NSTimeInterval lastTime;

@property (nonatomic, strong) NSTimer * toolViewShowTimer;
@property (nonatomic, assign) NSTimeInterval toolViewShowTime;
@property(nonatomic, copy)      NSURL *playUrl;
// 当前是否显示控制条
@property (nonatomic, assign) BOOL isShowToolView;
/** 是否是播放结束 */
@property(nonatomic, assign) BOOL isPlayEnd;
@property (nonatomic,strong) UIView * bottomToolView;
/** 播放暂停按钮 */
@property (nonatomic, strong) UIButton * playSwitch;
/** 取消播放按钮 */
@property(nonatomic, strong)  UIButton * cancleButton;
/** 更多按钮 */
@property(nonatomic, strong) UIButton * moreButton;
/** 当前的进度时间 */
@property (nonatomic, strong) UILabel * currentTimeLabel;
/** 总的播放时间 */
@property (nonatomic, strong) UILabel * totleTimeLabel;
/** 进度条 */
@property (nonatomic, strong) DZProgressSlider * progressSlider;
@property(nonatomic, assign) BOOL isPlayLocalUrl;
/** 当前是否是放大播放 */
@property(nonatomic, assign) BOOL isBigPalyerView;

/// 是否取消手势交互动效
@property (nonatomic, assign) BOOL disable;

/// 拖动的距离与最大高度的比例，达到这个比例就会出场
@property (nonatomic, assign) CGFloat dismissScale;

/// 拖动的速度，达到这个值就会出场
@property (nonatomic, assign) CGFloat dismissVelocityY;

/// 拖动动效复位时的时长
@property (nonatomic, assign) CGFloat restoreDuration;

/// 拖动触发手势交互动效的起始距离
@property (nonatomic, assign) CGFloat triggerDistance;
/** 点击事件显示或者隐藏操作栏 */
@property(nonatomic, strong) UITapGestureRecognizer *tapShow;
/** 长按事件 */
@property(nonatomic, strong) UILongPressGestureRecognizer *longPress;
@end
@implementation TimelinePlayVideoTool
+(instancetype)shareSingle{
    static TimelinePlayVideoTool *tool=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool=[[TimelinePlayVideoTool alloc]init];
        tool.tapShow=[[UITapGestureRecognizer alloc]initWithTarget:tool action:@selector(tapShowOrHideBottomView)];
        tool.longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:tool action:@selector(longPressAction:)];
        tool.longPress.minimumPressDuration=0.5;
        
    });
    return tool;
}
-(void)setMute:(BOOL)mute{
    _mute=mute;
    self.player.muted=mute;
}
- (DZPlayerLayerView *)layerView {
    if (!_layerView) {
        _layerView = [[DZPlayerLayerView alloc] init];
        
    }
    return _layerView;
}
-(void)removeTimelinePlayVideo{
    [self.playerLayer removeFromSuperlayer];
    [self.player pause];
    if (self.playerItem) {
        [self removeObserverWithPlayerItem:self.playerItem];
    }
    self.playerItem=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //恢复其他的APP播放
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
}
-(void)addGestureRecogniz{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPan:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [self.contentView addGestureRecognizer:pan];
    _disable = NO;
    _dismissScale = 0.22;
    _dismissVelocityY = 800;
    _restoreDuration = 0.15;
    _triggerDistance = 3;
}
- (void)respondsToPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.contentView];
    CGSize containerSize = self.contentView.bounds.size;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _interactStartPoint = point;
    } else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateRecognized || pan.state == UIGestureRecognizerStateFailed) {
        
        // End
        if (_interacting) {
            CGPoint velocity = [pan velocityInView:self.contentView];
            
            BOOL velocityArrive = ABS(velocity.y) > self.dismissVelocityY;
            BOOL distanceArrive = ABS(point.y - _interactStartPoint.y) > containerSize.height * self.dismissScale;
            
            BOOL shouldDismiss = distanceArrive || velocityArrive;
            if (shouldDismiss) {
                
                [self hiddenTimelinePlayVideo];
            } else {
                [self.player play];
                self.bottomToolView.hidden=NO;
                [self restoreGestureInteractionWithDuration:self.restoreDuration];
            }
        }
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
       
        if (_interacting) {
            [self.player pause];
            self.bottomToolView.hidden=YES;
            // Change
            self.layerView.center = point;
            CGFloat scale = 1 - ABS(point.y - _interactStartPoint.y) / (containerSize.height * 1.2);
            if (scale > 1) scale = 1;
            if (scale < 0.35) scale = 0.35;
            self.layerView. transform = CGAffineTransformMakeScale(scale, scale);
            
            CGFloat alpha = 1 - ABS(point.y - _interactStartPoint.y) / (containerSize.height * 0.7);
            if (alpha > 1) alpha = 1;
            if (alpha < 0) alpha = 0;
            self.contentView.backgroundColor = [self.contentView.backgroundColor colorWithAlphaComponent:alpha];
            
        } else {
            CGPoint velocityPoint = [pan velocityInView:self.contentView];
            CGFloat triggerDistance = self.triggerDistance;
            
            BOOL distanceArrive = ABS(point.y - _interactStartPoint.y) > triggerDistance && (ABS(point.x - _interactStartPoint.x) < triggerDistance && ABS(velocityPoint.x) < 500);
            
            BOOL shouldStart = distanceArrive;
            if (!shouldStart) return;
            _interactStartPoint = point;
            
            CGRect startFrame = self.contentView.bounds;
            CGFloat anchorX = (point.x - startFrame.origin.x) / startFrame.size.width,
            anchorY = (point.y - startFrame.origin.y) / startFrame.size.height;
            self.layerView.layer.anchorPoint = CGPointMake(anchorX, anchorY);
            self.layerView.userInteractionEnabled = NO;
            self.layerView.center = point;
            _interacting = YES;
        }
    }
}
- (void)restoreGestureInteractionWithDuration:(NSTimeInterval)duration {
    //    [self.videoView hideToolBar:NO];
    
    CGSize containerSize = self.contentView. bounds.size;
    
    void (^animations)(void) = ^{
        self.contentView.backgroundColor = [self.contentView.backgroundColor colorWithAlphaComponent:1];
        CGPoint anchorPoint = self.layerView.layer.anchorPoint;
        self.layerView.center = CGPointMake(containerSize.width * anchorPoint.x, containerSize.height * anchorPoint.y);
        self.layerView.transform = CGAffineTransformIdentity;
    };
    void (^completion)(BOOL finished) = ^(BOOL finished){
        self.layerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        //        self.layerView.center = CGPointMake(containerSize.width * 0.5, containerSize.height * 0.5);
        self.layerView.userInteractionEnabled = YES;
        self.layerView.frame=CGRectMake(0, 0, self.contentView.size.width, self.contentView.size.height);
        self.layerView.center=self.contentView.center;
        
        self->_interactStartPoint = CGPointZero;
        self->_interacting = NO;
    };
    if (duration <= 0) {
        animations();
        completion(NO);
    } else {
        [UIView animateWithDuration:duration animations:animations completion:completion];
    }
}
//当视频正在自动播放的时候 点击放大视频
-(void)showTimelinePlayVideo{
    [self.layerView addGestureRecognizer:self.tapShow];
    [self.layerView addGestureRecognizer:self.longPress];
    UIWindow*window=[UIApplication sharedApplication].delegate.window;
    self.contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.contentView.backgroundColor=UIColor.blackColor;
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.layerView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.contentView addSubview:self.layerView];
    self.player.muted=NO;
    [window addSubview:self.contentView];
    [self setUpView];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self addGestureRecogniz];
}
-(void)hiddenTimelinePlayVideo{
    [self.contentView removeFromSuperview];
    [self.layerView removeGestureRecognizer:self.tapShow];
    [self.layerView removeGestureRecognizer:self.longPress];
    //    [self.layerView removeFromSuperview];
    //    self.contentView=nil;
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.layerView.frame=CGRectMake(0, 0, self.originContentView.frame.size.width, self.originContentView.frame.size.height);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [self.originContentView addSubview:self.layerView];
    self.player.muted=YES;
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [self.player play];
}

-(void)showWithView:(UIView *)contentView videoUrl:(NSString*)videoUrl{
    _originContentView=contentView;
    self.playUrl=[NSURL URLWithString:videoUrl];
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrl]];
    self.playerItem = item;
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.layerView addPlayerLayer:self.playerLayer];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    //AVLayerVideoGravityResizeAspectFill 视频充满
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.layerView.frame=CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [contentView addSubview:self.layerView];
    [self addObserverWithPlayerItem:self.playerItem];
    self.player.muted=NO;
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateSlider)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
}
-(void)regainPlayer{
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [self.player play];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
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
    
    //   [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"status"];
}
// 监听变化方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem * playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            self.link.paused = NO;
            CMTime seekTime = CMTimeMake(0, 1);
            [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
                if (finished) {
                    NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
                    self.currentTimeLabel.text = [self convertTimeToString:current];
                }
            }];
            [self.player play];
            self.playSwitch.selected = NO;
        }
    }
}
-(void)playbackFinished:(NSNotification *)notification{
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}
-(void)setUpView{
    [self.contentView addSubview:self.playOrStopButton];
    [self.playOrStopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.contentView addSubview:self.bottomToolView];
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.equalTo(@120);
    }];
    [self.bottomToolView addSubview:self.playSwitch];
    [self.playSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@25);
        make.width.height.equalTo(@25);
        make.top.equalTo(@10);
    }];
    [self.bottomToolView addSubview:self.currentTimeLabel];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playSwitch.mas_centerY);
        make.left.equalTo(self.playSwitch.mas_right).offset(20);
    }];
    [self.bottomToolView addSubview:self.totleTimeLabel];
    [self.totleTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-25);
        make.centerY.equalTo(self.playSwitch.mas_centerY);
    }];
    [self.bottomToolView addSubview:self.progressSlider];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(5);
        make.height.equalTo(@15);
        make.centerY.equalTo(self.playSwitch.mas_centerY);
        make.right.equalTo(self.totleTimeLabel.mas_left).offset(-5);
    }];
    
    [self.bottomToolView addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playSwitch.mas_bottom).offset(30);
        make.centerX.equalTo(self.playSwitch.mas_centerX);
        make.width.height.equalTo(@15);
    }];
    [self.bottomToolView addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancleButton.mas_centerY);
        make.right.equalTo(@-25);
        make.width.height.equalTo(@20);
    }];
}
#pragma mark - notification
// 暂停
- (void)pause {
    
    [self.player pause];
    self.link.paused = YES;
    [self removeToolViewTimer];
}
// 停止
- (void)stop {
    [self.player pause];
    [self.link invalidate];
    [self removeToolViewTimer];
}
- (void)addToolViewTimer {
    
    [self removeToolViewTimer];
    _toolViewShowTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateToolViewShowTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_toolViewShowTimer forMode:NSRunLoopCommonModes];
}

- (void)removeToolViewTimer {
    
    [_toolViewShowTimer invalidate];
    _toolViewShowTimer = nil;
    _toolViewShowTime = 0;
}
- (void)updateToolViewShowTime {
    self.toolViewShowTime++;
    if (self.toolViewShowTime == 5) {
        
        [self removeToolViewTimer];
        self.toolViewShowTime = 0;
        self.bottomToolView.hidden=YES;
        self.isShowToolView=NO;
    }
}
-(void)tapShowOrHideBottomView{
    [self removeToolViewTimer];
    self.isShowToolView=!self.isShowToolView;
    if (self.isShowToolView) {
        [self addToolViewTimer];
        self.bottomToolView.hidden=NO;
    }else{
        
        self.bottomToolView.hidden=YES;
    }
    
}
- (void)showOrHideBar {
    self.isShowToolView = !self.isShowToolView;
    self.bottomToolView.hidden=self.isShowToolView;
    if (self.isShowToolView) {
        [self addToolViewTimer];
        
    }
    
}

//转换时间成字符串
- (NSString *)convertTimeToString:(NSTimeInterval)time {
    
    if (time <= 0) {
        
        return @"00:00";
    }
    int minute = time / 60;
    int second = (int)time % 60;
    NSString * timeStr;
    
    if (minute >= 100) {
        
        timeStr = [NSString stringWithFormat:@"%d:%02d", minute, second];
    }else {
        
        timeStr = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
    return timeStr;
}
#pragma mark - private


- (void)progressValueChange:(DZProgressSlider *)slider {
    
    [self addToolViewTimer];
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        NSTimeInterval duration = slider.sliderPercent * CMTimeGetSeconds(self.player.currentItem.duration);
        CMTime seekTime = CMTimeMake(duration, 1);
        
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
            
            if (finished) {
                self.playSwitch.selected=NO;
                self.playOrStopButton.hidden=YES;
                NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
                self.currentTimeLabel.text = [self convertTimeToString:current];
                [self.player play];
            }
        }];
    }
}
// 更新进度条
- (void)updateSlider {
    
    NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval total = CMTimeGetSeconds(self.player.currentItem.duration);
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (!self.progressSlider.isSliding) {
        
        self.progressSlider.sliderPercent = current/total;
    }
    self.currentTimeLabel.text = [self convertTimeToString:current];
    self.totleTimeLabel.text = isnan(total) ? @"00:00" : [self convertTimeToString:total];
}
#pragma mark - setter and getter

- (UIButton *)playSwitch {
    
    if (!_playSwitch) {
        
        UIButton * playSwitch = [[UIButton alloc] init];
        [playSwitch setImage:[UIImage imageNamed:@"icon_video_suspend"] forState:UIControlStateNormal];
        [playSwitch setImage:[UIImage imageNamed:@"icon_video_play_white"] forState:UIControlStateSelected];
        [playSwitch addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _playSwitch = playSwitch;
        _playSwitch.tag=100;
    }
    return _playSwitch;
}


- (UILabel *)currentTimeLabel {
    
    if (!_currentTimeLabel) {
        UILabel * currentTimeLabel = [[UILabel alloc] init];
        currentTimeLabel.textColor = [UIColor whiteColor];
        currentTimeLabel.font = [UIFont systemFontOfSize:12];
        currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        currentTimeLabel.text = @"00:00";
        _currentTimeLabel = currentTimeLabel;
    }
    return _currentTimeLabel;
}

- (UILabel *)totleTimeLabel {
    
    if (!_totleTimeLabel) {
        
        UILabel * totleTimeLabel = [[UILabel alloc] init];
        totleTimeLabel.textColor = [UIColor whiteColor];
        totleTimeLabel.font = [UIFont systemFontOfSize:12];
        totleTimeLabel.textAlignment = NSTextAlignmentCenter;
        totleTimeLabel.text = @"00:00";
        _totleTimeLabel = totleTimeLabel;
    }
    return _totleTimeLabel;
}

- (DZProgressSlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider=[[DZProgressSlider alloc] initWithFrame:CGRectZero direction:RHSliderDirectionHorizonal];
        _progressSlider.enabled = YES;
        [_progressSlider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _progressSlider;
}
-(void)longPressAction:(UILongPressGestureRecognizer*)gest{
    if (gest.state==UIGestureRecognizerStateBegan) {
        [self showMoreSelectView];
    }
}

-(UIButton *)playOrStopButton{
    if (!_playOrStopButton) {
        _playOrStopButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrStopButton setBackgroundImage:UIImageMake(@"icon_video_play") forState:UIControlStateNormal];
        _playOrStopButton.tag=103;
        [_playOrStopButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _playOrStopButton.hidden=YES;
    }
    return _playOrStopButton;
}
-(UIView *)bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView=[[UIView alloc]init];
        //        _bottomToolView.backgroundColor=[UIColor purpleColor];
    }
    return _bottomToolView;
}
- (void)dealloc {
    
    NSLog(@"player view dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [self removeObserverWithPlayerItem:self.playerItem];
}
-(UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setBackgroundImage:UIImageMake(@"icon_video_close") forState:UIControlStateNormal];
        _cancleButton.tag=101;
        [_cancleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}
-(UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.tag=102;
        [_moreButton setBackgroundImage:UIImageMake(@"icon_timeline_video_more") forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
-(void)resumePlay{
    if (self.isPlayEnd) {
        self.link.paused = NO;
        CMTime seekTime = CMTimeMake(0, 1);
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
            if (finished) {
                NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
                self.currentTimeLabel.text = [self convertTimeToString:current];
            }
        }];
        self.isPlayEnd=NO;
        [self.player play];
        self.playSwitch.selected = NO;
        [self addToolViewTimer];
    }else{
        self.isPlayEnd=NO;
        [self.player play];
        self.link.paused = NO;
        [self addToolViewTimer];
    }
}
-(void)buttonAction:(UIButton*)button{
    if (button.tag==100) {//播放暂停
        button.selected=!button.selected;
        if (button.selected) {//暂停状态
            [self.player pause];
            self.link.paused = YES;
            [self removeToolViewTimer];
            self.playOrStopButton.hidden=NO;
        }else{
            self.playOrStopButton.hidden=YES;
            [self resumePlay];
            
        }
    }else if (button.tag==101){
        
        [self hiddenTimelinePlayVideo];
        
    }else if(button.tag==102){//更多
        [self showMoreSelectView];
        
    }else{//播放
        self.playOrStopButton.hidden=YES;
        self.playSwitch.selected = NO;
        [self resumePlay];
        
        
    }
}



-(void)showMoreSelectView{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Save video".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [QMUITipsTool showLoadingWihtMessage:@"Saving, please wait" inView:nil isAutoHidden:NO];
        [[NetworkRequestManager shareManager]downloadVideoWithUrl:self.playUrl.absoluteString success:^(NSURL *url) {
            [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
                NSError *error;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
                    if (error) {
                        DDLogInfo(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Save Sucess",保存成功) inView:nil];
                        });
                    }
                    DDLogInfo(@"%@",error);
                } error:&error];
            } failure:^{
                
            }];
        } failure:^(NSError *failure) {
            
        }];
        
    }];
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    [alertController addAction:action3];
    [alertController showWithAnimated:YES];
}

@end
