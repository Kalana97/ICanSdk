//
//  TimelinesViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/4.
//  Copyright © 2020 dzl. All rights reserved.
//

#import "TimelinesViewController.h"
#import "TimelinesHeaderView.h"
#import "TimeLineRecommendTableViewCell.h"
#import "LoginViewController.h"
#import "PostMessageViewController.h"
#import "YBImageBrowerTool.h"
#import "HJCActionSheet.h"
#import "TimelinesDetailViewController.h"
#import "MessageNotificationListViewController.h"
#import "TimelinesShareView.h"
#import "QDNavigationController.h"
#import "PostMessageLimitViewController.h"
#import "ReportListTableViewController.h"
#import "XMFaceManager.h"
#import "DYPlayerViewController.h"
#import "TranspondTableViewController.h"
#import "TypeTimelinesViewController.h"
#import "ChatListMenuView.h"
#import "VideoCacheManager.h"
#import "QDTabBarViewController.h"
#import "TimelinesContentTableViewCell.h"
#import "TimelinesContentVideoTableViewCell.h"
#import "WCDBManager+TimeLineNotice.h"
#import "TimelinesDynamicMessageTableViewCell.h"
#ifdef ICANTYPE
#import "iCan_我行-Swift.h"
#else
#import "ICanCN-Swift.h"
#endif

@interface TimelinesViewController ()<HJCActionSheetDelegate,TimelinesShareViewDelegate,DYPlayerViewControllerDelegate>

@property(nonatomic,strong)  TimelinesHeaderView * headerView;
@property(nonatomic,strong)  YBImageBrowerTool *ybImageBrowerTool;
@property(nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@property(nonatomic,strong)  TimelinesListDetailInfo * listDetailInfo;
@property(nonatomic,strong)  NSMutableArray <UserMessageInfo *>* reminders;//提醒看的人
@property(nonatomic,strong)  TimelinesShareView * timelinesShareView;
@property(nonatomic, strong)  NSArray *recomItems;
@property(nonatomic, strong)  NSArray *nearItems;
/** 当前正在播放的cell */
@property(nonatomic, strong)  TimelinesContentVideoTableViewCell *currentPlayingVideoCell;
@property(nonatomic, strong)  TimelinesListDetailInfo * currentPlayDetailInfo;
@property(nonatomic, strong)  TimelineContentInfo * timelineContentInfo;
@property(nonatomic, strong)  NSArray *otherTitlesItems;

@property (nonatomic, strong) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navbarHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) NSUInteger selectedListItemID;
@end

@implementation TimelinesViewController

-(BOOL)preferredNavigationBarHidden{
    return YES;
}

-(void)updateNumber{
    NSArray*array=[[WCDBManager sharedManager]fetchAllUnReadTimeLineNoticeInfo];
    UITabBarItem *item = self.tabBarController.tabBar.items[2];
    item.qmui_badgeInteger = array.count;
    if (array.count >99) {
        item.qmui_badgeString =@"...";
    }
    self.numberLabel.hidden = array.count==0;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //当高于2*1024M的数据进行清理，并且保留1*1024M的最新的数据
    if ([VideoCacheManager sharedCacheManager].calculationDiskCache >2*1024) {
        [[VideoCacheManager sharedCacheManager] clearDiskCacheWihtRetain:1*1024];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"tabbar.share".icanlocalized;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTimelineSuccess:) name:KChangeTimelineSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shieldTimeLine:) name:kShieldTimeLineNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNickName) name:KUpdateUserMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNumber) name:kUpdateNoticeInfoNumberNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timelineVideoResumePlay) name:@"KTimelineVideoResumePlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateWebView:) name:@"Dynamic Message" object:nil];
    self.navbarHeight.constant = NavBarHeight;
    [self refreshList];
    [self fetchNearbyPeopleRequest];
    [self fetchUserRecommendRequest];
    [self updateNumber];
}
-(void)timelineVideoResumePlay{
    if (self.currentPlayingVideoCell) {
        [self.currentPlayingVideoCell resumePlay];
    }
    
}
-(void)changeNickName{
    self.titleLabel.text = [UserInfoManager sharedManager].nickname;
}
-(void)shieldTimeLine:(NSNotification*)notification{
    UserMessageInfo*info=(UserMessageInfo*)notification.object;
    NSMutableArray*array=[NSMutableArray array];
    for (id dinfo in self.listItems) {
        if ([dinfo isKindOfClass:[TimelineContentInfo class]]) {
            TimelineContentInfo *tInfo = (TimelineContentInfo *)dinfo;
            if (![info.userId isEqualToString:tInfo.timeLinePageVO.belongsId]) {
                [array addObject:tInfo.timeLinePageVO];
            }
        }else{
            [array addObject:dinfo];
        }
    }
    self.listItems=[NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //隐藏选择框
    if ([UserInfoManager sharedManager].messageMenuView) {
        [[UserInfoManager sharedManager].messageMenuView hiddenMessageMenuView];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KStartPlayVideoOrAudioNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KStopPlayVideoOrAudioNotification object:nil];
}

-(void)stopPlay{
    if (self.currentPlayingVideoCell) {
        
    }
}
-(void)startPlay{
    if (self.currentPlayingVideoCell) {
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.currentPlayingVideoCell) {
        
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopPlay) name:KStopPlayVideoOrAudioNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startPlay) name:KStartPlayVideoOrAudioNotification object:nil];
}
-(void)changeTimelineSuccess:(NSNotification*)notifi{
    TimelinesListDetailInfo *listDetail=notifi.object;
    for (int i=0; i<self.listItems.count; i++) {
        id info=[self.listItems objectAtIndex:i];
        if ([info isKindOfClass:[TimelineContentInfo class] ]) {
            TimelineContentInfo *info2 = (TimelineContentInfo *)info;
            if ([info2.timeLinePageVO.ID isEqualToString:listDetail.ID]) {
                [self.listItems replaceObjectAtIndex:i withObject:listDetail];
                break;
            }
        }
        
    }
    
}
-(void)initTableView{
    [super initTableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(@(NavBarHeight));
    }];
    //加了这两句缓解了屏幕闪动的问题，猪嗨哥你别删了
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registNibWithNibName:KTimelinesContentTableViewCell];
    [self.tableView registClassWithClassName:kTimeLineRecommendTableViewCell];
    [self.tableView registNibWithNibName:KTimelinesContentVideoTableViewCell];
    [self.tableView registNibWithNibName:KTimelinesDynamicMessageTableViewCell];
}

-(void)layoutTableView{
    
}

-(void)sendTimelineToChatView{
    TranspondTableViewController*vc=[[TranspondTableViewController alloc]init];
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

-(void)showHjcActionSheetWith:(BOOL) isBlongMyself timelinesListDetailInfo:(TimelinesListDetailInfo *)listDetailInfo{
    self.listDetailInfo = listDetailInfo;
    if (isBlongMyself) {
        //[@"timeline.post.operation.forward" icanlocalized:@"转发"],
        if ([listDetailInfo.visibleRange isEqualToString:@"Open"]) {
            self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.forward" icanlocalized:@"转发"], [@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
        }else{
            self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"], [@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
        }
        
       
    }else{
        if ([listDetailInfo.visibleRange isEqualToString:@"Open"]) {
            self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"], [@"timeline.post.operation.forward" icanlocalized:@"转发"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
        }else{
            self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.favorite" icanlocalized:@"收藏"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
        }
        
    }
    
    self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.otherTitlesItems];
    [self.hjcActionSheet show];
    
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
        [self deteleTimelinesRequest];
    }else if ([title isEqualToString:[@"timeline.post.operation.setVisibleRange" icanlocalized:@"设置可见范围"]]){
        PostMessageLimitViewController * vc =[PostMessageLimitViewController new];
        vc.timelinesListDetailInfo=self.listDetailInfo;
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.modalPresentationStyle =  UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    }
}
-(void)pushDYPlayerView:(TimelinesListDetailInfo*)responseInfo{
    NSMutableArray*array=[NSMutableArray array];
    for (id items in self.listItems) {
        if ([items isKindOfClass:[TimelineContentInfo class]]) {
            TimelineContentInfo *itemsInfo = (TimelineContentInfo *)items;
            if(itemsInfo.timeLinePageVO != nil){
                [array addObject:itemsInfo.timeLinePageVO];
            }
        }
    }
    DYPlayerViewController*vc=[[DYPlayerViewController alloc]initWithVideos:array index:[array indexOfObject:responseInfo]];
    vc.shareSuccessBlock = ^(TimelinesListDetailInfo * _Nonnull timelineDetailInfo) {
        [self refreshList];
    };
    
    vc.currentIndex=self.current;
    vc.timelineType=TimelineType_AllShare;
    vc.detailInfo=responseInfo;
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.backgroundColor = [UIColor qmui_colorWithHexString:@"#F8F8F8"];
    id info=[self.listItems objectAtIndex:indexPath.section];
    if ([info isKindOfClass:[TimelineContentInfo class]]) {
        TimelineContentInfo * dresponseInfo = (TimelineContentInfo *)info;
        if(dresponseInfo.type == 1){
            if (dresponseInfo.timeLinePageVO.imageUrls.count==1&&dresponseInfo.timeLinePageVO.videoUrl) {
                TimelinesContentVideoTableViewCell * videoCell = [tableView dequeueReusableCellWithIdentifier:KTimelinesContentVideoTableViewCell];
                videoCell.contentView.backgroundColor =  [UIColor qmui_colorWithHexString:@"#F8F8F8"];
                videoCell.listRespon = dresponseInfo.timeLinePageVO;
                videoCell.lookPictureBlock = ^(NSInteger index) {
                    [self pushDYPlayerView:dresponseInfo.timeLinePageVO];
                };
                videoCell.topRightBlock = ^{
                    self.selectedListItemID = indexPath.section;
                    if ([dresponseInfo.timeLinePageVO.belongsId isEqualToString:[UserInfoManager sharedManager].userId]) {
                        [self showHjcActionSheetWith:YES timelinesListDetailInfo:dresponseInfo.timeLinePageVO];
                    }else{
                        [self showHjcActionSheetWith:NO timelinesListDetailInfo:dresponseInfo.timeLinePageVO];
                    }
                };
                videoCell.tapBlock = ^(NSInteger index) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
                    [self handleLoveAndComnontShareWith:dresponseInfo.timeLinePageVO index:index indexPath:indexPath];

                };
                return videoCell;
            }
            TimelinesContentTableViewCell * tcell = [tableView dequeueReusableCellWithIdentifier:KTimelinesContentTableViewCell];
            tcell.contentView.backgroundColor =  [UIColor qmui_colorWithHexString:@"#F8F8F8"];
            tcell.listRespon = dresponseInfo.timeLinePageVO;
            tcell.lookPictureBlock = ^(NSInteger index) {
                [self pushDYPlayerView:dresponseInfo.timeLinePageVO];

            };
            tcell.topRightBlock = ^{
                self.selectedListItemID = indexPath.section;
                if ([dresponseInfo.timeLinePageVO.belongsId isEqualToString:[UserInfoManager sharedManager].userId]) {
                    [self showHjcActionSheetWith:YES timelinesListDetailInfo:dresponseInfo.timeLinePageVO];
                }else{
                    [self showHjcActionSheetWith:NO timelinesListDetailInfo:dresponseInfo.timeLinePageVO];
                }
            };
            tcell.tapBlock = ^(NSInteger index) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
                [self handleLoveAndComnontShareWith:dresponseInfo.timeLinePageVO index:index indexPath:indexPath];

            };
            return tcell;
        }else if(dresponseInfo.type == 2){
            TimelinesDynamicMessageTableViewCell *dynamicMessageCell = [tableView dequeueReusableCellWithIdentifier:KTimelinesDynamicMessageTableViewCell];
            dynamicMessageCell.contentView.backgroundColor =  [UIColor qmui_colorWithHexString:@"#F8F8F8"];
            dynamicMessageCell.listRespon = dresponseInfo.dynamicMessage;
            return dynamicMessageCell;
        }
    }
    
    TimeLineRecommendTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kTimeLineRecommendTableViewCell forIndexPath:indexPath ];
    cell.items=[self.listItems objectAtIndex:indexPath.section];
    return cell;
    
}
/** 操作点赞分享之后 刷新界面 */
-(void)operationTimeline:(TimelinesListDetailInfo *)timelinesListDetailInfo{
    for (int i=0; i<self.listItems.count; i++) {
        id info=[self.listItems objectAtIndex:i];
        TimelineContentInfo *responseInfo =(TimelineContentInfo *)info ;
        if ([info isKindOfClass:[TimelinesListDetailInfo class]]) {
            if ([responseInfo.timeLinePageVO.ID isEqualToString:timelinesListDetailInfo.ID]) {
                responseInfo.timeLinePageVO.love=timelinesListDetailInfo.love;
                responseInfo.timeLinePageVO.loveNum=timelinesListDetailInfo.loveNum;
                responseInfo.timeLinePageVO.commentNum=timelinesListDetailInfo.commentNum;
                responseInfo.timeLinePageVO.forwardNum=timelinesListDetailInfo.forwardNum;
                responseInfo.timeLinePageVO.comment=timelinesListDetailInfo.comment;
                TimelinesContentTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:i]];
                cell.listRespon=responseInfo.timeLinePageVO;
                break;
            }
        }
        
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id info=[self.listItems objectAtIndex:indexPath.section];
    if ([info isKindOfClass:[TimelineContentInfo class]]) {
        TimelineContentInfo *responseInfo =(TimelineContentInfo *)info;
        if(responseInfo.timeLinePageVO != nil){
            [self pushTimelinesDetailViewControllerWith:responseInfo.timeLinePageVO tapCommemt:NO];
        }else{
            if([responseInfo.dynamicMessage.onclickFunction isEqualToString:@"NONE"]){
                return;
            }else if([responseInfo.dynamicMessage.onclickFunction isEqualToString:@"OPEN_URL"]){
                UIStoryboard *board;
                board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
                WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
                View.isDynamicMessage = YES;
                View.dynamicMessageURL = responseInfo.dynamicMessage.onclickData;
                View.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:View animated:YES];
                [[self navigationController] setNavigationBarHidden:NO animated:YES];
            }else if([responseInfo.dynamicMessage.onclickFunction isEqualToString:@"OPEN_APP"]){
                return;
            }else if([responseInfo.dynamicMessage.onclickFunction isEqualToString:@"OPEN_HTML"]){
                UIStoryboard *board;
                board = [UIStoryboard storyboardWithName:@"WebPageVC" bundle:nil];
                WebPageVC *View = [board instantiateViewControllerWithIdentifier:@"WebPageVC"];
                View.isDynamicMessage = YES;
                View.htmlString = responseInfo.dynamicMessage.onclickData;
                View.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:View animated:YES];
                [[self navigationController] setNavigationBarHidden:NO animated:YES];
            }
        }
    }
}

-(void)navigateWebView:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[WebPageVC class]]) {
        WebPageVC *webPage = (WebPageVC *)notification.object;
        [self.navigationController pushViewController:webPage animated:YES];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
    id info = [self.listItems objectAtIndex:indexPath.section];
    if ([info isKindOfClass:[TimelineContentInfo class]]) {
        return UITableViewAutomaticDimension;
    }
    return kHeightTimeLineRecommendTableViewCell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 4)];
    view.backgroundColor = [UIColor qmui_colorWithHexString:@"#F8F8F8"];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
//点击查看照片
-(void)showPhotoWithIndex:(NSInteger)index images:(NSArray *)images{
    [self.ybImageBrowerTool showTimelinsNetWorkImageBrowerWithCurrentIndex:index imageItems:images];
}

-(void)pushToPossMessageVcWith:(PostMessageType)type{
    PostMessageViewController * vc = [PostMessageViewController new];
    vc.postMessageSucessBlock = ^{
        self.current=0;
        self.currentPlayingVideoCell=nil;
        [self fetchListRequest];
    };
    vc.postMessageType = type;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(IBAction)messageNoticeAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
    
    [self.navigationController pushViewController:[[MessageNotificationListViewController alloc]init] animated:YES];
}
-(IBAction)publishAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
    NSArray*array=
    @[@{@"icon":@"icon_timeline_pop_video",@"title":@"chatView.function.video".icanlocalized},
      @{@"icon":@"icon_timeline_pop_share",@"title":@"TimelineView.share".icanlocalized},
      //friend.detail.listCell.Moments朋友圈
      @{@"icon":@"icon_timeline_pop_circle",@"title":@"friend.detail.listCell.Moments".icanlocalized}];
    @weakify(self);
    [ChatListMenuView showMenuViewWithMenuItems:array didSelectBlock:^(NSInteger index) {
        @strongify(self);
        if (index==0) {
            [self pushToPossMessageVcWith:TimelinesVideo];
        }else if(index==1){
            [self pushToPossMessageVcWith:TimelinesShare];
        }else{
            [self pushToPossMessageVcWith:TimeLinesFriendCrile];
        }
        
    }];
}
- (IBAction)backAction:(id)sender {
    if ([CHANNELTYPE isEqualToString:ICANTYPETARGET]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [[BaseSettingManager sharedManager]resetAppToTabbarViewControllerDuplicate];
    }
}

-(TimelinesHeaderView *)headerView{
    if (!_headerView) {
        _headerView =[[TimelinesHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 165.5)];
        @weakify(self);
        _headerView.videoTapHandle = ^{//跳转到公开的分享 仅仅是视频
            @strongify(self);
            TypeTimelinesViewController*vc=[[TypeTimelinesViewController alloc]initWithStyle:UITableViewStyleGrouped];
            vc.timelineType=TimelineType_openVideo;
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
        };
        _headerView.shareTapHandle = ^{//跳转到公开的分享 仅仅是文字和图片
            @strongify(self);
            TypeTimelinesViewController*vc=[[TypeTimelinesViewController alloc]initWithStyle:UITableViewStyleGrouped];
            vc.timelineType=TimelineType_openText;
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
            
        };
        _headerView.friendTapHandle = ^{
            @strongify(self);
            TypeTimelinesViewController*vc=[[TypeTimelinesViewController alloc]initWithStyle:UITableViewStyleGrouped];
            vc.timelineType=TimelineType_find;
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
        };
        _headerView.publishVideoTapHandle = ^{
            @strongify(self);
            [self pushToPossMessageVcWith:TimelinesVideo];
        };
        _headerView.publishShareTapHandle = ^{
            @strongify(self);
            [self pushToPossMessageVcWith:TimelinesShare];
        };
        _headerView.publishFriendTapHandle = ^{
            @strongify(self);
            [self pushToPossMessageVcWith:TimeLinesFriendCrile];
        };
    }
    return _headerView;
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
-(void)refreshList{
    [super refreshList];
    [self fetchListRequest];
    
}
-(void)fetchListRequest{
    TimeLinesOpenRequest*request=[TimeLinesOpenRequest request];
    request.size=@(10);
    request.page=@(self.current);
    request.parameters = [request mj_JSONObject];
    @weakify(self);
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimelinesListInfo class] contentClass:[TimelinesListInfo class] success:^(TimelinesListInfo* response) {
        @strongify(self);
        self.listInfo=response;
        self.isLoadMoreData = NO;
        if (self.current==0) {
            self.listItems=[NSMutableArray arrayWithArray:response.content];
        }else{
            [self.listItems addObjectsFromArray:response.content];
        }
        for (TimelineContentInfo *detailInfo  in response.content) {
            [detailInfo.timeLinePageVO cacheCellHeightWith];
            if (detailInfo.timeLinePageVO.videoUrl.length >0) {
                [[VideoCacheManager sharedCacheManager] queryURLFromDiskMemory:detailInfo.timeLinePageVO.videoUrl cacheQueryCompletedBlock:^(id  _Nonnull data, BOOL hasCache) {
                }];
            }
        }
        [self checkHasFooter];
        [self endingRefresh];
        [self.tableView reloadData];
        if (self.current==0) {
            [self handleScroll];
        }
        [self checkShowAddNearbyOrRecommond];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        self.isLoadMoreData = NO;
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        [self endingRefresh];
    }];
    
}
-(void)checkShowAddNearbyOrRecommond{
    if (self.listItems.count>5) {
        id info=[self.listItems objectAtIndex:5];
        if (![info isKindOfClass:[NSArray class]]) {
            if (self.recomItems.count>0) {
                [self.listItems insertObject:self.recomItems atIndex:5];
            }
        }
    }
    if (self.listItems.count>=11){
        id info=[self.listItems objectAtIndex:10];
        if (![info isKindOfClass:[NSArray class]]) {
            if (self.nearItems.count>0) {
                [self.listItems insertObject:self.nearItems atIndex:10];
            }
        }
    }
    if (self.listItems.count<6) {
        if (![self.listItems containsObject:[NSArray class]]) {
            if (self.recomItems.count>0) {
                [self.listItems insertObject:self.recomItems atIndex:self.listItems.count];
            }
        }
    }
    [self.tableView reloadData];
    
}
//点赞
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
-(void)deteleTimelinesRequest{
    DeleteTimelinesRequest * request = [DeleteTimelinesRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@",request.baseUrlString,self.listDetailInfo.ID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITipsTool showOnlyTextWithMessage:@"DeleteSuccess".icanlocalized inView:self.view];
        [self.listItems removeObjectAtIndex:self.selectedListItemID];
        [self.tableView reloadData];
        self.currentPlayingVideoCell=nil;
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
        if (self.listDetailInfo.imageUrls.count==1) {
            
        }
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
        for (UserMessageInfo * user in self.timelinesShareView.reminders) {
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
        [self fetchListRequest];
        [self.timelinesShareView.reminders removeAllObjects];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
    
    
    
}
/** 获取附近的人 */
-(void)fetchNearbyPeopleRequest{
    if ([UserInfoManager sharedManager].openNearbyPeople) {
        GetUserNearbyRequest * request = [GetUserNearbyRequest request];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserLocationNearbyInfo class] success:^(NSArray * response) {
            self.nearItems = response;
            [self checkShowAddNearbyOrRecommond];
            [self.tableView reloadData];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
    
    
}
-(void)fetchUserRecommendRequest{
    if ([UserInfoManager sharedManager].openRecommend) {
        GertUserRecommendRequest * request = [GertUserRecommendRequest request];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserRecommendListInfo class] success:^(NSArray * response) {
            self.recomItems = response;
            [self checkShowAddNearbyOrRecommond];
            [self.tableView reloadData];
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
            [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        }];
    }
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

// 松手时已经静止,只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO) { // scrollView已经完全静止
        [self handleScroll];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([UserInfoManager sharedManager].messageMenuView) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
    }
    if (self.currentPlayingVideoCell) {
        if (![self.tableView.visibleCells containsObject:self.currentPlayingVideoCell]) {
            [self.currentPlayingVideoCell stopPlay];
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

// 松手时还在运动, 先调用scrollViewDidEndDragging,在调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // scrollView已经完全静止
    [self handleScroll];
}
-(void)handleScroll{
    TimelinesContentVideoTableViewCell *finnalCell = nil;
    TimelinesListDetailInfo * lastInfo = nil;
    for (id cell in [self.tableView visibleCells]) {
        if ([cell isKindOfClass:[TimelinesContentVideoTableViewCell class]]) {
            TimelinesContentVideoTableViewCell *videoCell = cell;
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
        
    }
    // 注意, 如果正在播放的cell和finnalCell是同一个cell,由于cell的复用机制self.currentPlayingVideoCell一定等于finnalCell
    if (finnalCell != nil && self.currentPlayDetailInfo != lastInfo) {
        [self.currentPlayingVideoCell stopPlay];
        self.currentPlayingVideoCell = finnalCell;
        self.currentPlayDetailInfo = lastInfo;
        [self.currentPlayingVideoCell stopPlay];
        [self.currentPlayingVideoCell startPlay];
        return;
    }
    
}
@end

