//
//  SettingGroupManagerViewController.m
//  ICan
//
//  Created by Limaohuyu666 on 2020/1/11.
//  Copyright © 2020 dzl. All rights reserved.
//  设置群管理员界面

#import "SettingGroupManagerViewController.h"
#import "FriendListTableViewCell.h"
#import "UITableView+SCIndexView.h"
#import "RightArrowTableViewCell.h"
#import "AddGroupManagerOrRemoveViewController.h"

#import "WCDBManager+UserMessageInfo.h"
#import "WCDBManager+GroupMemberInfo.h"

@interface SettingGroupManagerViewController ()
@property(nonatomic,strong)NSMutableArray * managerItems;
@property(nonatomic,strong)NSMutableArray * menberItems;
@property(nonatomic,strong)NSMutableArray * mutedUserItems;

@end

@implementation SettingGroupManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isMuteUserView == YES){
        self.title = @"Manage restricted list".icanlocalized;
    }else{
        self.title = NSLocalizedString(@"AdministratorSettings", 设置管理员);
    }
    [self sortData];
}

-(void)sortData{
    
    for (GroupMemberInfo * info in self.allMemberItems) {
        if(self.isMuteUserView == false){
            if ([info.role isEqualToString:@"1"]) {
                [self.managerItems addObject:info];
            }
            if ([info.role isEqualToString:@"2"]) {
                [self.menberItems addObject:info];
            }
        }else{
            if (info.mutedByAdmin == YES){
                [self.mutedUserItems addObject:info];
            }else{
                [self.menberItems addObject:info];
            }
        }
    }
    
    [self.tableView reloadData];
    
}

-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kFriendListTableViewCell];
    [self.tableView registNibWithNibName:kRightArrowTableViewCell];
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeightFriendListTableViewCell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        if(self.isMuteUserView == YES){
            return self.mutedUserItems.count;
        }else{
            return self.managerItems.count;
        }
    }else if(section==3){
        return self.menberItems.count;
    }
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        RightArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRightArrowTableViewCell];
        if(self.isMuteUserView == true){
            cell.titleLabel.text = @"Add to restricted list".icanlocalized;
        }else{
            cell.titleLabel.text = NSLocalizedString(@"Add Administrator", 添加管理员);
        }
        return cell;
    }else if (indexPath.section==1) {
        RightArrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRightArrowTableViewCell];
        if(self.isMuteUserView == true){
            cell.titleLabel.text = @"Remove from restricted list".icanlocalized;
        }else{
            cell.titleLabel.text = NSLocalizedString(@"Remove manager", 移除管理员);
        }
        return cell;
    }else if (indexPath.section==2) {
        FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
        if(self.isMuteUserView == true){
            cell.groupMemberInfo = self.mutedUserItems[indexPath.row];
        }else{
            cell.groupMemberInfo = self.managerItems[indexPath.row];
        }
        return cell;
    }
    
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFriendListTableViewCell];
    cell.groupMemberInfo = self.menberItems[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0||section==1) {
        return 0;
    }
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        view.backgroundColor = UIColorBg243Color;
        if(self.isMuteUserView == YES){
            UILabel *label = [UILabel leftLabelWithTitle:@"Restricted list".icanlocalized font:16 color:UIColorMake(51, 51, 51)];
            label.frame = CGRectMake(10, 0, self.view.frame.size.width, 30);
            [view addSubview:label];
        }else{
            UILabel *label = [UILabel leftLabelWithTitle:NSLocalizedString(@"Administrator", 管理员) font:16 color:UIColorMake(51, 51, 51)];
            label.frame = CGRectMake(10, 0, self.view.frame.size.width, 30);
            [view addSubview:label];
        }
        return view;
        
    }else if (section==3){
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        view.backgroundColor = UIColorBg243Color;
        UILabel * label = [UILabel leftLabelWithTitle:@"群成员" font:16 color:UIColorMake(51, 51, 51)];
        label.frame=CGRectMake(10, 0, self.view.frame.size.width, 30);
        [view addSubview:label];
        return view;
        
    }
    
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        [self addManager];
    }
    
    if (indexPath.section==1) {
        [self removeManager];
    }
}


-(void)addManager{
    AddGroupManagerOrRemoveViewController * vc = [AddGroupManagerOrRemoveViewController new];
    vc.allMemberItems = (NSArray *)self.menberItems;
    vc.sucessSettingManagerBlock = ^{
        [self fetchGroupMemberInfo];
    };
    vc.groupDetailInfo = self.groupDetailInfo;
    if(self.isMuteUserView == YES){
        vc.isAddMuteManager = YES;
    }
    vc.isAddManager = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)removeManager{
    AddGroupManagerOrRemoveViewController * vc = [AddGroupManagerOrRemoveViewController new];
    if(self.isMuteUserView == YES){
        vc.allMemberItems = (NSArray *)self.mutedUserItems;
    }else{
        vc.allMemberItems = (NSArray *)self.managerItems;
    }
    vc.sucessSettingManagerBlock = ^{
        [self fetchGroupMemberInfo];
    };
    vc.groupDetailInfo = self.groupDetailInfo;
    if(self.isMuteUserView == YES){
        vc.isRemoveMuteManager = YES;
    }
    vc.isAddManager = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}



-(NSMutableArray *)managerItems{
    if (!_managerItems) {
        _managerItems = [NSMutableArray array];
    }
    
    return _managerItems;
}

-(NSMutableArray *)menberItems{
    if (!_menberItems) {
        _menberItems = [NSMutableArray array];
    }
    
    return _menberItems;
}

-(NSMutableArray *)mutedUserItems{
    if (!_mutedUserItems) {
        _mutedUserItems = [NSMutableArray array];
    }
    return _mutedUserItems;
}

-(void)fetchGroupMemberInfo{
    GetGroupUserListRequest*request=[GetGroupUserListRequest request];
    request.groupId=self.groupDetailInfo.groupId;
    request.parameters=[request mj_JSONString];
    [[NetworkRequestManager shareManager]startRequest:request responseClass:[NSArray class] contentClass:[GroupMemberInfo class] success:^(NSArray<GroupMemberInfo*>* response) {
        self.allMemberItems=response;
        [[WCDBManager sharedManager]insertOrReplaceGroupMemberInfoWithArray:response];
        [self.menberItems removeAllObjects];
        [self.managerItems removeAllObjects];
        [self.mutedUserItems removeAllObjects];
        [self sortData];
    } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
        
    }];
    
    
}


@end
