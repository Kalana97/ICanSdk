//
//  TimelinesViewShareMoreViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/17.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TypeTimelinesViewController.h"
#import "TimelinesViewController.h"
#import "PostMessageViewController.h"
#import "YBImageBrowerTool.h"
#import "HJCActionSheet.h"
#import "TimelinesDetailViewController.h"
#import "MessageNotificationListViewController.h"
#import "TimelinesShareView.h"
#import "QDNavigationController.h"
#import "TimelinePlayVideoTool.h"
#import "ReportListTableViewController.h"
#import "XMFaceManager.h"
#import "DYPlayerViewController.h"
#import "TranspondTableViewController.h"
#import "PostMessageLimitViewController.h"
#import "UIViewController+Extension.h"
#import "VideoCacheManager.h"
#import "TimelinesContentTableViewCell.h"
#import "TimelinesContentVideoTableViewCell.h"
@interface TypeTimelinesViewController ()<HJCActionSheetDelegate,TimelinesShareViewDelegate,DYPlayerViewControllerDelegate>

@property(nonatomic,strong)  YBImageBrowerTool *ybImageBrowerTool;
@property(nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@property(nonatomic,strong)  TimelinesListDetailInfo * listDetailInfo;
@property(nonatomic,strong)  NSMutableArray <UserMessageInfo *>* reminders;//提醒看的人
@property(nonatomic,strong)  TimelinesShareView * timelinesShareView;
/** 当前正在播放的cell */
@property(nonatomic,strong)  TimelinesContentVideoTableViewCell *currentPlayingVideoCell;
@property(nonatomic,strong)  TimelinesListDetailInfo * currentPlayDetailInfo;
@property(nonatomic,strong)  UIButton *rightBtn;
@property(nonatomic,strong)  NSArray *otherTitlesItems;
@end

@implementation TypeTimelinesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.timelineType) {
        case TimelineType_UserAll:
            self.title = [NSString stringWithFormat:@"%@%@",self.usermessageInfo.remarkName?:self.usermessageInfo.nickname,@"’s post".icanlocalized];
            break;
        case TimelineType_find:{
//            friend.detail.listCell.Moments朋友圈
            self.title =@"friend.detail.listCell.Moments".icanlocalized;
            self.rightBtn=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:0 titleColor:nil target:self action:@selector(postMessage)];
            self.rightBtn.frame=CGRectMake(0, 0, 30, 30);
            [self.rightBtn setBackgroundImage:UIImageMake(@"icon_timeline_add") forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
        }
            break;
        case TimelineType_openText:
            self.title =@"TimelineView.share".icanlocalized;
            self.rightBtn=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:0 titleColor:nil target:self action:@selector(postMessage)];
            self.rightBtn.frame=CGRectMake(0, 0, 30, 30);
            [self.rightBtn setBackgroundImage:UIImageMake(@"icon_timeline_add") forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
            break;
        case TimelineType_openVideo:
            self.title =@"chatView.function.video".icanlocalized;
            self.rightBtn=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:0 titleColor:nil target:self action:@selector(postMessage)];
            self.rightBtn.frame=CGRectMake(0, 0, 30, 30);
            [self.rightBtn setBackgroundImage:UIImageMake(@"icon_timeline_add") forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
            break;
        case TimelineType_video:
            self.title =@"chatView.function.video".icanlocalized;
            break;
        default:
            break;
    }
    [self refreshList];
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //当高于2*1024M的数据进行清理，并且保留1*1024M的最新的数据
    if ([VideoCacheManager sharedCacheManager].calculationDiskCache >2*1024) {
        [[VideoCacheManager sharedCacheManager] clearDiskCacheWihtRetain:1*1024];
    }
}
-(void)postMessage{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
    switch (self.timelineType) {
        case TimelineType_UserAll:
            break;
        case TimelineType_find:{
            self.title =[@"friend.detail.listCell.Moments" icanlocalized:@"朋友圈"];
            [self pushToPossMessageVcWith:TimeLinesFriendCrile];
        }
            break;
        case TimelineType_openText:
            self.title =@"TimelineView.share".icanlocalized;
            [self pushToPossMessageVcWith:TimelinesShare];
            break;
        case TimelineType_openVideo:
            self.title =@"chatView.function.video".icanlocalized;
            [self pushToPossMessageVcWith:TimelinesVideo];
            break;
        case TimelineType_video:
            self.title =@"chatView.function.video".icanlocalized;
            break;
        default:
            break;
    }
   
}
-(void)dealloc{
    [[TimelinePlayVideoTool shareSingle]removeTimelinePlayVideo];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    if (self.currentPlayingVideoCell) {
        [[TimelinePlayVideoTool shareSingle].player pause];
        [self.currentPlayingVideoCell resumePlay];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KStartPlayVideoOrAudioNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KStopPlayVideoOrAudioNotification object:nil];
}
-(void)stopPlay{
    if (self.currentPlayingVideoCell) {
        [[TimelinePlayVideoTool shareSingle].player pause];
    }
}
-(void)startPlay{
    if (self.currentPlayingVideoCell) {
        [[TimelinePlayVideoTool shareSingle].player play];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self removeVcWithArray:@[@"PostMessageViewController"]];
    if (self.currentPlayingVideoCell) {
        [self.currentPlayingVideoCell resumePlay];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.currentPlayingVideoCell) {
        [[TimelinePlayVideoTool shareSingle].player play];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopPlay) name:KStopPlayVideoOrAudioNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startPlay) name:KStartPlayVideoOrAudioNotification object:nil];
}
-(void)initTableView{
    [super initTableView];
    //加了这两句缓解了屏幕闪动的问题，猪嗨哥你别删了
    self.tableView.estimatedSectionFooterHeight =0.01;
    self.tableView.estimatedSectionHeaderHeight = 0;
   
    [self.tableView registNibWithNibName:KTimelinesContentTableViewCell];
    [self.tableView registNibWithNibName:KTimelinesContentVideoTableViewCell];
}
-(void)showHjcActionSheetWith:(BOOL) isBlongMyself timelinesListDetailInfo:(TimelinesListDetailInfo *)listDetailInfo{
    self.listDetailInfo = listDetailInfo;
    switch (self.timelineType) {
        case TimelineType_UserAll:{
            if (isBlongMyself) {
                if ([self.listDetailInfo.visibleRange isEqualToString:@"Open"]) {
                    self.otherTitlesItems=@[ [@"timeline.post.operation.forward" icanlocalized:@"转发"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }else{
                    self.otherTitlesItems=@[[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }
               
                self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.otherTitlesItems];
                [self.hjcActionSheet show];
                
            }else{
                if ([self.listDetailInfo.visibleRange isEqualToString:@"Open"]) {
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],  [@"timeline.post.operation.forward" icanlocalized:@"转发"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }else{
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }
                
                self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.otherTitlesItems];
                [self.hjcActionSheet show];
                
            }
        }
            break;
        case  TimelineType_find:{
            if (isBlongMyself) {
                if ([self.listDetailInfo.visibleRange isEqualToString:@"Open"]) {
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"], [@"timeline.post.operation.forward" icanlocalized:@"转发"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }else{
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.setVisibleRange" icanlocalized:@"设置可见范围"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }
                
            }else{
                if ([self.listDetailInfo.visibleRange isEqualToString:@"Open"]) {
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"], [@"timeline.post.operation.forward" icanlocalized:@"转发"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }else{
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }
                
            }
            self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.otherTitlesItems];
            [self.hjcActionSheet show];
        }
            break;
        case TimelineType_openText:
        case TimelineType_video:
        case TimelineType_openVideo:{
            if (isBlongMyself) {
                if ([self.listDetailInfo.visibleRange isEqualToString:@"Open"]) {
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"], [@"timeline.post.operation.forward" icanlocalized:@"转发"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }else{
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }
                
                self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.otherTitlesItems];
                [self.hjcActionSheet show];
                
            }else{
                if ([self.listDetailInfo.visibleRange isEqualToString:@"Open"]) {
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"], [@"timeline.post.operation.forward" icanlocalized:@"转发"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }else{
                    self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
                }
                
                self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.otherTitlesItems];
                [self.hjcActionSheet show];
                
            }
        }
            break;
        default:
            break;
    }
   
    
}
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString*title=[self.otherTitlesItems objectAtIndex:buttonIndex-1];
    if ([title isEqualToString: [@"timeline.post.operation.forward" icanlocalized:@"转发"]]) {
        //分享
        [self.timelinesShareView showTimelinesShareView];
    }else if ([title isEqualToString:[@"timeline.post.operation.favorite" icanlocalized:@"收藏"]]){
        [self collectionMes];
    }else if ([title isEqualToString:[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"]]){
        [self sendTimelineToChatView];
    }else if ([title isEqualToString:[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]]){
        ReportListTableViewController*vc=[[ReportListTableViewController alloc]init];
        vc.timelineId=self.listDetailInfo.ID;
        vc.type=@"TimeLine";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:[@"timeline.post.operation.delete" icanlocalized:@"删除"]]){
        [self fetchDeteleTimelinesRequest];
    }else if ([title isEqualToString:[@"timeline.post.operation.setVisibleRange" icanlocalized:@"设置可见范围"]]){
        PostMessageLimitViewController * vc =[PostMessageLimitViewController new];
        vc.timelinesListDetailInfo=self.listDetailInfo;
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle =  UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
-(void)sendTimelineToChatView{
    TranspondTableViewController*vc=[[TranspondTableViewController alloc]init];
    vc.transpondType=TranspondType_Time;
    ChatPostShareMessageInfo*shareGoodsInfo=[[ChatPostShareMessageInfo alloc]init];
    shareGoodsInfo.postId=[self.listDetailInfo.ID intValue];
    shareGoodsInfo.videoUrl=self.listDetailInfo.videoUrl;
    shareGoodsInfo.content=self.listDetailInfo.content;
    shareGoodsInfo.avatarUrl=self.listDetailInfo.headImgUrl;
    shareGoodsInfo.imageUrls=self.listDetailInfo.imageUrls;
    shareGoodsInfo.nickName=self.listDetailInfo.nickName;
    vc.chatPostShareMessageInfo=shareGoodsInfo;
    QDNavigationController*nav=[[QDNavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)handleLoveAndComnontShareWith:(TimelinesListDetailInfo *)responseInfo index:(NSInteger)index indexPath:(NSIndexPath *)indexPath{
    if (index==0) {
        //赞
        [self interactiveRequestWith:responseInfo indexPath:indexPath];
    }else if (index==1){
        //评论
        [self pushTimelinesDetailViewControllerWith:responseInfo tapCommemt:YES];
    }else{
        //分享
        self.listDetailInfo = responseInfo;
        [self.timelinesShareView showTimelinesShareView];
    }
    
}
-(void)pushTimelinesDetailViewControllerWith:(TimelinesListDetailInfo*)info tapCommemt:(BOOL)tapCommemt{
    TimelinesDetailViewController * vc = [TimelinesDetailViewController new];
    vc.messageId = info.ID;
    vc.timelinesListDetailInfo=info;
    vc.tapCommentButton=tapCommemt;
    vc.deleteMessageSuccessBlock = ^(TimelinesListDetailInfo * _Nonnull timelineDetailInfo) {
        [self.listItems removeObject:timelineDetailInfo];
        [self.tableView reloadData];
    };
    vc.shareSuccessBlock = ^(TimelinesListDetailInfo * _Nonnull timelineDetailInfo) {
        [self refreshList];
    };
    vc.operateBlock = ^(TimelinesListDetailInfo * _Nonnull timelineDetailInfo) {
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)pushDYPlayerView:(TimelinesListDetailInfo*)responseInfo{
    
    DYPlayerViewController*vc=[[DYPlayerViewController alloc]initWithVideos:self.listItems index:[self.listItems indexOfObject:responseInfo]];
    vc.shareSuccessBlock = ^(TimelinesListDetailInfo * _Nonnull timelineDetailInfo) {
        [self refreshList];
    };
    vc.timelineType=self.timelineType;
    vc.currentIndex=self.current;
    vc.detailInfo=responseInfo;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimelinesListDetailInfo * dresponseInfo =[self.listItems objectAtIndex:indexPath.section];
    if (dresponseInfo.imageUrls.count==1&&dresponseInfo.videoUrl) {
        TimelinesContentVideoTableViewCell * videoCell = [tableView dequeueReusableCellWithIdentifier:KTimelinesContentVideoTableViewCell];
        videoCell.listRespon = dresponseInfo;
        videoCell.contentView.backgroundColor =  [UIColor qmui_colorWithHexString:@"#F8F8F8"];
        videoCell.lookPictureBlock = ^(NSInteger index) {
            if (videoCell == self.currentPlayingVideoCell) {
                [self pushDYPlayerView:dresponseInfo];
            }else{
                [[TimelinePlayVideoTool shareSingle].player pause];
                [self pushDYPlayerView:dresponseInfo];
            }
        };
        videoCell.topRightBlock = ^{
            if ([dresponseInfo.belongsId isEqualToString:[UserInfoManager sharedManager].userId]) {
                [self showHjcActionSheetWith:YES timelinesListDetailInfo:dresponseInfo];
            }else{
                [self showHjcActionSheetWith:NO timelinesListDetailInfo:dresponseInfo];
            }
        };
        videoCell.tapBlock = ^(NSInteger index) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
            [self handleLoveAndComnontShareWith:dresponseInfo index:index indexPath:indexPath];
            
        };
        return videoCell;
    }
    TimelinesContentTableViewCell * tcell = [tableView dequeueReusableCellWithIdentifier:KTimelinesContentTableViewCell];
    tcell.listRespon = dresponseInfo;
    tcell.contentView.backgroundColor =  [UIColor qmui_colorWithHexString:@"#F8F8F8"];
    tcell.lookPictureBlock = ^(NSInteger index) {
        [self pushDYPlayerView:dresponseInfo];
        
    };
    tcell.topRightBlock = ^{
        if ([dresponseInfo.belongsId isEqualToString:[UserInfoManager sharedManager].userId]) {
            [self showHjcActionSheetWith:YES timelinesListDetailInfo:dresponseInfo];
        }else{
            [self showHjcActionSheetWith:NO timelinesListDetailInfo:dresponseInfo];
        }
    };
    tcell.tapBlock = ^(NSInteger index) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
        [self handleLoveAndComnontShareWith:dresponseInfo index:index indexPath:indexPath];
        
    };
    return tcell;
}
/** 操作点赞分享之后 刷新界面 */
-(void)operationTimeline:(TimelinesListDetailInfo *)timelinesListDetailInfo{
    for (int i=0; i<self.listItems.count; i++) {
        TimelinesListDetailInfo * responseInfo =[self.listItems objectAtIndex:i];
        if ([responseInfo.ID isEqualToString:timelinesListDetailInfo.ID]) {
            responseInfo.love=timelinesListDetailInfo.love;
            responseInfo.loveNum=timelinesListDetailInfo.loveNum;
            responseInfo.commentNum=timelinesListDetailInfo.commentNum;
            responseInfo.forwardNum=timelinesListDetailInfo.forwardNum;
            responseInfo.comment=timelinesListDetailInfo.comment;
            TimelinesContentTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:i]];
            cell.listRespon=responseInfo;
            break;
        }
    }
    
}

-(void)didSelectTimelinesShareItemsIndex:(NSInteger)index timelinesListDetailInfo:(TimelinesListDetailInfo *)timelinesListDetailInfo{
    [self pushTimelinesDetailViewControllerWith:timelinesListDetailInfo tapCommemt:NO];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listItems.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F8F8F8"];;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?CGFLOAT_MIN:10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section!=0&&indexPath.row==0) {
        TimelinesListDetailInfo* info=[self.listItems objectAtIndex:indexPath.section];
        [self pushTimelinesDetailViewControllerWith:info tapCommemt:NO];
    }
}

//点击查看照片
-(void)showPhotoWithIndex:(NSInteger)index images:(NSArray *)images{
    [self.ybImageBrowerTool showTimelinsNetWorkImageBrowerWithCurrentIndex:index imageItems:images];
}

-(void)pushToPossMessageVcWith:(PostMessageType)type{
    PostMessageViewController * vc = [PostMessageViewController new];
    vc.postMessageSucessBlock = ^{
        self.current=0;
        [self fetchListRequest];
        
    };
    vc.postMessageType = type;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


-(YBImageBrowerTool *)ybImageBrowerTool{
    if (!_ybImageBrowerTool) {
        _ybImageBrowerTool = [[YBImageBrowerTool alloc]init];
    }
    return _ybImageBrowerTool;
}

-(NSMutableArray *)reminders{
    if (!_reminders) {
        _reminders = [NSMutableArray array];
    }
    
    return _reminders;
}

-(TimelinesShareView *)timelinesShareView{
    if (!_timelinesShareView) {
        _timelinesShareView=[[TimelinesShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _timelinesShareView.delegate = self;
        
    }
    
    return _timelinesShareView;
}


//点击分享按钮
-(void)timelinesShareViewShareAction{
    [self shareTimelinesRequest];
}


-(void)fetchListRequest{
    switch (self.timelineType) {
        case TimelineType_find:
            [self fetTimelineListRequest];
            [UserInfoManager sharedManager].lookTimelineTime=[NSString stringWithFormat:@"%.f",[[NSDate date]timeIntervalSince1970]*1000];
            break;
        case TimelineType_UserAll:
            [self fetUserAllTimelineRequest];
            break;;
        case TimelineType_openVideo:
            [self fetchAllVideoRequest];
//            [self fetchTimelineOpenRequest:YES all:NO];
            break;
        case TimelineType_openText:{
            [self fetchTimelineOpenRequest:NO all:NO];
        }
            break;
        case TimelineType_video:{
            [self fetchAllVideoRequest];
        }
            break;
        default:
            break;
    }
    
}
-(void)fetchAllVideoRequest{
    GetTimelinesAllVideoRequest *request = [GetTimelinesAllVideoRequest request];
    request.size=@(10);
    request.page=@(self.current);
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimeLinesNonDynamicListInfo class] contentClass:[TimeLinesNonDynamicListInfo class] success:^(TimeLinesNonDynamicListInfo *response) {
        @strongify(self);
        self.listInfo = response;
        if (self.current==0) {
            self.listItems = [NSMutableArray arrayWithArray:response.content];
        }else{
            [self.listItems addObjectsFromArray:response.content];
        }
        for (TimelinesListDetailInfo *  detailInfo  in response.content) {
            [detailInfo cacheCellHeightWith];
            if (detailInfo.videoUrl.length >0) {
                [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:detailInfo.videoUrl cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
                }];
            }
        }
        [self checkHasFooter];
        [self endingRefresh];
        [self.tableView reloadData];
        if (self.current==0) {
            [self handleScroll];
        }
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        [self endingRefresh];
    }];
}
/**
 获取某个用户的朋友圈
 */
-(void)fetUserAllTimelineRequest{
    UserAllTimeLinesRequest *request = [UserAllTimeLinesRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/all",request.baseUrlString,self.userId];
    request.size=@(30);
    request.page=@(self.current);
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimeLinesNonDynamicListInfo class] contentClass:[TimeLinesNonDynamicListInfo class] success:^(TimeLinesNonDynamicListInfo *response) {
        @strongify(self);
        self.listInfo=response;
        if (self.current==0) {
            self.listItems=[NSMutableArray arrayWithArray:response.content];
            if (response.content.count==0) {
                [self showEmptyViewWithText:@"Friends have not opened Moments".icanlocalized detailText:nil buttonTitle:nil buttonAction:nil];
            }else{
                [self hideEmptyView];
            }
        }else{
            [self.listItems addObjectsFromArray:response.content];
        }
        for (TimelinesListDetailInfo *  detailInfo  in response.content) {
            [detailInfo cacheCellHeightWith];
            if (detailInfo.videoUrl.length >0) {
                [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:detailInfo.videoUrl cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
                }];
            }
        }
        [self checkHasFooter];
        [self endingRefresh];
        [self.tableView reloadData];
        if (self.current==0) {
            [self handleScroll];
        }
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        [self endingRefresh];
    }];
}
-(void)fetTimelineListRequest{
    TimelinesListRequest *request = [TimelinesListRequest request];
    request.size=@(10);
    request.page=@(self.current);
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimeLinesNonDynamicListInfo class] contentClass:[TimeLinesNonDynamicListInfo class] success:^(TimeLinesNonDynamicListInfo *response) {
        @strongify(self);
        self.listInfo=response;
        if (self.current==0) {
            self.listItems=[NSMutableArray arrayWithArray:response.content];
            
        }else{
            [self.listItems addObjectsFromArray:response.content];
        }
        for (TimelinesListDetailInfo *detailInfo  in response.content) {
            [detailInfo cacheCellHeightWith];
            if (detailInfo.videoUrl.length >0) {
                [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:detailInfo.videoUrl cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
                }];
            }
        }
        [self checkHasFooter];
        [self endingRefresh];
        [self.tableView reloadData];
        if (self.current==0) {
            [self handleScroll];
        }
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        [self endingRefresh];
    }];
}
-(void)fetchTimelineOpenRequest:(BOOL)isVideo all:(BOOL)all{
    TimeLinesOpenRequest *request = [TimeLinesOpenRequest request];
    request.size=@(100);
    request.page=@(self.current);
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
        self.listInfo=response;
        NSMutableArray *resInfo = [NSMutableArray array];
        for (TimelineContentInfo *detailInfo  in response.content) {
            if(detailInfo.timeLinePageVO != nil){
                [resInfo addObject:detailInfo.timeLinePageVO];
                [detailInfo.timeLinePageVO cacheCellHeightWith];
                if (detailInfo.timeLinePageVO.videoUrl.length >0) {
                    [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:detailInfo.timeLinePageVO.videoUrl cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
                    }];
                }
            }
        }
        if (self.current==0) {
            self.listItems=[NSMutableArray arrayWithArray:resInfo];
        }else{
            [self.listItems addObjectsFromArray:resInfo];
        }
        [self checkHasFooter];
        [self endingRefresh];
        [self.tableView reloadData];
        if (self.current==0) {
            [self handleScroll];
        }
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        [self endingRefresh];
    }];
}
-(void)interactiveRequestWith:(TimelinesListDetailInfo *)info indexPath:(NSIndexPath *)indexPath{
    TimelinesInteractiveRequest * request = [TimelinesInteractiveRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/interactive",request.baseUrlString,info.ID];
    request.parameters =@"Love";
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        TimelinesContentTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell clickLikeButtonAction];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
    
}

//删除帖子
-(void)fetchDeteleTimelinesRequest{
    DeleteTimelinesRequest * request = [DeleteTimelinesRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@",request.baseUrlString,self.listDetailInfo.ID];
    
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"DeleteSuccess".icanlocalized inView:self.view];
        [self .listItems removeObject:self.listDetailInfo];
        [self.tableView reloadData];
        [self handleScroll];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

//分享帖子
-(void)shareTimelinesRequest{
    
    SendTimelinesRequest * request =[SendTimelinesRequest request];
    if (self.listDetailInfo.sharedMessage) {
        request.sharedId = self.listDetailInfo.sharedMessage.ID;
        request.forwardId=self.listDetailInfo.ID;
    }else{
        request.sharedId = self.listDetailInfo.ID;
    }
    request.visibleRange = @"Open";
    if (self.listDetailInfo.videoUrl) {
        request.videoUrl = self.listDetailInfo.videoUrl;
    }
    
    if (self.listDetailInfo.imageUrls.count>0) {
        request.imageUrls = self.listDetailInfo.imageUrls;
    }
    
    if (self.listDetailInfo.location) {
        request.location = self.listDetailInfo.location;
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
        [self.timelinesShareView.reminders removeAllObjects];
        [self.reminders removeAllObjects];
        self.timelinesShareView.textView.text = @"";
        [self.timelinesShareView hiddenTimelinesShareView];
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Sharing success", 分享成功) inView:self.view];
        [self fetchListRequest];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
    
    
    
}

-(void)collectionMes{
    CollectionRequest * request = [CollectionRequest request];
    request.favoriteType =@"TimeLine";
    request.busId = self.listDetailInfo.ID;
    request.originUserId = self.listDetailInfo.belongsId;
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"Added".icanlocalized inView:self.view];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([UserInfoManager sharedManager].messageMenuView) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
    }
    
    if (self.currentPlayingVideoCell) {
        if (![self.tableView.visibleCells containsObject:self.currentPlayingVideoCell]) {
            [self.currentPlayingVideoCell stopPlay];
            self.currentPlayingVideoCell.playIcon.hidden=NO;
            self.currentPlayingVideoCell=nil;
        }
    }
   
    if (self.listItems.count >8) {
        CGFloat bottomCellOffset = [self.tableView rectForSection:self.listItems.count-8].origin.y - NavBarHeight;
        if (scrollView.contentOffset.y >= bottomCellOffset) {
            if (!self.isLoadMoreData) {
                self.isLoadMoreData = YES;
                [self loadMore];
            }
        }
    }
    
}
// 松手时已经静止,只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO) { // scrollView已经完全静止
        [self handleScroll];
    }
}
// 松手时还在运动, 先调用scrollViewDidEndDragging,在调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // scrollView已经完全静止
    [self handleScroll];
}
-(void)handleScroll{
    TimelinesContentVideoTableViewCell *finnalCell = nil;
    TimelinesListDetailInfo*lastInfo=nil;
    for (TimelinesContentVideoTableViewCell* videoCell in [self.tableView visibleCells]) {
        TimelinesListDetailInfo*currenInfo =videoCell.listRespon;
        if (currenInfo.imageUrls.count == 1 &&currenInfo.videoUrl) {
            CGRect rect = [videoCell.firstImageView convertRect:videoCell.firstImageView.frame toView:kKeyWindow];
            //CGRectIntersection获取两个frame的交集
            CGRect rectIntersection = CGRectIntersection( CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-TabBarHeight), rect);
            if (rectIntersection.size.height == rect.size.height ) {
                finnalCell = videoCell;
                lastInfo = finnalCell.listRespon;
            }
        }
        
    }
    // 注意, 如果正在播放的cell和finnalCell是同一个cell,由于cell的复用机制self.currentPlayingVideoCell一定等于finnalCell
    if (finnalCell != nil && self.currentPlayDetailInfo != lastInfo) {
        [self.currentPlayingVideoCell stopPlay];
        self.currentPlayingVideoCell = finnalCell;
        self.currentPlayDetailInfo=lastInfo;
        [self.currentPlayingVideoCell stopPlay];
        [self.currentPlayingVideoCell startPlay];
        return;
    }
    
}

@end
