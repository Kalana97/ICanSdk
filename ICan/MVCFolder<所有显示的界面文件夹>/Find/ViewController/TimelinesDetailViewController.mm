//
//  TimelinesDetailViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/10.
//  Copyright © 2020 dzl. All rights reserved.
//  评论页面

#import "TimelinesDetailViewController.h"
#import "TimelinesDetailContentTableViewCell.h"
#import "TimelinesSubCommentTableViewCell.h"
#import "TimelinesCommentBottomView.h"
#import "YBImageBrowerTool.h"
#import "HJCActionSheet.h"
#import "TimelinesShareView.h"
#import "QDNavigationController.h"
#import "PostMessageLimitViewController.h"
#import "TimelineShowGoodsPeopleView.h"
#import "XMFaceManager.h"
#import "EmojyShowView.h"
#import "TimeLineDetailCommentTableViewCell.h"
#import "TranspondTableViewController.h"
#import "ReportListTableViewController.h"
#import "WCDBManager+TimelinesCommentInfo.h"
#import "TimelinesCommentInfo.h"
#import "DZAVPlayerViewController.h"
@interface TimelinesDetailViewController ()<HJCActionSheetDelegate,TimelinesShareViewDelegate>
@property(nonatomic,strong)   TimelinesDetailInfo * timelinesDetailInfo;
@property(nonatomic,strong)   TimelinesCommentBottomView * bottomView;
@property(nonatomic, strong)  YBImageBrowerTool *ybImageBrowerTool;
@property (nonatomic,strong)  HJCActionSheet * hjcActionSheet;
@property(nonatomic, strong)  NSString * commentId;
@property(nonatomic,strong)   NSString * deleteId;
/** 当前是不是评论 */
@property(nonatomic,assign)   BOOL isComment;
@property(nonatomic,assign)   NSString * replyId;
@property(nonatomic,assign)   CGFloat keyBordHeight;
@property (nonatomic,assign)  BOOL isOpenFaceView;

@property(nonatomic,strong)   TimelinesListDetailInfo * listDetailInfo;
@property(nonatomic,strong)   TimelinesShareView * timelinesShareView;
@property(nonatomic,strong)   NSMutableArray <UserMessageInfo *>* reminders;//提醒看的人
@property(nonatomic, strong)  UIButton *rightButton;

@property(nonatomic, strong)  NSArray *otherTitlesItems;

@end

@implementation TimelinesDetailViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KChangeTimelineSuccessNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =NSLocalizedString(@"details", 详情);
    [self fetchTimelinesDetailRequest:NO];
    self.isComment =YES;
    [IQKeyboardManager sharedManager].enable = NO;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTimelineSuccess:) name:KChangeTimelineSuccessNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (UserInfoManager.sharedManager.messageMenuView) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
    }
}
-(void)changeTimelineSuccess:(NSNotification*)notifi{
    TimelinesListDetailInfo*listDetail=notifi.object;
    self.timelinesDetailInfo.timeLine=listDetail;
    self.listDetailInfo=listDetail;
}
-(void)rightBarButtonItemAction{
    [self.view endEditing:YES];
    TimelinesListDetailInfo * responseInfo = self.timelinesDetailInfo.timeLine;
    if ([responseInfo.belongsId isEqualToString:[UserInfoManager sharedManager].userId]) {
        [self showHjcActionSheetWith:YES timelinesListDetailInfo:responseInfo];
    }else{
        [self showHjcActionSheetWith:NO timelinesListDetailInfo:responseInfo];
    }
}
- (void)scrollTableViewToBottom {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollToBottomWithContentOffsetAnimation:NO];
    });
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.tapCommentButton) {
        [self.bottomView.textView becomeFirstResponder];
    }
    
    
}
#pragma mark 表格开始拖拽滚动，隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView ==self.tableView) {
        [self.view endEditing:YES];
        [self.bottomView hiddenAllView];
    }
    if ([UserInfoManager sharedManager].messageMenuView) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
        
    }
    
}

-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:KTimelinesDetailContentTableViewCell];
    [self.tableView registClassWithClassName:KTimelinesSubCommentTableViewCell];
    [self.tableView registNibWithNibName:kTimeLineDetailCommentTableViewCell];
    [self.view addSubview:self.bottomView];
    if (isIPhoneX) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.bottom.equalTo(@-75);
        }];
        
    }else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(@0);
            make.bottom.equalTo(@-55);
            
        }];
        
        
    }
}

-(void)layoutTableView{
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.timelinesDetailInfo?2:0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return self.timelinesDetailInfo.comments.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimelinesListDetailInfo * responseInfo = self.timelinesDetailInfo.timeLine;
    responseInfo.showLookGoodsLabel=YES;
    if (indexPath.section==0) {
        TimelinesDetailContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KTimelinesDetailContentTableViewCell];
        cell.listRespon = responseInfo;
        @weakify(self);
        cell.tapBlock = ^(NSInteger index) {
            @strongify(self);
            [self handleLoveAndComnontShareWith:index];
        };
        cell.lookPictureBlock = ^(NSInteger index) {
            @strongify(self);
            if (responseInfo.videoUrl) {
                [self showVideoWithUrl:[NSURL URLWithString:responseInfo.videoUrl]];
            }else{
                [self showPhotoWithIndex:index images:responseInfo.imageUrls];
            }
        };
        return cell;
        
    }
    TimelinesCommentInfo * comment = [self.timelinesDetailInfo.comments objectAtIndex:indexPath.row];
    TimeLineDetailCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineDetailCommentTableViewCell];
    cell.detailInfo=self.timelinesListDetailInfo;
    cell.comment=comment;
    cell.replyBlock = ^(NSString * _Nonnull nickname, NSString * _Nonnull commentId) {
        [self.bottomView.textView becomeFirstResponder];
        self.bottomView.textView.placeholder =[NSString stringWithFormat:@"%@%@:",@"Reply".icanlocalized,nickname];
        self.bottomView.topBgView.hidden = NO;
        self.bottomView.replyLabel.text =[NSString stringWithFormat:@"%@%@:",@"Reply".icanlocalized,nickname];
        self.commentId = commentId;
        self.isComment =NO;
        [self.bottomView showReplyView];
    };
    cell.deleteBlock = ^{
        [UIAlertController alertControllerWithTitle:@"Do you want to delete the comment?".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
            if (index==1) {
                [self deleteCommentWith:comment.ID];
            }
        }];
        
    };
    return cell;
}
//回复他人的评论
-(void)replyWith:(NSString *)commentId nickName:(nonnull NSString *)nickName{
    [self.bottomView.textView becomeFirstResponder];
    self.bottomView.textView.placeholder =[NSString stringWithFormat:@"%@%@:",@"Reply".icanlocalized,nickName];
    self.bottomView.topBgView.hidden = NO;
    self.bottomView.replyLabel.text =[NSString stringWithFormat:@"%@%@:",@"Reply".icanlocalized,nickName];
    self.commentId = commentId;
    self.isComment =NO;
    [self.bottomView showReplyView];
}
-(void)showHjcActionSheetWith:(BOOL) isBlongMyself timelinesListDetailInfo:(TimelinesListDetailInfo *)listDetailInfo{
    self.listDetailInfo = listDetailInfo;
    if (isBlongMyself) {
        if ([self.listDetailInfo.visibleRange isEqualToString:@"Open"]) {
            self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"], [@"timeline.post.operation.forward" icanlocalized:@"转发"],NSLocalizedString(@"collect", 收藏),[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
        }else{
            self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.setVisibleRange" icanlocalized:@"设置可见范围"],NSLocalizedString(@"collect", 收藏),[@"timeline.post.operation.delete" icanlocalized:@"删除"],[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
        }
    }else{
        if ([self.listDetailInfo.visibleRange isEqualToString:@"Open"]) {
            self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],[@"timeline.post.operation.forward" icanlocalized:@"转发"],NSLocalizedString(@"collect", 收藏),[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
        }else{
            self.otherTitlesItems=@[[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"],NSLocalizedString(@"collect", 收藏),[@"timeline.post.operation.complaint" icanlocalized:@"投诉"]];
        }
        
    }
    self.hjcActionSheet=[[HJCActionSheet alloc]initWithArrayDelegate:self cancelTitle:NSLocalizedString(@"Cancel", nil) otherTitles:self.otherTitlesItems];
    [self.hjcActionSheet show];
}
-(void)sendTimelineToChatView:(void(^)(void))block{
    TranspondTableViewController*vc=[[TranspondTableViewController alloc]init];
    vc.transpondType=TranspondType_Time;
    vc.pushChatViewBlock = ^(ChatModel * _Nonnull toModel, NSArray * _Nonnull messageItems) {
        if (block) {
            block();
        }
    };
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
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString*title=[self.otherTitlesItems objectAtIndex:buttonIndex-1];
    if ([title isEqualToString: [@"timeline.post.operation.forward" icanlocalized:@"转发"]]) {
        //分享
        [self.timelinesShareView showTimelinesShareView];
    }else if ([title isEqualToString:[@"timeline.post.operation.favorite" icanlocalized:@"收藏"]]){
        [self collectionMes];
    }else if ([title isEqualToString:[@"timeline.post.operation.sendToFriends" icanlocalized:@"发送给朋友"]]){
        [self sendTimelineToChatView:^{
            
        }];
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


//删除评论
-(void)deleteWith:(NSString *)deleteId{
    
    [UIAlertController alertControllerWithTitle:@"Do you want to delete the comment?".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
        if (index==1) {
            [self deleteCommentWith:deleteId];
        }
    }];
}

-(void)showPhotoWithIndex:(NSInteger)index images:(NSArray *)images{
    [self.view endEditing:YES];
    [self.ybImageBrowerTool showTimelinsNetWorkImageBrowerWithCurrentIndex:index imageItems:images];
}


-(void)showVideoWithUrl:(NSURL *)url{
    DZAVPlayerViewController* vc = [[DZAVPlayerViewController alloc]init];
    [vc setPlayUrl:url aVPlayerViewType:AVPlayerViewNormal];
    [self.navigationController pushViewController:vc animated:YES];
    [self.view endEditing:YES];
    @weakify(vc);
    vc.transpondBlock = ^{
        @strongify(vc);
        [self sendTimelineToChatView:^{
            [vc forwardingSendMessage];
        }];
        
    };
    
    
    
}

-(void)handleLoveAndComnontShareWith:(NSInteger)index{
    if (index==0) {
        //赞
        [self interactiveRequest];
    }else if(index ==1){
        self.bottomView.topBgView.hidden = YES;
        self.bottomView.textView.placeholder = NSLocalizedString(@"Write a Review", 写评论...);
        [self.bottomView.textView becomeFirstResponder];
        self.commentId = self.messageId;
        self.isComment=YES;
    }else if(index==2){
        //分享
        [self.timelinesShareView showTimelinesShareView];
    }else{
        [self fetchGoodsPeopleRequest];
        
    }
    
}
-(NSMutableArray<UserMessageInfo *> *)reminders{
    if (!_reminders) {
        _reminders=[NSMutableArray array];
    }
    return _reminders;
}
-(YBImageBrowerTool *)ybImageBrowerTool{
    if (!_ybImageBrowerTool) {
        _ybImageBrowerTool = [[YBImageBrowerTool alloc]init];
    }
    return _ybImageBrowerTool;
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:UIColor.clearColor titleFont:0 titleColor:nil target:self action:@selector(rightBarButtonItemAction)];
        _rightButton.frame=CGRectMake(0, 0, 20, 20);
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"icon_nav_more_black"] forState:UIControlStateNormal];
        
    }
    return _rightButton;
}
-(void)sendCommentOrReply:(NSString*)conment{
    if (self.isComment) {
        [self sendCommentRequestWith:conment];
    }else{
        [self sendReplyRequestWith:conment];
    }
}
//底部评论框
-(TimelinesCommentBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[TimelinesCommentBottomView alloc]initWithFrame:CGRectMake(0, ScreenHeight-55, ScreenWidth, 55)];
        _bottomView.topBgView.hidden = YES;
        if (isIPhoneX) {
            _bottomView.frame = CGRectMake(0, ScreenHeight-75, ScreenWidth, 75);
        }
        @weakify(self);
        //点击发送按钮发送评论或者回复
        _bottomView.sendCommentBlock = ^(NSString * _Nonnull comment) {
            @strongify(self);
            [self sendCommentOrReply:comment];
        };
        _bottomView.closeBlock = ^{
            @strongify(self);
            self.isComment=YES;
        };
    }
    
    return _bottomView;
}


-(void)fetchTimelinesDetailRequest:(BOOL)block{
    TimelinesDetailRequest * request = [TimelinesDetailRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/v2",request.baseUrlString,self.messageId];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimelinesDetailInfo class] contentClass:[TimelinesDetailInfo class] success:^(TimelinesDetailInfo * response) {
        self.timelinesDetailInfo = response;
        self.listDetailInfo=response.timeLine;
        self.timelinesListDetailInfo.comment=response.timeLine.comment;
        self.timelinesListDetailInfo.love=response.timeLine.love;
        self.timelinesListDetailInfo.loveNum=response.timeLine.loveNum;
        self.timelinesListDetailInfo.commentNum=response.timeLine.commentNum;
        if (block) {
            if (self.operateBlock) {
                self.operateBlock(self.timelinesListDetailInfo);
            }
        }
        [response.timeLine cacheTimeLineDetailHeight];
        for (TimelinesCommentInfo*commentInfo in response.comments) {
            TimelinesCommentInfo*info=[[WCDBManager sharedManager]fetchCommentWithCommentId:commentInfo.ID];
            if (info) {
                commentInfo.translateStatus = info.translateStatus;
                commentInfo.translateMsg = info.translateMsg;
            }
        }
        [UIView performWithoutAnimation:^{
            [self.tableView reloadData];
        }];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        [self .navigationController popViewControllerAnimated:YES];
        
        
    }];
    
}
//发送评论
-(void)sendCommentRequestWith:(NSString *)tentContent{
    if([[tentContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"Please enter comment content".icanlocalized inView:self.view];
        return;
        
    }
    [QMUITips showLoadingInView:self.view];
    TimelinesSendCommentRequest * request = [TimelinesSendCommentRequest request];
    request.pathUrlString =[NSString stringWithFormat:@"%@/timeLines/%@/comment/v2",request.baseUrlString,self.listDetailInfo.ID];
    request.parameters = tentContent;
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITips hideAllTips];
        self.bottomView.textView.text = @"";
        self.bottomView.isComment=YES;
        self.bottomView.textView.placeholder =NSLocalizedString(@"Write a Review", 写评论...);
        [self.bottomView updateConstraintsFram];
        [self fetchTimelinesDetailRequest:YES];
        [self.view endEditing:YES];
        [self.bottomView hiddenAllView];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        
    }];
    
    
}

//回复
-(void)sendReplyRequestWith:(NSString *)content{
    if([NSString isEmptyString:content]) {
        [QMUITipsTool showOnlyTextWithMessage:@"TimelineCommentTips".icanlocalized inView:self.view];
        return;
        
    }
    TimelinesReplyRequest * request = [TimelinesReplyRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/%@/reply/v2",request.baseUrlString,self.listDetailInfo.ID,self.commentId];
    request.parameters = content;
    [QMUITips showLoadingInView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITips hideAllTips];
        self.bottomView.textView.text = @"";
        self.bottomView.isComment=YES;
        self.isComment=YES;
        self.bottomView.textView.placeholder =NSLocalizedString(@"Write a Review", 写评论...);
        [self.bottomView updateConstraintsFram];
        [self fetchTimelinesDetailRequest:YES];
        [self.bottomView hiddenAllView];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
        
    }];
    
}
//删除评论
-(void)deleteCommentWith:(NSString *)commentId{
    TimelinesDeleteCommentRequest * request = [TimelinesDeleteCommentRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/comment/v2",request.baseUrlString,commentId];
    [QMUITips showLoadingInView:self.view];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITips hideAllTips];
        [self fetchTimelinesDetailRequest:YES];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}


//点赞
-(void)interactiveRequest{
    TimelinesInteractiveRequest * request = [TimelinesInteractiveRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/interactive",request.baseUrlString,self.listDetailInfo.ID];
    request.parameters =@"Love";
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [self fetchTimelinesDetailRequest:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}

//删除帖子
-(void)fetchDeteleTimelinesRequest{
    
    DeleteTimelinesRequest * request = [DeleteTimelinesRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@",request.baseUrlString,self.listDetailInfo.ID];
    
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        
        [QMUITipsTool showOnlyTextWithMessage:@"DeleteSuccess".icanlocalized inView:nil];
        if (self.deleteMessageSuccessBlock) {
            self.deleteMessageSuccessBlock(self.timelinesListDetailInfo);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
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
        //选择要提醒的人
        request.reminders = (NSArray *)reminderArray;
    }
    
    request.parameters = [request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        
        [self.reminders removeAllObjects];
        self.timelinesShareView.textView.text = @"";
        [self.timelinesShareView hiddenTimelinesShareView];
        [self.timelinesShareView.reminders removeAllObjects];
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Sharing success", 分享成功) inView:self.view];
        if (self.shareSuccessBlock) {
            self.shareSuccessBlock(self.timelinesListDetailInfo);
        }
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
/// 查看点赞的人
-(void)fetchGoodsPeopleRequest{
    TimelineLoveRequest*request=[TimelineLoveRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/timeLines/love/%@",self.listDetailInfo.ID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[TimelineLoveInfo class] success:^(NSArray* response) {
        TimelineShowGoodsPeopleView*view=[[TimelineShowGoodsPeopleView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        view.goodsPeopleItems=response;
        [view showSurePaymentView];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

@end
