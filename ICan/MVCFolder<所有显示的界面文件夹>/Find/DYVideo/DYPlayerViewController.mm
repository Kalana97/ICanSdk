//
/**
 - Copyright © 2020 dzl. All rights reserved.
 - Author: Created  by DZL on 11/8/2020
 - File name:  DYPlayerViewController.m
 - Description:
 - Function List:
 */


#import "DYPlayerViewController.h"
#import "GKSlidePopupView.h"
#import "GKDYCommentView.h"
#import "GKBallLoadingView.h"
#import "GKLikeView.h"
#import "FriendDetailViewController.h"
#import "TimelinesShareView.h"
#import "QDNavigationController.h"
#import "TimelinesDetailViewController.h"
#import "HJCActionSheet.h"
#import "ReportListTableViewController.h"
#import "TranspondTableViewController.h"
#import "VideoCacheManager.h"
#import "TimelineBrowseImageViewCollectionViewCell.h"
@interface DYPlayerViewController ()<GKDYVideoViewDelegate, UINavigationControllerDelegate,GKDYCommentViewDelegate,TimelinesShareViewDelegate,HJCActionSheetDelegate>
@property(nonatomic, strong)  UIButton              *backBtn;
@property(nonatomic, strong)  UIButton *moreButton;

@property(nonatomic, assign)  BOOL                  isRefreshing;

@property(nonatomic, strong)  GKBallLoadingView     *refreshLoadingView;
@property(nonatomic, strong)  NSArray               *videos;

@property(nonatomic, assign)  NSInteger             playIndex;

@property(nonatomic, strong)  GKSlidePopupView *slidePopupView;
@property(nonatomic, strong)  GKDYCommentView *commentView ;

@property(nonatomic, strong)  TimelinesShareView * timelinesShareView;
//提醒看的人
@property(nonatomic, strong)  NSMutableArray <UserMessageInfo *>* reminders;

@property (nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@property(nonatomic, strong)  NSArray *otherTitlesItems;
@property(nonatomic, strong)  TimelinesListDetailInfo *listDetailInfo;
@end

@implementation DYPlayerViewController

- (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index {
    if (self = [super init]) {
        self.videos = videos;
        self.playIndex = index;
        
        //        self.isPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoView];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(1.0f);
        make.top.equalTo(self.view).offset(StatusBarHeight);
        make.width.height.mas_equalTo(44.0f);
    }];
    [self.view addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-1.0f);
        make.top.equalTo(self.view).offset(StatusBarHeight);
        make.width.height.mas_equalTo(44.0f);
    }];
    [self.videoView setModels:self.videos index:self.playIndex];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.videoView resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 停止播放
    [self.videoView pause];
}

- (void)dealloc {
    ///这里导致了奔溃
    [self.videoView destoryPlayer];
    DDLogInfo(@"playerVC dealloc");
    
}
-(BOOL)preferredNavigationBarHidden{
    return YES;
}
-(BOOL)forceEnableInteractivePopGestureRecognizer{
    return YES;
}
#pragma mark - GKDYVideoViewDelegate
- (void)videoView:(GKDYVideoView *)videoView didClickIcon:(TimelinesListDetailInfo *)videoModel {
    FriendDetailViewController * vc = [FriendDetailViewController new];
    vc.userId = videoModel.belongsId;
    vc.friendDetailType=FriendDetailType_push;
    [self.navigationController pushViewController:vc animated:YES];
}
/** 点击了点赞按钮 */
- (void)videoView:(GKDYVideoView *)videoView didClickPraise:(TimelinesListDetailInfo *)videoModel {
    TimelinesListDetailInfo *model = videoModel;
    model.love = !model.love;
    NSInteger agreeNum = model.loveNum;
    
    if (model.love) {
        model.loveNum = agreeNum + 1;
    }else {
        model.loveNum = agreeNum - 1;
    }
    videoView.currentPlayView.timeLineInfo = model;
    [self interactiveRequestWith:model];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(operationTimeline:)]) {
        [self.delegate operationTimeline:model];
    }
}
/** 点击了评论按钮 */
- (void)videoView:(GKDYVideoView *)videoView didClickComment:(TimelinesListDetailInfo *)videoModel {
    self.commentView.timelinesListDetailInfo=videoModel;
    [self.commentView removeAllData];
    [self.slidePopupView showFrom:self.view completion:^{
        [self.commentView requestData];
    }];
}
- (void)videoView:(GKDYVideoView *)videoView didClickShare:(TimelinesListDetailInfo *)videoModel{
    self.commentView.timelinesListDetailInfo=videoModel;
    [self.timelinesShareView showTimelinesShareView];
}
-(void)videoView:(GKDYVideoView *)videoView didClickNameLabel:(TimelinesListDetailInfo *)videoModel{
    TimelinesDetailViewController * vc = [TimelinesDetailViewController new];
    vc.messageId = videoModel.ID;
    vc.timelinesListDetailInfo=videoModel;
    vc.tapCommentButton=NO;
    vc.deleteMessageSuccessBlock = ^(TimelinesListDetailInfo * _Nonnull timelineDetailInfo) {
        
    };
    vc.shareSuccessBlock = ^(TimelinesListDetailInfo * _Nonnull timelineDetailInfo) {
        
    };
    vc.operateBlock = ^(TimelinesListDetailInfo * _Nonnull timelineDetailInfo) {
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - GKDYCommentViewDelegate
-(void)gkDYCommentViewDeleteCommentInfoWithtimelinesListDetailInfo:(TimelinesListDetailInfo *)timelinesListDetailInfo{
    self.videoView.currentPlayView.timeLineInfo=timelinesListDetailInfo;
    self.listDetailInfo=timelinesListDetailInfo;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(operationTimeline:)]) {
        [self.delegate operationTimeline:timelinesListDetailInfo];
    }
}

-(GKSlidePopupView *)slidePopupView{
    if (!_slidePopupView) {
        _slidePopupView=[GKSlidePopupView popupViewWithFrame:[UIScreen mainScreen].bounds contentView:self.commentView];
    }
    return _slidePopupView;
}
-(GKDYCommentView *)commentView{
    if (!_commentView) {
        _commentView=[GKDYCommentView new];
        _commentView.frame = CGRectMake(0, 0, ScreenWidth, KHeightRatio(440));
        _commentView.delegate=self;
        @weakify(self);
        _commentView.hiddenBlock = ^{
            @strongify(self);
            [self.slidePopupView dismiss];
        };
    }
    return _commentView;
}

- (void)videoView:(GKDYVideoView *)videoView didScrollIsCritical:(BOOL)isCritical {
    
}

- (void)videoView:(GKDYVideoView *)videoView didPanWithDistance:(CGFloat)distance isEnd:(BOOL)isEnd {
    if (self.isRefreshing) return;
    
    //    if (isEnd) {
    //        [UIView animateWithDuration:0.25 animations:^{
    //            CGRect frame = self.titleView.frame;
    //            frame.origin.y = kTitleViewY;
    //            self.titleView.frame = frame;
    //            self.refreshView.frame = frame;
    //
    //            CGRect loadingFrame = self.loadingBgView.frame;
    //            loadingFrame.origin.y = kTitleViewY;
    //            self.loadingBgView.frame = loadingFrame;
    //
    //            self.refreshView.alpha      = 0;
    //            self.titleView.alpha        = 1;
    //            self.loadingBgView.alpha    = 1;
    //        }];
    //
    //        if (distance >= 2 * kTransitionCenter) { // 刷新
    //            self.searchBtn.hidden = YES;
    //            [self.refreshLoadingView startLoading];
    //            self.isRefreshing = YES;
    //
    //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //                [self.refreshLoadingView stopLoading];
    //                self.loadingBgView.alpha = 0;
    //                self.searchBtn.hidden = NO;
    //                self.isRefreshing = NO;
    //            });
    //        }else {
    //            self.loadingBgView.alpha = 0;
    //        }
    //    }else {
    //        if (distance < 0) {
    //            self.refreshView.alpha = 0;
    //            self.titleView.alpha = 1;
    //        }else if (distance > 0 && distance < kTransitionCenter) {
    //            CGFloat alpha = distance / kTransitionCenter;
    //
    //            self.refreshView.alpha      = 0;
    //            self.titleView.alpha        = 1 - alpha;
    //            self.loadingBgView.alpha    = 0;
    //
    //            // 位置改变
    //            CGRect frame = self.titleView.frame;
    //            frame.origin.y = kTitleViewY + distance;
    //            self.titleView.frame = frame;
    //            self.refreshView.frame = frame;
    //
    //            CGRect loadingFrame = self.loadingBgView.frame;
    //            loadingFrame.origin.y = frame.origin.y;
    //            self.loadingBgView.frame = loadingFrame;
    //        }else if (distance >= kTransitionCenter && distance <= 2 * kTransitionCenter) {
    //            CGFloat alpha = (2 * kTransitionCenter - distance) / kTransitionCenter;
    //
    //            self.refreshView.alpha      = 1 - alpha;
    //            self.titleView.alpha        = 0;
    //            self.loadingBgView.alpha    = 1 - alpha;
    //
    //            // 位置改变
    //            CGRect frame = self.titleView.frame;
    //            frame.origin.y = kTitleViewY + distance;
    //            self.titleView.frame    = frame;
    //            self.refreshView.frame  = frame;
    //
    //            CGRect loadingFrame = self.loadingBgView.frame;
    //            loadingFrame.origin.y = frame.origin.y;
    //            self.loadingBgView.frame = loadingFrame;
    //
    //            [self.refreshLoadingView startLoadingWithProgress:(1 - alpha)];
    //        }else {
    //            self.titleView.alpha    = 0;
    //            self.refreshView.alpha  = 1;
    //            self.loadingBgView.alpha = 1;
    //            [self.refreshLoadingView startLoadingWithProgress:1];
    //        }
    //    }
}

//点击分享按钮
-(void)timelinesShareViewShareAction{
    [self shareTimelinesRequest];
}

#pragma mark - 懒加载
-(TimelinesShareView *)timelinesShareView{
    if (!_timelinesShareView) {
        _timelinesShareView=[[TimelinesShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _timelinesShareView.delegate = self;
        
    }
    
    return _timelinesShareView;
}
- (GKDYVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[GKDYVideoView alloc] initWithVC:self isPushed:NO];
        _videoView.delegate = self;
        _videoView.timelineType=self.timelineType;
        _videoView.currentIndex=self.currentIndex;
    }
    return _videoView;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton new];
        [_moreButton setImage:[UIImage imageNamed:@"icon_timeline_video_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
- (void)moreButtonClick{
    if ([self.videoView.currentPlayView.timeLineInfo.visibleRange isEqualToString:@"Open"]) {
        self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.forward" icanlocalized:@"转发"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"],@"Save".icanlocalized];
    }else{
        self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"],@"Save".icanlocalized];
    }
    
    self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.otherTitlesItems];
    [self.hjcActionSheet show];
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString*title=[self.otherTitlesItems objectAtIndex:buttonIndex-1];
    if ([title isEqualToString:[@"timeline.post.operation.forward" icanlocalized:@"转发"]]) {
        //分享
        [self.timelinesShareView showTimelinesShareView];
    }else if ([title isEqualToString:[@"timeline.post.operation.favorite" icanlocalized:@"收藏"]]){
        [self collectionMes];
    }else if ([title isEqualToString:[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"]]){
        [self sendTimelineToChatView];
    }else if ([title isEqualToString:[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]]){
        ReportListTableViewController*vc=[[ReportListTableViewController alloc]init];
        vc.timelineId=self.videoView.currentPlayView.timeLineInfo.ID;
        vc.type=@"TimeLine";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"Save".icanlocalized]){//保存
        [self saveAction];
    }else if ([title isEqualToString:[@"timeline.post.operation.setVisibleRange" icanlocalized:@"设置可见范围"]]){

    }
}
-(void)saveAction{
    TimelinesListDetailInfo*info=self.videoView.currentPlayView.timeLineInfo;
    if (info.videoUrl.length>0) {
        NSString*cachePath=[[VideoCacheManager sharedCacheManager]diskCachePathForKey:info.videoUrl];
        if ([DZFileManager fileIsExistOfPath:cachePath]) {
            NSError *error;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:cachePath]];
                if (error) {
                    DDLogInfo(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Save Sucess",保存成功) inView:nil];
                    });
                }
                DDLogInfo(@"%@",error);
            } error:&error];
        }else{
            [QMUITipsTool showLoadingWihtMessage:@"Saving, please wait" inView:self.view isAutoHidden:NO];
            [[NetworkRequestManager shareManager]downloadVideoWithUrl:info.videoUrl success:^(NSURL *url) {
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
            } failure:^(NSError *failure) {
                
            }];
        }
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger index=self.videoView.currentPlayView.timelineBrowseView.selectIndex;
            TimelineBrowseImageViewCollectionViewCell*cell=(TimelineBrowseImageViewCollectionViewCell*)[self.videoView.currentPlayView.timelineBrowseView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:cell.topImageVIew.image];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [QMUITipsTool showOnlyTextWithMessage:NSLocalizedString(@"Save Sucess",保存成功) inView:nil];
                    });
                   
                }
            }];
        });
        
    }
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"icon_nav_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (void)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//点赞
-(void)interactiveRequestWith:(TimelinesListDetailInfo *)info{
    TimelinesInteractiveRequest * request = [TimelinesInteractiveRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/interactive",request.baseUrlString,info.ID];
    request.parameters =@"Love";
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
    
}
//分享帖子
-(void)shareTimelinesRequest{
    SendTimelinesRequest * request =[SendTimelinesRequest request];
    if (self.videoView.currentPlayView.timeLineInfo.sharedMessage) {
        request.sharedId = self.videoView.currentPlayView.timeLineInfo.sharedMessage.ID;
        request.forwardId=self.videoView.currentPlayView.timeLineInfo.ID;
    }else{
        request.sharedId = self.videoView.currentPlayView.timeLineInfo.ID;
    }
    request.visibleRange = @"Open";
    if (self.videoView.currentPlayView.timeLineInfo.videoUrl) {
        request.videoUrl = self.videoView.currentPlayView.timeLineInfo.videoUrl;
    }
    
    if (self.videoView.currentPlayView.timeLineInfo.imageUrls.count>0) {
        request.imageUrls = self.videoView.currentPlayView.timeLineInfo.imageUrls;
    }
    if (self.videoView.currentPlayView.timeLineInfo.location) {
        request.location = self.videoView.currentPlayView.timeLineInfo.location;
    }
    if([[self.timelinesShareView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]!=0) {
        request.content = self.timelinesShareView.textView.text;
    }
    if (self.timelinesShareView.reminders.count>0) {
        NSMutableArray * extArray = [NSMutableArray array];
        NSMutableArray * reminderArray  = [NSMutableArray array];
        for (UserMessageInfo * user in self.reminders) {
            NSMutableDictionary * extDic = [[NSMutableDictionary alloc]init];
            [extDic setObject:user.nickname forKey:@"v"];
            [extDic setObject:user.userId forKey:@"k"];
            [extArray addObject:extDic];
            [reminderArray addObject:user.userId];
        }
        request.ext = [extArray mj_JSONString];
        request.reminders = (NSArray *)reminderArray;
    }
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [self.reminders removeAllObjects];
        self.timelinesShareView.textView.text = @"";
        [self.timelinesShareView hiddenTimelinesShareView];
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Sharing success", 分享成功) inView:self.view];
        if (self.shareSuccessBlock) {
            self.shareSuccessBlock(self.videoView.currentPlayView.timeLineInfo);
        }
        //重新获取数据
        [self.commentView fetchTimelinesDetailRequest];
        
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

-(void)collectionMes{
    CollectionRequest * request = [CollectionRequest request];
    request.favoriteType =@"TimeLine";
    request.busId = self.videoView.currentPlayView.timeLineInfo.ID;
    request.originUserId = self.videoView.currentPlayView.timeLineInfo.belongsId;
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"Added".icanlocalized inView:self.view];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

-(void)sendTimelineToChatView{
    TranspondTableViewController*vc=[[TranspondTableViewController alloc]init];
    vc.transpondType=TranspondType_Time;
    ChatPostShareMessageInfo*shareGoodsInfo=[[ChatPostShareMessageInfo alloc]init];
    shareGoodsInfo.postId=[self.videoView.currentPlayView.timeLineInfo.ID intValue];
    shareGoodsInfo.videoUrl=self.videoView.currentPlayView.timeLineInfo.videoUrl;
    shareGoodsInfo.content=self.videoView.currentPlayView.timeLineInfo.content;
    shareGoodsInfo.avatarUrl=self.videoView.currentPlayView.timeLineInfo.headImgUrl;
    shareGoodsInfo.imageUrls=self.videoView.currentPlayView.timeLineInfo.imageUrls;
    shareGoodsInfo.nickName=self.videoView.currentPlayView.timeLineInfo.nickName;
    vc.chatPostShareMessageInfo=shareGoodsInfo;
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
@end
