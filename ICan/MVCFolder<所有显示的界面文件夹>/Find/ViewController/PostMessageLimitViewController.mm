//
//  PostMessageLimitViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/3/6.
//  Copyright © 2020 dzl. All rights reserved.
//  朋友圈权限选择

#import "PostMessageLimitViewController.h"
#import "PostMessageLimitTableViewCell.h"
#import "SelectTimelineMembersViewController.h"
#import "WCDBManager+UserMessageInfo.h"
@interface PostMessageLimitViewController ()
/** 当前点击的是那个cell 也就是点击的是那个 是好友还是 其他权限 */
@property(nonatomic,assign)  NSInteger selectIndex;

@property(nonatomic,assign)  NSInteger currentSelectIndex;
/** 当前的数据内容 */
@property(nonatomic,strong)  NSArray * items;
/** 当前选中的权限的人数 */
@property(nonatomic,strong)  NSArray<UserMessageInfo*> *choseArray;
/** 是否是发送帖子 */
@property(nonatomic,assign)  BOOL isPostMessage;


@end

@implementation PostMessageLimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =[@"mine.setting.cell.title.privacy" icanlocalized:@"隐私设置"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithTitle:@"Done".icanlocalized target:self action:@selector(rightButtonAction)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem qmui_itemWithImage:[UIImage imageNamed:@"icon_nav_back_black"] target:self action:@selector(cancelAction)];
    /*
     朋友圈可见范围公开Open,仅自己可见OnlyMyself,好友AllFriend指定好SomeFriends,除了这些好友ExceptSomeFriends
     */
    self.items =
    @[
        @{@"top":@"timeline.limit.tip.friend".icanlocalized,@"bottom":[@"timeline.limit.tip.visibleToYourFriends" icanlocalized:@"你的好友可见"],@"icon":@"icon_timeline_post_setting_friend",@"visibleRange":@"AllFriend"},
        @{@"top":[@"timeline.limit.tip.exceptFriends" icanlocalized:@"好友，除了"],@"bottom":[@"timeline.limit.tip.somefriendsNotVisible" icanlocalized:@"对部分好友不可见"],@"icon":@"icon_timeline_post_setting_except",@"visibleRange":@"ExceptSomeFriends"},
        @{@"top":[@"timeline.limit.tip.designatedFriends" icanlocalized:@"指定好友"],@"bottom":[@"timeline.limit.tip.visibleToSomeFriends" icanlocalized:@"指定对部分好友可见"],@"icon":@"icon_timeline_post_setting_appoint",@"visibleRange":@"SomeFriends"},
        @{@"top": [@"timeline.limit.tip.onlyYourself" icanlocalized:@"仅限自己"],@"bottom":[@"timeline.limit.tip.onlyYourselfDetail" icanlocalized:@"只对自己可见"],@"icon":@"icon_timeline_post_setting_myself",@"visibleRange":@"OnlyMyself"}
    ];
    self.choseArray = [NSArray array];
    //如果当前拥有timelinesListDetailInfo 那么证明是修改朋友圈权限
    if (self.timelinesListDetailInfo) {
        for (int i=0; i<self.items.count; i++) {
            NSDictionary*dict=self.items[i];
            if ([dict[@"visibleRange"] isEqualToString:self.timelinesListDetailInfo.visibleRange] ) {
                self.selectIndex=[self.items indexOfObject:dict];
                self.currentSelectIndex=self.selectIndex;
                break;
            }
        }
        if ([self.timelinesListDetailInfo.visibleRange isEqualToString:@"SomeFriends"]) {
            NSMutableArray*array=[NSMutableArray array];
            for (NSString*userId in self.timelinesListDetailInfo.specifies) {
                
                UserMessageInfo*info= [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userId];
                if (info) {
                    [array addObject:info];
                }
                
            }
            self.choseArray=[array copy];
            
        }else if ([self.timelinesListDetailInfo.visibleRange isEqualToString:@"ExceptSomeFriends"]){
            
            NSMutableArray*array=[NSMutableArray array];
            for (NSString*userId in self.timelinesListDetailInfo.shields) {
                UserMessageInfo*info= [[WCDBManager sharedManager]fetchUserMessageInfoWithUserId:userId];
                [array addObject:info];
            }
            self.choseArray=[array copy];
            
        }
        if (self.choseArray.count) {
            NSMutableString * atContent = [NSMutableString string];
            if (self.selectIndex==1) {
                [atContent appendString:[@"timeline.limit.tip.visibleToSomeFriendsExcept" icanlocalized:@"对部分好友可见，除了"]];
            }else if (self.selectIndex==2){
                [atContent appendString:[@"timeline.limit.tip.SpecifyFriendsIncluding" icanlocalized:@"指定对部分好友可见，包括"]];
            }
            for (int i =0; i<self.choseArray.count; i++) {
                if (i>0) {
                    [atContent appendString:@","];
                }
                UserMessageInfo * user = self.choseArray[i];
                [atContent appendString:user.nickname];
            }
            if (self.selectIndex ==1) {
                self.items =
                @[
                    @{@"top":@"timeline.limit.tip.friend".icanlocalized,@"bottom":[@"timeline.limit.tip.visibleToYourFriends" icanlocalized:@"你的好友可见"],@"icon":@"icon_timeline_post_setting_friend",@"visibleRange":@"AllFriend"},
                    @{@"top":[@"timeline.limit.tip.exceptFriends" icanlocalized:@"好友，除了"],@"bottom":atContent,@"icon":@"icon_timeline_post_setting_except",@"visibleRange":@"ExceptSomeFriends"},
                    @{@"top":@"指定好友",@"bottom":[@"timeline.limit.tip.visibleToSomeFriends" icanlocalized:@"指定对部分好友可见"],@"icon":@"icon_timeline_post_setting_appoint",@"visibleRange":@"SomeFriends"},
                    @{@"top":[@"timeline.limit.tip.onlyYourself" icanlocalized:@"仅限自己"],@"bottom":[@"timeline.limit.tip.onlyYourselfDetail" icanlocalized:@"只对自己可见"],@"icon":@"icon_timeline_post_setting_myself",@"visibleRange":@"OnlyMyself"}
                ];
                
                
            }else if (self.selectIndex ==2){
                self.items =
                @[
                    @{@"top":@"timeline.limit.tip.friend".icanlocalized,@"bottom":[@"timeline.limit.tip.visibleToYourFriends" icanlocalized:@"你的好友可见"],@"icon":@"icon_timeline_post_setting_friend",@"visibleRange":@"AllFriend"},
                    @{@"top":[@"timeline.limit.tip.exceptFriends" icanlocalized:@"好友，除了"],@"bottom":[@"timeline.limit.tip.somefriendsNotVisible" icanlocalized:@"对部分好友不可见"],@"icon":@"icon_timeline_post_setting_except",@"visibleRange":@"ExceptSomeFriends"},
                    @{@"top":[@"timeline.limit.tip.designatedFriends" icanlocalized:@"指定好友"],@"bottom":atContent,@"icon":@"icon_timeline_post_setting_appoint",@"visibleRange":@"SomeFriends"},
                    @{@"top":[@"timeline.limit.tip.onlyYourself" icanlocalized:@"仅限自己"],@"bottom":[@"timeline.limit.tip.onlyYourselfDetail" icanlocalized:@"只对自己可见"],@"icon":@"icon_timeline_post_setting_myself",@"visibleRange":@"OnlyMyself"}
                ];
                
                
            }
            
        }
        [self.tableView reloadData];
        
    }else{
        
        self.isPostMessage=YES;
        self.selectIndex = 0;
        self.currentSelectIndex=0;
    }
}

-(void)selectVisibleRangeAction{
    SelectTimelineMembersViewController*vc=[[SelectTimelineMembersViewController alloc]init];
    if (self.selectIndex==self.currentSelectIndex) {
        vc.selectUsers=self.choseArray;
    }
    
    vc.addTimelinesAtMemberSuccessBlock = ^(NSArray *atArray) {
        if (self.currentSelectIndex!=self.selectIndex) {
            self.currentSelectIndex=self.selectIndex;
        }
        self.choseArray=atArray;
        if (self.choseArray.count) {
            NSMutableString * atContent = [NSMutableString string];
            if (self.selectIndex==1) {
                [atContent appendString:[@"timeline.limit.tip.visibleToSomeFriendsExcept" icanlocalized:@"对部分好友可见，除了"]];
            }else if (self.selectIndex==2){
                [atContent appendString:[@"timeline.limit.tip.SpecifyFriendsIncluding" icanlocalized:@"指定对部分好友可见，包括"]];
            }
            for (int i =0; i<atArray.count; i++) {
                if (i>0) {
                    [atContent appendString:@","];
                }
                UserMessageInfo * user = atArray[i];
                [atContent appendString:user.nickname];
            }
            
            if (self.selectIndex ==1) {
                self.items =
                @[
                    @{@"top":@"timeline.limit.tip.friend".icanlocalized,@"bottom":[@"timeline.limit.tip.visibleToYourFriends" icanlocalized:@"你的好友可见"],@"icon":@"icon_timeline_post_setting_friend",@"visibleRange":@"AllFriend"},
                    @{@"top":[@"timeline.limit.tip.exceptFriends" icanlocalized:@"好友，除了"],@"bottom":atContent,@"icon":@"icon_timeline_post_setting_except",@"visibleRange":@"ExceptSomeFriends"},
                    @{@"top":[@"timeline.limit.tip.designatedFriends" icanlocalized:@"指定好友"],@"bottom":[@"timeline.limit.tip.visibleToSomeFriends" icanlocalized:@"指定对部分好友可见"],@"icon":@"icon_timeline_post_setting_appoint",@"visibleRange":@"SomeFriends"},
                    @{@"top": [@"timeline.limit.tip.onlyYourself" icanlocalized:@"仅限自己"],@"bottom":[@"timeline.limit.tip.onlyYourselfDetail" icanlocalized:@"只对自己可见"],@"icon":@"icon_timeline_post_setting_myself",@"visibleRange":@"OnlyMyself"}
                ];
                
                
            }else if (self.selectIndex ==2){
                self.items =
                @[
                    @{@"top":@"timeline.limit.tip.friend".icanlocalized,@"bottom":[@"timeline.limit.tip.visibleToYourFriends" icanlocalized:@"你的好友可见"],@"icon":@"icon_timeline_post_setting_friend",@"visibleRange":@"AllFriend"},
                    @{@"top":[@"timeline.limit.tip.exceptFriends" icanlocalized:@"好友，除了"],@"bottom":[@"timeline.limit.tip.somefriendsNotVisible" icanlocalized:@"对部分好友不可见"],@"icon":@"icon_timeline_post_setting_except",@"visibleRange":@"ExceptSomeFriends"},
                    @{@"top":[@"timeline.limit.tip.designatedFriends" icanlocalized:@"指定好友"],@"bottom":atContent,@"icon":@"icon_timeline_post_setting_appoint",@"visibleRange":@"SomeFriends"},
                    @{@"top": [@"timeline.limit.tip.onlyYourself" icanlocalized:@"仅限自己"],@"bottom":[@"timeline.limit.tip.onlyYourselfDetail" icanlocalized:@"只对自己可见"],@"icon":@"icon_timeline_post_setting_myself",@"visibleRange":@"OnlyMyself"}
                ];
                
                
            }
            
            [self.tableView reloadData];
        }
    };
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)rightButtonAction{
    if (self.isPostMessage) {
        NSString * title = self.items[self.selectIndex][@"visibleRange"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didChoseLimit:index:choseArray:)]) {
            [self.delegate didChoseLimit:title index:self.selectIndex choseArray:self.choseArray];
        }
        [self cancelAction];
    }else{
        [self changeTimelineRequest];
    }
}

-(void)cancelAction{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:KPostMessageLimitTableViewCell];
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    headView.backgroundColor = UIColor.whiteColor;
    
    UILabel * label = [UILabel leftLabelWithTitle:[@"timeline.limit.tip.whoCanSeeYourPosts?" icanlocalized:@"谁能看到你的帖子？"] font:15.0 color:UIColorMake(0, 0, 0)];
    label.font = [UIFont boldSystemFontOfSize:15.0];
    
    [headView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    self.tableView.tableHeaderView =headView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightPostMessageLimitTableViewCell;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostMessageLimitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KPostMessageLimitTableViewCell];
    if (indexPath.row==0 || indexPath.row==3) {
        cell.rightImageView.hidden = YES;
    }
    cell.dictionary = self.items[indexPath.row];
    cell.isSelect=indexPath.row==self.selectIndex;
    cell.leftBtnBlock = ^{
        self.selectIndex = indexPath.row;
        [self.tableView reloadData];
        if (indexPath.row==1 || indexPath.row==2) {
            [self selectVisibleRangeAction];
        }
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
    if (indexPath.row==1||indexPath.row==2) {
        [self selectVisibleRangeAction];
    }
    
}
-(void)changeTimelineRequest{
    ChangeTimelineRequest*request=[ChangeTimelineRequest request];
    request.pathUrlString=[request.baseUrlString stringByAppendingFormat:@"/timeLines/%@",self.timelinesListDetailInfo.ID];
    NSDictionary*ditc=[self.items objectAtIndex:self.selectIndex];
    NSString*val=ditc[@"visibleRange"];
    request.visibleRange=val;
    NSMutableArray*array=[NSMutableArray array];
    for (UserMessageInfo*info in self.choseArray) {
        [array addObject:info.userId];
    }
    if ([val isEqualToString:@"ExceptSomeFriends"]) {
        request.shields=array;
        self.timelinesListDetailInfo.shields=array;
    }else if ([val isEqualToString:@"SomeFriends"]){
        request.specifies=array;
        self.timelinesListDetailInfo.specifies=array;
    }
    request.parameters=[request mj_JSONObject];
    self.timelinesListDetailInfo.visibleRange=val;
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[BaseResponse class] contentClass:[BaseResponse class] success:^(id response) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:KChangeTimelineSuccessNotification object:self.timelinesListDetailInfo];
        [self cancelAction];
//        tips.UpdateSuccess/
        [QMUITipsTool showSuccessWithMessage:@"tips.UpdateSuccess".icanlocalized inView:nil];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

@end
