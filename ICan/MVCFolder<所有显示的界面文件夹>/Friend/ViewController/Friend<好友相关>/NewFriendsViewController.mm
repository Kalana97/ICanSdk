//
//  NewFriendsViewController.m
//  EasyPay
//
//  Created by 刘志峰 on 2019/6/17.
//  Copyright © 2019 EasyPay. All rights reserved.
//

#import "NewFriendsViewController.h"

#import "NewFriendsTableViewCell.h"
#import "WCDBManager+ChatList.h"
#import "WCDBManager+ChatModel.h"
#import "WCDBManager+FriendSubscriptionInfo.h"
#import "WCDBManager+UserMessageInfo.h"

#import "FriendDetailViewController.h"
#import "ChatUtil.h"
#import "SearchHeadView.h"
#import "AddFriendsViewController.h"
#import "NewFriendRecommendController.h"
#import "TimeLineRecommendTableViewCell.h"
@interface NewFriendsViewController ()< WebSocketManagerDelegate>
@property (nonatomic,strong)  NSArray<FriendSubscriptionInfo*> *subscriptionItems;
@property (nonatomic, strong) SearchHeadView *searchHeaderView;

@property (nonatomic,strong)  NSMutableArray <UserRecommendListInfo *>* itemlist;
@property(nonatomic, strong)  NSArray  * originArray;
@property (nonatomic, strong) UIButton * rightButton;
@end

@implementation NewFriendsViewController
-(void)dealloc{
    [[WCDBManager sharedManager]updateFriendSubscriptionInfoHasRead];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.searchHeaderView];
    [self.searchHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@55);
        make.top.equalTo(@(StatusBarAndNavigationBarHeight));
    }];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self getAllData];
    self.titleView.title=NSLocalizedString(@"NewFriends", 新的好友);
    [WebSocketManager sharedManager].delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAllData) name:kAgreeFriendNotification object:nil];
    
    [self fetchUserRecommendRequest];
    self.view.backgroundColor=UIColorBg243Color;
    
}
-(void)pushToAddFriend{
    [self.navigationController pushViewController:[AddFriendsViewController new] animated:YES];
}
-(void)layoutTableView{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(@0);
        make.top.equalTo(@(StatusBarAndNavigationBarHeight+55));
        
    }];
}
-(void)getAllData{
    self.subscriptionItems = [[WCDBManager sharedManager]fetchAllFriendSubscriptionInfo];
    
    [self.tableView reloadData];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[NewFriendsTableViewCell class] forCellReuseIdentifier:KNewFriendsTableViewCell];
    [self.tableView registClassWithClassName:kTimeLineRecommendTableViewCell];
    
}

-(void)moreAction{
    NewFriendRecommendController * vc = [NewFriendRecommendController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        FriendSubscriptionInfo*info=[self.subscriptionItems objectAtIndex:indexPath.row];
        FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
        vc.userId=info.sender;
        vc.friendDetailType=FriendDetailType_fromNewFriend;
        vc.friendSubscriptionInfo=info;
        vc.refuseButtonBlock = ^{
            [self getAllData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        FriendDetailViewController*vc=[[FriendDetailViewController alloc]init];
        vc.userId=[self.itemlist objectAtIndex:indexPath.row].ID;
        vc.friendDetailType=FriendDetailType_push;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0? 40:10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        view.backgroundColor= UIColorViewBgColor;
        UILabel*label=[UILabel leftLabelWithTitle:NSLocalizedString(@"Friend request", 好友请求) font:16 color:UIColorThemeMainTitleColor];
        label.frame=CGRectMake(10, 0, ScreenWidth, 40);
        [view addSubview:label];
        return view;
    }
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor=UIColor10PxClearanceBgColor;
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.subscriptionItems.count;;
    }
    return self.itemlist.count>0?1:0;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [UserInfoManager sharedManager].openRecommend?2:1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return kNewFriendsTableViewCellHeight;
    }
    return kHeightTimeLineRecommendTableViewCell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        NewFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KNewFriendsTableViewCell];
        cell.agreeSucessBlock = ^{
            [self agreeActionAtIndexPath:indexPath];
        };
        cell.refuseSucessBlock = ^{
            [self refuseActionAtIndexPath:indexPath];
        };
        cell.friendSubscriptionInfo = self.subscriptionItems[indexPath.row];
        return cell;
    }
    TimeLineRecommendTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:kTimeLineRecommendTableViewCell forIndexPath:indexPath ];
    cell.items=self.itemlist;
    return cell;
    
    
    
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewRowAction * deleted = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:[@"timeline.post.operation.delete" icanlocalized:@"删除"] handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Do you want to delete?", 是否要删除) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"UIAlertController.cancel.title".icanlocalized style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"UIAlertController.sure.title".icanlocalized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self deleteFriendAtIndexPath:indexPath];
                
            }];
            [alert addAction:cancel];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
        }];
        return @[deleted];
        
    }
    return nil;
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [@"timeline.post.operation.delete" icanlocalized:@"删除"];
}
-(void)deleteFriendAtIndexPath:(NSIndexPath*)indexPath{
    FriendSubscriptionInfo * friendSubscriptionInfo = self.subscriptionItems[indexPath.row];
    [[WCDBManager sharedManager]deleteFriendSubscriptionInfoWithSender:friendSubscriptionInfo.sender];
    [self getAllData];
}
#pragma mark -- 拒绝

-(void)refuseActionAtIndexPath:(NSIndexPath *)indexPath {
    FriendSubscriptionInfo * friendSubscriptionInfo = self.subscriptionItems[indexPath.row];
    friendSubscriptionInfo.subscriptionType=0;
    [[WCDBManager sharedManager]updateFriendSubscriptionIsHasReadWithSender:friendSubscriptionInfo.sender SubscriptionType:0];
    [[WCDBManager sharedManager]updateFriendRelationWithUserId:friendSubscriptionInfo.sender isFriend:NO];
    [self getAllData];
}

-(void)agreeActionAtIndexPath:(NSIndexPath *)indexPath{
    FriendSubscriptionInfo * friendSubscriptionInfo = self.subscriptionItems[indexPath.row];
    [self agreeFriendRequest:friendSubscriptionInfo.sender];
    
}


#pragma mark -- 收到添加好友申请 delegate
-(void)receivedFriendRequest{
    [self getAllData];
}
-(SearchHeadView *)searchHeaderView{
    if (!_searchHeaderView) {
        _searchHeaderView=[[SearchHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _searchHeaderView.shouShowKeybord=YES;
        @weakify(self);
        _searchHeaderView.searchDidChangeBlock = ^(NSString * _Nonnull search) {
            @strongify(self);
            if (search.length>0) {
                NSPredicate * cpredicate = [NSPredicate predicateWithFormat:@"showName CONTAINS[c] %@ ",search];
                self.originArray = [[WCDBManager sharedManager]fetchAllFriendSubscriptionInfo];
                self.subscriptionItems=[self.originArray filteredArrayUsingPredicate:cpredicate];
                [self.tableView reloadData];
            }else{
                [self getAllData];
            }
        };
    }
    return _searchHeaderView;
}
//同意添加好友
-(void)agreeFriendRequest:(NSString*)userId{
    AgreeFriendRequest*request=[AgreeFriendRequest request];
    request.userId=@(userId.integerValue);
    request.parameters=[request mj_JSONObject];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
        [[WCDBManager sharedManager]updateFriendSubscriptionIsHasReadWithSender:userId SubscriptionType:1];
        [self getAllData];
        [self.tableView reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:kAgreeFriendNotification object:userId];
        [[WCDBManager sharedManager]updateFriendRelationWithUserId:userId isFriend:YES];
        [QMUITipsTool showSuccessWithMessage:NSLocalizedString(@"Friend added successfully", 成功添加好友) inView:self.view];
        ChatModel*model=[ChatUtil initAddFriendWithChatId:userId authorityType:AuthorityType_friend];
        [[WCDBManager sharedManager]cacheMessageWithChatModel:model isNeedSend:YES];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
}

-(void)fetchUserRecommendRequest{
    GertUserRecommendRequest * request = [GertUserRecommendRequest request];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[UserRecommendListInfo class] success:^(NSArray * response) {
        self.itemlist = [NSMutableArray arrayWithArray:response];
        [self.tableView reloadData];
        
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
        [QMUITipsTool showErrorWihtMessage:info.desc inView:self.view];
    }];
    
}
-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[UIButton dzButtonWithTitle:nil image:nil backgroundColor:nil titleFont:0 titleColor:nil target:self action:@selector(pushToAddFriend)];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"icon_chat__nav_add"] forState:UIControlStateNormal];
        _rightButton.frame=CGRectMake(0, 0, 30, 30);
    }
    return _rightButton;
}
@end
