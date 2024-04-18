//
/**
- Copyright © 2021 dzl. All rights reserved.
- Author: Created  by DZL on 22/10/2021
- File name:  GroupApplyTableViewController.m
- Description:
- Function List:
*/
        

#import "GroupApplyTableViewController.h"
#import "GroupApplyTableViewCell.h"
#import "WCDBManager+GroupApplyInfo.h"
#import "WCDBManager+ChatModel.h"
#import "GroupApplyDetailViewController.h"
#import "GroupApplyInfo.h"
@interface GroupApplyTableViewController ()
@property(nonatomic, strong) NSArray *applyItems;
@end

@implementation GroupApplyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GroupNotification".icanlocalized;
    self.applyItems = [[WCDBManager sharedManager]getAllApplyInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView) name:KreceivedApplyJoinGroupNotification object:nil];
    
}
-(void)reloadTableView{
    self.applyItems = [[WCDBManager sharedManager]getAllApplyInfo];
    [self.tableView reloadData];
}
-(void)initTableView{
    [super initTableView];
    [self.tableView registNibWithNibName:kGroupApplyTableViewCell];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.applyItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupApplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kGroupApplyTableViewCell];
    GroupApplyInfo * info = self.applyItems[indexPath.row];
    cell.info =info;
    cell.deleteBlock = ^{
        [[WCDBManager sharedManager]deleteOneGroupAppInfo:info.messageId];
        self.applyItems = [[WCDBManager sharedManager]getAllApplyInfo];
        [self.tableView reloadData];
    };
    cell.agreeBlock = ^{
        [[WCDBManager sharedManager]updateChatModelGroupApplyWithMessageId:info.messageId];
        [[WCDBManager sharedManager]updateGroupApplyInfoAgreeWithMessageId:info.messageId];
        [self reloadTableView];
        InviteGroupRequest*request=[InviteGroupRequest request];
        request.groupId = @(info.groupId.integerValue);
        request.joinType = info.joinType;
        request.inviterId = @(info.inviterId.integerValue);
        request.userIds = @[info.userId];
        request.operater = @(UserInfoManager.sharedManager.userId.intValue);
        request.parameters=[request mj_JSONString];
        [[NetworkRequestManager shareManager]startRequest:request responseClass:nil contentClass:nil success:^(id response) {
            
        } failure:^(NSError *error, NetworkErrorInfo *info, NSInteger statusCode) {
            
        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupApplyDetailViewController * vc = [[GroupApplyDetailViewController alloc]init];
    vc.info = self.applyItems[indexPath.row];
    vc.agreeBlock = ^(GroupApplyInfo * _Nonnull groupApplyInfo) {
        [self reloadTableView];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction * deleted = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete".icanlocalized handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        GroupApplyInfo * info = self.applyItems[indexPath.row];
        [[WCDBManager sharedManager]deleteOneGroupAppInfo:info.messageId];
        self.applyItems = [[WCDBManager sharedManager]getAllApplyInfo];
        [self.tableView reloadData];
        
    }];
    return @[deleted];
    
    
}

@end
