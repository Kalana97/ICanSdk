//
//  NewFriendRecommendController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/2.
//  Copyright © 2020 dzl. All rights reserved.
//  通讯录--新的好友--更多，推荐的人

#import "NewFriendRecommendController.h"
#import "RecommendTableViewCell.h"
#import "FriendDetailViewController.h"
#import "NewFriendRecommendListTableViewCell.h"
@interface NewFriendRecommendController ()


@end

@implementation NewFriendRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =[@"find.listView.cell.recommended" icanlocalized:@"推荐的人"];;
    [self fetchUserRecommendRequest];
}


-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:KRecommendTableViewCell];
    [self.tableView registClassWithClassName:kNewFriendRecommendListTableViewCell];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightNewFriendRecommendListTableViewCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemlist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewFriendRecommendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kNewFriendRecommendListTableViewCell];
    cell.userRecommendListInfo = self.itemlist[indexPath.item];
    @weakify(self);
    cell.agreeSucessBlock = ^{
        @strongify(self);
        FriendDetailViewController * vc = [FriendDetailViewController new];
        UserRecommendListInfo * info = [self.itemlist objectAtIndex:indexPath.row];
        vc.userId = info.ID;
        vc.friendDetailType=FriendDetailType_pushChatViewNotification;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.refuseSucessBlock = ^{
        @strongify(self);
        [self.itemlist removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    };
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendDetailViewController * vc = [FriendDetailViewController new];
    UserRecommendListInfo * info = [self.itemlist objectAtIndex:indexPath.row];
    vc.userId = info.ID;
    vc.friendDetailType=FriendDetailType_pushChatViewNotification;
    [self.navigationController pushViewController:vc animated:YES];
    
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



@end
