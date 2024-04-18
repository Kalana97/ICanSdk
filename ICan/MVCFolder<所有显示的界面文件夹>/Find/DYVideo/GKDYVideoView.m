//
//  GKDYVideoView.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYVideoView.h"
#import "GKDYVideoPlayer.h"
#import "GKDoubleLikeView.h"
#import "GKDYPanGestureRecognizer.h"
#import <MJRefresh.h>
#import "TimelineBrowseImageView.h"
#import "VideoCacheManager.h"
#import "DZDYVideoPlayer.h"
@interface GKDYVideoView()<UIScrollViewDelegate, DZDYVideoPlayerDelegate, GKDYVideoControlViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView              *scrollView;

// 创建三个控制视图，用于滑动切换
@property (nonatomic, strong) GKDYVideoControlView      *topView;   // 顶部视图
@property (nonatomic, strong) GKDYVideoControlView      *ctrView;   // 中间视图
@property (nonatomic, strong) GKDYVideoControlView      *btmView;   // 底部视图

// 控制播放的索引，不完全等于当前播放内容的索引
@property (nonatomic, assign) NSInteger                 index;

@property (nonatomic, weak) UIViewController            *vc;
@property (nonatomic, assign) BOOL                      isPushed;

@property (nonatomic, strong) NSMutableArray<TimelinesListDetailInfo*>  *videos;

//@property (nonatomic, strong) GKDYVideoPlayer           *player;

@property(nonatomic, strong) DZDYVideoPlayer *player;
// 记录播放内容
@property (nonatomic, copy) NSString                    *currentPlayId;

// 记录滑动前的播放状态
@property (nonatomic, assign) BOOL                      isPlaying_beforeScroll;

@property (nonatomic, assign) BOOL                      isRefreshMore;

@property (nonatomic, strong) GKDYPanGestureRecognizer  *panGesture;

@property (nonatomic, assign) BOOL                      interacting;
// 开始移动时的位置
@property (nonatomic, assign) CGFloat                   startLocationY;

@property (nonatomic, assign) CGPoint                   startLocation;
@property (nonatomic, assign) CGRect                    startFrame;

@property (nonatomic, strong) GKDoubleLikeView          *doubleLikeView;

@property(nonatomic, strong) TimelineBrowseImageView *timelineBrowseView;
@end

@implementation GKDYVideoView

- (instancetype)initWithVC:(UIViewController *)vc isPushed:(BOOL)isPushed {
    if (self = [super init]) {
        self.vc = vc;
        self.isPushed = isPushed;
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        @weakify(self);
        self.scrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.player pausePlay];
            // 当播放索引为最后一个时才会触发下拉刷新
            self.currentPlayIndex = self.videos.count - 1;
            [self refreshMore];
        }];
//        
        [self.scrollView addGestureRecognizer:self.panGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat controlW = CGRectGetWidth(self.scrollView.frame);
    CGFloat controlH = CGRectGetHeight(self.scrollView.frame);
    
    self.topView.frame   = CGRectMake(0, 0, controlW, controlH);
    self.ctrView.frame   = CGRectMake(0, controlH, controlW, controlH);
    self.btmView.frame   = CGRectMake(0, 2 * controlH, controlW, controlH);
}
-(void)dealloc{
    DDLogInfo(@"%s",__func__);
}
#pragma mark - Public Methods
- (void)setModels:(NSArray *)models index:(NSInteger)index {
    [self.videos removeAllObjects];
    [self.videos addObjectsFromArray:models];

    for (TimelinesListDetailInfo *detailInfo  in self.videos) {
        if (detailInfo.videoUrl.length >0) {
            [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:detailInfo.videoUrl cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
            }];
        }
    }

    self.index = index;
    self.currentPlayIndex = index;

    if (models.count == 0) return;

    if (models.count == 1) {
        [self.ctrView removeFromSuperview];
        [self.btmView removeFromSuperview];

        self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT);

        self.topView.hidden = NO;
        self.topView.timeLineInfo = self.videos.firstObject;

        [self playVideoFrom:self.topView];
    }else if (models.count == 2) {
        [self.btmView removeFromSuperview];

        self.scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 2);

        self.topView.hidden = NO;
        self.ctrView.hidden = NO;
        self.topView.timeLineInfo  = self.videos.firstObject;
        self.ctrView.timeLineInfo  = self.videos.lastObject;

        if (index == 1) {
            self.scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);

            [self playVideoFrom:self.ctrView];
        }else {
            [self playVideoFrom:self.topView];
        }
    }else {
        self.topView.hidden = NO;
        self.ctrView.hidden = NO;
        self.btmView.hidden = NO;

        if (index == 0) {   // 如果是第一个，则显示上视图，且预加载中下视图
            self.topView.timeLineInfo = self.videos[index];
            self.ctrView.timeLineInfo = self.videos[index + 1];
            self.btmView.timeLineInfo = self.videos[index + 2];

            // 播放第一个
            [self playVideoFrom:self.topView];
        }else if (index == models.count - 1) { // 如果是最后一个，则显示最后视图，且预加载前两个
            self.btmView.timeLineInfo = self.videos[index];
            self.ctrView.timeLineInfo = self.videos[index - 1];
            self.topView.timeLineInfo = self.videos[index - 2];

            // 显示最后一个
            self.scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT * 2);
            // 播放最后一个
            [self playVideoFrom:self.btmView];
        }else { // 显示中间，播放中间，预加载上下
            self.ctrView.timeLineInfo = self.videos[index];

            self.topView.timeLineInfo = self.videos[index - 1];
            self.btmView.timeLineInfo = self.videos[index + 1];

            // 显示中间
            self.scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
            // 播放中间
            [self playVideoFrom:self.ctrView];
        }
    }
}

- (void)resetModels:(NSArray *)models {
    [self.videos addObjectsFromArray:models];
}

- (void)pause {
    if (self.player.isPlaying) {
        self.isPlaying_beforeScroll = YES;
    }else {
        self.isPlaying_beforeScroll = NO;
    }
    
    [self.player pausePlay];
}

- (void)resume {
    if (self.isPlaying_beforeScroll) {
        [self.player resumePlay];
    }
}

- (void)destoryPlayer {
    [self.player removeObserver];
//    self.scrollView.delegate = nil;
//    self.player = nil;
}

#pragma mark - Private Methods
- (void)playVideoFrom:(GKDYVideoControlView *)fromView {
    // 移除原来的播放
    [self.player removeVideo];
    // 取消原来视图的代理
    self.currentPlayView.delegate = nil;
    // 切换播放视图
    self.currentPlayId    = fromView.timeLineInfo.ID;
    self.currentPlayView  = fromView;
    self.currentPlayIndex = [self indexOfModel:fromView.timeLineInfo];
    // 设置新视图的代理
    self.currentPlayView.delegate = self;
    if (fromView.timeLineInfo.videoUrl.length>0) {
        [self.player playVideoWithView:fromView.coverImgView url:fromView.timeLineInfo.videoUrl];
    }else{
        fromView.playBtn.hidden=YES;
    }
    
    
}
-(TimelineBrowseImageView *)timelineBrowseView{
    if (!_timelineBrowseView) {
        _timelineBrowseView=[[TimelineBrowseImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
    }
    return _timelineBrowseView;
}
// 获取当前播放内容的索引
- (NSInteger)indexOfModel:(TimelinesListDetailInfo *)model {
    __block NSInteger index = 0;
    //TODO 需要计算
    [self.videos enumerateObjectsUsingBlock:^(TimelinesListDetailInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.ID isEqualToString:obj.ID]) {
            index = idx;
        }
    }];
    return index;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.currentPlayIndex == 0 && scrollView.contentOffset.y < 0) {
        self.scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y == 0 || scrollView.contentOffset.y == SCREEN_HEIGHT || scrollView.contentOffset.y == 2 * SCREEN_HEIGHT) {
        if ([self.delegate respondsToSelector:@selector(videoView:didScrollIsCritical:)]) {
            [self.delegate videoView:self didScrollIsCritical:YES];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(videoView:didScrollIsCritical:)]) {
            [self.delegate videoView:self didScrollIsCritical:NO];
        }
    }
    
    // 小于等于三个，不用处理
    if (self.videos.count <= 3) return;
    
    // 上滑到第一个
    if (self.index == 0 && scrollView.contentOffset.y <= SCREEN_HEIGHT) {
        return;
    }
    // 下滑到最后一个
    if (self.index > 0 && self.index == self.videos.count - 1 && scrollView.contentOffset.y > SCREEN_HEIGHT) {
        return;
    }
    
    // 判断是从中间视图上滑还是下滑
    if (scrollView.contentOffset.y >= 2 * SCREEN_HEIGHT) {  // 上滑
        NSLog(@"上滑");
        [self.player removeVideo];  // 在这里移除播放，解决闪动的bug
        if (self.index == 0) {
            self.index += 2;
            
            scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
            self.topView.timeLineInfo = self.ctrView.timeLineInfo;
            self.ctrView.timeLineInfo = self.btmView.timeLineInfo;
            
        }else {
            self.index += 1;
            
            if (self.index == self.videos.count - 1) {
                self.ctrView.timeLineInfo = self.videos[self.index - 1];
            }else {
                scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
                
                self.topView.timeLineInfo = self.ctrView.timeLineInfo;
                self.ctrView.timeLineInfo = self.btmView.timeLineInfo;
            }
        }
        if (self.index < self.videos.count - 1 && self.videos.count >= 3) {
            self.btmView.timeLineInfo = self.videos[self.index + 1];
        }
    }else if (scrollView.contentOffset.y <= 0) { // 下滑
        [self.player removeVideo];  // 在这里移除播放，解决闪动的bug
        NSLog(@"下滑");
        if (self.index == 1) {
            self.topView.timeLineInfo = self.videos[self.index - 1];
            self.ctrView.timeLineInfo = self.videos[self.index];
            self.btmView.timeLineInfo = self.videos[self.index + 1];
            self.index -= 1;
        }else {
            if (self.index == self.videos.count - 1) {
                self.index -= 2;
            }else {
                self.index -= 1;
            }
            scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
            
            self.btmView.timeLineInfo = self.ctrView.timeLineInfo;
            self.ctrView.timeLineInfo = self.topView.timeLineInfo;
            
            if (self.index > 0) {
                self.topView.timeLineInfo = self.videos[self.index - 1];
            }
        }
    }
    
    if (self.isPushed) return;
    
    // 自动刷新，如果想要去掉自动刷新功能，去掉下面代码即可
    if (scrollView.contentOffset.y == SCREEN_HEIGHT) {
        // 播放到倒数第二个时，请求更多内容
        if (self.currentPlayIndex == self.videos.count - 3) {
            [self refreshMore];
        }
    }
    
    if (scrollView.contentOffset.y == 2 * SCREEN_HEIGHT) {
        [self refreshMore];
    }
}

// 结束滚动后开始播放
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
        if (self.currentPlayId == self.topView.timeLineInfo.ID) return;
        [self playVideoFrom:self.topView];
    }else if (scrollView.contentOffset.y == SCREEN_HEIGHT) {
        if (self.currentPlayId == self.ctrView.timeLineInfo.ID) return;
        [self playVideoFrom:self.ctrView];
    }else if (scrollView.contentOffset.y == 2 * SCREEN_HEIGHT) {
        if (self.currentPlayId == self.btmView.timeLineInfo.ID) return;
        [self playVideoFrom:self.btmView];
    }
}

- (void)refreshMore {
    if (self.isRefreshMore) return;
    self.isRefreshMore = YES;
    self.currentIndex++;
    switch (self.timelineType) {
        case TimelineType_find:
            [self fetTimelineListRequest];
            break;
        case TimelineType_UserAll:
            [self fetUserAllTimelineRequest];
            break;;
        case TimelineType_openVideo:
            [self fetchTimelineOpenRequest:YES all:NO];
            break;
        case TimelineType_openText:{
            [self fetchTimelineOpenRequest:NO all:NO];
        }
            break;
        case TimelineType_video:{
            [self fetchAllVideoRequest];
        }
            break;
        case TimelineType_AllShare:{
            [self fetchTimelineOpenRequest:YES all:YES];
        }
            break;
        default:
            break;
    }
    
}
-(void)fetchAllVideoRequest{
    GetTimelinesAllVideoRequest *request = [GetTimelinesAllVideoRequest request];
    request.size=@(10);
    request.page=@(self.currentIndex);
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimeLinesNonDynamicListInfo class] contentClass:[TimeLinesNonDynamicListInfo class] success:^(TimeLinesNonDynamicListInfo *response) {
        @strongify(self);
        [self handleData:response];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}
-(void)fetTimelineListRequest{
    TimelinesListRequest *request = [TimelinesListRequest request];
    request.size=@(10);
    request.page=@(self.currentIndex);
    
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimeLinesNonDynamicListInfo class] contentClass:[TimeLinesNonDynamicListInfo class] success:^(TimeLinesNonDynamicListInfo* response) {
        @strongify(self);
        [self handleData:response];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.isRefreshMore = NO;
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    }];
}
-(void)fetchTimelineOpenRequest:(BOOL)isVideo all:(BOOL)all{
    TimeLinesOpenRequest *request = [TimeLinesOpenRequest request];
    request.size=@(10);
    request.page=@(self.currentIndex);
    if (!all) {
        if (isVideo) {
            request.isVideo=@"true";
        }else{
            request.isVideo=@"false";
        }
    }
    
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimelinesListInfo class] contentClass:[TimelinesListInfo class] success:^(TimelinesListInfo* response) {
        @strongify(self);
        NSMutableArray *resInfo = [NSMutableArray array];
        for (TimelineContentInfo *detailInfo  in response.content) {
            if(detailInfo.timeLinePageVO != nil){
                [resInfo addObject:detailInfo.timeLinePageVO];
            }
        }
        TimeLinesNonDynamicListInfo *timeLinesNonDynamicListInfo = [TimeLinesNonDynamicListInfo alloc];
        timeLinesNonDynamicListInfo.content = resInfo;
        [self handleData:timeLinesNonDynamicListInfo];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.isRefreshMore = NO;
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    }];
}
/**
 获取某个用户的朋友圈
 */
-(void)fetUserAllTimelineRequest{
    UserAllTimeLinesRequest *request = [UserAllTimeLinesRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/all",request.baseUrlString,self.currentPlayView.timeLineInfo.belongsId];
    request.size=@(10);
    request.page=@(self.currentIndex);
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimeLinesNonDynamicListInfo class] contentClass:[TimeLinesNonDynamicListInfo class] success:^(TimeLinesNonDynamicListInfo *response) {
        @strongify(self);
        [self handleData:response];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.isRefreshMore = NO;
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    }];
}
-(void)handleData:(TimeLinesNonDynamicListInfo *)response{
    self.isRefreshMore = NO;
    if (response.content.count>0) {
        [self.videos addObjectsFromArray:response.content];
        for (TimelinesListDetailInfo *detailInfo  in response.content) {
            if (detailInfo.videoUrl.length >0) {
                [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:detailInfo.videoUrl cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
                }];
            }
        }
        [self.scrollView.mj_footer endRefreshing];
        if (response.content.count<10) {
            [self.scrollView.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        [self.scrollView.mj_footer endRefreshingWithNoMoreData];
    }
    if (self.scrollView.contentOffset.y > 2 * SCREEN_HEIGHT) {
        self.scrollView.contentOffset = CGPointMake(0, 2 * SCREEN_HEIGHT);
    }
}
#pragma mark - Gesture
- (void)handlePanGesture:(GKDYPanGestureRecognizer *)panGesture {
    if (self.currentPlayIndex == 0) {
        CGPoint location = [panGesture locationInView:panGesture.view];
        
        switch (panGesture.state) {
            case UIGestureRecognizerStateBegan: {
                self.startLocationY = location.y;
            }
                break;
            case UIGestureRecognizerStateChanged: {
                if (panGesture.direction == GKDYPanGestureRecognizerDirectionVertical) {
                    // 这里取整是解决上滑时可能出现的distance > 0的情况
                    CGFloat distance = ceil(location.y) - ceil(self.startLocationY);
                    if (distance > 0) { // 只要distance>0且没松手 就认为是下滑
                        self.scrollView.panGestureRecognizer.enabled = NO;
                    }
                    
                    if (self.scrollView.panGestureRecognizer.enabled == NO) {
                        if ([self.delegate respondsToSelector:@selector(videoView:didPanWithDistance:isEnd:)]) {
                            [self.delegate videoView:self didPanWithDistance:distance isEnd:NO];
                        }
                    }
                }
            }
                break;
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateEnded: {
                if (self.scrollView.panGestureRecognizer.enabled == NO) {
                    CGFloat distance = location.y - self.startLocationY;
                    if ([self.delegate respondsToSelector:@selector(videoView:didPanWithDistance:isEnd:)]) {
                        [self.delegate videoView:self didPanWithDistance:distance isEnd:YES];
                    }
                    
                    self.scrollView.panGestureRecognizer.enabled = YES;
                }
            }
                break;
                
            default:
                break;
        }
        
        [panGesture setTranslation:CGPointZero inView:panGesture.view];
    }
}

// 允许多个手势响应
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


/** 判断手势方向  */
- (BOOL)commitTranslation:(CGPoint)translation {
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    // 设置滑动有效距离
    if (MAX(absX, absY) < 5)
        return NO;
    if (absX > absY ) {
        if (translation.x<0) {//向左滑动
            return NO;
        }else{//向右滑动
            return NO;
        }
    } else if (absY > absX) {
        if (translation.y<0) {//向上滑动
            return NO;
        }else{ //向下滑动
            return YES;
        }
    }
    return NO;
}
-(void)player:(DZDYVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.currentPlayView) {
            [self.currentPlayView setProgress:progress];
        }
        
    });
    
    
}
-(void)player:(DZDYVideoPlayer *)player statusChanged:(DZDYVideoPlayerStatus)status{
    switch (status) {
        case DZDYVideoPlayerStatusUnload:   // 未加载
            
            break;
        case DZDYVideoPlayerStatusPrepared:   // 准备播放
            [self.currentPlayView startLoading];
            break;
        case DZDYVideoPlayerStatusLoading: {     // 加载中
            [self.currentPlayView hidePlayBtn];
        }
            break;
        case DZDYVideoPlayerStatusPlaying: {    // 播放中
            self.player.isPlaying = YES;
            [self.currentPlayView stopLoading];
            [self.currentPlayView hidePlayBtn];
        }
            break;
        case DZDYVideoPlayerStatusPaused: {     // 暂停
            [self.currentPlayView stopLoading];
            [self.currentPlayView showPlayBtn];
        }
            break;
        case DZDYVideoPlayerStatusEnded: {   // 播放结束
            // 重新开始播放
            [self.player resetPlay];
        }
            break;
        case DZDYVideoPlayerStatusError:   // 错误
            
            break;
            
        default:
            break;
    }
}

#pragma mark - GKDYVideoControlViewDelegate
- (void)controlViewDidPanSelf:(GKDYVideoControlView *)controlView value:(float)value{
    // GKDYVideoPlayerStatusUnload,      // 未加载
//    GKDYVideoPlayerStatusPrepared,    // 准备播放
//    GKDYVideoPlayerStatusLoading,     // 加载中
//    GKDYVideoPlayerStatusPlaying,     // 播放中
//    GKDYVideoPlayerStatusPaused,      // 暂停
//    GKDYVideoPlayerStatusEnded,       // 播放完成
//    GKDYVideoPlayerStatusError        // 错误
    if (self.player.status==DZDYVideoPlayerStatusPrepared||self.player.status==DZDYVideoPlayerStatusPlaying||self.player.status==DZDYVideoPlayerStatusEnded||self.player.status==DZDYVideoPlayerStatusPaused) {
        NSTimeInterval duration = value * self.player.duration;
        [self.player seekToTime:duration];
    }
    [controlView hiddenTimeBgView];
}

-(void)controlViewDidChangePanSelf:(GKDYVideoControlView *)controlView value:(float)value{
    float totalTime=self.player.duration;
    float currentTime=value * totalTime;
    [controlView showCurrentTimeLabelWithTotalTime:totalTime currentTime:currentTime];
}
- (void)controlViewDidClickSelf:(GKDYVideoControlView *)controlView {
    if (self.player.isPlaying) {
        [self.player pausePlay];
    }else {
        [self.player resumePlay];
    }
}

- (void)controlView:(GKDYVideoControlView *)controlView touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    [self.doubleLikeView createAnimationWithTouch:touches withEvent:event];
    
    //    [controlView showLikeAnimation];
}
-(void)controlViewDidClickNameLabel:(GKDYVideoControlView *)controlView{
    if ([self.delegate respondsToSelector:@selector(videoView:didClickNameLabel:)]) {
        [self.delegate videoView:self didClickNameLabel:controlView.timeLineInfo];
    }
}
- (void)controlViewDidClickIcon:(GKDYVideoControlView *)controlView {
    if ([self.delegate respondsToSelector:@selector(videoView:didClickIcon:)]) {
        [self.delegate videoView:self didClickIcon:controlView.timeLineInfo];
    }
}

- (void)controlViewDidClickPriase:(GKDYVideoControlView *)controlView {
    if ([self.delegate respondsToSelector:@selector(videoView:didClickPraise:)]) {
        [self.delegate videoView:self didClickPraise:controlView.timeLineInfo];
    }
}

- (void)controlViewDidClickComment:(GKDYVideoControlView *)controlView {
    if ([self.delegate respondsToSelector:@selector(videoView:didClickComment:)]) {
        [self.delegate videoView:self didClickComment:controlView.timeLineInfo];
    }
}

- (void)controlViewDidClickShare:(GKDYVideoControlView *)controlView {
    if ([self.delegate respondsToSelector:@selector(videoView:didClickShare:)]) {
        [self.delegate videoView:self didClickShare:controlView.timeLineInfo];
    }
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        
        [_scrollView addSubview:self.topView];
        [_scrollView addSubview:self.ctrView];
        [_scrollView addSubview:self.btmView];
        _scrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 3);
        
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (GKDYVideoControlView *)topView {
    if (!_topView) {
        _topView = [GKDYVideoControlView new];
        _topView.hidden = YES;
    }
    return _topView;
}

- (GKDYVideoControlView *)ctrView {
    if (!_ctrView) {
        _ctrView = [GKDYVideoControlView new];
        _ctrView.hidden = YES;
    }
    return _ctrView;
}

- (GKDYVideoControlView *)btmView {
    if (!_btmView) {
        _btmView = [GKDYVideoControlView new];
        _btmView.hidden = YES;
    }
    return _btmView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray new];
    }
    return _videos;
}
- (DZDYVideoPlayer *)player {
    if (!_player) {
        _player = [DZDYVideoPlayer new];
        _player.delegate = self;
    }
    return _player;
}
- (GKDYPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[GKDYPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panGesture.delegate = self;
        _panGesture.direction = GKDYPanGestureRecognizerDirectionVertical;
    }
    return _panGesture;
}

- (GKDoubleLikeView *)doubleLikeView {
    if (!_doubleLikeView) {
        _doubleLikeView = [GKDoubleLikeView new];
    }
    return _doubleLikeView;
}

@end
