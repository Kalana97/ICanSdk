//
/**
 - Copyright © 2022 dzl. All rights reserved.
 - Author: Created  by DZL on 10/5/2022
 - File name:  DZAVPlayerViewController.m
 - Description:
 - Function List:
 */


#import "DZAVPlayerViewController.h"
#import "DZPlayerLayerView.h"
#import "PrivacyPermissionsTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PlayerProgressSlider.h"
#import "VideoCacheManager.h"
#import "UIDevice+Orientation.h"
@interface DZAVPlayerViewController ()<UIGestureRecognizerDelegate>{
    CGPoint _interactStartPoint;
    BOOL _interacting;
}
@property (weak, nonatomic) IBOutlet UIView *bgContentView;
@property (nonatomic, strong) AVPlayerItem * playerItem;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@property (nonatomic, strong) UIActivityIndicatorView * activity;
@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UIButton * playOrStopButton;
@property (nonatomic, weak) IBOutlet DZPlayerLayerView * layerView;
/**
 是一个定时器对象，它可以让你与屏幕刷新频率相同的速率来刷新你的视图。就说CADisplayLink是用于同步屏幕刷新频率的计时器。
 */
@property (nonatomic, strong) CADisplayLink * link;
@property (nonatomic, assign) NSTimeInterval lastTime;

@property (nonatomic, strong) NSTimer * toolViewShowTimer;
@property (nonatomic, assign) NSTimeInterval toolViewShowTime;
@property (nonatomic, copy)   NSURL *playUrl;
// 当前是否显示控制条
@property (nonatomic, assign) BOOL isShowToolView;
/** 是否是播放结束 */
@property (nonatomic, assign) BOOL isPlayEnd;
@property (nonatomic, weak) IBOutlet UIView * bottomToolView;
/** 播放暂停按钮 */
@property (nonatomic, weak) IBOutlet UIButton * playSwitch;
/** 取消播放按钮 */
@property (nonatomic, weak)  IBOutlet UIButton * cancleButton;
/** 更多按钮 */
@property (nonatomic, weak) IBOutlet UIButton * moreButton;
/** 当前的进度时间 */
@property (nonatomic, weak) IBOutlet UILabel * currentTimeLabel;
/** 总的播放时间 */
@property (nonatomic, weak) IBOutlet UILabel * totleTimeLabel;
/** 进度条 */
@property (nonatomic, strong)  PlayerProgressSlider *slider;
/** 是否已经完成跳转 也就是拖拉进度条的跳转 */
@property (nonatomic, assign) BOOL isCompletedSlider;
/** 是否播放的是本地URL */
@property (nonatomic, assign) BOOL isPlayLocalUrl;

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property(nonatomic, assign) NSTimeInterval current;
@end

@implementation DZAVPlayerViewController
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self.playSwitch setImage:[UIImage imageNamed:@"icon_video_suspend"] forState:UIControlStateNormal];
    [self.playSwitch setImage:[UIImage imageNamed:@"icon_video_play_white"]forState:UIControlStateSelected];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShowOrHideBottomView)];
    [self.layerView addGestureRecognizer:tap];
    UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration=0.5;
    [self.layerView addGestureRecognizer:longPress];
    [self.bgContentView addSubview:self.slider];
    [self.slider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTimeLabel.mas_right).offset(5);
        make.right.equalTo(self.totleTimeLabel.mas_left).offset(-5);
        make.height.equalTo(@15);
        make.centerY.equalTo(self.playSwitch.mas_centerY);
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeStatusBar) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}
-(void)setPlayUrl:(NSURL *)url aVPlayerViewType:(AVPlayerViewType)aVPlayerViewType{
    _aVPlayerViewType = aVPlayerViewType;
    if (self.aVPlayerViewType==AVPlayerViewTimelinesPostMessage) {
        [self.moreButton setImage:UIImageMake(@"icon_photo_delect") forState:UIControlStateNormal];
    }else{
        [self.moreButton setImage:UIImageMake(@"icon_timeline_video_more") forState:UIControlStateNormal];
    }
    switch (aVPlayerViewType) {
        case AVPlayerViewNormal:
            
            break;
        case AVPlayerViewReply:
            self.moreButton.hidden = YES;
            break;
        case AVPlayerViewTimelinesPostMessage:
            
            break;
        default:
            break;
    }
    [self addGestureRecogniz];
    self.current = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startPlay) name:KStartPlayVideoOrAudioNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopPlay) name:KStopPlayVideoOrAudioNotification object:nil];
    self.isShowToolView = YES;
    self.aVPlayerViewType = aVPlayerViewType;
    [self setPlayerFromUrl:url];
}
-(void)didChangeStatusBar{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationPortrait||orientation ==UIDeviceOrientationPortraitUpsideDown) {
        self.leftContraint.constant = self.rightConstraint.constant = 0;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        self.bottomConstraint.constant =isIPhoneX?20:20;
    }else{
        self.leftContraint.constant = self.rightConstraint.constant = 50;
//        self.bottomConstraint.constant = 20;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.slider updateSliderWidth];
    });
    
}


-(void)addGestureRecogniz{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPan:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    _disable = NO;
    _dismissScale = 0.22;
    _dismissVelocityY = 800;
    _restoreDuration = 0.15;
    _triggerDistance = 3;
}
-(void)startPlay{
    [self.player play];
}
-(void)stopPlay{
    [self.player pause];
}
- (void)respondsToPan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.view];
    CGSize containerSize = self.view.bounds.size;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _interactStartPoint = point;
    } else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateRecognized || pan.state == UIGestureRecognizerStateFailed) {
        
        // End
        if (_interacting) {
            CGPoint velocity = [pan velocityInView:self.view];
            
            BOOL velocityArrive = ABS(velocity.y) > self.dismissVelocityY;
            BOOL distanceArrive = ABS(point.y - _interactStartPoint.y) > containerSize.height * self.dismissScale;
            
            BOOL shouldDismiss = distanceArrive || velocityArrive;
            if (shouldDismiss) {
                
                [self hiddenDZAVPlayerView];
            } else {
                [self.player play];
                self.bottomToolView.hidden=NO;
                [self restoreGestureInteractionWithDuration:self.restoreDuration];
            }
        }else{
            [self.player play];
        }
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (_interacting) {
            // Change
            self.layerView.center = point;
            CGFloat scale = 1 - ABS(point.y - _interactStartPoint.y) / (containerSize.height * 1.2);
            if (scale > 1) scale = 1;
            if (scale < 0.35) scale = 0.35;
            self.layerView. transform = CGAffineTransformMakeScale(scale, scale);
            
            CGFloat alpha = 1 - ABS(point.y - _interactStartPoint.y) / (containerSize.height * 0.7);
            if (alpha > 1) alpha = 1;
            if (alpha < 0) alpha = 0;
            self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:alpha];
            [self.player pause];
            self.bottomToolView.hidden=YES;
        } else {
            
            //        // Start
            //        if (CGPointEqualToPoint(_interactStartPoint, CGPointZero) || self.yb_currentPage() != self.yb_selfPage() || !self.yb_cellIsInCenter() || self.videoView.actionBar.isTouchInside) return;
            
            CGPoint velocityPoint = [pan velocityInView:self.view];
            CGFloat triggerDistance = self.triggerDistance;
            
            BOOL distanceArrive = ABS(point.y - _interactStartPoint.y) > triggerDistance && (ABS(point.x - _interactStartPoint.x) < triggerDistance && ABS(velocityPoint.x) < 500);
            
            BOOL shouldStart = distanceArrive;
            if (!shouldStart) return;
            
            //        [self.videoView hideToolBar:YES];
            
            _interactStartPoint = point;
            
            CGRect startFrame = self.layerView.bounds;
            CGFloat anchorX = (point.x - startFrame.origin.x) / startFrame.size.width,
            anchorY = (point.y - startFrame.origin.y) / startFrame.size.height;
            self.layerView.layer.anchorPoint = CGPointMake(anchorX, anchorY);
            self.layerView.userInteractionEnabled = NO;
            self.layerView.center = point;
            
            //        [self hideToolViews:YES];
            //        self.yb_hideStatusBar(NO);
            //        self.yb_collectionView().scrollEnabled = NO;
            
            _interacting = YES;
        }
    }
}
- (void)restoreGestureInteractionWithDuration:(NSTimeInterval)duration {
    //    [self.videoView hideToolBar:NO];
    
    CGSize containerSize = self.view.bounds.size;
    
    void (^animations)(void) = ^{
        self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:1];
        
        CGPoint anchorPoint = self.layerView.layer.anchorPoint;
        self.layerView.center = CGPointMake(containerSize.width * anchorPoint.x, containerSize.height * anchorPoint.y);
        self.layerView.transform = CGAffineTransformIdentity;
    };
    void (^completion)(BOOL finished) = ^(BOOL finished){
        self.layerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        self.layerView.center = CGPointMake(containerSize.width * 0.5, containerSize.height * 0.5);
        self.layerView.userInteractionEnabled = YES;
        
        //           self.yb_hideStatusBar(YES);
        //           self.yb_collectionView().scrollEnabled = YES;
        //           if (!self.videoView.isPlaying) [self hideToolViews:NO];;
        
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

-(void)hiddenDZAVPlayerView{
    [UIDevice interfaceOrientation:UIInterfaceOrientationPortrait];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserverWithPlayerItem:self.playerItem];
    [self removeToolViewTimer];
    [self.player pause];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if (self.cancleBlock) {
        self.cancleBlock();
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}

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
//添加控制底部操作view显示或者隐藏的定时器
- (void)addToolViewTimer {
    [self removeToolViewTimer];
    _toolViewShowTimer =[NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self updateToolViewShowTime];
    }];
}
- (void)removeToolViewTimer {
    [_toolViewShowTimer invalidate];
    _toolViewShowTimer = nil;
    _toolViewShowTime = 0;
}
- (void)updateToolViewShowTime {
    self.toolViewShowTime ++;
    if (self.toolViewShowTime == 5) {
        [self removeToolViewTimer];
        self.toolViewShowTime = 0;
        if (!self.slider.isSliding) {
            self.bottomToolView.hidden=YES;
        }
        self.isShowToolView=NO;
    }
}
-(void)tapShowOrHideBottomView{
    [self removeToolViewTimer];
    self.isShowToolView=!self.isShowToolView;
    if (self.isShowToolView) {//当前显示操作view 才添加定时器
        [self addToolViewTimer];
        self.bottomToolView.hidden=NO;
    }else{
        self.bottomToolView.hidden=YES;
    }
}

#pragma mark - 监听视频缓冲和加载状态
//注册观察者监听状态和缓冲
- (void)addObserverWithPlayerItem:(AVPlayerItem *)playerItem {
    if (playerItem) {
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
}

//移除观察者
- (void)removeObserverWithPlayerItem:(AVPlayerItem *)playerItem {
    if (playerItem) {
        [playerItem removeObserver:self forKeyPath:@"status"];
    }
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
                    self.currentTimeLabel.text = [GetTime getMinutesAndSeconds:current];
                }
            }];
            [self.player play];
            @weakify(self);
            [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 60) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                @strongify(self);
                self.current = self.current+1/60.0;
                [self updateSlider];
            }];
            self.playSwitch.selected = NO;
            [self addToolViewTimer];
        }
    }
}
// 设置播放器
- (void)setPlayerFromUrl:(NSURL *)url {
    self.playUrl = url;
    [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:self.playUrl.absoluteString cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
        if (hasCache) {
            self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:data]];
        }else{
            self.playerItem = [AVPlayerItem playerItemWithURL:self.playUrl];
        }
        [self createPlayerLayer];
        
    }];
    
}
-(void)createPlayerLayer{
    [self addObserverWithPlayerItem:self.playerItem];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.layerView addPlayerLayer:self.playerLayer];
    self.isCompletedSlider=YES;
}
// 更新进度条
- (void)updateSlider {
    //    NSTimeInterval current =roundf(CMTimeGetSeconds(self.player.currentTime));
    NSTimeInterval total =roundf(CMTimeGetSeconds(self.player.currentItem.duration));
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (!self.slider.isSliding&&self.isCompletedSlider) {
        if (total>0) {
            self.slider.sliderPercent=self.current/total;
        }
    }
    self.currentTimeLabel.text = [GetTime getMinutesAndSeconds:self.current];
    self.totleTimeLabel.text = isnan(total) ? @"00:00" : [GetTime getMinutesAndSeconds:total];
    if (roundf(self.current)==total) {
        self.isPlayEnd=YES;
        self.playSwitch.selected = YES;
        self.playOrStopButton.hidden=NO;
        self.isShowToolView = YES;
        self .bottomToolView.hidden=NO;
        [self removeToolViewTimer];
    }
}

-(void)longPressAction:(UILongPressGestureRecognizer*)gest{
    if (gest.state==UIGestureRecognizerStateBegan) {
        [self showMoreSelectView];
    }
}
- (void)dealloc {
    
    NSLog(@"player view dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [self removeObserverWithPlayerItem:self.playerItem];
}
//重新播放
-(void)resumePlay{
    if (self.isPlayEnd) {
        self.link.paused = NO;
        CMTime seekTime = CMTimeMake(0, 1);
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
            if (finished) {
                self.current = CMTimeGetSeconds(self.player.currentTime);
                self.currentTimeLabel.text = [GetTime getMinutesAndSeconds:self.current];
                self.isPlayEnd=NO;
                [self.player play];
                
                self.playSwitch.selected = NO;
                [self addToolViewTimer];
            }
        }];
    }else{
        self.isPlayEnd=NO;
        [self.player play];
        self.link.paused = NO;
        [self addToolViewTimer];
    }
}
-(IBAction)buttonAction:(UIButton*)button{
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
        
        [self hiddenDZAVPlayerView];
        
    }else if(button.tag==102){//更多
        if (self.aVPlayerViewType==AVPlayerViewTimelinesPostMessage) {
            [self showDeleteAlertView];
        }else{
            [self showMoreSelectView];
        }
    }else{//播放
        self.playSwitch.selected = NO;
        [self resumePlay];
        self.playOrStopButton.hidden = YES;
    }
}



-(void)showMoreSelectView{
    
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"]  style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [self.player pause];
        
        [UIDevice interfaceOrientation:UIInterfaceOrientationPortrait];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forwardingSendMessage) name:kForwardingSendMessageNotification object:nil];
        if (self.transpondBlock) {
            self.transpondBlock();
        }
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"Save video".icanlocalized style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        
        if (self.isPlayLocalUrl) {
            [PrivacyPermissionsTool judgeAlbumAuthorizationSuccess:^{
                NSError *error;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    
                    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self.playUrl];
                    
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
        }else{
            [QMUITipsTool showLoadingWihtMessage:@"Saving, please wait" inView:self.view isAutoHidden:NO];
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
        }
        
    }];
    
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleActionSheet];
    [alertController addAction:action1];
    if (self.aVPlayerViewType==AVPlayerViewNormal) {
        [alertController addAction:action2];
    }
    [alertController addAction:action3];
    [alertController showWithAnimated:YES];
}

-(void)showDeleteAlertView{
    [UIAlertController alertControllerWithTitle:nil message:@"DZAVPlayerView.sureDeleteVideo".icanlocalized target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        if (index ==1) {
            !self.delectBlock?:self.delectBlock();
            [self hiddenDZAVPlayerView];
        }
    }];
}


-(void)forwardingSendMessage{
    [self.player play];
}
-(PlayerProgressSlider *)slider{
    if (!_slider) {
        _slider=[[NSBundle mainBundle]loadNibNamed:@"PlayerProgressSlider" owner:self options:nil].firstObject;
        @weakify(self);
        _slider.valueChangeBlock = ^(double value) {
            @strongify(self);
            [self addToolViewTimer];
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                self.current = value * CMTimeGetSeconds(self.player.currentItem.duration);
                CMTime seekTime = CMTimeMake(self.current, 1);
                self.isCompletedSlider=NO;
                [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
                    if (finished) {
                        self.isCompletedSlider=YES;
                        self.playSwitch.selected=NO;
                        self.playOrStopButton.hidden=YES;
                        self.currentTimeLabel.text = [GetTime getMinutesAndSeconds:self.current];
                        [self.player play];
                        [self removeToolViewTimer];
                        [self addToolViewTimer];
                    }
                }];
            }
        };
    }
    return _slider;
}

@end
