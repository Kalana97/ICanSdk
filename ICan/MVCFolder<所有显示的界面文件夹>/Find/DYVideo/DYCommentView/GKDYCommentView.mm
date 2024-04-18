//
//  GKDYCommentView.m
//  GKDYVideo
//
//  Created by QuintGao on 2019/5/1.
//  Copyright © 2019 QuintGao. All rights reserved.
//

#import "GKDYCommentView.h"
#import "DYCommentTextView.h"
#import "GKBallLoadingView.h"
#import "WCDBManager+TimelinesCommentInfo.h"
#import "TimeLineDetailCommentTableViewCell.h"
#import "TimelinesCommentInfo.h"
@interface GKDYCommentView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIVisualEffectView    *effectView;
@property (nonatomic, strong) UIView                *topView;
@property (nonatomic, strong) UILabel               *countLabel;
@property (nonatomic, strong) UIButton              *closeBtn;

@property (nonatomic, strong) UITableView           *tableView;

@property (nonatomic, assign) NSInteger             count;
/** 当前点击的是哪个评论 */
@property(nonatomic, strong) TimelinesCommentInfo *currentCommentInfo;
@property(nonatomic, strong) DYCommentTextView *commentTextView;
/** 当前是否是直接发表评论 */
@property(nonatomic, assign) BOOL isComment;
@end

@implementation GKDYCommentView

- (instancetype)init {
    if (self = [super init]) {
        self.isComment=YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self addSubview:self.topView];
        [self addSubview:self.effectView];
        [self addSubview:self.countLabel];
        [self addSubview:self.closeBtn];
        [self addSubview:self.tableView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(ADAPTATIONRATIO * 50.0f);
        }];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.topView);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 8.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 18.0f);
        }];
        if (isIPhoneX) {
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self.topView.mas_bottom);
                make.bottom.equalTo(@-75);
            }];
        }else{
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(self.topView.mas_bottom);
                make.bottom.equalTo(@-55);
            }];
        }
        [self addSubview:self.commentTextView];
        self.countLabel.text = [NSString stringWithFormat:@"%zd%@", self.count,@"Comments".icanlocalized];
    }
    return self;
}
-(void)removeAllData{
    self.commentItems=@[];
    [self.tableView reloadData];
}
-(void)reloadDataFromTimelinesDetailInfo:(TimelinesDetailInfo*)timelinesDetailInfo{
    for (TimelinesCommentInfo*commentInfo in timelinesDetailInfo.comments) {
        TimelinesCommentInfo*info=[[WCDBManager sharedManager]fetchCommentWithCommentId:commentInfo.ID];
        if (info) {
            commentInfo.translateStatus=info.translateStatus;
            commentInfo.translateMsg=info.translateMsg;
        }
    }
    self.commentItems=timelinesDetailInfo.comments;
    [self.tableView reloadData];
    self.countLabel.text=[NSString stringWithFormat:@"%zd%@",timelinesDetailInfo.timeLine.commentNum,@"Comments".icanlocalized];
}
- (void)requestData {
   GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.tableView];
    [loadingView startLoading];
    TimelinesDetailRequest * request = [TimelinesDetailRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/v2",request.baseUrlString,self.timelinesListDetailInfo.ID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimelinesDetailInfo class] contentClass:[TimelinesDetailInfo class] success:^(TimelinesDetailInfo * response) {
        [self.timelineComnentDict setObject:response forKey:response.timeLine.ID];
        [loadingView stopLoading];
        [loadingView removeFromSuperview];
        [self reloadDataFromTimelinesDetailInfo:response];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
    }];
   
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (UserInfoManager.sharedManager.messageMenuView) {
        [self hiddenView];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimeLineDetailCommentTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kTimeLineDetailCommentTableViewCell];
    cell.detailInfo=self.timelinesListDetailInfo;
    TimelinesCommentInfo*comment=[self.commentItems objectAtIndex:indexPath.row];
    cell.comment=comment;
    cell.replyBlock = ^(NSString * _Nonnull nickname, NSString * _Nonnull commentId) {
        self.currentCommentInfo=comment;
        [self.commentTextView.textView becomeFirstResponder];
        self.commentTextView.textView.placeholder =[NSString stringWithFormat:@"%@%@:",@"Reply".icanlocalized,comment.belongsNickName];
        self.commentTextView.topBgView.hidden = YES;
        self.commentTextView.replyLabel.text =[NSString stringWithFormat:@"%@%@:",@"Reply".icanlocalized,comment.belongsNickName];
        self.isComment =NO;
        
    };
    cell.deleteBlock = ^{
        [UIAlertController alertControllerWithTitle:@"Do you want to delete the comment?".icanlocalized message:nil target:self preferredStyle:UIAlertControllerStyleAlert actionTitles:@[@"UIAlertController.cancel.title".icanlocalized,@"UIAlertController.sure.title".icanlocalized] handler:^(int index) {
               if (index==1) {
                   [self deleteCommentWith:comment];
               }
           }];
        
    };
    return cell;
}
#pragma mark - 懒加载
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _effectView;
}
-(NSMutableDictionary *)timelineComnentDict{
    if (!_timelineComnentDict) {
        _timelineComnentDict=[NSMutableDictionary dictionary];
    }
    return _timelineComnentDict;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = UIColor.whiteColor;
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, ADAPTATIONRATIO * 50.0f);
        //绘制圆角 要设置的圆角 使用“|”来组合
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //设置大小
        maskLayer.frame = frame;
        //设置图形样子
        maskLayer.path = maskPath.CGPath;
        _topView.layer.mask = maskLayer;
    }
    return _topView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel centerLabelWithTitle:nil font:17 color:UIColor153Color];
    }
    return _countLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_pop_close_white"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
-(void)hiddenView{
    if (UserInfoManager.sharedManager.messageMenuView) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HiddenTimelineMenuViewNotification" object:nil];
        
    }
    if (self.hiddenBlock) {
        self.hiddenBlock();
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registNibWithNibName:kTimeLineDetailCommentTableViewCell];
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}
//底部评论框
-(DYCommentTextView *)commentTextView{
    if (!_commentTextView) {
        _commentTextView = [[DYCommentTextView alloc]initWithFrame:CGRectMake(0, KHeightRatio(440)-55, ScreenWidth, 55)];
        _commentTextView.topBgView.hidden = YES;
        if (isIPhoneX) {
            _commentTextView.frame = CGRectMake(0, KHeightRatio(440)-75, ScreenWidth, 75);
        }
        @weakify(self);
        //点击发送按钮发送评论或者回复
        _commentTextView.sendCommentBlock = ^(NSString * _Nonnull comment) {
            @strongify(self);
            if (self.isComment) {//直接发表评论
                [self sendCommentRequestWith:comment];
            }else{
                [self sendReplyRequestWith:comment];
            }
        };
        _commentTextView.closeBlock = ^{
            @strongify(self);
            self.isComment=YES;
        };
    }
    return _commentTextView;
}

//删除评论
-(void)deleteCommentWith:(TimelinesCommentInfo *)commentInfo{
    TimelinesDeleteCommentRequest * request = [TimelinesDeleteCommentRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/comment/v2",request.baseUrlString,commentInfo.ID];
    [QMUITips showLoadingInView:self];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITips hideAllTips];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.commentItems];
        [array removeObject:commentInfo];
        self.timelinesListDetailInfo.commentNum=self.timelinesListDetailInfo.commentNum-1;
        self.commentItems=[array copy];
        [self.tableView reloadData];
        [self fetchTimelinesDetailRequest];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self];
    }];
    
}

//删除回复
-(void)deleteReplyRequestWith:(ReplyVOsInfo *)replyVOsInfo{
    TimelinesDeleteReplyRequest * request = [TimelinesDeleteReplyRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/reply/v2",request.baseUrlString,replyVOsInfo.ID];
    [QMUITips showLoadingInView:self];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITips hideAllTips];
        [self fetchTimelinesDetailRequest];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self];
    }];
    
}
-(void)fetchTimelinesDetailRequest{
    TimelinesDetailRequest * request = [TimelinesDetailRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/v2",request.baseUrlString,self.timelinesListDetailInfo.ID];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[TimelinesDetailInfo class] contentClass:[TimelinesDetailInfo class] success:^(TimelinesDetailInfo * response) {
        self.timelinesListDetailInfo = response.timeLine;
        self.timelinesListDetailInfo.comment=response.timeLine.comment;
        self.timelinesListDetailInfo.love=response.timeLine.love;
        self.timelinesListDetailInfo.loveNum=response.timeLine.loveNum;
        self.timelinesListDetailInfo.commentNum=response.timeLine.commentNum;
        self.timelinesListDetailInfo.comment=response.timeLine.comment;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(gkDYCommentViewDeleteCommentInfoWithtimelinesListDetailInfo:)]) {
                [self.delegate gkDYCommentViewDeleteCommentInfoWithtimelinesListDetailInfo:self.timelinesListDetailInfo];
            }
        [self reloadDataFromTimelinesDetailInfo:response];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITipsTool showErrorWihtMessage:info.desc inView:nil];
        
        
        
    }];
    
}
//发送评论
-(void)sendCommentRequestWith:(NSString *)tentContent{
    if([[tentContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        [QMUITipsTool showOnlyTextWithMessage:@"Please enter comment content".icanlocalized inView:self];
        return;
        
    }
    [QMUITips showLoadingInView:self];
    TimelinesSendCommentRequest * request = [TimelinesSendCommentRequest request];
    request.pathUrlString =[NSString stringWithFormat:@"%@/timeLines/%@/comment/v2",request.baseUrlString,self.timelinesListDetailInfo.ID];
    
    request.parameters = tentContent;
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        [QMUITips hideAllTips];
        self.commentTextView.textView.text = @"";
        self.commentTextView.isComment=YES;
        self.commentTextView.textView.placeholder =NSLocalizedString(@"Write a Review", 写评论...);
        [self fetchTimelinesDetailRequest];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self];
        
    }];
    
    
}

//回复
-(void)sendReplyRequestWith:(NSString *)content{
    if([NSString isEmptyString:content]) {
//        "TimelineCommentTips"="请输入回复内容";
        [QMUITipsTool showOnlyTextWithMessage:@"TimelineCommentTips".icanlocalized inView:self];
        return;
        
    }
    TimelinesReplyRequest * request = [TimelinesReplyRequest request];
    request.pathUrlString = [NSString stringWithFormat:@"%@/timeLines/%@/%@/reply/v2",request.baseUrlString,self.timelinesListDetailInfo.ID,self.currentCommentInfo.ID];
    request.parameters = content;
    [QMUITips showLoadingInView:self];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        
        [QMUITips hideAllTips];
        self.commentTextView.textView.text = @"";
        self.commentTextView.isComment=YES;
        self.commentTextView.textView.placeholder =NSLocalizedString(@"Write a Review", 写评论...);
        [self fetchTimelinesDetailRequest];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        [QMUITips hideAllTips];
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self];
        
    }];
    
}
@end
